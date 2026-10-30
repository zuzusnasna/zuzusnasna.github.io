---
layout: post
layout: post
title: "Java Map — HashMap의 Key 조회와 해시 동작"
date: 2026-10-30
categories: [Spring]
tags: [Java, Collection, Map, HashMap]
---

## Map의 구조

Map은 Key와 Value를 한 쌍으로 저장한다. Key는 중복될 수 없으며 동일한 Key로 다시 저장하면 기존 Value가 교체된다. 사용자 ID로 사용자 정보를 찾거나 상품 코드로 가격을 조회할 때 적합하다.

## HashMap의 조회 원리

HashMap은 Key의 hashCode()를 바탕으로 저장 위치를 계산한다. 같은 위치에 여러 Key가 모이면 equals()를 이용해 실제로 같은 Key인지 확인한다. 따라서 사용자 정의 Key는 equals()와 hashCode() 계약을 지켜야 한다.

## 다른 Map 구현체

| 구현체 | 특징 |
| --- | --- |
| HashMap | 순서를 보장하지 않는 일반적인 해시 Map |
| LinkedHashMap | 입력 순서 또는 접근 순서 유지 |
| TreeMap | Key 정렬 순서 유지 |
| ConcurrentHashMap | 여러 스레드의 동시 접근을 고려 |

## 동시성 주의

HashMap은 여러 스레드가 동시에 수정하는 상황을 안전하게 처리하도록 설계된 자료구조가 아니다. 공유 데이터에 동시 접근해야 한다면 ConcurrentHashMap이나 별도 동기화 전략을 검토한다.

## 실무 체크

Key로 사용하는 객체의 동등성 기준을 안정적으로 유지하고, 데이터 규모와 순서 요구사항을 확인한다. 모든 상황에서 HashMap이 정답은 아니다.
