---
layout: post
title: "Java Map과 HashMap — Key 조회, 해시 충돌, 동시성"
date: 2026-10-30 11:00:00 +0900
categories: [Spring]
tags: [Java, Collection, Map, HashMap, ConcurrentHashMap]
---

## 1. Map의 역할

Map은 Key와 Value를 한 쌍으로 저장하는 자료구조다. Key는 중복될 수 없으며 같은 Key로 다시 값을 저장하면 기존 Value가 교체된다.

```java
Map<Long, String> members = new HashMap<>();
members.put(101L, "민수");
members.put(102L, "지영");
members.put(101L, "민수(수정)");

System.out.println(members.get(101L)); // 민수(수정)
```

회원 ID로 회원 정보를 찾거나 상품 코드로 가격을 조회하는 것처럼 특정 기준값으로 데이터를 빠르게 찾을 때 사용한다.

## 2. HashMap의 저장과 조회

HashMap은 Key의 해시 값을 이용해 내부 테이블의 위치를 계산한다. 조회는 다음 흐름으로 이해할 수 있다.

1. Key의 `hashCode()`를 계산한다.
2. 해시를 바탕으로 테이블의 버킷 위치를 찾는다.
3. 해당 버킷의 후보들과 `equals()`를 비교한다.
4. 일치하는 Key를 찾으면 Value를 반환한다.

평균적으로 삽입·조회·삭제는 O(1)에 가까운 성능을 기대할 수 있지만, 해시 충돌과 테이블 상태에 따라 달라진다.

## 3. hashCode와 equals 계약

사용자 정의 객체를 Key로 사용한다면 두 메서드를 함께 구현해야 한다.

```java
class ProductKey {
    private final String category;
    private final String code;

    ProductKey(String category, String code) {
        this.category = category;
        this.code = code;
    }

    @Override
    public boolean equals(Object obj) {
        if (this == obj) return true;
        if (!(obj instanceof ProductKey other)) return false;
        return Objects.equals(category, other.category)
                && Objects.equals(code, other.code);
    }

    @Override
    public int hashCode() {
        return Objects.hash(category, code);
    }
}
```

두 Key가 논리적으로 같다면 같은 해시 값을 반환해야 한다. 반대로 해시 값이 같다는 이유만으로 같은 Key라고 판단해서는 안 된다. 최종 동등성은 equals가 판단한다.

Key로 사용하는 객체의 필드가 저장 후 변경되면 문제가 발생할 수 있다. 저장할 때 계산한 위치와 조회할 때 계산한 위치가 달라질 수 있기 때문이다. Map의 Key는 불변 객체로 사용하는 편이 안전하다.

## 4. 해시 충돌과 리사이징

서로 다른 Key가 같은 버킷에 배치되는 현상을 해시 충돌이라고 한다. HashMap은 충돌한 항목을 같은 버킷에서 관리하고, Java 버전에 따라 충돌이 심한 버킷을 트리 구조로 바꾸는 최적화도 수행한다.

테이블이 일정 수준 이상 채워지면 더 큰 테이블로 확장하는 리사이징이 발생한다. 이 과정에서는 기존 항목의 배치를 다시 계산하는 비용이 생긴다.

데이터 개수를 대략 알고 있다면 초기 용량을 적절히 지정해 확장 횟수를 줄일 수 있다. 다만 지나치게 큰 초기 용량은 메모리 낭비를 만들 수 있으므로 예상 데이터 규모에 맞춰야 한다.

## 5. 자주 사용하는 메서드

```java
Map<String, Integer> stock = new HashMap<>();

stock.put("keyboard", 10);
stock.putIfAbsent("mouse", 5);

stock.merge("keyboard", 2, Integer::sum);
stock.computeIfAbsent("monitor", key -> 1);

int keyboardStock = stock.getOrDefault("keyboard", 0);
stock.remove("mouse");
```

- `putIfAbsent`: Key가 없을 때만 값 추가
- `getOrDefault`: Key가 없을 때 기본값 반환
- `merge`: 기존 값과 새 값을 병합
- `computeIfAbsent`: 값이 없을 때 계산해 저장

단순 조회·수정뿐 아니라 이런 메서드를 활용하면 null 검사 코드를 줄일 수 있다.

## 6. Map 구현체 비교

| 구현체 | 특징 |
| --- | --- |
| HashMap | 일반적인 해시 기반 Map, 순서 보장 안 함 |
| LinkedHashMap | 입력 순서 또는 접근 순서 유지 |
| TreeMap | Key 정렬 기준으로 관리 |
| ConcurrentHashMap | 여러 스레드의 동시 접근을 고려한 Map |

## 7. 서버 개발에서의 사용과 주의

HashMap은 요청 내부의 임시 데이터 변환, 코드와 객체 매핑, 캐시 데이터 구성 등에 활용할 수 있다. 하지만 여러 스레드가 공유하는 HashMap을 동시에 수정하면 안전하지 않다.

여러 스레드가 공유하는 Map이 필요하다면 ConcurrentHashMap을 검토한다. 다만 ConcurrentHashMap을 사용해도 여러 번의 조회와 수정으로 이루어진 업무 전체가 자동으로 하나의 원자적 작업이 되는 것은 아니다. 복합 작업에는 원자적 메서드나 별도 동기화가 필요하다.

또한 HashMap은 null Key와 null Value를 허용하지만 ConcurrentHashMap은 null을 허용하지 않는 차이도 알아두어야 한다.

## 핵심 정리

- Map은 Key를 통해 Value를 찾는 자료구조다.
- HashMap은 hashCode로 버킷을 찾고 equals로 Key를 비교한다.
- 해시 충돌과 리사이징이 내부 성능에 영향을 준다.
- Key로 사용하는 객체는 동등성 필드를 변경하지 않는 것이 안전하다.
- 공유 데이터의 동시 수정에는 ConcurrentHashMap 등 적절한 동시성 전략이 필요하다.
