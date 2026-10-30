---
layout: post
title: "Java 생성자와 this, super"
date: 2026-10-07 00:00:00 +0900
categories: [학습]
tags: [Java, 생성자, 상속]
---

객체를 생성할 때 호출되는 생성자는 객체의 초기 상태를 만드는 역할을 한다. `this`와 `super`는 각각 현재 객체와 부모 클래스 부분을 가리키거나 생성자를 호출할 때 사용한다.

## 1. 생성자란?

생성자는 클래스 이름과 같고 반환 타입을 작성하지 않는 특별한 구성 요소다. 객체를 생성할 때 호출되며 필드 초기화 등에 사용한다.

```java
class Member {
    String name;
    int age;

    Member(String name, int age) {
        this.name = name;
        this.age = age;
    }
}

Member member = new Member("Kim", 20);
```

생성자를 하나도 작성하지 않으면 컴파일러가 매개변수가 없는 기본 생성자를 제공한다. 생성자를 직접 하나라도 선언하면 컴파일러가 기본 생성자를 자동으로 추가하지 않는다.

## 2. 생성자 오버로딩

매개변수의 개수나 타입, 순서가 다르면 여러 생성자를 선언할 수 있다. 이를 생성자 오버로딩이라고 한다.

```java
class Product {
    String name;
    int price;

    Product() {
        this("이름 없음", 0);
    }

    Product(String name) {
        this(name, 0);
    }

    Product(String name, int price) {
        this.name = name;
        this.price = price;
    }
}
```

기본 생성자와 이름만 받는 생성자가 공통 생성자를 호출하므로 초기화 코드의 중복을 줄일 수 있다.

## 3. this: 현재 객체와 생성자 호출

`this`는 현재 객체를 가리킨다. 필드 이름과 매개변수 이름이 같을 때 구분하는 데 자주 사용한다.

```java
class Member {
    private String name;

    Member(String name) {
        this.name = name;
    }
}
```

또한 `this()` 형태로 같은 클래스의 다른 생성자를 호출할 수 있다. 이때 `this()`는 생성자의 첫 번째 문장이어야 한다.

```java
Member() {
    this("Guest");
}
```

## 4. super: 부모 클래스의 멤버와 생성자

`super`는 부모 클래스 부분을 가리킨다. 부모 클래스의 필드나 메서드에 접근하거나 `super()`로 부모 생성자를 호출할 수 있다.

```java
class Person {
    String name;

    Person(String name) {
        this.name = name;
    }
}

class Student extends Person {
    int grade;

    Student(String name, int grade) {
        super(name);
        this.grade = grade;
    }
}
```

부모 클래스에 매개변수가 없는 생성자가 없다면 자식 생성자는 적절한 `super(인자)` 호출을 작성해야 한다.

## 5. 생성자 호출 순서

자식 객체를 생성하면 부모 클래스 부분이 먼저 초기화되고 자식 클래스 부분이 초기화된다.

```java
class Parent {
    Parent() {
        System.out.println("Parent 생성자");
    }
}

class Child extends Parent {
    Child() {
        System.out.println("Child 생성자");
    }
}

new Child();
```

출력 결과:

```text
Parent 생성자
Child 생성자
```

생성자에서 `this()` 또는 `super()`를 명시하지 않으면 컴파일러가 가능한 경우 `super()`를 첫 문장에 삽입한다. 따라서 부모 생성자 호출이 먼저 진행된다.

## 6. this()와 super()의 관계

한 생성자에서 `this()`와 `super()`를 동시에 직접 첫 문장으로 호출할 수는 없다. `this()`로 같은 클래스의 다른 생성자를 호출하고, 그 생성자가 다시 부모 생성자를 호출하도록 구성할 수 있다.

Java 25부터는 생성자 첫 부분의 명시적 생성자 호출 규칙에 변화가 있지만, 일반적인 코드와 학습에서는 대상 Java 버전의 규칙을 확인해야 한다. Java 21 환경에서는 `this()` 또는 `super()` 호출을 생성자의 첫 문장에 두는 규칙으로 작성하면 된다.

## 정리

- 생성자는 객체 생성 시 초기 상태를 설정한다.
- 생성자를 직접 선언하면 기본 생성자가 자동으로 추가되지 않는다.
- this는 현재 객체를 가리키고 this()는 같은 클래스의 다른 생성자를 호출한다.
- super는 부모 클래스 부분을 가리키고 super()는 부모 생성자를 호출한다.
- 상속 관계에서 부모 생성자가 먼저 실행된다.
