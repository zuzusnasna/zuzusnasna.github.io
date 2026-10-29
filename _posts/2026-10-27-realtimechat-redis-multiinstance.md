---
layout: post
title: "개인 프로젝트 : RealTimeChat — Redis Pub/Sub으로 다중 인스턴스 메시지 전달"
date: 2026-10-27 09:00:00 +0900
categories: [프로젝트]
tags: [RealTimeChat, Redis, WebSocket, Docker]
---

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
