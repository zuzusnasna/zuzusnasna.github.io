---
layout: post
layout: post
title: "Java Set — HashSet과 TreeSet의 중복·정렬 관리"
date: 2026-10-30
categories: [Spring]
tags: [Java, Collection, Set, HashSet, TreeSet]
---

## Set의 특징

Set은 중복 원소를 허용하지 않는 Collection이다. 중복 제거, 고유 사용자 ID 관리, 권한 목록 관리 등에 활용한다.

## HashSet

HashSet은 해시 기반으로 요소를 관리하며 일반적으로 순서를 보장하지 않는다. 객체를 저장할 때는 equals()와 hashCode()가 일관되게 구현되어야 한다. 같은 객체인지 판단하는 기준을 명확하게 정해야 한다.

## LinkedHashSet과 TreeSet

LinkedHashSet은 입력 순서를 유지한다. TreeSet은 자연 순서 또는 Comparator가 정한 기준으로 요소를 정렬한다.

| 구현체 | 특징 | 사용 상황 |
| --- | --- | --- |
| HashSet | 해시 기반, 순서 비보장 | 중복 제거와 존재 확인 |
| LinkedHashSet | 입력 순서 유지 | 중복 제거 + 입력 순서 |
| TreeSet | 정렬 순서 유지 | 정렬된 데이터 순회 |

## 객체를 Set에 저장할 때

사용자 정의 객체라면 어떤 필드를 기준으로 동등성을 판단할지 결정해야 한다. 해시 계산에 사용하는 필드가 저장 후 변경되면 조회와 삭제가 예상대로 동작하지 않을 수 있다.

## 선택 기준

정렬이 필요하지 않다면 HashSet이 단순하다. 입력 순서가 필요하면 LinkedHashSet, 정렬된 결과가 필요하면 TreeSet을 고려한다.
