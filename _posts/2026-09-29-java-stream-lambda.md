---
layout: post
title: "Java : 함수형 프로그래밍, 람다와 Stream"
date: 2026-08-18 00:00:00 +0900
categories: [학습]
tags: [Java, Lambda, Stream, 함수형 프로그래밍]
---

람다와 Stream을 이해하려면 먼저 **명령형 프로그래밍과 선언형 프로그래밍의 차이**를 알아야 한다. 두 방식은 같은 결과를 만들더라도 코드를 표현하는 관점이 다르다.

## 1. 명령형과 선언형 프로그래밍

### 명령형(Imperative)

명령형 프로그래밍은 원하는 결과를 만들기 위해 컴퓨터가 수행할 작업 순서와 방법을 직접 작성한다.

- 어떻게(How) 처리할 것인지에 집중한다.
- 반복문, 조건문, 변수 변경 등으로 실행 절차를 표현한다.
- 대표적인 예로 일반적인 Java 반복문을 들 수 있다.

### 선언형(Declarative)

선언형 프로그래밍은 원하는 결과가 무엇인지 표현하고, 구체적인 처리 과정은 라이브러리나 실행 환경에 맡긴다.

- 무엇을(What) 얻을 것인지에 집중한다.
- 세부적인 반복이나 처리 절차를 직접 작성하지 않아도 된다.
- SQL과 HTML이 대표적인 예다.

예를 들어 서울에 거주하는 사용자를 조회한다고 하자.

```sql
SELECT *
FROM users
WHERE country = '서울';
```

쿼리는 어떤 데이터를 원하는지 표현한다. 데이터베이스가 실제로 데이터를 읽고 조건에 맞는 행을 찾는 과정은 데이터베이스 엔진이 처리한다.

### 같은 작업을 두 방식으로 작성하기

배열의 각 요소에 2를 곱하는 예제다.

명령형 방식은 반복과 결과 저장 과정을 직접 작성한다.

```java
List<Integer> numbers = List.of(1, 2, 3, 4, 5);
List<Integer> doubled = new ArrayList<>();

for (int number : numbers) {
    doubled.add(number * 2);
}
```

Stream을 사용하면 변환하려는 작업을 표현할 수 있다.

```java
List<Integer> doubled = numbers.stream()
    .map(number -> number * 2)
    .toList();
```

두 코드는 같은 결과를 만든다. 차이는 반복 과정을 직접 제어하는지, 각 요소에 적용할 변환을 표현하는지에 있다.

선언형 코드가 항상 더 좋은 것은 아니다. 처리 단계가 복잡하거나 중간 상태를 세밀하게 제어해야 한다면 반복문이 더 읽기 쉬울 수 있다.

## 2. 함수형 프로그래밍

함수형 프로그래밍(Functional Programming)은 계산을 함수의 조합으로 표현하는 프로그래밍 패러다임이다. Java는 객체지향 언어이지만 람다와 Stream 등을 통해 함수형 프로그래밍 스타일을 지원한다.

함수형 프로그래밍을 이해할 때 알아둘 특징은 다음과 같다.

### 2-1. 순수 함수(Pure Function)

순수 함수는 같은 입력에 대해 항상 같은 결과를 반환하고, 함수 외부의 상태를 변경하는 부수 효과(Side Effect)를 만들지 않는 함수다.

```java
static int add(int a, int b) {
    return a + b;
}
```

입력값이 같으면 결과도 항상 같다. 외부 변수나 객체를 변경하지도 않는다.

반대로 다음 코드는 외부 상태를 변경하므로 순수 함수가 아니다.

```java
static int total = 0;

static void addToTotal(int number) {
    total += number;
}
```

함수 호출 결과가 외부 변수의 현재 상태에 영향을 받으며, 실행할 때마다 상태가 바뀔 수 있다.

### 2-2. 일급 객체(First-class Object)

일급 객체는 일반적인 값처럼 다룰 수 있는 대상을 말한다. 일반적으로 다음 조건을 가진다.

1. 변수에 할당할 수 있다.
2. 함수나 메서드의 인자로 전달할 수 있다.
3. 함수나 메서드의 반환값으로 사용할 수 있다.

Java에서는 메서드 자체를 독립적인 값으로 전달하지는 않는다. 대신 **함수형 인터페이스를 구현한 객체**를 통해 람다식을 변수에 저장하거나 메서드의 인자로 전달한다.

### 2-3. 불변성(Immutability)

불변성은 데이터를 직접 변경하지 않고 새로운 값을 만들어 사용하는 방식이다.

```java
List<Integer> numbers = List.of(1, 2, 3);

// 기존 목록을 직접 수정하는 대신 새로운 목록 생성
List<Integer> added = numbers.stream()
    .map(number -> number + 10)
    .toList();
```

Stream의 변환 연산은 원본 컬렉션을 직접 수정하지 않고 결과를 만든다. 다만 람다 내부에서 외부 객체를 변경하면 부수 효과가 발생할 수 있으므로 주의해야 한다.

## 3. 람다 표현식(Lambda Expression)

람다식은 메서드를 간결하게 표현하는 문법이다. Java에서 람다식을 사용하려면 람다식이 구현할 대상인 **함수형 인터페이스**가 필요하다.

함수형 인터페이스는 추상 메서드가 하나만 선언된 인터페이스다. `@FunctionalInterface`를 붙이면 컴파일러가 이 조건을 검사한다. default 메서드나 static 메서드가 추가로 있어도 추상 메서드가 하나라면 함수형 인터페이스가 될 수 있다.

```java
@FunctionalInterface
interface MyFunc {
    int max(int a, int b);
}
```

### 익명 클래스와 람다식 비교

익명 클래스로 구현하면 다음과 같다.

```java
MyFunc func = new MyFunc() {
    @Override
    public int max(int a, int b) {
        return a > b ? a : b;
    }
};

System.out.println(func.max(3, 5)); // 5
```

같은 동작을 람다식으로 표현할 수 있다.

```java
MyFunc func = (a, b) -> a > b ? a : b;

System.out.println(func.max(3, 5)); // 5
```

람다식은 함수형 인터페이스의 추상 메서드를 구현하는 객체를 간결하게 표현한다. JavaScript처럼 메서드만 독립적으로 선언하는 것과는 다르다.

### 람다식 기본 형태

```java
(매개변수) -> { 실행문 }
```

반환식이 하나라면 중괄호와 `return`을 생략할 수 있다.

```java
// 매개변수와 반환값이 있는 형태
(a, b) -> a + b

// 매개변수가 하나라면 괄호 생략 가능
name -> System.out.println(name)

// 실행문이 여러 개라면 중괄호와 return 사용
(a, b) -> {
    int result = a + b;
    return result;
}
```

### 자주 사용하는 함수형 인터페이스

Java는 자주 사용하는 함수형 인터페이스를 `java.util.function` 패키지로 제공한다.

| 인터페이스 | 역할 | 추상 메서드 |
|---|---|---|
| `Predicate<T>` | 조건 검사, boolean 반환 | `test(T)` |
| `Function<T, R>` | 입력값을 다른 값으로 변환 | `apply(T)` |
| `Consumer<T>` | 값을 받아 작업 수행 | `accept(T)` |
| `Supplier<T>` | 값을 제공 | `get()` |

```java
Predicate<Integer> isEven = number -> number % 2 == 0;
Function<Integer, String> toText = number -> "숫자: " + number;
Consumer<String> print = text -> System.out.println(text);
Supplier<String> greeting = () -> "안녕하세요";

System.out.println(isEven.test(4)); // true
System.out.println(toText.apply(10)); // 숫자: 10
print.accept("Java");
System.out.println(greeting.get()); // 안녕하세요
```

## 4. Stream API

Stream은 컬렉션이나 배열 등의 데이터를 선언적인 방식으로 처리할 수 있도록 제공하는 API다. 데이터를 저장하는 자료구조가 아니라, 데이터 처리 작업을 연결해 표현하는 도구다.

주요 연산은 다음과 같다.

| 연산 | 구분 | 역할 |
|---|---|---|
| `filter()` | 중간 연산 | 조건에 맞는 요소만 남김 |
| `map()` | 중간 연산 | 요소를 다른 값으로 변환 |
| `sorted()` | 중간 연산 | 요소 정렬 |
| `distinct()` | 중간 연산 | 중복 요소 제거 |
| `forEach()` | 최종 연산 | 요소별 작업 수행 |
| `toList()` | 최종 연산 | 결과를 List로 수집 |
| `count()` | 최종 연산 | 요소 개수 반환 |
| `sum()` | 최종 연산 | 숫자 합계 계산 |

### 명령형 방식과 Stream 방식 비교

1부터 10까지의 숫자 중 짝수만 골라 합계를 구하는 예제다.

명령형 방식은 반복, 조건 검사, 누적 과정을 직접 작성한다.

```java
List<Integer> numbers =
    List.of(1, 2, 3, 4, 5, 6, 7, 8, 9, 10);

int result = 0;

for (int number : numbers) {
    if (number % 2 == 0) {
        result += number;
    }
}

System.out.println(result); // 30
```

Stream 방식은 처리 단계를 연결한다.

```java
int result = numbers.stream()
    .filter(number -> number % 2 == 0)
    .mapToInt(Integer::intValue)
    .sum();

System.out.println(result); // 30
```

각 연산의 역할은 다음과 같다.

1. `stream()`: 컬렉션을 Stream으로 변환한다.
2. `filter()`: 짝수만 남긴다.
3. `mapToInt()`: Integer 요소를 int 값으로 변환한 `IntStream`을 만든다.
4. `sum()`: 남은 숫자의 합계를 계산한다.

### 중간 연산과 최종 연산

Stream 연산은 중간 연산과 최종 연산으로 나뉜다.

- **중간 연산**: `filter()`, `map()`, `sorted()`처럼 새로운 Stream을 반환한다.
- **최종 연산**: `toList()`, `forEach()`, `sum()`, `count()`처럼 결과를 만들거나 처리를 끝낸다.

중간 연산은 최종 연산이 호출되기 전까지 실제 처리를 시작하지 않는다. 이를 지연 연산(Lazy Evaluation)이라고 한다.

```java
List<String> names = List.of("Kim", "Lee", "Kang");

Stream<String> stream = names.stream()
    .filter(name -> name.startsWith("K"));

// 최종 연산이 실행되는 시점에 처리
List<String> result = stream.toList();

System.out.println(result); // [Kim, Kang]
```

Stream은 한 번 최종 연산에 사용하면 다시 사용할 수 없다. 재사용이 필요하다면 원본 컬렉션에서 새로운 Stream을 생성해야 한다.

## 5. 람다와 Stream을 사용할 때 주의할 점

### 외부 상태 변경 피하기

다음 코드는 Stream 내부에서 외부 리스트를 변경한다.

```java
List<Integer> result = new ArrayList<>();

numbers.stream()
    .filter(number -> number % 2 == 0)
    .forEach(result::add);
```

이런 방식보다 결과를 수집하는 최종 연산을 사용하는 편이 의도를 명확하게 표현할 수 있다.

```java
List<Integer> result = numbers.stream()
    .filter(number -> number % 2 == 0)
    .toList();
```

### 모든 반복문을 Stream으로 바꾸지 않기

- 단순 반복이나 인덱스 기반 처리는 일반 반복문이 더 명확할 수 있다.
- Stream 단계가 지나치게 길어지면 중간 결과를 변수로 나누어 표현한다.
- 람다 내부에서 외부 상태를 변경하는 코드는 피한다.
- 병렬 Stream은 무조건 빠른 것이 아니다. 데이터 크기, 작업 비용, 공유 상태, 순서 보장 여부를 확인하고 사용한다.

## 정리

| 구분 | 핵심 |
|---|---|
| 명령형 | 작업을 수행하는 순서와 방법을 작성 |
| 선언형 | 원하는 결과와 처리 조건을 표현 |
| 함수형 프로그래밍 | 함수를 조합해 계산을 표현하는 방식 |
| 람다식 | 함수형 인터페이스 구현을 간결하게 표현 |
| Stream | 데이터 처리 단계를 연결해 표현 |

람다와 Stream을 사용하는 목적은 단순히 코드를 짧게 만드는 것이 아니다. **데이터를 어떤 조건으로 선택하고, 어떻게 변환하고, 어떤 결과로 만들 것인지**를 코드에서 명확하게 드러내는 데 있다.

참고: [선언형 프로그래밍](https://ko.wikipedia.org/wiki/선언형_프로그래밍)
