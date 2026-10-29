---
layout: post
title: "실시간 시스템 : Redis Pub/Sub과 Kafka를 구분해서 사용하기"
date: 2026-10-30 23:00:00 +0900
categories: [학습]
tags: [Redis, Kafka, WebSocket, Spring Boot]
---

실시간 채팅을 구현하면서 Redis Pub/Sub과 Kafka를 모두 메시징 기술로 볼 수 있지만 요구사항은 다르다는 것을 정리했다.

## Redis Pub/Sub

```text
Publisher → Redis → Subscriber
```

현재 연결된 인스턴스에 빠르게 메시지를 전달하는 용도로 단순하고 빠르게 사용할 수 있다. 하지만 구독자가 없을 때 지나간 메시지를 나중에 다시 읽는 용도로 적합하지 않다.

## Kafka

Kafka는 메시지를 topic과 partition에 기록하고 consumer가 자신의 위치를 관리할 수 있다.

```text
Producer
   ↓
Topic / Partition
   ↓
Consumer Group
```

대규모 이벤트 처리, 여러 소비자가 같은 이벤트를 각각 처리해야 하는 경우, 이벤트를 일정 기간 보관해야 하는 경우에 강점이 있다.

## 선택 기준

```text
단순 실시간 전달 → Redis Pub/Sub
이벤트 스트림 / 재처리 / 소비자 분리 → Kafka
```

## 배운 점

기술 스택을 많이 사용하는 것보다 **메시지를 얼마나 오래 보관해야 하는지, 재처리가 필요한지, 소비자가 몇 개인지**를 먼저 정의하고 기술을 선택해야 한다.
