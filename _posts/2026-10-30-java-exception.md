---
layout: post
title: "부트캠프 : Java 예외 처리와 checked / unchecked exception"
date: 2026-10-30 11:00:00 +0900
categories: [학습]
tags: [Java]
---

예외 처리는 단순히 오류 메시지를 출력하는 기능이 아니라 **실패했을 때 프로그램이 어떤 상태로 동작해야 하는지를 결정하는 설계**다.

## 기본 구조

```java
try {
    service.execute();
} catch (IllegalArgumentException e) {
    // 잘못된 입력 처리
} finally {
    // 정리 작업
}
```

## Checked와 Unchecked

Checked Exception은 컴파일 단계에서 처리를 요구한다. 대표적으로 파일이나 네트워크처럼 외부 자원과 관련된 작업에서 볼 수 있다.

Unchecked Exception은 `RuntimeException` 계열이며 잘못된 상태나 입력 등을 표현하는 데 많이 사용한다.

## 실무에서 중요한 것

모든 예외를 `catch (Exception e)`로 잡고 무조건 로그만 남기면 원인을 숨길 수 있다. 서비스 계층에서는 의미 있는 예외로 변환하고 Controller에서는 사용자에게 적절한 HTTP 응답을 내려주는 식으로 책임을 나누는 것이 중요하다.

## 배운 점

예외 처리는 많이 잡는 것이 목적이 아니라 **어디에서 복구할 수 있는지와 어디에서 실패를 전달해야 하는지를 구분하는 것**이다.
