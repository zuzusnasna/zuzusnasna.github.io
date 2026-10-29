---
layout: post
title: "개인 프로젝트 : RealTimeChat — WebSocket 기반 실시간 채팅"
date: 2026-09-22 09:00:00 +0900
categories: [프로젝트]
tags: [RealTimeChat, WebSocket, STOMP, Redis, AWS, EC2]
---

## 프로젝트 개요

Spring Boot와 React로 구현한 실시간 채팅 서비스다.

### 주요 구성

- HTTP Session 인증
- 채팅방 생성·참여
- 메시지 저장 및 이전 대화 조회
- WebSocket / STOMP 실시간 송수신
- 사용자별 읽음 위치와 미읽음 인원 수
- 닉네임 변경 및 URL 링크 처리
- Redis Pub/Sub 기반 다중 인스턴스 메시지 중계
- Docker Compose + Nginx + EC2 배포
- k6 WebSocket 부하 테스트

## 아키텍처에서 중요했던 부분

Spring Boot 인스턴스를 2개 실행하고 Redis Pub/Sub을 중간에 두어 한 인스턴스에서 발생한 메시지를 다른 인스턴스로 전달하도록 구성했다.

```text
Browser
  ↓
Nginx
  ↓
App 1 / App 2
  ↓
MySQL + Redis Pub/Sub
```

## 프로젝트에서 어려웠던 부분

### EC2 자원 부족

빠르게 메시지를 연속 전송했을 때 약 1초 정도 지연이 발생했다. 처음에는 WebSocket이나 메시지 순서를 의심했지만 서버 자원을 먼저 확인했다.

약 770MiB 메모리와 1GiB 수준의 swap 사용량, 높은 I/O wait가 관찰됐고 모니터링 컨테이너를 중지한 뒤 자원 사용량이 감소했다.

### 메시지 순서

전달 지연 자체는 개선됐지만 강한 부하 테스트에서 메시지 순서 역전과 sequence gap이 기록됐다. 그래서 실제 유실인지 늦은 도착인지 구분하는 검증 로직이 필요하다는 결론을 얻었다.

## 배운 점

실시간 시스템에서는 기능이 정상적으로 동작하는 것과 **부하가 걸렸을 때 지연·순서·중복이 어떻게 되는지**를 별도로 검증해야 한다는 것을 배웠다.
