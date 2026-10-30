---
layout: post
title: "Java ThreadLocal — 스레드별 데이터를 격리하는 방법"
date: 2026-10-30
categories: [Spring]
tags: [Java, Concurrency, ThreadLocal, Thread]
---

## ThreadLocal이란?

ThreadLocal은 같은 변수에 접근하더라도 스레드마다 별도의 값을 보관할 수 있게 한다. 요청별 문맥이나 작업 스레드에 한정된 데이터를 분리할 때 활용할 수 있다.

## 사용 시 주의점

스레드 풀은 작업이 끝난 스레드를 재사용한다. ThreadLocal 값을 제거하지 않으면 다음 요청이 같은 스레드를 사용하면서 이전 요청의 값이 남을 수 있다. 따라서 작업이 끝나는 지점에서 remove()를 호출해야 한다.

## 적절한 사용 상황

- 스레드별 임시 문맥
- 프레임워크가 제공하는 요청 처리 문맥
- 특정 스레드에서만 사용하는 데이터

ThreadLocal은 스레드 간 통신 수단이나 공유 데이터 저장소가 아니다.

## 비동기 작업과의 관계

ThreadLocal 값은 일반적으로 다른 스레드로 자동 전달되지 않는다. CompletableFuture 등으로 실행 스레드가 바뀌면 문맥 전달 방식을 별도로 고려해야 한다.

## 정리

ThreadLocal은 스레드별 데이터 격리를 제공하지만 스레드 풀 환경에서는 생명 주기 관리가 필수다. Spring Security나 요청 문맥처럼 프레임워크가 제공하는 기능이 ThreadLocal을 어떻게 관리하는지도 함께 이해하면 좋다.
