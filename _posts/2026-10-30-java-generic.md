---
layout: post
title: "Java Generic — 타입을 매개변수로 사용하는 제네릭"
date: 2026-10-30 12:20:00 +0900
categories: [Spring]
tags: [Java, Generic]
---

제네릭(Generic)은 클래스나 메서드에서 사용할 데이터 타입을 미리 고정하지 않고, 사용하는 시점에 타입을 지정할 수 있도록 하는 기능이다.

같은 기능을 여러 타입에 재사용하면서도 컴파일 단계에서 타입 오류를 확인할 수 있다.

## 1. 제네릭을 사용하는 이유

제네릭이 없다면 여러 타입을 받기 위해 `Object`를 사용하고, 값을 꺼낼 때 실제 타입으로 형변환해야 할 수 있다.

```java
List names = new ArrayList();
names.add("Kim");
names.add(100);

String name = (String) names.get(0);
```

이 방식은 서로 다른 타입이 섞일 수 있고, 잘못된 형변환은 실행 중 오류로 이어질 수 있다.

제네릭을 사용하면 저장할 타입을 제한할 수 있다.

```java
List<String> names = new ArrayList<>();
names.add("Kim");
// names.add(100); // 컴파일 오류

String name = names.get(0); // 별도 형변환 불필요
```

## 2. 제네릭 클래스 만들기

클래스 이름 뒤에 타입 매개변수 `<T>`를 선언한다. T는 실제 타입이 들어갈 자리이며, 객체를 생성할 때 구체적인 타입으로 결정된다.

```java
class Box<T> {
    private T value;

    public void set(T value) {
        this.value = value;
    }

    public T get() {
        return value;
    }
}

public class Main {
    public static void main(String[] args) {
        Box<String> textBox = new Box<>();
        textBox.set("Hello");
        String text = textBox.get();

        Box<Integer> numberBox = new Box<>();
        numberBox.set(100);
        int number = numberBox.get();

        System.out.println(text);
        System.out.println(number);
    }
}
```

`Box<String>`에서는 T가 String으로, `Box<Integer>`에서는 T가 Integer로 사용된다.

## 3. 제네릭 메서드

메서드 자체에 타입 매개변수를 선언할 수도 있다. 반환 타입 앞에 `<T>`를 작성한다.

```java
public class Main {
    public static <T> T first(T[] values) {
        return values[0];
    }

    public static void main(String[] args) {
        String[] names = {"Kim", "Lee"};
        Integer[] scores = {90, 80};

        System.out.println(first(names));
        System.out.println(first(scores));
    }
}
```

하나의 메서드가 문자열 배열과 정수 배열을 모두 처리할 수 있다.

## 4. 실제 사용 사례

- `List<Member>`: Member 객체만 담는 목록
- `Map<String, Integer>`: 문자열 키와 정수 값을 관리
- `ResponseDto<T>`: API 응답 데이터 타입을 상황에 따라 변경
- `Optional<User>`: User 타입의 값이 존재할 수도, 없을 수도 있음을 표현

제네릭은 단순히 코드를 짧게 만드는 문법이 아니다. 데이터 타입을 명확하게 제한해 잘못된 데이터 사용을 컴파일 단계에서 줄이고, 공통 코드를 여러 타입에 재사용하도록 돕는다.
