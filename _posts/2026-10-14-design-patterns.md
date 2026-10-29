---
layout: post
title: "Template Method, Factory Method, Abstract Factory 비교"
date: 2026-10-14 09:00:00 +0900
categories: [학습]
tags: [Java, 디자인패턴]
---

디자인 패턴을 공부하면서 중요한 것은 이름보다 **어떤 변경을 분리하기 위해 사용하는가**였다.

## Template Method

전체 알고리즘의 흐름은 부모 클래스가 정하고, 일부 단계만 자식 클래스가 구현한다.

```text
공통 흐름
  ↓
준비 → 처리 → 정리
       ↑
   일부 단계만 구현
```

## Factory Method

객체를 생성하는 책임을 별도 메서드나 구현체로 분리한다. 생성 방식이 바뀌어도 사용하는 쪽의 코드가 덜 영향을 받는다.

## Abstract Factory

서로 연관된 여러 객체를 하나의 제품군으로 생성할 때 사용한다.

## 한 줄 비교

| 패턴 | 핵심 |
|---|---|
| Template Method | 알고리즘 흐름 고정 |
| Factory Method | 객체 생성 책임 분리 |
| Abstract Factory | 관련 객체군 생성 |

패턴을 무조건 적용하기보다 실제로 변경되는 지점이 어디인지 먼저 찾는 것이 중요하다고 정리했다.
