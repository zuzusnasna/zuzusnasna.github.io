---
layout: post
title: "Java Queue와 Deque — 대기열과 양방향 큐"
date: 2026-10-30
categories: [Spring]
tags: [Java, Collection, Queue, Deque]
---

## Queue란?

Queue는 먼저 들어온 데이터가 먼저 나가는 FIFO 방식의 자료구조다. 작업 대기열, 요청 처리 순서 관리에 활용한다. 삽입은 offer(), 꺼내면서 제거는 poll(), 맨 앞 요소 확인은 peek()을 사용한다.

## Deque란?

Deque(Double Ended Queue)는 양쪽 끝에서 삽입과 삭제가 가능하다. Queue처럼 사용할 수도 있고 Stack처럼 사용할 수도 있다. Java에서는 ArrayDeque를 일반적인 큐·덱 구현체로 고려할 수 있다.

## BlockingQueue

BlockingQueue는 큐가 비어 있으면 take()가 기다리고, 용량이 가득 차면 put()이 공간이 생길 때까지 대기할 수 있다. 생산자-소비자 패턴에서 작업을 안전하게 전달할 때 사용한다.

## 선택 기준

| 요구사항 | 선택 |
| --- | --- |
| FIFO 대기열 | Queue |
| 양쪽 끝에서 삽입·삭제 | Deque |
| 스레드 간 작업 전달과 대기 | BlockingQueue |

## 서버 개발에서 구분할 점

BlockingQueue는 한 JVM 프로세스 내부의 스레드 간 작업 전달에 적합하다. 여러 서버 인스턴스가 함께 소비해야 하는 메시지라면 Kafka나 RabbitMQ 같은 외부 메시지 브로커가 해결하는 범위다.
