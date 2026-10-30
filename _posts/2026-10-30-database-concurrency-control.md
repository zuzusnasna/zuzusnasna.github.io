---
layout: post
title: "DB 동시성 제어: Lock과 Transaction을 어떻게 선택할까"
date: 2026-09-19 00:00:00 +0900
categories: [학습]
tags: [Database, MySQL, Transaction, Lock, 동시성]
---

동시에 여러 요청이 같은 데이터를 변경할 때 어떤 문제가 생기는지, Transaction과 Lock을 이용해 어떻게 제어하는지 정리했다.

## 동시성 문제가 생기는 상황

재고가 1개 남아 있는데 두 요청이 거의 동시에 재고를 조회한다고 생각해 보자.

```text
재고 = 1

요청 A → 재고 조회 → 1
요청 B → 재고 조회 → 1

요청 A → 구매 처리
요청 B → 구매 처리
```

각 요청이 조회할 때는 문제가 없어 보이지만 최종 결과에서는 하나만 처리되어야 할 작업이 두 번 처리될 수 있다.

## Transaction은 무엇을 보장하는가

Transaction은 여러 DB 작업을 하나의 논리적인 작업 단위로 묶는다.

```text
BEGIN
  ↓
조회
  ↓
변경
  ↓
COMMIT
```

중간에 예외가 발생하면 `ROLLBACK`으로 작업을 되돌릴 수 있다.

Spring에서는 보통 서비스 계층에 `@Transactional`을 선언해 경계를 만든다.

```java
@Transactional
public void decreaseStock(Long productId) {
    Product product = repository.findById(productId)
            .orElseThrow();

    if (product.getStock() <= 0) {
        throw new IllegalStateException("재고 없음");
    }

    product.decreaseStock();
}
```

하지만 Transaction을 사용한다고 해서 모든 동시성 문제가 자동으로 해결되는 것은 아니다. 여러 Transaction이 동시에 같은 값을 읽고 변경하는 경우에는 격리 수준이나 Lock 전략을 함께 봐야 한다.

## 비관적 Lock

비관적 Lock은 충돌이 발생할 가능성이 높다고 보고 데이터를 읽을 때부터 다른 Transaction의 변경을 제한하는 방식이다.

JPA에서는 `PESSIMISTIC_WRITE` 같은 Lock 모드를 사용할 수 있다.

```java
@Lock(LockModeType.PESSIMISTIC_WRITE)
Optional<Product> findById(Long id);
```

대표적으로 수량 차감처럼 같은 데이터를 동시에 변경하면 안 되는 경우에 사용할 수 있다.

단점은 Lock을 오래 잡으면 다른 요청이 대기하면서 처리량이 떨어질 수 있다는 점이다.

## 낙관적 Lock

낙관적 Lock은 충돌이 자주 발생하지 않는다고 보고 데이터를 읽을 때 Lock을 오래 잡지 않는다. 대신 변경 시점에 다른 요청이 먼저 변경했는지 확인한다.

JPA에서는 `@Version`을 이용할 수 있다.

```java
@Entity
public class Product {

    @Version
    private Long version;
}
```

두 Transaction이 같은 버전의 데이터를 읽고 하나가 먼저 수정하면 다른 Transaction의 수정은 버전 충돌로 실패할 수 있다.

## 어떤 방식을 선택할까

| 상황 | 고려할 방식 |
|---|---|
| 충돌 가능성이 높고 반드시 직렬화해야 함 | 비관적 Lock |
| 충돌이 드물고 Lock 대기를 줄이고 싶음 | 낙관적 Lock |
| 단순한 여러 DB 작업의 원자성 필요 | Transaction |
| 애플리케이션 여러 인스턴스 사이의 경쟁 제어 | DB Lock 외 별도 분산 제어 검토 |

중요한 것은 `@Transactional`이나 Lock을 무조건 붙이는 것이 아니라 **어떤 공유 상태를 어떤 범위에서 보호해야 하는지** 먼저 정하는 것이다.

## 확인해야 할 것

동시성 제어를 적용한 뒤에는 정상 요청 하나만 실행해서 끝내면 안 된다.

- 같은 데이터를 동시에 변경하는 요청
- 같은 요청의 중복 전송
- Lock 대기 시간이 길어지는 상황
- Transaction 중간에 예외가 발생하는 상황
- 실패한 요청이 남긴 데이터 상태

이런 조건을 함께 확인해야 실제로 정합성이 유지되는지 판단할 수 있다.
