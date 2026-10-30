---
layout: post
title: "Prototype Pattern — 기존 객체를 복제해 새로운 객체를 만드는 프로토타입 패턴"
date: 2026-09-30 00:00:00 +0900
categories: [학습]
tags: [Java, 디자인패턴, Prototype]
---

## 1. Prototype Pattern이란?

Prototype Pattern(프로토타입 패턴)은 **새 객체를 처음부터 생성하는 대신 이미 만들어진 객체를 복제해 새로운 객체를 만드는 패턴**이다.

게임에서 캐릭터를 생성한다고 생각해 보자. 기본 능력치와 장비가 설정된 캐릭터를 매번 처음부터 구성하는 대신 기본 캐릭터를 복제한 다음 이름이나 일부 능력치만 변경할 수 있다.

## 2. 실제 사례: 게임 캐릭터 복제

복제 기능을 제공하는 캐릭터 클래스를 만든다.

```java
class GameCharacter implements Cloneable {
    private String name;
    private int health;
    private final List<String> items;

    GameCharacter(String name, int health, List<String> items) {
        this.name = name;
        this.health = health;
        this.items = new ArrayList<>(items);
    }

    public void setName(String name) {
        this.name = name;
    }

    public void addItem(String item) {
        items.add(item);
    }

    @Override
    public GameCharacter clone() {
        return new GameCharacter(name, health, items);
    }

    @Override
    public String toString() {
        return name + " / 체력: " + health + " / 장비: " + items;
    }
}
```

위 예제는 생성자에서 목록을 새로 복사하기 때문에 원본과 복제본이 서로 다른 리스트를 가진다. 단순히 참조만 복사하는 얕은 복사와 달리, 이 예제의 items는 독립적으로 변경할 수 있다.

```java
public class Main {
    public static void main(String[] args) {
        GameCharacter original = new GameCharacter(
                "기본 전사", 100,
                new ArrayList<>(List.of("검", "방패"))
        );

        GameCharacter copy = original.clone();
        copy.setName("복제 전사");
        copy.addItem("물약");

        System.out.println(original);
        System.out.println(copy);
    }
}
```

원본 캐릭터의 장비 목록에는 물약이 추가되지 않는다.

## 3. 실행 흐름

```text
기본 캐릭터 생성
       |
    clone()
       |
새 캐릭터 생성
       |
이름 / 장비 등 개별 변경
```

## 4. 복사할 때 주의할 점

객체 복사는 크게 얕은 복사와 깊은 복사로 나눠 생각할 수 있다.

- 얕은 복사: 객체 내부의 참조 필드가 같은 객체를 가리킬 수 있다.
- 깊은 복사: 내부에 포함된 객체까지 별도로 복사해 독립성을 확보한다.

위 예제는 리스트를 새로 만들지만 리스트 안에 변경 가능한 객체가 들어 있다면 그 요소까지 복사할지 추가로 결정해야 한다.

## 5. 실제 적용 사례

- 기본 설정이 복잡한 객체의 복제
- 게임 캐릭터나 적 객체 생성
- 문서 및 템플릿 복사
- 테스트 데이터의 기본 객체 복제
- 생성 비용이 큰 객체의 복사본 생성

복제가 생성보다 항상 빠른 것은 아니다. 객체 내부 구조와 복사 비용을 고려해야 하며, 복사 후 원본과 공유하면 안 되는 데이터가 무엇인지 명확히 해야 한다.

**핵심:** 기존 객체를 원형으로 삼아 복제하고 필요한 부분만 변경해 새로운 객체를 만든다.
