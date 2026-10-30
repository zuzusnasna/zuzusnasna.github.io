---
title: "Java Collection Framework — List, Set, Map을 사용하는 기준"
date: 2026-09-28 00:00:00 +0900
categories: [Spring]
tags: [Java, Collection, List, Set, Map]
---

## 1. Collection Framework란?

Collection Framework는 여러 객체를 하나의 자료구조로 관리할 수 있도록 Java가 제공하는 인터페이스와 구현 클래스의 모음이다. 배열과 달리 크기를 유연하게 관리할 수 있고, 자료의 중복 허용 여부와 저장 순서에 따라 적절한 자료구조를 선택할 수 있다.

대표적으로 List, Set, Map을 많이 사용한다.

## 2. List — 순서가 있고 중복을 허용

List는 데이터를 입력한 순서대로 관리하며 같은 값이 여러 번 들어갈 수 있다.

```java
List<String> names = new ArrayList<>();
names.add("Kim");
names.add("Lee");
names.add("Kim");

System.out.println(names.get(0)); // Kim
System.out.println(names.size()); // 3
```

- 순서가 중요하거나 인덱스로 조회할 때 사용한다.
- ArrayList는 인덱스 기반 조회가 빠르고, 중간 삽입·삭제가 잦으면 비용이 커질 수 있다.
- LinkedList는 노드 연결 구조지만 특정 위치 조회에는 불리하다.

## 3. Set — 중복을 허용하지 않음

Set은 같은 값을 중복 저장하지 않는다. 중복 제거 또는 존재 여부 확인이 필요한 경우 적합하다.

```java
Set<String> skills = new HashSet<>();
skills.add("Java");
skills.add("Spring");
skills.add("Java");

System.out.println(skills.size()); // 2
System.out.println(skills.contains("Spring")); // true
```

- HashSet: 순서를 보장하지 않고 해시 기반으로 관리한다.
- LinkedHashSet: 입력 순서를 유지한다.
- TreeSet: 정렬된 순서로 관리한다.

## 4. Map — Key와 Value를 연결

Map은 Key 하나에 Value 하나를 연결한다. Key는 중복될 수 없으며, 같은 Key로 다시 저장하면 기존 값이 교체된다.

```java
Map<String, Integer> scores = new HashMap<>();
scores.put("Kim", 90);
scores.put("Lee", 85);
scores.put("Kim", 95);

System.out.println(scores.get("Kim")); // 95
```

사용자 ID로 사용자 정보를 조회하거나 상품 코드로 가격을 찾는 상황에 활용할 수 있다.

## 5. 어떤 자료구조를 선택할까?

| 요구사항 | 선택 |
| --- | --- |
| 순서 유지 + 중복 허용 | List |
| 중복 제거 | Set |
| Key로 Value 조회 | Map |
| 입력 순서 유지가 필요한 Set | LinkedHashSet |
| 정렬된 Set | TreeSet |

## 6. 실무에서 생각할 점

채팅 서비스에서 특정 방의 참여자 목록을 순서대로 보여준다면 List를 고려할 수 있다. 동일 사용자의 중복 참여를 막거나 고유한 사용자 ID를 관리한다면 Set이 적합하다. 사용자 ID를 기준으로 접속 세션을 빠르게 찾는 구조라면 Map을 활용할 수 있다.

자료구조는 익숙한 것을 무조건 선택하기보다, 중복·순서·조회 방식과 데이터 규모를 기준으로 선택해야 한다.
