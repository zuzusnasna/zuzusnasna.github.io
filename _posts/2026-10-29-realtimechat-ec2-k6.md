---
layout: post
title: "개인 프로젝트 : RealTimeChat — EC2 자원 부족과 k6 부하 테스트"
date: 2026-10-29 09:00:00 +0900
categories: [프로젝트]
tags: [RealTimeChat, AWS, EC2, k6, 성능]
---

RealTimeChat을 EC2에 배포한 뒤 빠르게 메시지를 연속으로 보내면 약 1초 정도 지연되는 현상이 있었다.

## 처음 의심한 부분

실시간 채팅이기 때문에 WebSocket이나 메시지 순서를 먼저 의심했다. 하지만 코드부터 수정하기보다 서버 상태를 확인했다.

## 서버 상태

관찰 당시 약 770MiB 수준의 메모리 사용, 1GiB 이상의 swap 사용, 높은 I/O wait가 확인됐다. 이후에도 메모리 약 757MiB, swap 약 1.4GiB, I/O wait 약 84~86% 수준이 관찰됐다.

Prometheus/Grafana 모니터링 컨테이너를 중지하자 메모리와 swap 사용량이 감소했다.

## 판단

```text
메시지 지연
   ↓
애플리케이션 코드만 의심하지 않음
   ↓
CPU / Memory / Swap / I/O 확인
   ↓
EC2 자원 압박 확인
   ↓
모니터링 컨테이너 축소
```

## k6 검증

이후 WebSocket 부하 테스트에서는 5 VU 기준 HTTP 요청 51/51 성공, WebSocket 관련 검증 23/23 성공을 확인했고 cross-instance delivery 평균 약 17.99ms, p95 약 27ms를 기록했다.

## 배운 점

성능 문제는 **기능 문제와 분리해서 접근해야 한다.** 메시지 순서가 이상하더라도 서버가 swap을 과도하게 사용하는 상황이라면 먼저 시스템 자원을 정상화해야 정확한 원인을 판단할 수 있다.
