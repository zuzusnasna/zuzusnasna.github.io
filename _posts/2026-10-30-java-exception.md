---
layout: post
title: "Java 데이터 처리 — Generic, Garbage Collection, Serialization"
date: 2026-10-30 11:50:00 +0900
categories: [Spring]
tags: [Java]
---

오늘은 Java의 타입 처리와 메모리 관리, 객체를 데이터로 변환하는 과정을 정리했다.

## 1. Generic

Generic은 클래스나 메서드에서 사용할 타입을 지정할 수 있게 해준다.

```java
List<Integer> numbers = new ArrayList<>();
numbers.add(10);
numbers.add(20);
```

타입을 `Integer`로 지정했기 때문에 다른 타입의 값을 넣으면 컴파일 단계에서 확인할 수 있다.

## 2. Garbage Collection

Java에서는 객체 메모리를 직접 해제하지 않는다.

```java
Member member = new Member();
member = null;
```

더 이상 다른 객체가 참조하지 않는 객체는 GC의 대상이 될 수 있다.

```text
member ───→ Member 객체

member = null

Member 객체
   ↑
참조 없음
   ↓
GC 대상이 될 수 있음
```

중요한 점은 `member = null`을 했다고 바로 GC가 실행되는 것은 아니라는 것이다. GC 실행 시점은 JVM이 판단한다.

## 3. Serialization

객체를 저장하거나 전송할 수 있는 데이터 형태로 변환하는 것을 직렬화라고 한다.

```text
객체
 ↓
직렬화
 ↓
데이터
 ↓
저장 / 전송
```

반대로 데이터를 다시 객체로 만드는 것이 역직렬화다.

```text
데이터
 ↓
역직렬화
 ↓
객체
```

실제 서버 개발에서는 Java 기본 Serialization뿐 아니라 JSON 같은 형식을 자주 사용한다.

```json
{
  "name": "홍길동",
  "age": 25
}
```

객체를 메모리에 존재하는 상태 그대로만 보는 것이 아니라 저장·전송을 위한 데이터 형태로 바꿀 수 있다는 점까지 같이 정리했다.
