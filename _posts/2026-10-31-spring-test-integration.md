---
layout: post
title: "Spring Boot 통합 테스트 — @SpringBootTest와 테스트 DB 전략"
date: 2026-10-31 12:30:00 +0900
categories: [Spring]
tags: [Spring Boot, Testing, SpringBootTest, Integration Test, Database]
---
## 통합 테스트가 검증하는 것

단위 테스트는 각 클래스의 동작을 검증하지만 Bean 등록, AOP 프록시, 트랜잭션, Repository SQL, 직렬화가 실제로 연결되는지는 보장하지 않는다. 통합 테스트는 여러 구성 요소가 함께 동작하는 경계를 확인한다.

```java
@SpringBootTest
class OrderIntegrationTest {
    @Autowired OrderService orderService;
    @Autowired OrderRepository orderRepository;

    @Test
    @Transactional
    void createsOrder() {
        Order order = orderService.create(...);

        assertTrue(orderRepository.findById(order.getId()).isPresent());
    }
}
```

@SpringBootTest는 애플리케이션 컨텍스트를 로드하므로 슬라이스 테스트보다 무겁다. 실제로 확인할 통합 경계를 정해 테스트 수와 실행 시간을 관리한다.

## 테스트 DB 선택

- H2: 빠르지만 MySQL·Oracle과 SQL, 타입, 제약 조건 동작이 다를 수 있다.
- 실제 DB 컨테이너: 운영 DB와 가까운 동작을 확인할 수 있지만 시작 비용이 있다.
- 공유 개발 DB: 테스트 데이터 충돌과 환경 오염 위험이 있어 자동화 테스트에 부적절하다.

DB 종속 기능이 중요하다면 Testcontainers 등으로 실제 사용하는 DB 엔진을 테스트 환경에서 실행하는 방법을 검토한다.

## @Transactional 테스트의 주의점

테스트 메서드에 @Transactional을 붙이면 테스트 종료 시 롤백되는 방식으로 격리할 수 있다. 하지만 이 특성 때문에 실제 커밋 시점에 발생하는 동작을 검증하지 못할 수 있다. 커밋 시점의 제약 조건이나 트랜잭션 후처리를 확인하려면 테스트 트랜잭션을 명시적으로 커밋하는 별도 시나리오가 필요하다.

## 외부 시스템

결제, 메일, 메시지 브로커를 매 테스트마다 실제 호출하면 네트워크와 외부 장애에 영향을 받는다. 테스트 목적에 따라 Mock 서버, 컨테이너, 계약 테스트를 선택한다.

**실무 기준:** 통합 테스트는 모든 것을 한 번에 검증하는 테스트가 아니다. 실제 연결이 중요한 경계를 골라 운영 환경과 유사한 조건에서 확인하는 테스트다.
