---
layout: post
title: "Redis Sorted Set으로 대기 순번을 조회한 이유"
date: 2026-10-27
tags: [Redis, Spring Boot, 성능, SmartTicketing]
categories: [프로젝트]
---

SmartTicketing의 대기열을 구현하면서 Redis Sorted Set을 사용했다.

대기열에서는 사용자의 현재 순번을 빠르게 조회할 수 있어야 했다.

## 1. 왜 Sorted Set인가

Redis Sorted Set은 각 member에 score를 함께 저장하고 score 순서로 데이터를 관리한다.

대기열에 들어온 순서를 score로 표현하면 사용자의 순위를 계산하기 편하다.

## 2. 순번 조회

특정 사용자의 앞에 몇 명이 있는지를 조회하면 현재 대기 순번을 계산할 수 있다.

```text
대기열

userA  score 100
userB  score 200
userC  score 300

userC의 앞에 있는 사용자 수 → 2명
현재 순번 → 3번
```

Redis의 Sorted Set을 이용하면 전체 대기열을 애플리케이션으로 가져와 직접 순위를 계산하지 않고 Redis에서 필요한 범위를 조회할 수 있다.

## 3. 배운 점

자료구조를 선택할 때 단순히 저장하기 편한지를 보는 것이 아니라 **서비스에서 가장 자주 필요한 조회가 무엇인지** 먼저 생각해야 한다.

대기열에서는 삽입 자체보다 현재 순번 조회가 중요한 요구사항이었고, 이 요구사항에 Sorted Set이 잘 맞았다.
