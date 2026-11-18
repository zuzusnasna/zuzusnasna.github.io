---
layout: post
title: "2. 배열과 문자열 (Array & String)"
date: 2026-11-18 00:00:00 +0900
categories: ["CS 학습"]
section: "custom-cs-학습--자료구조와-알고리"
section_parent: "custom-cs-학습"
section_parent_label: "CS 학습"
section_label: "자료구조와 알고리"
tags: ["CS"]
---
## 2.1 배열(Array)

**배열(Array)**은 같은 자료형의 데이터를 메모리의 연속된 공간에 저장하는 자료구조다.

각 데이터는 인덱스(Index)라는 번호를 통해 접근할 수 있다.

### 1. 배열의 기본 구조

예를 들어 정수 5개를 배열에 저장한다고 생각해 보자.

```java
int[] numbers = {10, 20, 30, 40, 50};
```

배열은 다음과 같은 구조로 데이터를 저장한다.

| 인덱스(Index) | 0 | 1 | 2 | 3 | 4 |
|---|---|---|---|---|---|
| 데이터(Data) | 10 | 20 | 30 | 40 | 50 |

- 배열의 첫 번째 인덱스는 `0`이다.
- 마지막 인덱스는 `배열 길이 - 1`이다.
- 배열을 생성할 때 크기가 결정된다.
- 인덱스를 사용해 원하는 위치의 데이터에 접근할 수 있다.

### 2. 배열의 주요 연산

| 연산 | 설명 | 시간 복잡도 |
|---|---|---|
| 접근(Access) | 특정 인덱스의 값 읽기 | O(1) |
| 검색(Search) | 특정 값 찾기 | O(n) |
| 수정(Update) | 특정 인덱스의 값 변경 | O(1) |
| 삽입(Insert) | 중간에 새로운 값 추가 | O(n) |
| 삭제(Delete) | 중간의 값 제거 | O(n) |

※ 삽입과 삭제는 일반적인 배열에서 데이터를 이동해야 하는 상황을 기준으로 한다.

### 3. 배열의 주요 연산 이해하기

#### ① 접근(Access) - O(1)

```java
int[] numbers = {10, 20, 30, 40, 50};

System.out.println(numbers[2]);
```

결과:
```text
30
```

- 인덱스를 이용해 원하는 위치에 바로 접근할 수 있다.
- 배열의 크기와 관계없이 접근 시간은 일정하다.

#### ② 검색(Search) - O(n)

```java
int[] numbers = {10, 20, 30, 40, 50};

int target = 40;

for (int i = 0; i < numbers.length; i++) {
    if (numbers[i] == target) {
        System.out.println(i);
        break;
    }
}
```

결과:
```text
3
```

- 배열에서 특정 값을 찾으려면 처음부터 하나씩 비교해야 할 수 있다.
- 최악의 경우 모든 원소를 확인하므로 O(n)이다.

#### ③ 삽입(Insert) - O(n)

배열 중간에 새로운 데이터를 넣으려면 기존 데이터를 뒤로 이동해야 한다.

```text
삽입 전: [10, 20, 30, 40]
삽입 후: [10, 20, 25, 30, 40]
```

- 삽입 위치 뒤에 있는 데이터들을 이동해야 한다.
- 최악의 경우 O(n)이다.

#### ④ 삭제(Delete) - O(n)

배열 중간의 데이터를 삭제하면 빈 공간을 채우기 위해 뒤에 있는 데이터들을 앞으로 이동해야 한다.

```text
삭제 전: [10, 20, 30, 40, 50]
삭제 후: [10, 20, 40, 50]
```

- 삭제한 위치 뒤의 데이터들을 앞으로 이동해야 한다.
- 최악의 경우 O(n)이다.

### 4. Java에서 배열 사용하기

```java
public class ArrayExample {

    public static void main(String[] args) {

        // 배열 생성 및 초기화
        int[] numbers = {10, 20, 30, 40, 50};

        // 배열 길이
        System.out.println(numbers.length);

        // 특정 인덱스 접근
        System.out.println(numbers[2]);

        // 값 수정
        numbers[2] = 100;

        // 전체 배열 출력
        for (int i = 0; i < numbers.length; i++) {
            System.out.println(numbers[i]);
        }
    }
}
```

실행 결과:
```text
5
30
10
20
100
40
50
```

Java 배열의 주요 문법:

- `int[]`: 정수형 배열 선언
- `new int[5]`: 크기가 5인 배열 생성
- `numbers.length`: 배열의 길이 확인
- `numbers[0]`: 첫 번째 원소 접근

### 5. 배열의 장단점

| 장점 | 단점 |
|---|---|
| 인덱스로 빠른 접근 가능 | 생성 후 크기 변경 불가 |
| 데이터 관리가 간단함 | 중간 삽입·삭제가 비효율적 |
| 연속된 메모리로 관리 | 크기를 잘못 설정하면 메모리 낭비 가능 |

## 2.2 문자열(String)

**문자열(String)**은 여러 개의 문자가 순서대로 나열된 데이터이다.

Java에서는 `String` 클래스를 사용하여 문자열을 표현하며, 문자열은 내부적으로 문자 데이터를 관리한다.

### 1. 문자열의 기본 구조

예를 들어 `"HELLO"`라는 문자열이 있다고 생각해 보자.

```java
String str = "HELLO";
```

문자열은 다음과 같이 각 문자가 순서대로 구성되어 있다.

| 인덱스(Index) | 0 | 1 | 2 | 3 | 4 |
|---|---|---|---|---|---|
| 문자(Character) | H | E | L | L | O |

- 문자열의 첫 번째 인덱스는 `0`이다.
- 마지막 인덱스는 `문자열 길이 - 1`이다.
- 인덱스를 사용하여 특정 위치의 문자에 접근할 수 있다.
- Java의 `String`은 생성된 이후 내용을 직접 변경할 수 없는 **불변 객체(Immutable Object)**이다.

### 2. 문자열의 주요 연산

| 연산 | 설명 | 시간 복잡도 |
|---|---|---|
| 길이 확인(Length) | 문자열의 길이 확인 | O(1) |
| 문자 접근(Access) | 특정 인덱스의 문자 확인 | O(1) |
| 검색(Search) | 특정 문자 또는 문자열 검색 | O(n) |
| 비교(Compare) | 두 문자열의 내용 비교 | O(n) |
| 연결(Concatenation) | 두 문자열 연결 | O(n + m) |
| 추출(Substring) | 특정 범위의 문자열 추출 | O(k) |

※ `n`, `m`은 각각 문자열의 길이이며, `k`는 추출하는 문자열의 길이다. 시간 복잡도는 일반적인 구현과 연산을 기준으로 한 설명이다.

### 3. 문자열의 주요 연산 이해하기

#### ① 길이 확인(Length) - O(1)

```java
String str = "HELLO";

System.out.println(str.length());
```

결과:

```text
5
```

- `length()` 메서드를 사용하여 문자열의 길이를 확인한다.
- Java의 String은 길이 정보를 관리하므로 길이 확인은 O(1)이다.

#### ② 문자 접근(Access) - O(1)

```java
String str = "HELLO";

System.out.println(str.charAt(2));
```

결과:

```text
L
```

- `charAt(index)` 메서드를 사용하여 특정 위치의 문자를 가져온다.
- 인덱스를 사용하므로 O(1)에 접근할 수 있다.

#### ③ 검색(Search) - O(n)

```java
String str = "HELLO";

int index = str.indexOf("L");

System.out.println(index);
```

결과:

```text
2
```

- `indexOf()` 메서드는 특정 문자 또는 문자열이 처음 등장하는 위치를 반환한다.
- 찾는 값이 없으면 `-1`을 반환한다.
- 최악의 경우 문자열 전체를 확인해야 하므로 일반적으로 O(n)이다.

#### ④ 문자열 비교(Compare) - O(n)

```java
String str1 = "HELLO";
String str2 = "HELLO";

System.out.println(str1.equals(str2));
```

결과:

```text
true
```

- `equals()`는 두 문자열의 실제 내용이 같은지 비교한다.
- 문자열의 길이와 내용에 따라 비교해야 하므로 최악의 경우 O(n)이다.

**주의: `==`와 `equals()`의 차이**

```java
String str1 = new String("HELLO");
String str2 = new String("HELLO");

System.out.println(str1 == str2);
System.out.println(str1.equals(str2));
```

결과:

```text
false
true
```

- `==`: 두 변수가 동일한 객체를 참조하는지 비교한다.
- `equals()`: 두 문자열의 내용이 같은지 비교한다.

문자열의 내용 비교에는 일반적으로 `equals()`를 사용한다.

#### ⑤ 문자열 연결(Concatenation) - O(n + m)

```java
String str1 = "HELLO";
String str2 = "WORLD";

String result = str1 + str2;

System.out.println(result);
```

결과:

```text
HELLOWORLD
```

- `+` 연산자를 사용하여 문자열을 연결할 수 있다.
- Java의 String은 불변 객체이므로 기존 문자열의 내용을 직접 변경하지 않는다.
- 새로운 문자열 객체를 만들어 연결 결과를 반환한다.

#### ⑥ 문자열 추출(Substring) - O(k)

```java
String str = "HELLOWORLD";

String result = str.substring(0, 5);

System.out.println(result);
```

결과:

```text
HELLO
```

- `substring(start, end)`는 시작 인덱스부터 끝 인덱스 직전까지 추출한다.
- 위 예시에서는 인덱스 0부터 4까지 추출한다.
- 추출 결과의 길이를 `k`라고 할 때, 일반적인 복사 기반 구현에서는 O(k)로 볼 수 있다.

### 4. Java에서 문자열 사용하기

```java
public class StringExample {

    public static void main(String[] args) {

        // 문자열 생성
        String str = "HELLO";

        // 문자열 길이
        System.out.println(str.length());

        // 특정 위치의 문자 접근
        System.out.println(str.charAt(0));

        // 특정 문자열 검색
        System.out.println(str.indexOf("L"));

        // 문자열 포함 여부
        System.out.println(str.contains("ELL"));

        // 문자열 비교
        System.out.println(str.equals("HELLO"));

        // 문자열 추출
        System.out.println(str.substring(1, 4));

        // 문자열 연결
        System.out.println(str.concat(" WORLD"));
    }
}
```

실행 결과:

```text
5
H
2
true
true
ELL
HELLO WORLD
```

Java String의 주요 메서드:

| 메서드 | 설명 |
|---|---|
| `length()` | 문자열 길이 반환 |
| `charAt(index)` | 특정 인덱스의 문자 반환 |
| `indexOf(value)` | 특정 문자 또는 문자열의 위치 반환 |
| `contains(value)` | 특정 문자열 포함 여부 반환 |
| `equals(value)` | 문자열 내용 비교 |
| `substring(start, end)` | 문자열 일부 추출 |
| `concat(value)` | 문자열 연결 |
| `replace(old, new)` | 특정 문자열 교체 |
| `toUpperCase()` | 대문자로 변환 |
| `toLowerCase()` | 소문자로 변환 |

### 5. 문자열의 불변성(Immutable)

Java의 String은 한 번 생성되면 내부 문자열의 내용을 변경할 수 없다.

```java
String str = "HELLO";

str.concat(" WORLD");

System.out.println(str);
```

실행 결과:

```text
HELLO
```

`concat()`은 기존 문자열을 변경하는 것이 아니라 새로운 문자열을 반환한다.

변경된 결과를 사용하려면 반환값을 다시 저장해야 한다.

```java
String str = "HELLO";

str = str.concat(" WORLD");

System.out.println(str);
```

실행 결과:

```text
HELLO WORLD
```

이러한 특성을 **불변성(Immutable)**이라고 한다.

#### StringBuilder 활용

문자열을 반복적으로 연결해야 하는 경우에는 `StringBuilder`를 사용하는 것이 효율적이다.

```java
StringBuilder sb = new StringBuilder();

sb.append("HELLO");
sb.append(" ");
sb.append("WORLD");

System.out.println(sb.toString());
```

실행 결과:

```text
HELLO WORLD
```

- `String`: 불변 객체로 문자열 변경 시 새로운 문자열을 생성한다.
- `StringBuilder`: 내부 문자열을 변경할 수 있어 반복적인 문자열 연결에 유리하다.

### 6. 문자열의 장단점

| 장점 | 단점 |
|---|---|
| 다양한 문자열 처리 메서드 제공 | 불변 객체이므로 반복적인 연결에 비효율적 |
| 인덱스를 통한 문자 접근 가능 | 문자열 변경 시 새로운 객체 생성 |
| 문자열 비교 및 검색이 간편함 | 문자 인코딩과 유니코드에 대한 이해 필요 |

### 7. 핵심 정리

| 핵심 개념 | 내용 |
|---|---|
| String | 여러 문자가 순서대로 나열된 데이터 |
| Index | 문자의 위치를 나타내는 번호 |
| length() | 문자열 길이 확인 |
| charAt() | 특정 위치의 문자 접근 |
| indexOf() | 특정 문자열 검색 |
| equals() | 문자열 내용 비교 |
| Immutable | 생성된 문자열의 내용을 직접 변경할 수 없는 특성 |
| StringBuilder | 문자열을 효율적으로 변경하고 연결하는 클래스 |
