---
layout: post
title: "Builder Pattern — 복잡한 객체를 단계적으로 생성하는 빌더 패턴"
date: 2026-07-21 00:00:00 +0900
categories: [학습]
tags: [Java, 디자인패턴, Builder]
---

## 1. Builder Pattern이란?

Builder Pattern(빌더 패턴)은 **필요한 값을 단계적으로 설정한 뒤 객체를 생성하는 패턴**이다.

회원 가입 객체에 이름, 이메일, 전화번호, 주소, 마케팅 수신 여부 등 여러 값이 있다고 생각해 보자. 생성자 매개변수가 많아지면 값을 전달하는 순서를 기억하기 어렵고, 선택값이 많을수록 생성자 오버로딩도 늘어난다.

빌더 패턴을 사용하면 어떤 값을 설정하는지 메서드 이름으로 확인하면서 객체를 만들 수 있다.

## 2. 실제 사례: 회원 정보 생성

회원 정보 클래스는 생성자를 외부에서 직접 호출하지 못하도록 하고 Builder를 제공한다.

```java
class Member {
    private final String name;
    private final String email;
    private final String phone;
    private final boolean marketingAgreed;

    private Member(Builder builder) {
        this.name = builder.name;
        this.email = builder.email;
        this.phone = builder.phone;
        this.marketingAgreed = builder.marketingAgreed;
    }

    static class Builder {
        private final String name;
        private final String email;
        private String phone;
        private boolean marketingAgreed;

        Builder(String name, String email) {
            this.name = name;
            this.email = email;
        }

        Builder phone(String phone) {
            this.phone = phone;
            return this;
        }

        Builder marketingAgreed(boolean agreed) {
            this.marketingAgreed = agreed;
            return this;
        }

        Member build() {
            return new Member(this);
        }
    }

    @Override
    public String toString() {
        return name + ", " + email + ", " + phone
                + ", 마케팅 동의: " + marketingAgreed;
    }
}
```

필수값은 Builder 생성자에서 받고, 선택값은 필요한 경우에만 설정한다.

```java
public class Main {
    public static void main(String[] args) {
        Member member = new Member.Builder(
                "홍길동", "hong@example.com"
        )
                .phone("010-1234-5678")
                .marketingAgreed(true)
                .build();

        System.out.println(member);
    }
}
```

## 3. 생성 과정

```text
new Member.Builder(필수값)
          |
      phone(...)
          |
  marketingAgreed(...)
          |
        build()
          |
      Member 생성
```

build()가 호출되는 시점에 설정된 값으로 최종 객체를 만든다.

## 4. 실제 적용 사례

- 회원 및 사용자 정보 생성
- 주문 생성 시 배송지, 쿠폰, 요청사항 설정
- 검색 조건이나 API 요청 객체 구성
- 설정 항목이 많은 객체 생성
- 테스트용 객체 데이터 구성

빌더는 생성자 매개변수가 많거나 선택값이 많은 객체에서 특히 유용하다. 필드가 적고 생성 과정이 단순하다면 일반 생성자로 충분할 수 있다.

**핵심:** 객체 생성 과정을 단계별 메서드로 표현해 생성 코드를 읽기 쉽고 안전하게 만든다.
