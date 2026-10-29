---
layout: post
title: "Java 기본 문법을 다시 정리한 내용"
date: 2026-10-03 09:00:00 +0900
categories: [학습]
tags: [Java]
---

부트캠프에서 Java 문법을 익히면서 이후 Spring을 이해하기 위한 기본기를 정리했다.

## 기본 구성

Java 프로그램은 클래스와 메서드를 중심으로 구성된다.

```java
public class Main {
    public static void main(String[] args) {
        int age = 20;
        if (age >= 20) {
            System.out.println("성인");
        }
    }
}
```

## 학습한 핵심 문법

- 변수와 자료형
- 조건문과 반복문
- 배열
- 메서드
- 문자열 처리
- 입력과 출력

문법 자체를 외우는 것보다 반복문, 배열, 메서드를 조합해 작은 문제를 직접 해결하는 방식으로 익혔다.

## 배운 점

Spring Boot를 사용하면 많은 부분이 프레임워크에 의해 감춰지지만 결국 요청을 처리하는 코드는 Java이기 때문에 기본 문법과 객체지향 개념이 기반이 된다는 점을 느꼈다.
