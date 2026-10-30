---
layout: post
title: "WebSocket과 STOMP의 개념과 사용 방법"
date: 2026-10-30 09:10:00 +0900
categories: [학습]
tags: [WebSocket, STOMP, Spring Boot]
---

실시간 통신을 공부하면서 HTTP 요청과 WebSocket 통신이 어떻게 다른지, 그리고 Spring에서 STOMP를 어떤 식으로 사용하는지 정리했다.

## WebSocket이란

HTTP는 일반적으로 클라이언트가 요청하고 서버가 응답하는 방식이다. WebSocket은 한 번 연결을 맺은 뒤 클라이언트와 서버가 같은 연결을 유지하면서 양방향으로 데이터를 주고받을 수 있다.

```text
HTTP
Client ── request ──> Server
Client <── response ── Server

WebSocket
Client <════ persistent connection ════> Server
          ↕ 양방향 메시지
```

채팅, 실시간 알림, 협업 화면처럼 서버에서 먼저 데이터를 보내야 하는 기능에 적합하다.

## Spring에서 WebSocket 연결 만들기

Spring에서는 WebSocket 엔드포인트를 등록하고 클라이언트가 해당 경로로 연결하도록 구성할 수 있다.

```java
@Configuration
@EnableWebSocketMessageBroker
public class WebSocketConfig implements WebSocketMessageBrokerConfigurer {

    @Override
    public void registerStompEndpoints(StompEndpointRegistry registry) {
        registry.addEndpoint("/ws");
    }
}
```

여기서 `/ws`는 WebSocket 연결을 시작하는 엔드포인트다.

## STOMP는 왜 사용하는가

WebSocket 자체는 연결과 데이터 전달 방법을 제공하지만 메시지를 어떤 형식으로 주고받을지에 대한 애플리케이션 레벨 규칙까지 정해주지는 않는다.

STOMP는 메시지의 destination과 subscribe, send 같은 규칙을 제공해 여러 메시지 흐름을 구분하기 쉽게 만든다.

```text
Client
  │
  ├─ SUBSCRIBE /topic/chat/1
  │
  └─ SEND /app/chat
          ↓
      Spring Message Broker
          ↓
      /topic/chat/1
          ↓
   subscribed clients
```

## Controller에서 메시지 처리하기

Spring에서는 `@MessageMapping`으로 클라이언트가 보낸 STOMP 메시지를 처리할 수 있다.

```java
@Controller
public class ChatController {

    @MessageMapping("/chat")
    @SendTo("/topic/chat")
    public ChatMessage send(ChatMessage message) {
        return message;
    }
}
```

클라이언트가 `/app/chat`으로 메시지를 보내면 `@MessageMapping("/chat")`가 처리하고, 반환된 메시지는 `/topic/chat`을 구독한 클라이언트에게 전달된다.

## WebSocket과 HTTP의 차이

| 구분 | HTTP | WebSocket |
|---|---|---|
| 통신 방식 | 요청 → 응답 | 양방향 통신 |
| 연결 | 요청마다 처리 | 연결 유지 |
| 서버의 먼저 전송 | 일반적으로 불가 | 가능 |
| 적합한 기능 | CRUD API | 채팅, 실시간 알림 |

WebSocket을 사용한다고 해서 모든 API를 WebSocket으로 바꿀 필요는 없다. 일반적인 조회·등록·수정·삭제는 HTTP API로 처리하고 실시간으로 전달해야 하는 이벤트만 WebSocket으로 분리하는 방식도 많이 사용한다.

## 사용할 때 같이 확인할 것

WebSocket 연결이 된다고 끝나는 것은 아니다. 인증된 사용자인지, 해당 destination을 사용할 권한이 있는지, 연결이 끊겼을 때 재연결을 어떻게 처리할지까지 별도로 설계해야 한다.

또한 여러 서버 인스턴스에서 WebSocket을 운영하면 각 서버의 메모리에 있는 연결 목록만으로는 다른 서버에 연결된 사용자에게 메시지를 전달할 수 없다. 이 경우 메시지 브로커나 별도의 이벤트 전달 구조가 필요하다.
