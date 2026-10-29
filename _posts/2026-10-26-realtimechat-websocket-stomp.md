---
layout: post
title: "개인 프로젝트 : RealTimeChat — WebSocket과 STOMP를 선택한 이유"
date: 2026-10-26 09:00:00 +0900
categories: [프로젝트]
tags: [RealTimeChat, WebSocket, STOMP, Spring Boot]
---

<figure class="project-visual project-diagram">
<svg viewBox="0 0 760 150" role="img" aria-label="실시간 채팅 WebSocket STOMP 흐름">
<rect x="8" y="35" width="150" height="72" rx="3" fill="#fff" stroke="#dedde1"/><text x="83" y="65" text-anchor="middle" font-size="14" fill="#242832">브라우저</text><text x="83" y="85" text-anchor="middle" font-size="11" fill="#6f727b">STOMP client</text>
<path d="M158 71 H202" stroke="#bd4b35" stroke-width="2"/><path d="M195 65 L202 71 L195 77" fill="none" stroke="#bd4b35" stroke-width="2"/>
<rect x="202" y="35" width="170" height="72" rx="3" fill="#f3e7e2" stroke="#bd4b35"/><text x="287" y="65" text-anchor="middle" font-size="14" fill="#242832">WebSocket</text><text x="287" y="85" text-anchor="middle" font-size="11" fill="#6f727b">양방향 연결</text>
<path d="M372 71 H416" stroke="#bd4b35" stroke-width="2"/><path d="M409 65 L416 71 L409 77" fill="none" stroke="#bd4b35" stroke-width="2"/>
<rect x="416" y="35" width="155" height="72" rx="3" fill="#fff" stroke="#dedde1"/><text x="493" y="65" text-anchor="middle" font-size="14" fill="#242832">Spring Broker</text><text x="493" y="85" text-anchor="middle" font-size="11" fill="#6f727b">구독 목적지</text>
<path d="M571 71 H615" stroke="#bd4b35" stroke-width="2"/><path d="M608 65 L615 71 L608 77" fill="none" stroke="#bd4b35" stroke-width="2"/>
<rect x="615" y="35" width="137" height="72" rx="3" fill="#fff" stroke="#dedde1"/><text x="683" y="65" text-anchor="middle" font-size="14" fill="#242832">구독 사용자</text><text x="683" y="85" text-anchor="middle" font-size="11" fill="#6f727b">실시간 수신</text>
</svg><figcaption>STOMP 목적지에 메시지를 발행하고 해당 목적지를 구독 중인 클라이언트로 전달하는 기본 흐름.</figcaption></figure>

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

## 더 깊게 이해하기: WebSocket 연결과 메시지 권한은 별개다

WebSocket은 연결을 오래 유지하며 양방향 데이터를 전달하는 통신 방식이다. STOMP는 그 위에서 destination, subscribe, send 같은 메시징 규약을 제공한다. 연결이 성공했다는 사실만으로 모든 destination을 구독하거나 메시지를 보낼 권한이 생기는 것은 아니다.

실시간 서비스에서는 연결 시점 인증과 메시지 처리 시점의 권한 검증을 구분해야 한다. 사용자가 로그인한 상태여도 특정 채팅방의 참여자가 아닐 수 있다. 따라서 서버는 destination이나 메시지의 room ID를 신뢰하지 않고 실제 사용자와 방 참여 관계를 확인해야 한다.

### 테스트 시나리오
- 비로그인 사용자의 WebSocket 연결 또는 STOMP 메시지가 거부되는가?
- 다른 방 ID를 임의로 지정해 구독하거나 메시지를 보내도 차단되는가?
- 연결이 끊겼다가 재연결될 때 구독과 인증 상태를 올바르게 복구하는가?
- REST API와 WebSocket에서 권한 규칙이 일치하는가?
- 메시지를 저장하기 전에 유효성 검사와 권한 확인이 완료되는가?

실시간 통신에서도 서버가 권한의 최종 판단자여야 한다. 클라이언트 화면에서 버튼을 숨기는 것은 접근 제어를 대신하지 못한다.
