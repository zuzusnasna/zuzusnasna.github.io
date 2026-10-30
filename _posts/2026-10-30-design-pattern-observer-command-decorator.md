---
layout: post
title: "Design Pattern — Observer, Command, Decorator"
date: 2026-10-05 00:00:00 +0900
categories: [Spring]
tags: [Design Pattern]
---

오늘은 객체 사이의 관계를 다루는 Observer, Command, Decorator 패턴을 정리했다.

## 1. Observer Pattern

하나의 객체 상태가 변경되었을 때 여러 객체에게 변경 사실을 알려주는 구조다.

```java
interface Observer {
    void update(String message);
}

class User implements Observer {
    private final String name;

    User(String name) {
        this.name = name;
    }

    public void update(String message) {
        System.out.println(name + ": " + message);
    }
}
```

Subject는 Observer 목록을 관리한다.

```java
class Notification {
    private final List<Observer> observers = new ArrayList<>();

    void addObserver(Observer observer) {
        observers.add(observer);
    }

    void notifyObservers(String message) {
        for (Observer observer : observers) {
            observer.update(message);
        }
    }
}
```

게시글 알림처럼 한 이벤트를 여러 대상에게 전달해야 할 때 생각해볼 수 있다.

## 2. Command Pattern

실행할 작업 자체를 객체로 만드는 패턴이다.

```java
interface Command {
    void execute();
}

class Light {
    void on() {
        System.out.println("불 켜기");
    }
}

class LightOnCommand implements Command {
    private final Light light;

    LightOnCommand(Light light) {
        this.light = light;
    }

    public void execute() {
        light.on();
    }
}
```

호출하는 쪽에서는 실제 작업을 직접 알지 않아도 된다.

```java
Command command = new LightOnCommand(new Light());
command.execute();
```

작업을 객체로 만들어두면 실행 취소, 예약, 큐 처리 같은 구조와 연결하기 좋다.

## 3. Decorator Pattern

기존 객체를 수정하지 않고 새로운 기능을 감싸서 추가하는 패턴이다.

```java
interface Coffee {
    int price();
}

class Americano implements Coffee {
    public int price() {
        return 3000;
    }
}

class SyrupDecorator implements Coffee {
    private final Coffee coffee;

    SyrupDecorator(Coffee coffee) {
        this.coffee = coffee;
    }

    public int price() {
        return coffee.price() + 500;
    }
}
```

```java
Coffee coffee = new Americano();
coffee = new SyrupDecorator(coffee);

System.out.println(coffee.price()); // 3500
```

원래 `Americano`를 수정하지 않고 기능을 추가했다. 여러 Decorator를 조합해서 기능을 계속 붙일 수도 있다.
