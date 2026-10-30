---
layout: post
title: "Transactional Outbox의 개념과 이벤트를 안전하게 전달하는 방법"
date: 2026-09-11 00:00:00 +0900
categories: [학습]
tags: [Transactional Outbox, Transaction, Kafka, Event]
---

DB 상태 변경과 메시지 발행을 함께 처리해야 하는 상황을 공부하면서 Transactional Outbox 패턴을 정리했다.

## 왜 문제가 생기는가

주문 상태를 DB에 저장한 뒤 메시지 브로커에 이벤트를 발행한다고 가정해 보자.

```text
DB 저장 성공
   ↓
이벤트 발행
   ↓
실패
```

DB에는 상태가 바뀌었는데 이벤트가 전달되지 않는 문제가 생길 수 있다.

반대로 이벤트를 먼저 발행하고 DB 저장이 실패하면 소비자는 존재하지 않는 상태를 기준으로 작업할 수도 있다.

## Outbox 패턴

핵심은 이벤트를 별도의 Outbox 테이블에 DB 변경과 같은 Transaction으로 저장하는 것이다.

```text
Service
  │
  ├── 실제 데이터 변경
  │
  └── Outbox 이벤트 저장
          ↓
       COMMIT
          ↓
     Outbox Worker
          ↓
    Message Broker
```

DB Transaction이 성공하면 실제 데이터와 Outbox 이벤트가 함께 저장된다.

## 테이블 예시

```sql
CREATE TABLE outbox_event (
    id BIGINT PRIMARY KEY,
    event_type VARCHAR(100) NOT NULL,
    payload TEXT NOT NULL,
    status VARCHAR(20) NOT NULL,
    created_at TIMESTAMP NOT NULL
);
```

서비스에서는 두 작업을 같은 Transaction 안에서 처리한다.

```java
@Transactional
public void createOrder(Order order) {
    orderRepository.save(order);

    outboxRepository.save(
        OutboxEvent.create("ORDER_CREATED", order.getId())
    );
}
```

## Worker가 하는 일

별도의 Worker가 아직 처리되지 않은 Outbox 이벤트를 조회해 메시지 브로커로 전달한다.

```text
PENDING
  ↓
발행 시도
  ↓
성공 → SENT
실패 → 재시도
```

따라서 애플리케이션 요청 처리와 외부 메시지 전달을 분리할 수 있다.

## 중복 처리는 별도로 필요하다

Outbox를 사용한다고 해서 메시지가 정확히 한 번만 전달되는 것은 아니다.

Worker가 메시지를 브로커에 성공적으로 발행한 직후 상태 변경 전에 종료되면 같은 이벤트가 다시 발행될 수 있다.

그래서 소비자 쪽에서는 이벤트 ID 등을 기준으로 중복 처리를 방어하는 구조가 필요하다.

```text
Outbox
  ↓
이벤트 발행
  ↓
Consumer
  ↓
eventId 이미 처리했나?
  ├─ Yes → 무시
  └─ No  → 처리 후 기록
```

## 언제 사용하는가

DB 변경과 외부 이벤트 발행의 정합성이 중요한 경우에 적합하다.

- 주문 생성 후 이벤트 발행
- 결제 상태 변경 후 후속 처리
- 회원 상태 변경 후 다른 시스템 알림
- 비동기 작업 요청 기록

다만 단순한 내부 메서드 호출에 항상 Outbox를 적용할 필요는 없다. 별도 메시지 전달의 신뢰성과 재처리가 필요한지부터 판단해야 한다.
