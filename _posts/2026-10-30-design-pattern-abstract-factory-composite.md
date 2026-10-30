---
layout: post
title: "Design Pattern — Abstract Factory와 Composite"
date: 2026-08-02 00:00:00 +0900
categories: [Spring]
tags: [Design Pattern]
---

오늘은 서로 관련된 객체를 묶어서 생성하는 Abstract Factory와 트리 구조를 다루는 Composite를 정리했다.

## 1. Abstract Factory Pattern

서로 관련된 여러 객체를 한 묶음으로 생성할 때 사용하는 패턴이다.

```java
interface ComputerFactory {
    CPU createCPU();
    RAM createRAM();
    GPU createGPU();
}
```

제조사별 Factory는 서로 맞는 제품을 생성한다.

```java
class IntelFactory implements ComputerFactory {
    public CPU createCPU() {
        return new IntelCPU();
    }

    public RAM createRAM() {
        return new IntelRAM();
    }

    public GPU createGPU() {
        return new IntelGPU();
    }
}
```

Factory Method가 하나의 객체 생성에 집중한다면 Abstract Factory는 서로 연관된 여러 객체를 한 세트로 만드는 데 초점이 있다.

## 2. Composite Pattern

개별 객체와 여러 객체로 구성된 객체를 같은 방식으로 처리할 수 있도록 만드는 패턴이다.

파일과 폴더 구조를 예로 들 수 있다.

```text
root
├── a.txt
├── b.txt
└── project
    ├── Main.java
    └── Test.java
```

공통 인터페이스를 만든다.

```java
interface Component {
    void print();
}
```

파일은 하나의 Component이고 폴더는 여러 Component를 가진다.

```java
class Folder implements Component {
    private final List<Component> children = new ArrayList<>();

    void add(Component component) {
        children.add(component);
    }

    public void print() {
        for (Component child : children) {
            child.print();
        }
    }
}
```

폴더 안에 다시 폴더를 넣을 수 있기 때문에 트리 구조를 재귀적으로 처리할 수 있다.

```java
Folder root = new Folder();
root.add(new File("a.txt"));

Folder project = new Folder();
project.add(new File("Main.java"));
project.add(new File("Test.java"));

root.add(project);
root.print();
```

Composite는 파일 시스템처럼 계층 구조가 있고 개별 객체와 그룹을 같은 방식으로 처리하고 싶을 때 사용할 수 있다.
