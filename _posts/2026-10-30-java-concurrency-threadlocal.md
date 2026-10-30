---
layout: post
title: "Java ThreadLocal — 스레드별 데이터와 스레드 풀 주의점"
date: 2026-07-31 00:00:00 +0900
categories: [Spring]
tags: [Java, Concurrency, ThreadLocal, Thread]
---

## 1. ThreadLocal이란?

ThreadLocal은 같은 ThreadLocal 변수에 접근하더라도 스레드마다 서로 다른 값을 보관할 수 있게 하는 기능이다. 일반적인 공유 변수처럼 모든 스레드가 하나의 값을 함께 수정하는 구조와 다르다.

```java
private static final ThreadLocal<String> USER =
        new ThreadLocal<>();

// 스레드 A
USER.set("user-A");

// 스레드 B
USER.set("user-B");
```

두 스레드는 같은 ThreadLocal 객체를 사용하지만 각자 자신의 스레드에 연결된 값을 읽는다.

## 2. 사용 예시

```java
public class RequestContext {
    private static final ThreadLocal<String> TRACE_ID =
            new ThreadLocal<>();

    public static void setTraceId(String id) {
        TRACE_ID.set(id);
    }

    public static String getTraceId() {
        return TRACE_ID.get();
    }

    public static void clear() {
        TRACE_ID.remove();
    }
}
```

요청 처리 중 Trace ID를 여러 계층에 전달해야 할 때 매개변수로 계속 넘기는 대신 스레드별 문맥에 보관하는 방식으로 활용할 수 있다.

다만 비동기 작업으로 스레드가 바뀌면 기존 ThreadLocal 값이 자동으로 전달되지 않는다는 점을 알아야 한다.

## 3. ThreadLocal 내부 개념

각 Thread 객체는 ThreadLocal 값을 보관하는 저장 구조를 가진다. ThreadLocal 자체가 모든 스레드의 값을 하나로 보관하는 것이 아니라, 현재 스레드와 ThreadLocal 키에 대응하는 값을 관리하는 방식이다.

따라서 같은 ThreadLocal을 사용해도 스레드마다 독립된 값이 조회된다.

## 4. 스레드 풀에서 문제가 되는 이유

스레드 풀은 요청을 처리한 스레드를 종료하지 않고 다음 작업에 재사용한다. 작업이 끝났는데 ThreadLocal 값을 제거하지 않으면 다음 작업이 같은 스레드에서 실행될 때 이전 값이 남아 있을 수 있다.

```java
ExecutorService pool = Executors.newFixedThreadPool(1);

pool.submit(() -> {
    USER.set("첫 번째 요청");
});

pool.submit(() -> {
    System.out.println(USER.get()); // 이전 값이 남을 수 있음
});

pool.shutdown();
```

스레드가 하나인 풀을 사용했기 때문에 두 작업이 같은 스레드에서 실행될 수 있다. 첫 번째 작업이 값을 정리하지 않았다면 두 번째 작업에서 이전 값이 노출될 위험이 있다.

## 5. 반드시 remove()로 정리하기

```java
try {
    USER.set("요청 사용자");
    processRequest();
} finally {
    USER.remove();
}
```

작업 성공 여부와 관계없이 finally에서 제거하도록 작성하면 예외가 발생한 경우에도 정리할 수 있다.

ThreadLocal은 값이 필요할 때만 설정하고, 작업 범위가 끝나면 제거하는 생명 주기 관리가 중요하다.

## 6. Spring 웹 요청과 ThreadLocal

일부 프레임워크 기능은 요청 문맥이나 보안 문맥을 현재 실행 스레드와 연결해 관리한다. 예를 들어 요청별 사용자 정보나 로깅 추적 정보를 처리할 때 ThreadLocal 계열의 기능이 사용될 수 있다.

하지만 Servlet 기반 요청 스레드와 비동기 실행 스레드는 다르다. @Async, CompletableFuture, 별도 Executor를 사용하면 실행 스레드가 바뀔 수 있으므로 문맥 전달 방식을 별도로 고려해야 한다.

## 7. ThreadLocal 사용 시 주의점

- 스레드 풀에서는 반드시 작업 종료 시 remove()를 고려한다.
- 큰 객체를 오래 보관하면 메모리 점유가 커질 수 있다.
- 비동기 스레드로 값이 자동 전파된다고 가정하지 않는다.
- 사용자 정보나 인증 정보를 다룬다면 요청 간 데이터가 섞이지 않도록 정리한다.
- ThreadLocal은 스레드 간 통신 도구가 아니라 스레드별 데이터 격리 도구다.

## 핵심 정리

- ThreadLocal은 스레드마다 독립된 값을 저장한다.
- 공유 변수의 동기화 문제를 줄이는 데 활용할 수 있지만 데이터 전달 수단은 아니다.
- 스레드 풀은 스레드를 재사용하므로 이전 값이 남을 수 있다.
- try/finally와 remove()로 생명 주기를 관리한다.
- 비동기 실행에서는 문맥 전달을 별도로 설계한다.
