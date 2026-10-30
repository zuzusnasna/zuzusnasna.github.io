---
layout: post
layout: post
title: "JVM Class Loading — 클래스 로딩과 초기화 과정"
date: 2026-10-30
categories: [Spring]
tags: [Java, JVM, ClassLoader, Class Loading]
---

## 클래스 로딩이란?

JVM은 실행에 필요한 클래스를 읽고 연결한 뒤 초기화한다. 이 과정을 이해하면 static 필드와 초기화 블록이 언제 실행되는지 파악할 수 있다.

## 주요 단계

1. Loading: 클래스 파일의 바이트 정보를 읽어 JVM 내부 표현을 만든다.
2. Linking: 검증, 준비, 해석 과정을 수행한다.
3. Initialization: 클래스 변수의 명시적 초기화와 static 초기화 블록을 실행한다.

준비 단계에서는 static 필드가 기본값으로 설정되고, 코드에 작성한 초기화는 초기화 단계에서 수행된다.

## ClassLoader

ClassLoader는 클래스의 바이트 정보를 찾아 로딩한다. 대표적으로 Bootstrap, Platform, Application ClassLoader가 있다.

## 부모 위임 모델

일반적인 클래스 로딩은 먼저 부모 ClassLoader에 로딩을 위임한다. 부모가 찾지 못하면 자식이 직접 탐색한다. 핵심 Java 클래스가 애플리케이션 클래스에 의해 임의로 대체되는 위험을 줄이는 데 도움이 된다.

## 백엔드에서의 의미

Spring Boot는 컴포넌트 스캔과 의존성 주입 과정에서 여러 클래스를 탐색하고 사용한다. 시작 시점의 클래스 로딩·초기화 문제는 의존성 충돌이나 static 초기화 오류를 분석할 때 도움이 된다.
