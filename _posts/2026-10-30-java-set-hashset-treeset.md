---
layout: post
title: "Java Set — HashSet, LinkedHashSet, TreeSet의 동작 원리"
date: 2026-09-11 00:00:00 +0900
categories: [Spring]
tags: [Java, Collection, Set, HashSet, TreeSet]
---

## 1. Set을 사용하는 이유

Set은 중복 요소를 허용하지 않는 컬렉션이다. 회원 권한, 이미 처리한 이벤트 ID, 중복 제거 대상처럼 같은 값이 여러 번 들어오면 안 되는 데이터에 적합하다.

```java
Set<String> roles = new HashSet<>();
roles.add("USER");
roles.add("ADMIN");
roles.add("USER");

System.out.println(roles.size()); // 2
System.out.println(roles.contains("ADMIN")); // true
```

두 번째 "USER"는 이미 존재하므로 새로운 요소로 추가되지 않는다. 단, Set 인터페이스 자체는 정렬이나 입력 순서를 보장하지 않는다.

## 2. HashSet의 내부 동작

HashSet은 내부적으로 HashMap을 이용해 요소를 관리한다. 요소 자체를 Map의 Key처럼 저장하고, 중복 여부는 해시와 동등성 비교를 통해 판단한다.

요소를 추가할 때의 개념적인 흐름은 다음과 같다.

1. 요소의 `hashCode()`를 구한다.
2. 해시 값을 바탕으로 저장 위치를 계산한다.
3. 같은 위치에 요소가 있다면 `equals()`로 같은 객체인지 확인한다.
4. 동일한 요소가 없다면 저장한다.

따라서 사용자 정의 객체를 HashSet에 넣을 때는 `equals()`와 `hashCode()`를 함께 올바르게 구현해야 한다.

```java
class Member {
    private final Long id;

    Member(Long id) {
        this.id = id;
    }

    @Override
    public boolean equals(Object obj) {
        if (this == obj) return true;
        if (!(obj instanceof Member other)) return false;
        return Objects.equals(id, other.id);
    }

    @Override
    public int hashCode() {
        return Objects.hash(id);
    }
}
```

이 예제에서는 회원 ID가 같으면 같은 회원으로 취급한다. 두 메서드의 기준이 다르면 중복 제거와 검색 결과가 예상과 달라질 수 있다.

## 3. 해시 충돌과 동등성

서로 다른 객체가 같은 해시 값을 가질 수 있다. 이를 해시 충돌이라고 한다. 해시 값이 같다는 사실만으로 두 객체가 같다고 판단하지 않고, 실제 동등성은 `equals()`로 확인한다.

반드시 지켜야 하는 계약은 다음과 같다.

- `equals()`가 true인 두 객체는 같은 `hashCode()`를 반환해야 한다.
- 같은 해시 값을 반환한다고 해서 `equals()`가 true일 필요는 없다.
- Set에 저장한 뒤 동등성 판단에 사용하는 필드를 변경하면 검색과 삭제가 실패할 수 있다.

가능하면 Set의 요소는 불변 객체로 설계하는 것이 안전하다.

## 4. LinkedHashSet과 TreeSet

| 구현체 | 저장 방식과 순서 | 적합한 상황 |
| --- | --- | --- |
| HashSet | 해시 기반, 순서 보장 안 함 | 빠른 중복 검사 |
| LinkedHashSet | 입력 순서 유지 | 중복 제거 후 입력 순서 유지 |
| TreeSet | 정렬 기준에 따라 정렬 | 정렬된 순회와 범위 검색 |

```java
Set<Integer> hash = new HashSet<>(List.of(3, 1, 2));
Set<Integer> linked = new LinkedHashSet<>(List.of(3, 1, 2));
Set<Integer> tree = new TreeSet<>(List.of(3, 1, 2));

System.out.println(linked); // 입력 순서 유지
System.out.println(tree);   // [1, 2, 3]
```

TreeSet은 자연 정렬 또는 Comparator를 이용한다. 정렬 기준에서 비교 결과가 0이면 같은 정렬 요소로 취급될 수 있으므로 비교 기준을 신중하게 정해야 한다.

## 5. TreeSet의 범위 조회

TreeSet은 정렬 상태를 유지하므로 특정 범위의 데이터를 조회하는 데 활용할 수 있다.

```java
TreeSet<Integer> scores =
        new TreeSet<>(List.of(55, 70, 80, 90, 100));

System.out.println(scores.headSet(80));      // 80 미만
System.out.println(scores.tailSet(80));      // 80 이상
System.out.println(scores.subSet(70, 100));  // 70 이상 100 미만
```

범위 조회가 필요하고 정렬 기준이 명확한 경우 TreeSet이 유용하다. 단순 중복 제거만 필요하다면 정렬 비용을 부담할 필요가 없다.

## 6. 실무에서 주의할 점

HashSet은 일반적으로 여러 스레드가 동시에 수정하는 상황을 보장하지 않는다. 공유 상태로 사용한다면 동기화 전략이나 동시성 컬렉션을 검토해야 한다. 또한 요소를 저장한 후 해시 계산에 쓰이는 값을 변경하지 않아야 한다.

## 핵심 정리

- Set은 중복을 허용하지 않는 자료구조다.
- HashSet은 hashCode로 위치를 찾고 equals로 동등성을 확인한다.
- LinkedHashSet은 입력 순서를 유지한다.
- TreeSet은 정렬과 범위 조회를 지원한다.
- equals/hashCode 계약과 저장 후 요소 변경에 주의한다.
