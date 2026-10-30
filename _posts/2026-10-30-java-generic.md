---
layout: post
title: "Java Generic — 타입 매개변수, 제한된 타입과 와일드카드"
date: 2026-08-30 00:00:00 +0900
categories: [Spring]
tags: [Java, Generic, Type Safety, Wildcard]
---

## 1. 제네릭이 필요한 이유

제네릭(Generic)은 클래스나 메서드에서 사용할 데이터 타입을 매개변수처럼 전달하는 기능이다. 공통 로직을 여러 타입에 재사용하면서도 컴파일 시점에 타입을 검사할 수 있다.

제네릭이 없다면 Object로 여러 타입을 담을 수 있지만, 값을 꺼낼 때 형변환이 필요하고 잘못된 타입이 들어가도 컴파일러가 놓칠 수 있다.

```java
List values = new ArrayList();
values.add("Java");
values.add(100);

String text = (String) values.get(0);
String number = (String) values.get(1); // 실행 중 ClassCastException
```

제네릭을 사용하면 저장 가능한 타입이 명확해진다.

```java
List<String> values = new ArrayList<>();
values.add("Java");
// values.add(100); // 컴파일 오류

String text = values.get(0);
```

## 2. 제네릭 클래스

클래스 선언에서 타입 매개변수를 지정하면 객체를 생성할 때 실제 타입을 전달할 수 있다.

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

Box<String> textBox = new Box<>();
textBox.set("Hello");

Box<Integer> numberBox = new Box<>();
numberBox.set(100);
```

T는 관례적으로 Type을 의미한다. 여러 타입 매개변수를 사용할 때는 K(Key), V(Value), E(Element), N(Number) 등의 이름도 자주 사용한다.

## 3. 제네릭 메서드

클래스 전체가 아니라 특정 메서드에서만 타입 매개변수를 선언할 수도 있다.

```java
public static <T> T first(List<T> values) {
    return values.get(0);
}

List<String> names = List.of("Kim", "Lee");
String name = first(names);
```

메서드 반환 타입 앞에 `<T>`를 선언한다. 컴파일러가 인자 타입을 바탕으로 T를 추론할 수 있어 호출할 때 타입을 명시하지 않아도 되는 경우가 많다.

## 4. 제한된 타입 매개변수

타입에 특정 상위 타입을 요구하려면 extends를 사용할 수 있다.

```java
public static <T extends Number> double sum(T a, T b) {
    return a.doubleValue() + b.doubleValue();
}

sum(10, 20);
sum(10.5, 20.5);
// sum("10", "20"); // 컴파일 오류
```

T는 Number 또는 Number의 하위 타입이어야 한다. 인터페이스도 extends로 제한할 수 있고, 여러 타입 제한은 `T extends Number & Comparable<T>`처럼 선언할 수 있다.

## 5. 와일드카드: ?

이미 선언된 제네릭 타입을 유연하게 전달하려면 와일드카드를 사용한다.

| 표현 | 의미 |
| --- | --- |
| `<?> ` | 타입을 알 수 없는 모든 제네릭 타입 |
| `<? extends Number>` | Number 또는 하위 타입 |
| `<? super Integer>` | Integer 또는 상위 타입 |

```java
static double total(List<? extends Number> numbers) {
    double result = 0;

    for (Number number : numbers) {
        result += number.doubleValue();
    }

    return result;
}
```

Integer 목록, Double 목록을 모두 전달할 수 있다. 다만 extends 와일드카드에는 구체적인 하위 타입 값을 안전하게 추가하기 어렵다. 읽기 중심의 자료에 적합하다.

반대로 super는 특정 타입을 넣는 작업에 유리하다.

```java
static void addScores(List<? super Integer> values) {
    values.add(90);
    values.add(80);
}
```

## 6. PECS 원칙

PECS는 Producer Extends, Consumer Super의 약자다.

- 데이터를 읽어 제공하는 역할(Producer)이면 `? extends T`
- 데이터를 받아 소비하는 역할(Consumer)이면 `? super T`

컬렉션에서 값을 꺼내 다른 곳으로 전달한다면 extends를, 특정 타입의 값을 컬렉션에 넣는다면 super를 우선 고려한다. 읽기와 쓰기가 모두 필요하면 구체적인 타입 매개변수를 사용하는 편이 명확할 수 있다.

## 7. 제네릭과 배열의 차이

Java에서는 제네릭 타입 정보가 런타임에 대부분 소거되는 Type Erasure 방식을 사용한다. 그래서 `new T()`, `new T[10]` 같은 코드는 허용되지 않는다. 또한 `List<String>`과 `List<Integer>`는 런타임에 동일한 List 계열 타입으로 취급된다.

이 특성 때문에 다음과 같은 제약이 있다.

- 기본형 int 대신 Integer 같은 래퍼 타입 사용
- 제네릭 타입의 직접적인 instanceof 검사 제한
- 제네릭 배열 생성 제한
- 오버로딩 시 타입 소거로 시그니처가 충돌할 수 있음

## 8. 실무에서 사용하는 위치

- `List<Member>`: 특정 타입의 목록
- `Map<Long, Member>`: ID와 객체 매핑
- `ResponseDto<T>`: 여러 API 응답 데이터에 공통 구조 적용
- `Optional<User>`: 값의 존재 여부를 타입으로 표현
- 저장소·서비스 공통 인터페이스: 엔티티 타입별 공통 동작 정의

## 핵심 정리

- 제네릭은 타입 안정성과 코드 재사용성을 높인다.
- 클래스와 메서드에 타입 매개변수를 선언할 수 있다.
- extends와 super로 타입 범위를 제한할 수 있다.
- PECS는 읽기와 쓰기 방향을 기준으로 와일드카드를 선택하는 원칙이다.
- 타입 소거 때문에 제네릭 배열 생성 등 일부 제약이 존재한다.
