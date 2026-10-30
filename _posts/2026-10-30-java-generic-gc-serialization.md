---
layout: post
title: "Java 데이터 처리 — Generic, Garbage Collection, Serialization"
date: 2026-10-30 12:10:00 +0900
categories: [Spring]
tags: [Java]
---

오늘은 Generic, Garbage Collection, Serialization을 같이 정리했다.

## 1. Generic

Generic은 클래스나 메서드에서 사용할 타입을 지정할 수 있게 해주는 기능이다.

```java
List<String> names = new ArrayList<>();
names.add("홍길동");
// names.add(100); // 컴파일 오류
```

`String`을 지정했기 때문에 다른 타입의 값을 넣으면 컴파일 단계에서 확인할 수 있다. `Object`로 관리한 뒤 직접 형변환하는 방식보다 타입을 명확하게 유지할 수 있다.

## 2. Garbage Collection

Java에서는 객체의 메모리를 직접 해제하지 않는다.

```java
Member member = new Member();
member = null;
```

더 이상 참조되지 않는 객체는 GC의 대상이 될 수 있다.

```text
member ───→ Member 객체

member = null

Member 객체
참조 없음
   ↓
GC 대상이 될 수 있음
```

다만 `null`을 대입했다고 바로 GC가 실행되는 것은 아니다. 실제 실행 시점은 JVM이 결정한다.

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

반대로 데이터를 객체로 다시 만드는 것이 역직렬화다.

```text
데이터
 ↓
역직렬화
 ↓
객체
```

실제 서버에서는 JSON 같은 형식을 많이 사용한다.

```json
{
  "name": "홍길동",
  "age": 25
}
```

객체를 단순히 메모리 안에서 사용하는 것과 저장·전송을 위해 데이터로 변환하는 것은 다른 작업이라는 점을 구분했다.
