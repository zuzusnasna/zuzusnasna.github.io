---
layout: post
title: "Java 예외 처리와 컬렉션을 사용하면서 배운 점"
date: 2026-10-05 09:00:00 +0900
categories: [학습]
tags: [Java]
---

## 예외 처리

예외 처리는 프로그램 실행 중 발생할 수 있는 문제를 정상적인 흐름과 분리해서 다루는 방법이다.

```java
try {
    int result = 10 / value;
} catch (ArithmeticException e) {
    System.out.println("0으로 나눌 수 없습니다.");
}
```

무조건 예외를 숨기는 것보다 어떤 상황이 잘못됐는지 알 수 있도록 처리하는 것이 중요했다.

## 컬렉션

- `List` : 순서가 있는 데이터
- `Set` : 중복을 허용하지 않는 데이터
- `Map` : key와 value의 연결

```java
List<String> names = new ArrayList<>();
names.add("홍길동");
names.add("김철수");
```

프로젝트에서는 여러 데이터를 다루는 일이 많기 때문에 배열보다 컬렉션을 훨씬 자주 사용하게 된다.

## 배운 점

예외 처리와 컬렉션은 단독 문법이 아니라 실제 애플리케이션에서 입력값, DB 결과, 외부 API 응답을 안전하게 다루기 위한 기본 도구라고 이해했다.
