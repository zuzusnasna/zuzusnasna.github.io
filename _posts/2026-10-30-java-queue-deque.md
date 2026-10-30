---
layout: post
title: "Java Queue와 Deque — FIFO, 양방향 큐와 BlockingQueue"
date: 2026-10-10 00:00:00 +0900
categories: [Spring]
tags: [Java, Collection, Queue, Deque, BlockingQueue]
---

## 1. Queue란?

Queue는 먼저 들어온 데이터가 먼저 나가는 FIFO(First In, First Out) 구조다. 은행 대기열, 작업 처리 순서, 요청 버퍼처럼 들어온 순서를 유지해야 하는 곳에 사용한다.

```java
Queue<String> queue = new LinkedList<>();

queue.offer("작업 A");
queue.offer("작업 B");
queue.offer("작업 C");

System.out.println(queue.poll()); // 작업 A
System.out.println(queue.peek()); // 작업 B
```

Queue 인터페이스에서 자주 사용하는 메서드는 다음과 같다.

| 메서드 | 동작 | 실패 시 |
| --- | --- | --- |
| add(e) | 요소 추가 | 예외 발생 |
| offer(e) | 요소 추가 | false 반환 |
| remove() | 맨 앞 요소 제거 후 반환 | 예외 발생 |
| poll() | 맨 앞 요소 제거 후 반환 | null 반환 |
| element() | 맨 앞 요소 확인 | 예외 발생 |
| peek() | 맨 앞 요소 확인 | null 반환 |

실패 상황을 예외 대신 반환값으로 처리하고 싶다면 offer, poll, peek을 사용할 수 있다.

## 2. Deque란?

Deque(Double Ended Queue)는 양쪽 끝에서 삽입과 삭제가 가능한 자료구조다. Queue처럼 FIFO로 사용할 수도 있고 Stack처럼 LIFO로 사용할 수도 있다.

```java
Deque<String> deque = new ArrayDeque<>();

deque.addFirst("앞");
deque.addLast("뒤");

System.out.println(deque.removeFirst()); // 앞
System.out.println(deque.removeLast());  // 뒤
```

Stack 용도로는 오래된 Stack 클래스 대신 Deque의 `push()`, `pop()`을 활용할 수 있다.

```java
Deque<Integer> stack = new ArrayDeque<>();

stack.push(10);
stack.push(20);

System.out.println(stack.pop()); // 20
```

## 3. ArrayDeque와 LinkedList

ArrayDeque는 배열 기반으로 양 끝 작업을 처리하는 덱 구현체다. 일반적인 큐나 스택 용도에서 우선 고려할 수 있다. LinkedList는 노드 연결 방식으로 양 끝 삽입·삭제를 제공한다.

ArrayDeque는 null 요소를 허용하지 않으며, 두 구현체 모두 일반적인 동시성 공유를 위한 자료구조는 아니다. 여러 스레드가 동시에 접근해야 한다면 별도의 동시성 컬렉션을 선택해야 한다.

## 4. BlockingQueue

BlockingQueue는 스레드 간 작업 전달을 위해 제공되는 큐다. 큐가 비어 있을 때 `take()`를 호출하면 요소가 들어올 때까지 기다리고, 제한 용량이 가득 찬 큐에 `put()`을 호출하면 공간이 생길 때까지 대기한다.

```java
BlockingQueue<String> jobs = new ArrayBlockingQueue<>(3);

// 생산자
jobs.put("메일 발송");

// 소비자
String job = jobs.take();
System.out.println(job);
```

생산자는 작업을 큐에 넣고 소비자는 큐에서 꺼내 처리한다. 두 스레드가 직접 서로의 실행 시점을 맞추지 않아도 큐가 대기와 전달을 조정한다.

## 5. 생산자-소비자 패턴

```java
BlockingQueue<Integer> queue = new ArrayBlockingQueue<>(10);

Runnable producer = () -> {
    try {
        for (int i = 1; i <= 5; i++) {
            queue.put(i);
        }
    } catch (InterruptedException e) {
        Thread.currentThread().interrupt();
    }
};

Runnable consumer = () -> {
    try {
        while (!Thread.currentThread().isInterrupted()) {
            Integer job = queue.take();
            System.out.println("처리: " + job);
            if (job == 5) break;
        }
    } catch (InterruptedException e) {
        Thread.currentThread().interrupt();
    }
};
```

실제 서비스에서는 종료 신호, 예외 처리, 작업 재시도, 소비자 스레드 종료 정책을 함께 설계해야 한다. 무한 루프만 작성하면 애플리케이션 종료가 어려워질 수 있다.

## 6. BlockingQueue와 메시지 브로커의 차이

BlockingQueue는 기본적으로 한 JVM 프로세스 안에서 스레드 사이의 작업을 전달하는 용도다. 애플리케이션 프로세스가 종료되면 메모리의 큐 데이터도 사라진다.

반면 Kafka나 RabbitMQ 같은 메시지 브로커는 별도 프로세스/서버로 동작하며 여러 애플리케이션 인스턴스 사이의 메시지 전달, 보관, 소비 관리 등을 제공한다.

| 구분 | BlockingQueue | Kafka 등 브로커 |
| --- | --- | --- |
| 범위 | 한 프로세스 내부 | 여러 프로세스·서버 |
| 데이터 | 주로 메모리 | 설정에 따라 디스크 보관 |
| 목적 | 스레드 간 작업 전달 | 서비스 간 메시지 전달 |
| 확장 | 프로세스 내부 | 분산 환경 고려 |

## 핵심 정리

- Queue는 FIFO, Deque는 양쪽 끝에서 삽입·삭제를 지원한다.
- ArrayDeque는 일반적인 큐와 스택 구현에서 유용하다.
- BlockingQueue는 큐가 비거나 가득 찬 상황에서 스레드를 대기시킬 수 있다.
- BlockingQueue는 JVM 내부 작업 전달이며 분산 메시징 브로커와 역할이 다르다.
