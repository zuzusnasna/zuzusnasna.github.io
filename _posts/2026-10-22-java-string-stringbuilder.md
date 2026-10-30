---
layout: post
title: "Java String과 StringBuilder의 차이"
date: 2026-10-07 00:00:00 +0900
categories: [학습]
tags: [Java, String, StringBuilder]
---

Java에서 문자열을 다룰 때 `String`과 `StringBuilder`는 모두 문자열을 표현하지만, 문자열을 변경하는 방식이 다르다. 특히 반복해서 문자열을 연결하는 코드에서는 이 차이가 성능에 영향을 줄 수 있다.

## 1. String은 불변 객체

`String`은 한 번 생성된 문자열의 내용을 변경할 수 없는 불변(Immutable) 객체다.

```java
String message = "Hello";
message.concat(" Java");

System.out.println(message); // Hello
```

`concat()`은 기존 객체를 수정하지 않고 연결된 새로운 문자열을 반환한다. 반환값을 저장해야 변경된 결과를 사용할 수 있다.

```java
message = message.concat(" Java");
System.out.println(message); // Hello Java
```

문자열 리터럴을 사용하면 JVM의 문자열 상수 풀(String Pool)을 활용할 수 있다. 같은 문자열 리터럴은 풀에 있는 동일한 문자열 객체를 재사용할 수 있다.

## 2. 문자열 비교: ==와 equals()

문자열 내용을 비교할 때는 일반적으로 `equals()`를 사용한다.

- `==`: 두 참조 변수가 같은 객체를 가리키는지 비교한다.
- `equals()`: String의 경우 문자열 내용을 비교한다.

```java
String a = "Java";
String b = "Java";
String c = new String("Java");

System.out.println(a == b);      // true: 같은 문자열 리터럴 객체를 참조
System.out.println(a == c);      // false: 별도로 생성한 객체
System.out.println(a.equals(c)); // true: 문자열 내용이 같음
```

문자열 상수 풀의 동작에 따라 `==` 결과가 달라질 수 있으므로 문자열 내용 비교에 `==`를 사용하면 안 된다.

## 3. StringBuilder로 문자열 변경하기

문자열을 반복해서 연결해야 한다면 `StringBuilder`를 고려할 수 있다. 내부 버퍼에 문자열을 추가하는 방식이므로 매번 새로운 String을 연결하는 방식보다 반복적인 수정에 적합하다.

```java
StringBuilder builder = new StringBuilder();

builder.append("Java");
builder.append(" ");
builder.append("Backend");

String result = builder.toString();
System.out.println(result); // Java Backend
```

자주 사용하는 메서드는 다음과 같다.

| 메서드 | 역할 |
|---|---|
| `append()` | 문자열 뒤에 내용 추가 |
| `insert()` | 지정한 위치에 내용 삽입 |
| `delete()` | 지정한 범위의 문자 삭제 |
| `replace()` | 지정한 범위의 문자 교체 |
| `reverse()` | 문자열 순서 반전 |
| `toString()` | String으로 변환 |

## 4. 반복 연결에서 차이 확인하기

```java
String result = "";

for (int i = 0; i < 1000; i++) {
    result += i;
}

StringBuilder builder = new StringBuilder();

for (int i = 0; i < 1000; i++) {
    builder.append(i);
}

String text = builder.toString();
```

첫 번째 코드는 반복할 때마다 기존 문자열과 새 값을 연결한 결과를 만들 수 있다. 두 번째 코드는 StringBuilder의 버퍼에 차례로 추가한다.

다만 컴파일러가 단순한 문자열 연결을 최적화할 수 있고, 실제 성능은 실행 환경과 작업량에 따라 달라진다. 짧은 문자열 연결까지 무조건 StringBuilder로 바꿀 필요는 없다.

## 5. StringBuilder와 StringBuffer

두 클래스 모두 변경 가능한 문자열을 다루지만 동기화 여부가 다르다.

| 구분 | StringBuilder | StringBuffer |
|---|---|---|
| 변경 가능 | O | O |
| 주요 메서드 동기화 | X | O |
| 일반적인 사용 | 단일 스레드에서 문자열 조립 | 여러 스레드에서 같은 인스턴스를 공유할 때 고려 |

StringBuffer의 동기화가 모든 상황에서 더 나은 성능을 의미하지는 않는다. 공유가 필요하지 않은 일반적인 문자열 조립에는 StringBuilder를 많이 사용한다.

## 정리

- String은 불변 객체이므로 변경 결과를 사용하려면 반환값을 저장해야 한다.
- 문자열 내용 비교에는 `equals()`를 사용한다.
- 반복적인 문자열 조립에는 StringBuilder가 적합하다.
- StringBuilder와 StringBuffer는 동기화 여부가 다르다.

문자열을 한두 번 연결하는지, 반복문에서 계속 조립하는지에 따라 적절한 타입을 선택하면 된다.
