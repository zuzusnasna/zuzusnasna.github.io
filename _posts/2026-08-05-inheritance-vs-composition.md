---
layout: post
title: "상속과 조합(Composition), 어떤 설계를 선택할까?"
date: 2026-10-01 00:00:00 +0900
categories: [학습]
tags: [Java, 객체지향, 상속, Composition]
---

코드 재사용이 필요할 때 가장 먼저 떠올리는 방법 중 하나가 상속이다. 하지만 모든 공통 기능을 상속으로 해결하면 클래스 사이의 결합도가 높아질 수 있다. 조합(Composition)은 필요한 객체를 필드로 가지고 기능을 위임하는 방식으로 이 문제를 줄인다.

## 1. 상속으로 기능 재사용하기

상속은 `extends`를 사용해 부모 클래스의 기능을 물려받는다.

```java
class Engine {
    void start() {
        System.out.println("엔진 시작");
    }
}

class Car extends Engine {
    void drive() {
        start();
        System.out.println("주행 시작");
    }
}
```

Car는 Engine의 기능을 직접 물려받는다. 하지만 자동차가 엔진의 한 종류인 것은 아니다. 자동차는 엔진을 가지고 있는 관계에 가깝다. 이처럼 실제 개념 관계가 맞지 않는 상속은 설계를 어색하게 만든다.

## 2. 조합으로 기능 사용하기

조합은 다른 객체를 필드로 보유하고 필요한 기능을 호출한다.

```java
class Engine {
    void start() {
        System.out.println("엔진 시작");
    }
}

class Car {
    private final Engine engine;

    Car(Engine engine) {
        this.engine = engine;
    }

    void drive() {
        engine.start();
        System.out.println("주행 시작");
    }
}
```

Car는 Engine을 상속하지 않고 Engine 객체를 전달받아 사용한다. 엔진 구현을 바꾸고 싶다면 다른 Engine 구현을 전달할 수 있도록 인터페이스로 추상화할 수도 있다.

## 3. 상속과 조합 비교

| 구분 | 상속 | 조합 |
|---|---|---|
| 관계 | is-a 관계 | has-a 관계 |
| 코드 재사용 | 부모 구현을 상속 | 필요한 객체에 위임 |
| 결합도 | 부모 구현에 영향을 받기 쉬움 | 인터페이스를 사용하면 낮출 수 있음 |
| 변경 | 부모 변경이 자식에 영향 가능 | 구성 객체 교체가 상대적으로 쉬움 |
| 사용 | 진짜 하위 타입 관계 | 기능을 조립하거나 위임할 때 |

## 4. 인터페이스와 조합으로 교체 가능하게 만들기

```java
interface Engine {
    void start();
}

class ElectricEngine implements Engine {
    public void start() {
        System.out.println("전기 모터 시작");
    }
}

class GasEngine implements Engine {
    public void start() {
        System.out.println("가솔린 엔진 시작");
    }
}

class Car {
    private final Engine engine;

    Car(Engine engine) {
        this.engine = engine;
    }

    void drive() {
        engine.start();
        System.out.println("주행 시작");
    }
}
```

사용하는 쪽에서는 구현체를 선택해 전달한다.

```java
Car electricCar = new Car(new ElectricEngine());
electricCar.drive();

Car gasCar = new Car(new GasEngine());
gasCar.drive();
```

Car의 코드를 수정하지 않고 엔진 구현을 교체할 수 있다.

## 5. 언제 선택할까?

- 상속: 자식이 부모의 특수한 종류이고 부모가 정의한 동작 규칙을 지킬 수 있을 때
- 조합: 객체가 다른 객체의 기능을 사용하거나 실행 중 구현을 교체해야 할 때

상속이 항상 나쁜 것은 아니며 조합이 무조건 정답인 것도 아니다. 상속 관계가 자연스럽고 다형성을 보장할 수 있다면 상속이 간결하다. 단순히 코드 몇 줄을 재사용하려는 목적이라면 조합이 더 안전한 선택일 수 있다.

## 정리

상속은 타입 간 관계를 표현하고, 조합은 객체가 가진 기능을 연결한다. 설계할 때는 "코드를 재사용할 수 있는가?"보다 "실제로 A는 B의 한 종류인가, 아니면 B를 가지고 사용하는가?"를 먼저 질문하는 것이 좋다.
