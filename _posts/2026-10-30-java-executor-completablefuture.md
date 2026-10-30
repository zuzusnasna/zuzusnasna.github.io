---
title: "Java ExecutorService — 스레드 풀과 CompletableFuture"
date: 2026-09-01 00:00:00 +0900
categories: [Spring]
tags: [Java, Concurrency, ExecutorService, CompletableFuture, ThreadPool]
---

## 1. 매번 Thread를 생성하면 생기는 문제

요청이 들어올 때마다 새로운 Thread를 생성하면 생성·종료 비용이 반복되고, 요청이 급증할 경우 스레드 수가 지나치게 많아질 수 있다. 스레드 생성과 작업 실행을 분리하고 재사용할 수 있도록 돕는 도구가 ExecutorService다.

## 2. ExecutorService와 스레드 풀

스레드 풀은 미리 생성한 스레드 또는 필요할 때 생성한 스레드를 재사용해 작업을 처리한다.

```java
ExecutorService executor = Executors.newFixedThreadPool(4);

executor.submit(() -> {
    System.out.println(Thread.currentThread().getName());
});

executor.shutdown();
```

- submit(): 작업을 등록하고 Future를 반환한다.
- shutdown(): 새 작업 접수를 중단하고 이미 등록된 작업을 마무리한다.
- shutdownNow(): 실행 중인 작업에 중단을 요청하고 대기 작업을 반환한다.

실제 서버에서는 작업량에 맞게 스레드 수와 큐 용량, 거부 정책을 고려해야 한다. 무제한 큐를 사용하면 요청이 몰릴 때 대기 작업이 계속 쌓일 수 있다.

## 3. CompletableFuture

CompletableFuture는 비동기 작업의 결과를 Future 형태로 다루고, 작업 간 후속 동작을 연결할 수 있게 한다.

```java
CompletableFuture<String> future =
    CompletableFuture.supplyAsync(() -> "사용자 조회")
        .thenApply(result -> result + " 완료");

System.out.println(future.join());
```

- supplyAsync(): 값을 반환하는 비동기 작업을 실행한다.
- runAsync(): 반환값이 없는 비동기 작업을 실행한다.
- thenApply(): 이전 결과를 변환한다.
- thenCompose(): 비동기 작업을 이어 붙여 중첩 Future를 평탄화한다.
- thenCombine(): 서로 독립적인 두 작업의 결과를 결합한다.
- exceptionally(): 예외가 발생했을 때 복구 값을 제공할 수 있다.

별도 Executor를 지정하지 않으면 기본적으로 공용 ForkJoinPool을 사용할 수 있다. 서비스 특성에 맞는 Executor를 명시하는 편이 작업 격리와 자원 관리에 유리할 수 있다.

## 4. 언제 사용하면 좋을까?

예를 들어 대시보드 응답을 만들 때 서로 독립적인 사용자 정보와 통계 정보를 동시에 조회한 뒤 결과를 합칠 수 있다. 이처럼 서로 의존하지 않는 작업은 병렬 실행을 고려할 수 있다.

반대로 작업 간 순서나 트랜잭션 경계가 중요한 로직을 무조건 비동기로 분리하면 디버깅과 오류 처리가 어려워질 수 있다.

## 5. 운영 환경에서 확인할 것

- 스레드 풀 크기와 작업 큐의 용량
- 작업 처리 시간과 대기 시간
- 예외 처리 및 타임아웃
- 애플리케이션 종료 시 작업 정리
- CPU 작업인지 I/O 대기 작업인지에 따른 풀 구성

비동기 처리는 단순히 응답을 빠르게 만드는 기능이 아니다. 제한된 스레드와 자원을 어떤 방식으로 나누어 사용할지 설계하는 과정이다.
