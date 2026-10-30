---
layout: post
title: "Java Deadlock — 교착 상태의 발생 조건과 예방"
date: 2026-09-04 00:00:00 +0900
categories: [Spring]
tags: [Java, Concurrency, Deadlock, Thread, Lock]
---

## 1. 교착 상태란?

Deadlock(교착 상태)은 두 개 이상의 스레드가 서로 상대방이 점유한 자원을 기다리면서 더 이상 진행하지 못하는 상태다.

예를 들어 스레드 A가 자원 1을 가진 채 자원 2를 기다리고, 스레드 B가 자원 2를 가진 채 자원 1을 기다리면 두 스레드는 서로 기다리게 된다.

```text
Thread A: Lock 1 보유 ──> Lock 2 대기
Thread B: Lock 2 보유 ──> Lock 1 대기
                   ↖      ↙
                    Deadlock
```

## 2. Java 코드로 보는 Deadlock

```java
public class DeadlockExample {
    private static final Object LOCK_A = new Object();
    private static final Object LOCK_B = new Object();

    public static void main(String[] args) {
        Thread t1 = new Thread(() -> {
            synchronized (LOCK_A) {
                sleep();
                synchronized (LOCK_B) {
                    System.out.println("Thread 1 작업");
                }
            }
        });

        Thread t2 = new Thread(() -> {
            synchronized (LOCK_B) {
                sleep();
                synchronized (LOCK_A) {
                    System.out.println("Thread 2 작업");
                }
            }
        });

        t1.start();
        t2.start();
    }

    private static void sleep() {
        try {
            Thread.sleep(100);
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
        }
    }
}
```

t1은 A를 획득한 뒤 B를 기다리고, t2는 B를 획득한 뒤 A를 기다릴 수 있다. 두 스레드가 서로의 락을 기다리는 상황이 만들어진다.

## 3. 교착 상태의 네 가지 필요 조건

일반적으로 교착 상태가 발생하려면 다음 네 조건이 동시에 성립해야 한다.

1. **상호 배제(Mutual Exclusion)**: 자원을 한 번에 하나의 스레드만 사용한다.
2. **점유와 대기(Hold and Wait)**: 자원을 가진 상태에서 다른 자원을 기다린다.
3. **비선점(No Preemption)**: 다른 스레드가 자원을 강제로 빼앗을 수 없다.
4. **순환 대기(Circular Wait)**: 스레드들이 원형으로 서로의 자원을 기다린다.

예방은 네 조건 중 하나 이상이 성립하지 않도록 설계하는 것이다.

## 4. 락 획득 순서를 통일하기

가장 실용적인 예방 방법 중 하나는 여러 락을 획득할 때 순서를 통일하는 것이다.

```java
synchronized (LOCK_A) {
    synchronized (LOCK_B) {
        // 두 자원이 필요한 작업
    }
}
```

모든 스레드가 A 다음 B 순서로 락을 획득하면 A와 B를 반대 순서로 잡는 순환 대기를 방지할 수 있다.

실제 서비스에서 여러 계좌를 이체하는 로직처럼 두 개 이상의 데이터나 자원을 잠가야 한다면, 자원 ID를 기준으로 정렬한 후 같은 순서로 잠그는 방법을 고려할 수 있다.

## 5. ReentrantLock과 tryLock

ReentrantLock은 락 획득 시도와 타임아웃을 지원한다.

```java
Lock lockA = new ReentrantLock();

try {
    if (lockA.tryLock(1, TimeUnit.SECONDS)) {
        try {
            process();
        } finally {
            lockA.unlock();
        }
    } else {
        // 제한 시간 안에 락을 얻지 못한 경우
    }
} catch (InterruptedException e) {
    Thread.currentThread().interrupt();
}
```

tryLock은 무한 대기를 피하는 데 도움이 되지만, 락 획득 실패 시 재시도·오류 반환·보상 처리 등 업무 정책을 함께 정해야 한다. 락을 획득했다면 반드시 finally에서 해제해야 한다.

## 6. Deadlock과 다른 대기 상태 구분

| 상태 | 의미 |
| --- | --- |
| BLOCKED | 모니터 락을 얻기 위해 대기 |
| WAITING | 다른 스레드의 특정 동작을 기다림 |
| TIMED_WAITING | 제한된 시간 동안 대기 |
| Deadlock | 스레드 간 자원 대기가 순환되어 진행 불가 |

BLOCKED 상태가 있다고 무조건 Deadlock은 아니다. 다른 스레드가 락을 해제하면 정상 진행할 수 있다. 서로가 가진 락을 기다리는 순환 관계인지 확인해야 한다.

## 7. 장애 분석: Thread Dump

서버가 응답하지 않을 때 CPU 사용률만 확인해서는 원인을 찾기 어렵다. 스레드 덤프를 수집하면 어떤 스레드가 어떤 락을 보유하고 기다리는지 확인할 수 있다.

```bash
jcmd <PID> Thread.print
```

분석할 때는 다음을 살펴본다.

- BLOCKED 상태가 장시간 유지되는 스레드
- 각 스레드가 보유한 모니터 락
- 대기 중인 락의 소유자
- Deadlock detected 메시지
- 동일한 스택 위치에서 반복적으로 대기하는 스레드

## 핵심 정리

- Deadlock은 스레드들이 서로의 자원을 기다리는 순환 대기 상태다.
- 상호 배제, 점유와 대기, 비선점, 순환 대기 조건을 이해한다.
- 락 획득 순서를 통일하면 순환 대기를 예방할 수 있다.
- tryLock과 타임아웃은 무한 대기를 줄이는 수단이다.
- 장애 상황에서는 Thread Dump로 락 소유 관계를 분석한다.
