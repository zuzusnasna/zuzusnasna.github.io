---
layout: post
title: "Redis Study : Sorted Set으로 대기 순번을 계산한 이유"
date: 2026-10-30 09:00:00 +0900
categories: [학습]
tags: [Redis, Spring Boot, 성능]
---

대기열을 구현하면서 중요한 요구사항은 단순히 순서를 저장하는 것이 아니라 **현재 사용자가 몇 번째인지 빠르게 조회하는 것**이었다.

## Sorted Set

Redis Sorted Set은 member와 score를 함께 저장하고 score 순으로 정렬할 수 있다.

```text
member = userId
score  = 대기열에 들어온 순서
```

예를 들어 다음과 같이 저장한다.

```text
userA → 100
userB → 101
userC → 102
```

## 순번 조회

특정 사용자의 score보다 작은 데이터를 세면 앞에 있는 사용자 수를 계산할 수 있다.

```text
내 앞의 사용자 수 + 1 = 현재 순번
```

Redis에서는 `ZCOUNT` 같은 명령을 이용해 이 작업을 빠르게 수행할 수 있다.

## 왜 DB만 사용하지 않았나

대기열 순번은 사용자가 자주 조회할 수 있는 값이고 매번 큰 테이블을 정렬해 계산하면 DB 부하가 커질 수 있다.

따라서 Redis를 빠른 순번 조회에 사용하고 DB를 원본 데이터로 두는 구조를 선택했다.

## 배운 점

Redis는 무조건 캐시로 사용하는 것이 아니라 **조회 요구사항에 맞는 자료구조를 선택하는 것**이 핵심이었다.
