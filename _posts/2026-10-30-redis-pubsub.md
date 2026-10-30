---
layout: post
title: "Redis Pub/Sub의 개념과 메시지 전달 방식"
date: 2026-07-31 00:00:00 +0900
categories: [학습]
tags: [Redis, Pub/Sub, Spring Boot]
---

Redis를 공부하면서 단순 캐시뿐 아니라 여러 애플리케이션 사이에 이벤트를 전달하는 Pub/Sub 기능도 정리했다.

## Pub/Sub이란

Publisher가 채널에 메시지를 발행하면 해당 채널을 구독하고 있는 Subscriber가 메시지를 받는 방식이다.

```text
Publisher
   │ PUBLISH chat "hello"
   ↓
 Redis Channel
   ↓
Subscriber A   Subscriber B
```

메시지를 특정 저장 공간에 넣어두고 나중에 읽는 방식이 아니라, 발행 시점에 연결되어 있는 구독자에게 전달하는 구조다.

## Redis에서 사용하는 방법

Redis CLI에서는 다음처럼 채널을 구독할 수 있다.

```text
SUBSCRIBE chat
```

다른 연결에서 메시지를 발행한다.

```text
PUBLISH chat "hello"
```

그러면 `chat` 채널을 구독하고 있던 클라이언트가 메시지를 받는다.

## Spring에서 사용하기

Spring Data Redis에서는 `RedisMessageListenerContainer`를 이용해 특정 채널의 메시지를 수신할 수 있다.

```java
@Bean
RedisMessageListenerContainer container(
        RedisConnectionFactory connectionFactory,
        MessageListenerAdapter listener) {

    RedisMessageListenerContainer container =
            new RedisMessageListenerContainer();
    container.setConnectionFactory(connectionFactory);
    container.addMessageListener(listener,
            new ChannelTopic("chat"));
    return container;
}
```

메시지를 보내는 쪽에서는 RedisTemplate을 사용할 수 있다.

```java
redisTemplate.convertAndSend("chat", message);
```

## Pub/Sub의 장점

- 애플리케이션 인스턴스 사이에 이벤트를 전달하기 쉽다.
- 별도의 메시지 소비자 관리 없이 간단한 이벤트 중계에 사용할 수 있다.
- Redis를 이미 사용하고 있다면 추가 구성 비용이 작다.

## 주의할 점

Redis Pub/Sub은 메시지를 영구 저장하는 큐가 아니다. Subscriber가 연결되어 있지 않은 동안 발행된 메시지를 나중에 다시 읽을 수 없다.

```text
Subscriber 연결 상태
     │
     ├─ 연결됨 → 메시지 수신
     │
     └─ 연결 끊김 → 해당 메시지를 놓침
```

메시지 유실이 허용되지 않거나 처리 여부를 추적해야 한다면 Redis Streams, Kafka 같은 다른 메시징 방식을 검토해야 한다.

## Pub/Sub과 Queue의 차이

Pub/Sub은 하나의 이벤트를 여러 구독자에게 전달하는 데 적합하고, 일반적인 작업 큐는 하나의 작업을 소비자가 처리하고 완료하는 흐름에 더 가깝다.

따라서 기술을 선택할 때는 **메시지를 얼마나 오래 보관해야 하는지, 재처리가 필요한지, 소비 순서를 보장해야 하는지**를 먼저 확인해야 한다.
