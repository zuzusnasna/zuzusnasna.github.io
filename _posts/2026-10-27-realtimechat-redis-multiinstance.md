---
layout: post
title: "개인 프로젝트 : RealTimeChat — Redis Pub/Sub으로 다중 인스턴스 메시지 전달"
date: 2026-10-27 09:00:00 +0900
categories: [프로젝트]
tags: [RealTimeChat, Redis, WebSocket, Docker]
---

<figure class="project-visual project-diagram">
<svg viewBox="0 0 760 190" role="img" aria-label="Redis Pub Sub을 통한 채팅 다중 인스턴스 전달">
<rect x="8" y="20" width="160" height="60" rx="3" fill="#fff" stroke="#dedde1"/><text x="88" y="45" text-anchor="middle" font-size="14" fill="#242832">사용자 A</text><text x="88" y="64" text-anchor="middle" font-size="11" fill="#6f727b">App 1 연결</text>
<path d="M168 50 H220" stroke="#bd4b35" stroke-width="2"/><path d="M213 44 L220 50 L213 56" fill="none" stroke="#bd4b35" stroke-width="2"/>
<rect x="220" y="20" width="160" height="60" rx="3" fill="#f3e7e2" stroke="#bd4b35"/><text x="300" y="45" text-anchor="middle" font-size="14" fill="#242832">App 1</text><text x="300" y="64" text-anchor="middle" font-size="11" fill="#6f727b">메시지 처리</text>
<path d="M380 50 H432" stroke="#bd4b35" stroke-width="2"/><path d="M425 44 L432 50 L425 56" fill="none" stroke="#bd4b35" stroke-width="2"/>
<rect x="432" y="20" width="150" height="60" rx="3" fill="#fff" stroke="#dedde1"/><text x="507" y="45" text-anchor="middle" font-size="14" fill="#242832">Redis Pub/Sub</text><text x="507" y="64" text-anchor="middle" font-size="11" fill="#6f727b">이벤트 전달</text>
<path d="M582 50 H625 V133 H582" fill="none" stroke="#bd4b35" stroke-width="2"/><path d="M589 127 L582 133 L589 139" fill="none" stroke="#bd4b35" stroke-width="2"/>
<rect x="432" y="105" width="150" height="60" rx="3" fill="#fff" stroke="#dedde1"/><text x="507" y="130" text-anchor="middle" font-size="14" fill="#242832">App 2</text><text x="507" y="149" text-anchor="middle" font-size="11" fill="#6f727b">구독 후 전달</text>
<path d="M432 135 H380" stroke="#bd4b35" stroke-width="2"/><path d="M387 129 L380 135 L387 141" fill="none" stroke="#bd4b35" stroke-width="2"/>
<rect x="220" y="105" width="160" height="60" rx="3" fill="#fff" stroke="#dedde1"/><text x="300" y="130" text-anchor="middle" font-size="14" fill="#242832">사용자 B</text><text x="300" y="149" text-anchor="middle" font-size="11" fill="#6f727b">App 2 연결</text>
</svg><figcaption>각 애플리케이션 인스턴스의 로컬 세션을 넘어 Redis Pub/Sub으로 메시지 이벤트를 전달한다.</figcaption></figure>

서버를 한 대만 실행하면 메모리 안에서 메시지를 전달해도 되지만 애플리케이션 인스턴스가 두 개라면 문제가 달라진다.

## 문제

```text
User A → App 1
User B → App 2
```

A의 WebSocket 연결은 App 1에 있고 B의 연결은 App 2에 있다. App 1만 메시지를 알고 있으면 B에게 전달할 수 없다.

## Redis Pub/Sub

Redis를 중간 메시지 전달 계층으로 사용했다.

```text
          Redis Pub/Sub
         ↙             ↘
      App 1             App 2
       ↑                   ↑
    Client A            Client B
```

App 1이 채널에 메시지를 발행하면 다른 인스턴스가 구독해 자신의 WebSocket 연결에 전달한다.

## 중요한 구분

Redis Pub/Sub은 메시지 전달에 사용하고, 영구적인 채팅 기록은 MySQL에 저장한다.

```text
실시간 전달 → Redis Pub/Sub
영구 보관   → MySQL
```

## 배운 점

다중 인스턴스 환경에서는 WebSocket 연결 자체보다 **인스턴스 사이에서 메시지를 어떻게 공유할지**가 중요한 설계 문제가 된다는 것을 경험했다.

## 더 깊게 이해하기: Redis Pub/Sub은 브로커지만 영속 큐는 아니다

Redis Pub/Sub은 발행 시점에 구독 중인 클라이언트에게 메시지를 전달하는 간단한 방식이다. 구독자가 내려가 있거나 연결이 끊긴 동안 발행된 메시지를 나중에 다시 읽을 수 있는 저장소는 아니다. 따라서 메시지 유실을 허용할 수 있는 실시간 알림 중계에는 단순하지만, 반드시 처리해야 하는 업무 이벤트에는 별도 전달 보장이 필요할 수 있다.

여러 애플리케이션 인스턴스가 각각 WebSocket 연결을 담당하면, 한 인스턴스가 받은 메시지를 다른 인스턴스에 연결된 사용자에게 전달하는 경로가 필요하다. Redis는 이 이벤트를 중계할 수 있지만, DB 저장과 발행의 순서, 중복 전달, 메시지 순서 보장은 별도로 생각해야 한다.

### 선택 기준
- 유실된 이벤트를 나중에 재처리해야 하는가?
- 소비자 그룹과 오프셋 같은 처리 상태가 필요한가?
- 이벤트 순서가 어떤 범위에서 보장되어야 하는가?
- 운영 복잡도와 자원 비용을 감당할 수 있는가?

Pub/Sub과 Kafka를 비교할 때는 기능 목록만 비교하지 말고 이벤트의 중요도, 재처리 요구, 트래픽 규모, 운영 능력을 함께 고려해야 한다.
