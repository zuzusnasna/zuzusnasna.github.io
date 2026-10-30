---
layout: post
title: "Java Iterator와 Comparable·Comparator — 순회와 정렬 기준"
date: 2026-10-30 11:00:00 +0900
categories: [Spring]
tags: [Java, Collection, Iterator, Comparable, Comparator]
---

## 1. Iterator란?

Iterator는 컬렉션의 요소를 순차적으로 탐색하기 위한 인터페이스다. 컬렉션 구현 방식이 배열인지 연결 리스트인지 몰라도 동일한 방식으로 요소를 읽을 수 있다.

```java
List<String> names = new ArrayList<>(List.of("민수", "지영", "현우"));

Iterator<String> iterator = names.iterator();

while (iterator.hasNext()) {
    String name = iterator.next();
    System.out.println(name);
}
```

- `hasNext()`: 다음 요소가 있는지 확인
- `next()`: 다음 요소를 반환하고 커서를 이동
- `remove()`: 마지막으로 반환된 요소를 제거(구현체가 지원하는 경우)

## 2. 반복 중 요소를 삭제할 때

향상된 for문으로 순회하면서 원본 컬렉션을 직접 수정하면 ConcurrentModificationException이 발생할 수 있다.

```java
List<Integer> numbers = new ArrayList<>(List.of(1, 2, 3, 4));

// 잘못된 예: 반복 중 구조 변경
for (Integer number : numbers) {
    if (number % 2 == 0) {
        numbers.remove(number);
    }
}
```

반복 중 제거가 필요하다면 Iterator의 remove를 사용한다.

```java
Iterator<Integer> it = numbers.iterator();

while (it.hasNext()) {
    if (it.next() % 2 == 0) {
        it.remove();
    }
}
```

조건에 맞는 요소를 제거하는 목적이라면 `removeIf()`가 더 간결하다.

```java
numbers.removeIf(number -> number % 2 == 0);
```

ConcurrentModificationException은 모든 동시성 문제를 탐지하는 장치가 아니다. 일반 컬렉션의 반복 중 구조 변경을 빠르게 감지하기 위한 fail-fast 동작이며, 멀티스레드 동기화를 대신하지 않는다.

## 3. Comparable: 클래스의 기본 정렬 기준

Comparable은 객체 자신이 자연 정렬 기준을 정의할 때 구현한다.

```java
class Student implements Comparable<Student> {
    private final String name;
    private final int score;

    Student(String name, int score) {
        this.name = name;
        this.score = score;
    }

    @Override
    public int compareTo(Student other) {
        return Integer.compare(this.score, other.score);
    }

    public int getScore() {
        return score;
    }

    public String getName() {
        return name;
    }
}
```

이 클래스의 자연 정렬은 점수 오름차순이다.

```java
List<Student> students = new ArrayList<>();
students.add(new Student("민수", 80));
students.add(new Student("지영", 95));
students.add(new Student("현우", 70));

Collections.sort(students);
```

## 4. Comparator: 외부에서 정렬 기준 지정

한 객체를 항상 한 가지 기준으로만 정렬할 필요는 없다. 학생 목록을 점수순, 이름순, 점수 내림차순으로 각각 정렬해야 할 수 있다. 이때 Comparator를 사용한다.

```java
students.sort(Comparator.comparingInt(Student::getScore));
students.sort(Comparator.comparing(Student::getName));
students.sort(
    Comparator.comparingInt(Student::getScore).reversed()
);
```

여러 기준을 연결할 수도 있다.

```java
students.sort(
    Comparator.comparingInt(Student::getScore).reversed()
              .thenComparing(Student::getName)
);
```

점수가 높은 학생을 먼저 배치하고, 점수가 같으면 이름순으로 정렬한다.

## 5. Comparable과 Comparator 비교

| 구분 | Comparable | Comparator |
| --- | --- | --- |
| 기준 정의 | 클래스 내부 | 외부 객체 |
| 대표 메서드 | compareTo | compare |
| 기준 개수 | 자연 정렬 기준 | 여러 정렬 기준 구성 가능 |
| 사용 예 | 기본 사번순 | 화면별 이름순·점수순 |

비교 메서드는 음수, 0, 양수로 순서를 표현한다. 직접 뺄셈으로 비교하면 정수 오버플로가 발생할 수 있으므로 `Integer.compare(a, b)` 같은 메서드를 사용하는 것이 안전하다.

## 6. TreeSet·TreeMap과 정렬 기준

TreeSet과 TreeMap은 정렬 기준을 이용해 데이터를 관리한다. 비교 결과가 0인 두 객체는 정렬 구조에서 같은 요소로 취급될 수 있다. 따라서 객체의 equals 기준과 compareTo/Comparator 기준이 크게 어긋나지 않도록 설계해야 한다.

## 핵심 정리

- Iterator는 컬렉션을 구현 방식에 관계없이 순회하는 표준 방법이다.
- 반복 중 삭제는 Iterator.remove 또는 removeIf를 사용한다.
- Comparable은 객체의 자연 정렬 기준을 정의한다.
- Comparator는 상황에 따라 외부에서 정렬 기준을 제공한다.
- 정렬 비교는 오버플로와 동등성 기준까지 고려해 구현한다.
