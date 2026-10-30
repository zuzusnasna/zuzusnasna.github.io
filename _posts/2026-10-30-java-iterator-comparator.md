---
layout: post
title: "Java Iterator와 Comparator — 컬렉션 순회와 정렬 기준"
date: 2026-10-30
categories: [Spring]
tags: [Java, Collection, Iterator, Comparator, Comparable]
---

## Iterator

Iterator는 컬렉션을 순차적으로 탐색하고 요소를 제거할 수 있게 한다. 순회 도중 컬렉션에서 요소를 제거해야 한다면 Iterator의 remove() 또는 조건 기반 removeIf()를 고려한다. 일반 반복문에서 직접 구조를 변경하면 ConcurrentModificationException이 발생할 수 있다.

## Comparable

Comparable은 클래스 자체에 자연 정렬 기준을 정의한다. 예를 들어 사원 객체가 사번을 기준으로 기본 정렬되어야 한다면 해당 클래스가 Comparable을 구현할 수 있다.

## Comparator

Comparator는 외부에서 정렬 기준을 제공한다. 같은 객체를 이름순, 점수순, 가입일순 등 여러 방식으로 정렬해야 할 때 유용하다. comparing(), thenComparing(), reversed() 등을 조합할 수 있다.

## 비교

| 구분 | Comparable | Comparator |
| --- | --- | --- |
| 정렬 기준 위치 | 클래스 내부 | 외부에서 전달 |
| 기준 개수 | 자연 정렬 기준 | 여러 기준 가능 |
| 사용 상황 | 대표 기본 순서 | 상황별 정렬 |

## 주의할 점

비교 결과는 일관되어야 한다. TreeSet이나 TreeMap에서는 비교 결과가 0인 두 객체가 같은 정렬 요소로 취급될 수 있으므로 동등성 기준과 정렬 기준을 함께 고려한다.
