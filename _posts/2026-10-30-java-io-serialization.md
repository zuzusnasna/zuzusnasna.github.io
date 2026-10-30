---
title: "Java Object Serialization — 객체 직렬화와 역직렬화"
date: 2026-10-30
categories: [Spring]
tags: [Java, IO, Serialization, ObjectInputStream, ObjectOutputStream]
---

## 직렬화란?

직렬화는 객체의 상태를 바이트 형태로 변환하는 과정이고, 역직렬화는 바이트 데이터에서 객체를 복원하는 과정이다. Java는 Serializable 인터페이스와 ObjectOutputStream, ObjectInputStream을 제공한다.

## serialVersionUID

serialVersionUID는 직렬화된 데이터와 클래스 버전의 호환성을 확인하는 식별자다. 클래스 구조가 변경되었을 때 호환성 정책을 명확히 관리하는 데 사용한다.

## transient

transient로 선언한 필드는 기본 직렬화 대상에서 제외된다. 비밀번호나 재생성 가능한 임시 데이터 등 직렬화하지 않을 값을 구분할 수 있다. 민감정보 보호를 transient 하나에만 의존해서는 안 된다.

## 보안상 주의점

신뢰할 수 없는 데이터의 역직렬화는 위험할 수 있다. 외부 입력을 무분별하게 객체로 복원하지 말고, 가능하면 JSON 등 명시적인 데이터 형식과 검증된 파싱 방식을 사용한다.

## 활용 판단

Java 기본 직렬화는 객체 그래프를 보존하는 특성이 있지만 언어와 버전 간 호환성, 보안, 유지보수 측면을 검토해야 한다. 시스템 간 API 데이터 전달에는 일반적으로 명시적인 데이터 포맷을 고려한다.
