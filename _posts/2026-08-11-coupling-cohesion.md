---
layout: post
title: "객체지향 설계의 결합도와 응집도"
date: 2026-08-13 00:00:00 +0900
categories: [학습]
tags: [Java, 객체지향, 설계]
---

객체지향 설계에서 클래스와 모듈을 어떻게 나눌지 판단할 때 결합도와 응집도를 살펴볼 수 있다. 일반적으로는 서로 다른 구성 요소 사이의 불필요한 의존은 줄이고, 한 구성 요소 내부에는 관련된 책임이 모이도록 설계하는 것이 좋다.

## 1. 결합도(Coupling)

결합도는 한 클래스나 모듈이 다른 구성 요소에 얼마나 의존하는지를 나타낸다. 특정 구현에 강하게 묶여 있으면 변경이 발생했을 때 함께 수정해야 할 코드가 늘어날 수 있다.

다음 예제에서 OrderService는 KakaoPayment를 직접 생성한다.

```java
class KakaoPayment {
    void pay(int amount) {
        System.out.println("카카오 결제: " + amount);
    }
}

class OrderService {
    private final KakaoPayment payment = new KakaoPayment();

    void order(int amount) {
        payment.pay(amount);
    }
}
```

다른 결제 수단을 추가하면 OrderService도 수정해야 한다.

## 2. 추상화로 결합도 낮추기

구현 클래스 대신 인터페이스에 의존하도록 바꿀 수 있다.

```java
interface Payment {
    void pay(int amount);
}

class KakaoPayment implements Payment {
    public void pay(int amount) {
        System.out.println("카카오 결제: " + amount);
    }
}

class CardPayment implements Payment {
    public void pay(int amount) {
        System.out.println("카드 결제: " + amount);
    }
}

class OrderService {
    private final Payment payment;

    OrderService(Payment payment) {
        this.payment = payment;
    }

    void order(int amount) {
        payment.pay(amount);
    }
}
```

OrderService는 Payment 계약에 의존하고 구체 구현은 생성자를 통해 전달받는다. 구현체를 교체해도 주문 처리 코드는 유지할 수 있다.

## 3. 응집도(Cohesion)

응집도는 하나의 클래스나 모듈 안에 있는 기능들이 얼마나 밀접하게 관련되어 있는지를 나타낸다.

예를 들어 회원 서비스 클래스가 회원 가입, 이메일 발송, 이미지 파일 저장, 통계 리포트 생성까지 모두 담당한다면 서로 다른 변경 이유가 한 클래스에 모인다. 기능별 책임을 나누면 각 클래스의 목적이 명확해진다.

```java
class MemberService {
    void register() {
        // 회원 등록
    }
}

class EmailService {
    void sendWelcomeEmail() {
        // 환영 이메일 발송
    }
}

class ProfileImageStorage {
    void save() {
        // 프로필 이미지 저장
    }
}
```

각 클래스는 한 가지 목적과 관련된 기능을 중심으로 구성된다.

## 4. 결합도와 응집도는 함께 봐야 한다

| 설계 방향 | 기대 효과 |
|---|---|
| 결합도 낮추기 | 다른 모듈의 변경이 전달되는 범위 감소 |
| 응집도 높이기 | 한 클래스의 역할과 변경 이유가 명확해짐 |
| 인터페이스 활용 | 구현 교체와 테스트가 쉬워질 수 있음 |
| 책임 분리 | 변경 지점을 찾고 관리하기 쉬워짐 |

클래스를 무조건 잘게 나누는 것이 높은 응집도를 뜻하지는 않는다. 너무 작은 클래스가 서로 많은 메시지를 주고받으면 오히려 이해하기 어려운 구조가 될 수 있다.

## 5. 설계 점검 질문

- 이 클래스가 변경되는 이유는 하나로 설명할 수 있는가?
- 특정 구현체를 교체하려면 사용하는 클래스까지 수정해야 하는가?
- 서로 관련 없는 기능이 한 클래스에 모여 있지는 않은가?
- 책임을 분리한 결과 클래스 사이의 호출과 의존성이 과도하게 늘어나지는 않았는가?

## 정리

좋은 설계는 결합도를 무조건 0으로 만들거나 클래스를 많이 만드는 것이 아니다. 변경이 함께 일어나야 하는 기능은 가까이 두고, 독립적으로 바뀔 수 있는 구현은 추상화와 명확한 경계를 통해 분리하는 것이다.
