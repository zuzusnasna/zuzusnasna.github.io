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

## 더 깊게 이해하기: Map의 키는 안정적인 식별자여야 한다

Map은 키를 이용해 값을 찾는 자료구조다. 해시 기반 Map은 키의 `hashCode()`로 저장 위치를 찾고 `equals()`로 키가 같은지 확인한다. 키로 사용하는 객체의 equals와 hashCode가 일관되지 않거나, Map에 저장한 뒤 키 객체의 비교 기준 필드가 바뀌면 값을 찾지 못하는 문제가 발생할 수 있다.

HashMap은 일반적인 키-값 조회에 적합하고, LinkedHashMap은 삽입 순서를 유지해야 할 때, TreeMap은 정렬된 키 순서가 필요할 때 고려할 수 있다. 자료구조 선택은 API 응답 순서, 데이터 크기, 조회 패턴에 영향을 준다.

### 실습 점검
- 사용자 정의 객체를 키로 사용할 때 equals와 hashCode를 함께 구현했는가?
- 결과 순서가 중요하다면 순서를 보장하는 Map을 선택했는가?
- 존재하지 않는 키와 null 값을 구분해야 하는가?
- Map을 공유 상태로 사용할 때 동시 접근을 고려했는가?

Map을 사용할 때는 메서드 이름보다 키의 동일성 규칙과 필요한 순서 보장부터 확인하는 것이 좋다.
