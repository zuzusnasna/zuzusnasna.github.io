---
layout: post
title: "Java static과 final의 사용 기준"
date: 2026-08-22 00:00:00 +0900
categories: [학습]
tags: [Java, static, final]
---

Java에서 `static`은 클래스에 소속되는 멤버를 선언할 때 사용하고, `final`은 재할당이나 재정의 등을 제한할 때 사용한다. 두 키워드는 역할이 다르며 함께 사용되기도 한다.

## 1. static 변수

일반 인스턴스 변수는 객체마다 별도로 존재한다. 반면 static 변수는 클래스에 속하므로 해당 클래스의 모든 인스턴스가 같은 변수를 공유한다.

```java
class User {
    static int count = 0;

    User() {
        count++;
    }
}

public class Main {
    public static void main(String[] args) {
        new User();
        new User();

        System.out.println(User.count); // 2
    }
}
```

static 변수는 객체를 생성하지 않아도 클래스 이름으로 접근할 수 있다. 따라서 특정 객체의 상태가 아니라 클래스 전체에서 공유할 값에 적합하다.

## 2. static 메서드

static 메서드 역시 객체가 아니라 클래스에 속한다.

```java
class Calculator {
    static int add(int a, int b) {
        return a + b;
    }
}

int result = Calculator.add(10, 20);
System.out.println(result); // 30
```

static 메서드는 특정 인스턴스의 상태에 의존하지 않는 기능에 적합하다. 인스턴스가 생성되지 않은 상태에서도 호출되므로 인스턴스 필드나 인스턴스 메서드에 직접 접근할 수 없다.

```java
class Example {
    int value = 10;

    static void printValue() {
        // System.out.println(value); // 컴파일 오류
    }
}
```

static 메서드 안에서 인스턴스 멤버를 사용하려면 먼저 객체를 전달받거나 생성해야 한다.

## 3. final 변수와 상수

final 변수는 한 번 값이 정해지면 다시 대입할 수 없다.

```java
final int MAX_USERS = 100;
// MAX_USERS = 200; // 컴파일 오류
```

선언할 때 초기화하지 않았다면 생성자 등에서 한 번 초기화할 수 있다. 이를 blank final이라고 한다.

```java
class Member {
    private final String name;

    Member(String name) {
        this.name = name;
    }
}
```

클래스 전체에서 공유하는 상수는 보통 `static final`로 선언한다.

```java
class AppConfig {
    static final int MAX_RETRY_COUNT = 3;
}
```

상수 이름은 관례적으로 대문자와 언더스코어를 사용한다.

## 4. 참조형 변수에 final을 사용하면?

final이 참조형 변수에 적용되면 참조 변수에 다른 객체를 다시 대입할 수 없다는 뜻이다. 참조하는 객체 내부의 상태까지 자동으로 불변이 되는 것은 아니다.

```java
final List<String> names = new ArrayList<>();
names.add("Kim"); // 가능

// names = new ArrayList<>(); // 불가능
```

객체 자체의 변경까지 막으려면 불변 객체를 사용하거나 별도의 방어적 복사와 변경 제한 설계가 필요하다.

## 5. final을 클래스와 메서드에 사용하기

| 위치 | 의미 |
|---|---|
| 변수 | 재할당할 수 없음 |
| 메서드 | 하위 클래스에서 오버라이딩할 수 없음 |
| 클래스 | 상속할 수 없음 |

```java
final class SecurityPolicy {
}

// class CustomPolicy extends SecurityPolicy {} // 컴파일 오류
```

메서드에 final을 붙이면 하위 클래스가 해당 구현을 변경하지 못하도록 제한할 수 있다.

## 정리

- static은 클래스에 소속되는 멤버를 만든다.
- static 변수는 모든 인스턴스가 공유한다.
- static 메서드는 인스턴스 멤버에 직접 접근할 수 없다.
- final 변수는 재할당할 수 없지만, final 참조가 가리키는 객체의 내부 상태까지 고정하지는 않는다.
- static final은 클래스 수준의 상수를 표현할 때 자주 사용한다.

static은 공유와 소속의 기준, final은 변경 제한의 기준으로 구분해서 이해하면 된다.
