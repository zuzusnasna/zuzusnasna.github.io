---
layout: post
title: "부트캠프 : Java Collection을 상황에 맞게 선택하는 기준"
date: 2026-10-30 10:00:00 +0900
categories: [학습]
tags: [Java]
---

Collection은 종류를 외우는 것보다 **어떤 데이터를 어떻게 조회할 것인지**를 기준으로 선택하는 것이 중요했다.

## List

순서가 중요하고 중복을 허용하는 데이터를 다룰 때 사용한다.

```java
List<String> names = new ArrayList<>();
names.add("A");
names.add("B");
```

## Set

중복을 허용하지 않아야 할 때 적합하다.

```java
Set<Long> userIds = new HashSet<>();
```

## Map

키로 값을 빠르게 찾을 때 사용한다.

```java
Map<Long, String> users = new HashMap<>();
users.put(1L, "홍길동");
```

## 실무에서 생각할 기준

```text
순서 + 중복 허용 → List
중복 제거       → Set
Key → Value 조회 → Map
```

자료구조 선택은 단순 취향이 아니라 **조회 패턴과 데이터의 중복/순서 요구사항을 코드에 반영하는 설계**라고 정리했다.
