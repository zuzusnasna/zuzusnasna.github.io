---
layout: post
title: "Spring @Transactional 동작 원리 — 프록시와 트랜잭션 경계"
date: 2026-10-30 00:00:00 +0900
categories: [Spring]
tags: [Spring, Transaction, Transactional, AOP, Proxy]
---
## @Transactional은 무엇을 하는가

@Transactional은 메서드 실행을 트랜잭션 경계로 만들도록 Spring의 트랜잭션 인프라에 정보를 제공한다. 일반적인 선언적 트랜잭션은 AOP 프록시가 호출을 가로채 트랜잭션을 시작하고, 메서드 결과에 따라 커밋 또는 롤백한다.

## 기본 사용

```java
@Service
public class OrderService {
    @Transactional
    public void createOrder() {
        // 주문 저장
        // 재고 차감
    }
}
```

두 데이터 변경이 같은 트랜잭션에 참여하면 중간 단계에서 실패했을 때 함께 롤백할 수 있다. 단, 외부 결제 API 호출은 DB 트랜잭션 롤백만으로 취소되지 않는다. 외부 시스템과의 정합성은 보상 트랜잭션이나 Outbox 패턴 등을 별도로 고려해야 한다.

## 기본 롤백 규칙

기본 설정에서는 RuntimeException과 Error가 발생하면 롤백하고, 일반적인 checked exception은 자동 롤백 대상이 아니다. checked exception도 롤백해야 한다면 rollbackFor를 명시한다.

```java
@Transactional(rollbackFor = Exception.class)
public void process() throws Exception {
    // 처리
}
```

예외를 메서드 내부에서 잡아 삼키면 프록시가 실패를 감지하지 못해 커밋될 수 있다. 예외를 다시 던지거나 rollbackOnly를 명시하는 등 정책을 분명히 해야 한다.

## 프록시를 우회하는 호출

같은 객체 안에서 this를 통해 @Transactional 메서드를 호출하면 프록시를 거치지 않을 수 있다. 따라서 트랜잭션이 적용될 것으로 기대한 메서드가 실제로는 트랜잭션 없이 실행되는 문제가 발생한다. 트랜잭션 경계를 외부에서 호출되는 서비스 메서드에 두거나 책임을 별도 Bean으로 분리한다.

## 트랜잭션 경계 설계

- Controller가 아니라 업무 단위가 명확한 Service 계층에 둔다.
- 외부 API 호출을 DB 트랜잭션 안에서 오래 기다리지 않게 한다.
- 읽기 전용 조회에는 readOnly=true를 검토하되, 이것이 모든 DB에서 쓰기를 강제로 차단하는 보안 장치라고 생각하지 않는다.
- 트랜잭션 범위를 지나치게 넓히지 않는다.

**정리:** @Transactional은 애너테이션 한 줄이 아니라 프록시 호출과 DB 커넥션의 생명주기를 다루는 기능이다. 실제 호출 경로와 롤백 규칙을 이해해야 한다.
