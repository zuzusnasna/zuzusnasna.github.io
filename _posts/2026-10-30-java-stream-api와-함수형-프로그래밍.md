---
layout: post
title: "Java Stream API와 함수형 프로그래밍"
date: 2026-10-30 00:00:00 +0900
categories: [JVM]
tags: [Java, Stream, Lamda]
---
# Java Stream API와 함수형 프로그래밍

## 1. Stream API

### Stream API란?

`Stream API`는 Java 8부터 도입된 **컬렉션과 배열 등의 데이터를 함수형 방식으로 처리하기 위한 API**이다.

기존에는 반복문과 조건문을 직접 작성하여 데이터를 처리했다면, Stream을 사용하면 **데이터를 어떻게 처리할지보다 어떤 데이터를 원하는지**에 집중하여 코드를 작성할 수 있다.

```java
List<String> names = Arrays.asList(
    "홍길동", "김철수", "홍길순", "이영희"
);

List<String> result = names.stream()
        .filter(name -> name.startsWith("홍"))
        .collect(Collectors.toList());
```

### Stream의 처리 과정

Stream은 일반적으로 다음과 같은 흐름으로 동작한다.

```text
데이터 소스
   ↓
Stream 생성
   ↓
중간 연산
   ↓
중간 연산
   ↓
최종 연산
   ↓
결과
```

예를 들어,

```java
names.stream()
     .filter(name -> name.startsWith("홍"))
     .map(String::toUpperCase)
     .collect(Collectors.toList());
```

- `stream()` → Stream 생성
- `filter()` → 조건에 맞는 데이터 추출
- `map()` → 데이터 변환
- `collect()` → 최종 결과 생성

### Stream의 특징

- 원본 컬렉션의 데이터를 직접 변경하지 않는다.
- 중간 연산은 실제로 바로 실행되지 않고 최종 연산이 수행될 때 처리된다.
- 하나의 Stream은 최종 연산 이후 재사용할 수 없다.
- 여러 데이터를 연속적인 연산으로 처리할 수 있다.

---

## 2. Stream 주요 메서드

### `filter()`

조건에 맞는 데이터만 추출한다.

```java
List<String> names = Arrays.asList(
    "홍길동", "김철수", "홍길순", "이영희"
);

List<String> result = names.stream()
        .filter(name -> name.contains("홍"))
        .collect(Collectors.toList());
```

결과:

```text
[홍길동, 홍길순]
```

즉,

```text
filter() = 데이터 선택
```

---

### `map()`

Stream의 데이터를 다른 형태로 변환한다.

```java
List<String> names = Arrays.asList(
    "hong", "kim", "lee"
);

List<String> result = names.stream()
        .map(String::toUpperCase)
        .collect(Collectors.toList());
```

결과:

```text
[HONG, KIM, LEE]
```

즉,

```text
map() = 데이터 변환
```

`filter()`와 `map()`을 구분하는 것이 중요하다.

```text
filter → 필요한 데이터만 골라낸다.
map    → 데이터를 다른 값으로 변환한다.
```

---

### `distinct()`

중복 데이터를 제거한다.

```java
List<Integer> numbers = Arrays.asList(1, 2, 2, 3, 3, 4);

List<Integer> result = numbers.stream()
        .distinct()
        .collect(Collectors.toList());
```

결과:

```text
[1, 2, 3, 4]
```

---

### `sorted()`

Stream의 데이터를 정렬한다.

```java
List<String> names = Arrays.asList(
    "홍길동", "김철수", "이영희"
);

List<String> result = names.stream()
        .sorted()
        .collect(Collectors.toList());
```

---

### `limit()`

앞에서부터 지정한 개수만큼 데이터를 가져온다.

```java
List<Integer> result = numbers.stream()
        .limit(3)
        .collect(Collectors.toList());
```

---

### `count()`

Stream의 데이터 개수를 반환한다.

```java
long count = names.stream()
        .filter(name -> name.startsWith("홍"))
        .count();
```

---

### `collect()`

Stream의 처리 결과를 원하는 형태로 수집한다.

```java
List<String> result = names.stream()
        .filter(name -> name.startsWith("홍"))
        .collect(Collectors.toList());
```

가장 기본적으로 `List` 형태의 결과를 만들 때 많이 사용한다.

---

## 3. Stream의 중간 연산과 최종 연산

Stream 연산은 크게 **중간 연산**과 **최종 연산**으로 나눌 수 있다.

### 중간 연산

데이터를 가공하고 새로운 Stream을 반환한다.

```text
filter()
map()
distinct()
sorted()
limit()
```

예:

```java
names.stream()
     .filter(name -> name.startsWith("홍"))
     .map(String::toUpperCase);
```

이 코드만 작성하면 아직 최종 결과가 만들어지지 않는다.

### 최종 연산

Stream의 처리를 끝내고 실제 결과를 만든다.

```text
collect()
count()
sum()
forEach()
```

예:

```java
names.stream()
     .filter(name -> name.startsWith("홍"))
     .collect(Collectors.toList());
```

### 중요

```java
names.stream()
     .filter(name -> name.startsWith("홍"));
```

위 코드만으로는 최종 결과가 만들어지지 않는다.

```java
names.stream()
     .filter(name -> name.startsWith("홍"))
     .collect(Collectors.toList());
```

처럼 **최종 연산이 있어야 실제 Stream 처리가 완료된다.**

---

## 4. Stream은 일회용

Stream은 최종 연산이 실행되면 다시 사용할 수 없다.

```java
Stream<String> stream = names.stream();

stream.filter(name -> name.startsWith("홍"))
      .forEach(System.out::println);

// 다시 사용하면 오류 발생
stream.forEach(System.out::println);
```

따라서 다시 사용하려면 새로운 Stream을 생성해야 한다.

```java
names.stream()
     .filter(name -> name.startsWith("홍"))
     .forEach(System.out::println);

names.stream()
     .filter(name -> name.startsWith("김"))
     .forEach(System.out::println);
```

---

# 5. 람다식

## 람다식이란?

람다식은 **메서드를 간결하게 표현하기 위한 Java 8의 문법**이다.

기존에는 익명 클래스를 사용하여 구현해야 했던 코드를 람다식으로 간단하게 표현할 수 있다.

### 기존 익명 클래스

```java
Runnable runnable = new Runnable() {
    @Override
    public void run() {
        System.out.println("실행");
    }
};
```

### 람다식

```java
Runnable runnable = () -> {
    System.out.println("실행");
};
```

더 간단하게 작성할 수도 있다.

```java
Runnable runnable = () -> System.out.println("실행");
```

즉,

```text
익명 클래스
    ↓
람다식
    ↓
불필요한 코드를 제거하고 핵심 동작만 표현
```

---

# 6. 함수형 인터페이스

람다식을 이해하기 위해서는 **함수형 인터페이스**를 알아야 한다.

### 함수형 인터페이스란?

**추상 메서드를 하나만 가지고 있는 인터페이스**를 의미한다.

```java
@FunctionalInterface
interface Calculator {
    int calculate(int a, int b);
}
```

이 인터페이스는 추상 메서드가 하나이기 때문에 람다식으로 구현할 수 있다.

```java
Calculator calculator = (a, b) -> a + b;

System.out.println(calculator.calculate(10, 20));
```

결과:

```text
30
```

### `@FunctionalInterface`

```java
@FunctionalInterface
```

어노테이션을 사용하면 해당 인터페이스가 함수형 인터페이스의 조건을 만족하는지 컴파일러가 확인해준다.

---

## 7. 일반 클래스 → 익명 클래스 → 람다식

같은 기능을 여러 방식으로 표현할 수 있다.

### 일반적인 구현

```java
class CalculatorImpl implements Calculator {

    @Override
    public int calculate(int a, int b) {
        return a + b;
    }
}
```

### 익명 클래스

```java
Calculator calculator = new Calculator() {
    @Override
    public int calculate(int a, int b) {
        return a + b;
    }
};
```

### 람다식

```java
Calculator calculator = (a, b) -> a + b;
```

즉,

```text
구현 클래스
    ↓
익명 클래스
    ↓
람다식
```

람다식을 사용하면 인터페이스 구현을 훨씬 간결하게 작성할 수 있다.

---

# 8. 메서드 참조

메서드 참조는 이미 만들어진 메서드를 `::` 연산자를 사용하여 참조하는 방법이다.

람다식에서 단순히 기존 메서드를 호출하는 경우 코드를 더 간결하게 만들 수 있다.

### 람다식

```java
names.stream()
     .map(name -> name.toUpperCase())
     .collect(Collectors.toList());
```

### 메서드 참조

```java
names.stream()
     .map(String::toUpperCase)
     .collect(Collectors.toList());
```

두 코드는 같은 의미이다.

```text
name -> name.toUpperCase()
        ↓
String::toUpperCase
```

### 대표적인 메서드 참조

```java
System.out::println
String::toUpperCase
Math::abs
```

---

# 9. 생성자 참조

생성자도 `::`를 사용하여 참조할 수 있다.

```java
Function<String, Person> function =
        name -> new Person(name);
```

이를 생성자 참조로 표현하면,

```java
Function<String, Person> function =
        Person::new;
```

즉,

```text
name -> new Person(name)
        ↓
Person::new
```

---

# 10. 명령형 프로그래밍과 선언형 프로그래밍

## 명령형 프로그래밍

**어떻게 처리할 것인지**를 직접 작성하는 방식이다.

예를 들어 짝수의 합을 구한다고 하면,

```java
int sum = 0;

for (int number : numbers) {
    if (number % 2 == 0) {
        sum += number;
    }
}
```

개발자가 직접

1. 데이터를 반복하고
2. 짝수인지 검사하고
3. 결과에 더하는

과정을 작성해야 한다.

---

## 선언형 프로그래밍

**무엇을 원하는지**를 중심으로 표현하는 방식이다.

```java
int sum = numbers.stream()
        .filter(number -> number % 2 == 0)
        .mapToInt(Integer::intValue)
        .sum();
```

코드의 흐름을 보면,

```text
numbers
   ↓
filter()
짝수만 선택
   ↓
mapToInt()
정수로 변환
   ↓
sum()
합계 계산
```

반복문을 직접 작성하지 않고 **원하는 데이터 처리 과정을 선언적으로 표현**할 수 있다.

---

# 11. 함수형 프로그래밍

함수형 프로그래밍은 **함수를 중심으로 프로그램을 구성하는 프로그래밍 패러다임**이다.

Java는 완전한 함수형 언어는 아니지만 Java 8부터 람다식과 Stream API 등을 통해 함수형 프로그래밍 방식을 사용할 수 있다.

### 순수 함수

같은 입력에 대해 항상 같은 결과를 반환하고 외부 상태를 변경하는 등의 부수 효과를 최소화하는 함수이다.

```java
int add(int a, int b) {
    return a + b;
}
```

같은 값을 전달하면 항상 같은 결과가 나온다.

---

### 일급 객체

함수를 값처럼 활용할 수 있는 특성을 의미한다.

Java에서는 람다식을 함수형 인터페이스의 객체로 표현하여 다음과 같이 사용할 수 있다.

```java
Function<Integer, Integer> square =
        number -> number * number;
```

함수를 변수에 저장하는 것처럼 사용할 수 있고, 다른 메서드의 매개변수나 반환값으로 활용할 수도 있다.

---

### 불변성

기존 데이터를 직접 변경하기보다는 새로운 결과를 만들어 처리하는 방식이다.

```java
List<String> result = names.stream()
        .filter(name -> name.startsWith("홍"))
        .collect(Collectors.toList());
```

기존 `names`를 직접 변경하지 않고 새로운 `List`를 생성한다.

---

# 12. Stream + Lambda + Functional Interface 관계

오늘 배운 내용은 각각 별개의 개념이 아니라 서로 연결되어 있다.

```text
                 함수형 인터페이스
                       ↑
                       │
                    람다식
                       │
                       ↓
                  Stream API
                       │
          ┌────────────┼────────────┐
          ↓            ↓            ↓
       filter()      map()       sorted()
          │            │            │
          └────────────┼────────────┘
                       ↓
                  최종 연산
                       ↓
                     결과
```

예를 들어,

```java
List<String> result = names.stream()
        .filter(name -> name.contains("홍"))
        .map(String::toUpperCase)
        .sorted()
        .collect(Collectors.toList());
```

여기서

- `stream()` → Stream 생성
- `filter()` → 조건에 맞는 데이터 선택
- `map()` → 데이터 변환
- `sorted()` → 데이터 정렬
- `collect()` → 결과 생성
- `name -> ...` → 람다식
- `String::toUpperCase` → 메서드 참조
- 람다식이 사용되는 대상 → 함수형 인터페이스

처럼 서로 연결되어 있다.

---

# 13. 오늘 배운 내용 정리

| 개념 | 핵심 |
|---|---|
| Stream API | 데이터를 연속적인 처리 과정으로 다루는 API |
| `filter()` | 조건에 맞는 데이터 선택 |
| `map()` | 데이터를 다른 형태로 변환 |
| `distinct()` | 중복 제거 |
| `sorted()` | 정렬 |
| `limit()` | 데이터 개수 제한 |
| `count()` | 데이터 개수 계산 |
| `collect()` | 처리 결과 수집 |
| 람다식 | 함수를 간결하게 표현 |
| 함수형 인터페이스 | 추상 메서드가 하나인 인터페이스 |
| 메서드 참조 | `::`를 이용한 메서드 호출 간소화 |
| 생성자 참조 | `::new`를 이용한 객체 생성 간소화 |
| 명령형 | 처리 과정을 직접 작성 |
| 선언형 | 원하는 결과와 처리 의도를 표현 |
| 함수형 프로그래밍 | 함수를 중심으로 프로그램 구성 |

## 핵심 흐름

```text
람다식
  ↓
함수형 인터페이스를 통해 동작
  ↓
Stream API의 연산에 활용
  ↓
filter / map / sorted 등으로 데이터 가공
  ↓
collect / count / sum 등으로 결과 생성
```

### 한 줄 정리

> **Stream은 데이터를 처리하는 도구이고, 람다식은 그 처리 방법을 간결하게 표현하는 문법이며, 함수형 인터페이스는 람다식이 사용될 수 있는 기반이다.**