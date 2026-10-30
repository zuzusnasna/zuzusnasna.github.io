---
layout: post
title: "Adapter Pattern — 서로 다른 인터페이스를 연결하는 어댑터 패턴"
date: 2026-08-21 09:00:00 +0900
categories: [학습]
tags: [Java, 디자인패턴, Adapter]
---

## 1. Adapter Pattern이란?

Adapter Pattern(어댑터 패턴)은 **기존 클래스의 인터페이스를 클라이언트가 원하는 인터페이스로 변환하는 패턴**이다.

콘센트 어댑터를 생각하면 이해하기 쉽다. 해외에서 가져온 전자제품의 플러그가 국내 콘센트와 맞지 않을 때 어댑터를 중간에 연결한다. 전자제품 자체를 바꾸지 않고도 사용할 수 있다.

프로그램에서도 외부 라이브러리나 기존 시스템의 메서드 형태가 현재 코드와 맞지 않을 때 어댑터를 둘 수 있다.

## 2. 실제 사례: 외부 결제 시스템 연결

우리 서비스는 결제 기능을 pay()라는 메서드로 사용하고 싶다고 가정하자.

```java
interface Payment {
    void pay(int amount);
}
```

그런데 외부 결제 라이브러리는 다음과 같은 메서드를 제공한다.

```java
class ExternalPayClient {
    public void processPayment(String userId, long price) {
        System.out.println(userId + " 결제 요청: " + price);
    }
}
```

메서드 이름과 매개변수가 다르기 때문에 Payment를 사용하는 코드에 바로 연결할 수 없다.

이때 어댑터가 두 인터페이스 사이를 연결한다.

```java
class ExternalPayAdapter implements Payment {
    private final ExternalPayClient client;
    private final String userId;

    ExternalPayAdapter(ExternalPayClient client, String userId) {
        this.client = client;
        this.userId = userId;
    }

    @Override
    public void pay(int amount) {
        client.processPayment(userId, amount);
    }
}
```

사용하는 쪽은 외부 라이브러리의 구조를 알 필요가 없다.

```java
public class Main {
    public static void main(String[] args) {
        Payment payment = new ExternalPayAdapter(
                new ExternalPayClient(), "user-100"
        );

        payment.pay(25000);
    }
}
```

## 3. 실행 흐름

```text
서비스 코드
    |
 Payment.pay()
    |
ExternalPayAdapter
    |
ExternalPayClient.processPayment()
    |
외부 결제 시스템
```

서비스는 Payment 인터페이스만 알고 있고, 어댑터가 메서드 호출과 데이터 형태를 변환한다.

## 4. 실제로 활용할 수 있는 상황

- 서로 다른 결제 회사의 API 연결
- 기존 레거시 시스템과 신규 시스템 연결
- 외부 라이브러리의 인터페이스를 내부 규격에 맞게 변환
- 서로 다른 데이터 형식이나 메시지 구조 연결

외부 라이브러리 코드를 직접 수정하기 어렵거나, 여러 외부 시스템을 내부에서 동일한 방식으로 사용하고 싶을 때 유용하다.

**핵심:** 기존 코드를 뜯어고치지 않고 중간 어댑터를 통해 서로 다른 인터페이스를 연결한다.
