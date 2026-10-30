---
layout: post
title: "Mockito Service 단위 테스트 — Mock과 실제 검증의 경계"
date: 2026-09-17 00:00:00 +0900
categories: [Spring]
tags: [Spring, Testing, Mockito, Unit Test]
---
## Service 테스트에서 의존성을 격리하기

Service는 Repository, 결제 API, 메시지 발행기 등에 의존할 수 있다. 업무 흐름을 검증하는 테스트에서 실제 DB와 외부 API를 매번 호출하면 느리고 불안정해진다. Mockito는 협력 객체를 Mock으로 대체해 Service 동작을 격리한다.

```java
@ExtendWith(MockitoExtension.class)
class OrderServiceTest {
    @Mock OrderRepository orderRepository;
    @InjectMocks OrderService orderService;

    @Test
    void returnsOrderWhenFound() {
        Order order = new Order(1L, OrderStatus.CREATED);
        given(orderRepository.findById(1L))
            .willReturn(Optional.of(order));

        Order result = orderService.find(1L);

        assertEquals(OrderStatus.CREATED, result.getStatus());
        then(orderRepository).should().findById(1L);
    }
}
```

- @Mock: 가짜 협력 객체 생성
- @InjectMocks: Mock을 테스트 대상에 주입
- given / willReturn: 호출 결과 설정
- then / should: 상호작용 검증

## 실패 조건을 반드시 테스트한다

주문 서비스라면 다음 상황을 검증할 수 있다.

- 주문이 존재하지 않으면 적절한 예외가 발생하는가?
- 이미 취소된 주문을 다시 취소하지 못하게 하는가?
- 재고가 부족하면 주문을 생성하지 않는가?
- 결제 실패 후 다음 단계로 진행하지 않는가?

## Mock을 과도하게 사용하지 않기

내부 메서드 호출 순서를 전부 검증하면 리팩터링만으로 테스트가 깨진다. 반환값, 저장 결과, 상태 변화 등 외부에서 확인할 수 있는 동작을 우선 검증한다.

Mock은 실제 DB의 제약 조건이나 SQL 오류를 검증하지 못한다. Repository 동작은 JPA 슬라이스 테스트나 통합 테스트에서 별도로 확인해야 한다.

**실무 기준:** Mockito는 외부 의존성을 격리하는 도구이지 실제 인프라 테스트를 대체하는 도구가 아니다.
