---
title: "Java Synchronization — synchronized와 Lock으로 동시성 제어하기"
date: 2026-08-11 00:00:00 +0900
categories: [Spring]
tags: [Java, Concurrency, Thread, synchronized, Lock]
---

## 1. 동시성 문제가 발생하는 이유

여러 스레드가 같은 데이터를 동시에 읽고 수정하면 실행 순서에 따라 결과가 달라질 수 있다. 예를 들어 두 스레드가 동시에 재고를 1개씩 감소시키면, 읽기와 쓰기 사이에 실행이 섞여 실제 감소량보다 적게 반영될 수 있다.

이를 경쟁 상태(Race Condition)라고 한다.

## 2. synchronized

synchronized는 지정한 모니터 락을 획득한 스레드만 임계 영역을 실행하도록 한다. 같은 락을 사용하는 다른 스레드는 먼저 실행 중인 스레드가 락을 반납할 때까지 대기한다.

```java
public class Stock {
    private int quantity = 10;

    public synchronized void decrease() {
        if (quantity > 0) {
            quantity--;
        }
    }

    public synchronized int getQuantity() {
        return quantity;
    }
}
```

인스턴스 synchronized 메서드는 해당 객체의 모니터 락을 사용한다. static synchronized 메서드는 해당 Class 객체의 모니터 락을 사용한다.

## 3. Lock 인터페이스

ReentrantLock은 synchronized보다 세밀하게 락 획득과 해제 시점을 제어할 수 있다. 단, 직접 락을 해제해야 하므로 finally에서 unlock하는 습관이 중요하다.

```java
private final Lock lock = new ReentrantLock();

public void decrease() {
    lock.lock();
    try {
        if (quantity > 0) {
            quantity--;
        }
    } finally {
        lock.unlock();
    }
}
```

tryLock()을 사용하면 일정 시간 동안 락 획득을 시도하거나, 락을 얻지 못했을 때 다른 처리를 할 수 있다.

## 4. synchronized와 Lock 선택

| 구분 | synchronized | ReentrantLock |
| --- | --- | --- |
| 락 해제 | 블록 종료 시 자동 | unlock 직접 호출 |
| 타임아웃 획득 | 기본 제공 안 함 | tryLock 지원 |
| 인터럽트 대응 | 제한적 | lockInterruptibly 지원 |
| 사용 난이도 | 비교적 간단 | 직접 관리 필요 |

단순한 임계 영역 보호라면 synchronized로 충분한 경우가 많다. 락 획득 시간 제한이나 인터럽트 처리 등 세밀한 제어가 필요하면 Lock을 고려한다.

## 5. 서버 개발에서 주의할 점

Java의 synchronized는 하나의 JVM 내부에서만 동작한다. 애플리케이션을 여러 서버 인스턴스로 실행하면 각 인스턴스의 락은 서로 공유되지 않는다.

따라서 여러 서버가 같은 DB 데이터를 수정하는 상황에서는 DB 트랜잭션과 잠금, 낙관적·비관적 락, 분산 락 등의 접근을 별도로 검토해야 한다. 로컬 스레드 동기화와 분산 환경의 동시성 제어는 다른 문제다.
