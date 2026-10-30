---
layout: post
title: "Java 오버로딩과 오버라이딩, 바인딩의 차이"
date: 2026-08-29 00:00:00 +0900
categories: [학습]
tags: [Java, 객체지향, 다형성]
---

오버로딩과 오버라이딩은 메서드 이름을 재사용한다는 공통점이 있지만 동작 방식은 다르다. 특히 오버라이딩은 상속과 다형성에 연결되며, 메서드가 어떤 구현으로 연결되는지 이해하려면 바인딩 개념도 함께 알아야 한다.

## 1. 오버로딩(Overloading)

오버로딩은 같은 클래스 또는 상속 관계에서 같은 이름의 메서드를 매개변수 목록을 다르게 선언하는 것이다.

```java
class Calculator {
    int add(int a, int b) {
        return a + b;
    }

    double add(double a, double b) {
        return a + b;
    }

    int add(int a, int b, int c) {
        return a + b + c;
    }
}
```

메서드 이름은 같지만 매개변수의 타입이나 개수 등이 다르므로 호출할 메서드를 구분할 수 있다.

반환 타입만 다르게 선언하는 것은 오버로딩이 아니다.

```java
// int getValue() { return 1; }
// double getValue() { return 1.0; } // 매개변수 목록이 같아 선언 불가
```

## 2. 오버라이딩(Overriding)

오버라이딩은 하위 클래스가 부모 클래스에서 상속한 메서드를 자신에게 맞게 재정의하는 것이다.

```java
class Animal {
    void sound() {
        System.out.println("동물 소리");
    }
}

class Dog extends Animal {
    @Override
    void sound() {
        System.out.println("멍멍");
    }
}
```

부모 타입 변수로 자식 객체를 참조해도 실제 객체가 Dog라면 Dog의 메서드가 실행된다.

```java
Animal animal = new Dog();
animal.sound(); // 멍멍
```

`@Override`를 붙이면 컴파일러가 실제로 재정의 가능한 메서드인지 검사하므로 오타나 시그니처 오류를 찾기 쉽다.

## 3. 오버로딩과 오버라이딩 비교

| 구분 | 오버로딩 | 오버라이딩 |
|---|---|---|
| 목적 | 같은 기능 이름에 여러 매개변수 형태 제공 | 상속받은 동작을 하위 클래스에 맞게 변경 |
| 관계 | 상속이 필수 아님 | 상속 또는 인터페이스 구현 관계 |
| 매개변수 | 목록이 달라야 함 | 재정의 대상과 동일한 시그니처 |
| 결정 시점 | 컴파일 시점에 호출 대상 선택 | 실행 시 실제 객체 타입에 따라 구현 선택 |

## 4. 정적 바인딩과 동적 바인딩

바인딩은 메서드 호출과 실제 실행할 메서드를 연결하는 과정이다.

오버로딩처럼 매개변수 목록을 바탕으로 호출 대상을 결정하는 것은 컴파일 시점에 이루어진다. 이를 정적 바인딩이라고 설명한다.

오버라이딩된 인스턴스 메서드는 실행 시 실제 객체의 타입을 기준으로 구현이 선택된다. 이를 동적 바인딩이라고 한다.

```java
class Parent {
    void print() {
        System.out.println("Parent");
    }
}

class Child extends Parent {
    @Override
    void print() {
        System.out.println("Child");
    }
}

Parent value = new Child();
value.print(); // Child
```

참조 변수의 선언 타입은 Parent지만 실제 객체는 Child이므로 Child의 오버라이딩 메서드가 호출된다.

## 5. 필드와 static 메서드는 다르게 동작한다

다형성이 모든 멤버에 똑같이 적용되는 것은 아니다. 필드는 참조 변수의 선언 타입을 기준으로 접근하며, static 메서드는 인스턴스의 동적 디스패치 대상이 아니다.

```java
class Parent {
    String value = "Parent";

    static void print() {
        System.out.println("Parent static");
    }
}

class Child extends Parent {
    String value = "Child";

    static void print() {
        System.out.println("Child static");
    }
}

Parent item = new Child();
System.out.println(item.value); // Parent
item.print();                   // Parent static
```

static 메서드의 경우 클래스 이름으로 호출하는 것이 명확하다. 위 예제는 인스턴스 메서드의 오버라이딩과 static 메서드의 숨김(hiding)을 구분하기 위한 예시다.

## 정리

오버로딩은 매개변수 목록을 달리해 같은 이름의 메서드를 여러 형태로 제공하는 것이고, 오버라이딩은 하위 클래스가 상속받은 동작을 재정의하는 것이다. 오버라이딩과 동적 바인딩을 이해하면 부모 타입으로 여러 구현체를 다루는 다형성이 어떻게 동작하는지 알 수 있다.
