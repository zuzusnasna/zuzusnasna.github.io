---
layout: post
title: "개인 프로젝트 : RealTimeChat — WebSocket과 STOMP를 선택한 이유"
date: 2026-10-26 09:00:00 +0900
categories: [프로젝트]
tags: [RealTimeChat, WebSocket, STOMP, Spring Boot]
---

일반적인 HTTP 요청만으로 채팅을 만들면 사용자가 메시지를 확인하기 위해 계속 서버에 요청해야 한다. 실시간 채팅에서는 서버가 새로운 메시지를 연결된 클라이언트에 바로 전달할 필요가 있다.

## WebSocket

WebSocket은 연결을 한 번 만든 뒤 양방향으로 데이터를 주고받을 수 있다.

```text
Client ←──────── WebSocket ────────→ Server
          연결 유지
```

## STOMP

WebSocket 자체는 통신 채널이고 메시지의 목적지와 형식까지 모두 정해 주지는 않는다. STOMP를 사용하면 destination 기반으로 메시지를 구분할 수 있다.

```text
/ws
 /pub/rooms/{roomId}
 /sub/rooms/{roomId}
```

## 프로젝트에서의 흐름

```text
사용자 메시지
 ↓
STOMP SEND
 ↓
Spring Message Broker
 ↓
채팅방 구독자에게 전달
 ↓
DB 저장 / 화면 반영
```

## 배운 점

WebSocket을 단순히 HTTP보다 빠른 기술로 생각하기보다 **연결을 지속하면서 서버와 클라이언트가 모두 메시지를 보낼 수 있게 하는 통신 방식**으로 이해하는 것이 중요했다.
