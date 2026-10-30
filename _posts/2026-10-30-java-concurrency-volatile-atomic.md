---
layout: post
title: "Java volatile과 Atomic — 가시성과 원자성 이해하기"
date: 2026-10-30
categories: [Spring]
tags: [Java, Concurrency, volatile, AtomicInteger, Thread]
---

## 동시성에서 구분할 문제

여러 스레드가 같은 값을 다룰 때는 가시성, 원자성, 실행 순서 문제를 구분해야 한다. 가시성은 한 스레드의 변경을 다른 스레드가 볼 수 있는지, 원자성은 작업이 중간에 끊기지 않고 하나의 단위로 처리되는지를 의미한다.

## volatile

volatile은 한 스레드의 쓰기가 다른 스레드의 읽기에 보이도록 가시성을 보장하고 관련 메모리 순서 규칙을 제공한다. 종료 플래그처럼 한 스레드가 값을 변경하고 다른 스레드가 확인하는 상황에서 사용할 수 있다.

## volatile은 복합 연산을 원자적으로 만들지 않는다

count++는 읽기, 증가, 쓰기의 여러 단계로 이루어진다. volatile int에 적용해도 여러 스레드가 동시에 실행하면 증가가 유실될 수 있다.

## AtomicInteger

AtomicInteger는 단일 정수 값의 원자적 갱신 연산을 제공한다. incrementAndGet() 등을 사용하면 증가 연산을 안전하게 수행할 수 있다.

## 선택 기준

| 요구사항 | 선택 |
| --- | --- |
| 상태 플래그 가시성 | volatile |
| 단일 값의 원자적 갱신 | AtomicInteger 등 |
| 여러 변수의 불변식 보호 | synchronized 또는 Lock |

volatile과 Atomic은 대체재가 아니다. 필요한 보장 수준에 맞춰 선택해야 한다.
