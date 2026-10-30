---
layout: post
title: "Java 접근 제어자와 캡슐화"
date: 2026-08-20 00:00:00 +0900
categories: [학습]
tags: [Java, 접근 제어자, 캡슐화]
---

클래스와 객체를 만들 때 모든 필드와 메서드를 외부에 공개할 필요는 없다. 접근 제어자는 클래스의 구성 요소를 어디까지 사용할 수 있는지 정하고, 캡슐화는 객체의 상태와 변경 규칙을 내부에 모으는 데 목적이 있다.

## 1. 접근 제어자

Java의 접근 제어자는 `public`, `protected`, `default`, `private` 네 가지로 구분한다. 여기서 default는 별도의 키워드가 아니라 접근 제어자를 생략한 상태를 의미한다.

| 접근 제어자 | 같은 클래스 | 같은 패키지 | 다른 패키지의 자식 클래스 | 그 외 |
|---|---:|---:|---:|---:|
| public | O | O | O | O |
| protected | O | O | O* | X |
| default | O | O | X | X |
| private | O | X | X | X |

*protected는 다른 패키지의 자식 클래스에서도 접근할 수 있지만, 상속 관계에서 허용되는 접근 규칙을 따른다. 단순히 모든 외부 객체가 접근할 수 있다는 뜻은 아니다.

```java
public class Member {
    private String name;
    protected int level;
    String team; // default: 같은 패키지에서 접근
    public void introduce() {
        System.out.println(name);
    }
}
```

최상위 클래스에는 일반적으로 public 또는 package-private(접근 제어자 생략)를 사용할 수 있다. private이나 protected 최상위 클래스는 선언할 수 없다.

## 2. private 필드와 메서드로 상태 보호하기

필드를 public으로 열어 두면 외부 코드가 객체의 상태를 직접 변경할 수 있다.

```java
class Account {
    public int balance;
}
```

다음과 같은 잘못된 값도 제한 없이 대입할 수 있다.

```java
Account account = new Account();
account.balance = -100000;
```

필드를 private으로 감추고 유효한 변경만 허용하는 메서드를 제공할 수 있다.

```java
class Account {
    private int balance;

    public void deposit(int amount) {
        if (amount <= 0) {
            throw new IllegalArgumentException("입금액은 0보다 커야 합니다.");
        }
        balance += amount;
    }

    public int getBalance() {
        return balance;
    }
}
```

이제 외부에서는 잔액을 직접 대입할 수 없고, 입금 규칙을 거쳐야만 잔액을 변경할 수 있다.

## 3. 캡슐화는 getter와 setter를 만드는 것만이 아니다

캡슐화의 핵심은 필드를 private으로 선언하는 데서 끝나지 않는다. 객체가 지켜야 할 규칙을 객체 내부에 두고, 외부에는 필요한 기능만 제공하는 것이다.

예를 들어 다음처럼 모든 필드에 무조건 setter를 만들면 private으로 감춘 의미가 약해진다.

```java
public void setBalance(int balance) {
    this.balance = balance;
}
```

호출자가 잔액을 어떤 값으로든 바꿀 수 있기 때문이다. 대신 입금과 출금처럼 업무 규칙을 표현하는 메서드를 제공하는 편이 낫다.

```java
public void withdraw(int amount) {
    if (amount <= 0 || amount > balance) {
        throw new IllegalArgumentException("출금할 수 없는 금액입니다.");
    }
    balance -= amount;
}
```

## 4. 접근 범위를 정하는 기준

- 외부에서 호출해야 하는 기능은 public으로 공개한다.
- 객체 내부에서만 사용해야 하는 구현 세부 사항은 private으로 둔다.
- 같은 패키지 내부에서만 공유할 기능은 default 접근을 고려한다.
- 상속을 위해 하위 클래스에 제공할 필요가 있는 기능은 protected를 검토한다.

접근 범위를 좁게 시작하고 실제 사용처가 생길 때 공개 범위를 넓히면 불필요한 의존성을 줄일 수 있다.

## 정리

접근 제어자는 코드의 사용 범위를 제한하는 문법이고, 캡슐화는 객체의 상태와 규칙을 보호하는 설계 원칙이다. 필드를 감추는 것뿐 아니라 잘못된 상태 변경을 막는 메서드를 제공해야 캡슐화의 목적을 달성할 수 있다.
