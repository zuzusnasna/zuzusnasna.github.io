---
layout: post
title: "Java volatile과 Atomic — 가시성, 원자성과 CAS"
date: 2026-08-21 00:00:00 +0900
categories: [Spring]
tags: [Java, Concurrency, volatile, AtomicInteger, Thread]
---

## 1. 동시성에서 발생하는 문제

여러 스레드가 같은 데이터를 읽고 수정하면 실행 순서에 따라 결과가 달라질 수 있다. 대표적으로 가시성(Visibility), 원자성(Atomicity), 순서(Ordering) 문제를 구분해야 한다.

- 가시성: 한 스레드의 변경 내용이 다른 스레드에 보이는가?
- 원자성: 여러 단계의 작업이 중간에 끊기지 않고 하나의 작업처럼 처리되는가?
- 순서: 컴파일러나 CPU의 최적화로 메모리 작업 순서가 바뀌어도 안전한가?

## 2. 가시성 문제 예시

```java
class Worker {
    private boolean running = true;

    void stop() {
        running = false;
    }

    void work() {
        while (running) {
            // 작업 수행
        }
    }
}
```

한 스레드가 stop()에서 false를 기록해도 다른 스레드가 변경된 값을 즉시 관찰한다고 보장할 수 없다. 스레드별 캐시나 컴파일러 최적화 등으로 인해 가시성 문제가 생길 수 있다.

## 3. volatile의 역할

volatile은 변수에 대한 읽기와 쓰기의 가시성을 보장하고, 해당 접근과 관련된 메모리 순서 규칙을 제공한다.

```java
class Worker {
    private volatile boolean running = true;

    void stop() {
        running = false;
    }

    void work() {
        while (running) {
            // 작업 수행
        }
    }
}
```

이처럼 한 스레드가 종료 플래그를 변경하고 다른 스레드가 확인하는 상황에 사용할 수 있다.

volatile은 모든 동시성 문제를 해결하는 키워드가 아니다. 특히 여러 단계로 이루어진 복합 연산을 원자적으로 만들지는 않는다.

## 4. volatile만으로 count++가 안전하지 않은 이유

```java
class Counter {
    volatile int count = 0;

    void increase() {
        count++;
    }
}
```

count++는 단일 CPU 명령처럼 보이지만 개념적으로 다음 세 단계다.

1. count 값을 읽는다.
2. 읽은 값에 1을 더한다.
3. 결과를 count에 기록한다.

두 스레드가 동시에 0을 읽으면 둘 다 1을 기록해 최종 결과가 2가 아니라 1이 될 수 있다. 이를 경쟁 상태(Race Condition)라고 한다.

## 5. AtomicInteger와 CAS

AtomicInteger는 정수 값을 원자적으로 갱신하는 연산을 제공한다.

```java
AtomicInteger count = new AtomicInteger(0);

Runnable task = () -> {
    for (int i = 0; i < 1000; i++) {
        count.incrementAndGet();
    }
};
```

CAS(Compare-And-Set)는 현재 값이 예상한 값과 같을 때만 새 값으로 변경하는 방식이다.

개념적으로는 다음과 같다.

1. 현재 값을 읽는다.
2. 읽은 값이 예상값과 같은지 확인한다.
3. 같으면 새 값으로 변경한다.
4. 중간에 다른 스레드가 값을 변경했다면 실패하고 다시 시도한다.

AtomicInteger의 증가 연산은 이러한 원자적 갱신 메커니즘을 활용한다. 다만 경쟁이 매우 심한 환경에서는 재시도가 늘어날 수 있다.

## 6. synchronized, volatile, Atomic 비교

| 방법 | 제공하는 보장 | 적합한 상황 |
| --- | --- | --- |
| volatile | 가시성 및 메모리 순서 | 상태 플래그 |
| AtomicInteger | 단일 변수의 원자적 갱신 | 카운터, 시퀀스 |
| synchronized | 임계 영역의 상호 배제와 가시성 | 여러 작업·변수의 일관성 |

여러 변수의 관계를 함께 유지해야 한다면 Atomic 변수 하나만으로 해결할 수 없다. 예를 들어 잔액을 확인한 뒤 출금하는 과정은 조회와 차감이 하나의 임계 영역으로 보호되어야 할 수 있다.

## 7. LongAdder는 언제 사용할까?

여러 스레드가 높은 빈도로 카운터를 증가시키는 통계성 작업에서는 LongAdder를 고려할 수 있다. 내부적으로 값을 분산해 경합을 줄이는 방식이다.

반면 즉시 정확한 단일 값을 읽어야 하는 업무에서는 AtomicLong 등과 요구사항을 비교해야 한다. LongAdder는 모든 상황에서 AtomicLong을 대체하는 자료구조가 아니다.

## 8. 실무 선택 기준

- 단순 종료 플래그처럼 한 값의 변경을 다른 스레드에 알려야 한다면 volatile을 고려한다.
- 단일 숫자의 원자적 증가·감소라면 AtomicInteger/AtomicLong을 고려한다.
- 여러 변수에 걸친 조건 검사와 변경을 함께 보호해야 한다면 synchronized 또는 Lock을 검토한다.
- 통계 카운터처럼 높은 경합에서 누적값을 모으는 목적이라면 LongAdder를 비교한다.

## 핵심 정리

- 가시성과 원자성은 서로 다른 문제다.
- volatile은 가시성을 보장하지만 count++ 같은 복합 연산을 원자적으로 만들지 않는다.
- Atomic 클래스는 CAS 기반의 원자적 갱신을 제공한다.
- 여러 값의 일관성을 지켜야 한다면 Lock이나 synchronized가 필요할 수 있다.
