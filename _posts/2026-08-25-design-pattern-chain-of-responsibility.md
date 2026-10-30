---
layout: post
title: "Chain of Responsibility Pattern — 요청을 단계별로 전달하는 책임 연쇄 패턴"
date: 2026-09-04 00:00:00 +0900
categories: [학습]
tags: [Java, 디자인패턴, Chain of Responsibility]
---

## 1. Chain of Responsibility Pattern이란?

Chain of Responsibility(책임 연쇄 패턴)는 **요청을 처리할 수 있는 객체들을 연결하고, 요청이 연결된 순서대로 전달되도록 만드는 패턴**이다.

온라인 서비스의 요청 검증을 생각해 보자. 요청이 들어오면 인증 확인, 권한 확인, 입력값 검증을 차례대로 통과해야 한다. 각 검증 단계가 자신의 책임만 처리하고 다음 단계로 넘기는 구조를 만들 수 있다.

## 2. 실제 사례: API 요청 검증

각 검증 단계가 공통으로 구현할 인터페이스를 만든다.

```java
abstract class RequestHandler {
    private RequestHandler next;

    public RequestHandler setNext(RequestHandler next) {
        this.next = next;
        return next;
    }

    public void handle(String token, String role, String input) {
        if (!check(token, role, input)) {
            return;
        }

        if (next != null) {
            next.handle(token, role, input);
        }
    }

    protected abstract boolean check(
            String token, String role, String input
    );
}
```

인증을 검사하는 단계다.

```java
class AuthenticationHandler extends RequestHandler {
    @Override
    protected boolean check(String token, String role, String input) {
        if (token == null || token.isBlank()) {
            System.out.println("인증 실패");
            return false;
        }
        System.out.println("인증 통과");
        return true;
    }
}
```

권한을 검사하는 단계다.

```java
class AuthorizationHandler extends RequestHandler {
    @Override
    protected boolean check(String token, String role, String input) {
        if (!"ADMIN".equals(role)) {
            System.out.println("권한 부족");
            return false;
        }
        System.out.println("권한 확인 완료");
        return true;
    }
}
```

입력값을 검사하는 단계다.

```java
class ValidationHandler extends RequestHandler {
    @Override
    protected boolean check(String token, String role, String input) {
        if (input == null || input.isBlank()) {
            System.out.println("입력값 오류");
            return false;
        }
        System.out.println("입력값 검증 완료");
        return true;
    }
}
```

검증 단계를 연결하고 요청을 전달한다.

```java
public class Main {
    public static void main(String[] args) {
        RequestHandler auth = new AuthenticationHandler();
        RequestHandler permission = new AuthorizationHandler();
        RequestHandler validation = new ValidationHandler();

        auth.setNext(permission).setNext(validation);

        auth.handle("token-123", "ADMIN", "주문 요청");
    }
}
```

## 3. 실행 흐름

```text
요청
 |
인증 검사
 |
권한 검사
 |
입력값 검사
 |
다음 비즈니스 로직
```

중간 단계에서 검증에 실패하면 다음 단계로 전달하지 않는다.

## 4. 실제 적용 사례

- 웹 요청의 인증 및 권한 검사
- 입력값 검증 파이프라인
- 로그 레벨별 로그 처리
- 결재 요청의 담당자별 승인 단계
- 예외 처리기 또는 이벤트 처리 체인

요청 처리 단계를 독립적으로 추가하거나 순서를 변경해야 할 때 유용하다. 다만 체인이 길어지면 실제로 어떤 객체가 요청을 처리하는지 추적하기 어려워질 수 있으므로 흐름을 명확하게 관리해야 한다.

**핵심:** 요청을 여러 처리 객체에 연결된 순서대로 전달하고, 각 객체가 처리하거나 다음 객체로 넘긴다.
