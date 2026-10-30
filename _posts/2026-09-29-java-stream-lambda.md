---
layout: post
title: "Java Study : Lambda와 Stream을 사용하면서 달라진 코드"
date: 2026-09-29 09:00:00 +0900
categories: [학습]
tags: [Java]
---

Lambda와 Stream을 배우면서 반복문을 없애는 것보다 **데이터 처리 과정을 표현하는 방식이 달라진다**는 점에 집중했다.

## Lambda

```java
List<String> names = List.of("홍길동", "김철수");
names.forEach(name -> System.out.println(name));
```

함수를 값처럼 전달할 수 있어 컬렉션 처리 코드를 간결하게 만들 수 있다.

## Stream

```java
List<String> result = names.stream()
    .filter(name -> name.startsWith("김"))
    .toList();
```

`filter`, `map`, `sorted`, `collect` 등을 연결해 데이터 처리 과정을 표현할 수 있다.

## 주의할 점

코드가 짧아진다고 항상 좋은 것은 아니다. 복잡한 Stream을 한 줄로 작성하면 오히려 읽기 어려워질 수 있다.

## 배운 점

Lambda와 Stream은 단순 문법이 아니라 **컬렉션 데이터를 어떤 단계로 변환할 것인지 표현하는 도구**라고 이해했다.

## 더 깊게 이해하기: Stream은 가독성을 위한 표현이다

Stream은 컬렉션 데이터를 선언적으로 변환·필터링·집계할 수 있게 해준다. 다만 모든 반복문을 Stream으로 바꾸는 것이 좋은 설계는 아니다. 중간 연산이 길어지거나 외부 상태를 변경하면 실행 흐름을 이해하기 어려워질 수 있다.

Stream의 중간 연산은 최종 연산이 실행될 때 평가되는 지연 연산이다. 따라서 중간 연산만 작성하고 결과를 사용하지 않으면 실제 처리가 실행되지 않을 수 있다. `map`은 각 요소를 변환하고, `filter`는 조건에 맞는 요소를 남기며, `collect`는 결과를 모으는 역할을 한다.

### 비교 실습
- 같은 작업을 for문과 Stream으로 작성한 뒤 어느 쪽이 더 읽기 쉬운지 비교한다.
- 중간 연산 안에서 카운터나 외부 리스트를 수정하는 코드를 피한다.
- 병렬 Stream은 공유 상태와 순서, 데이터 크기를 고려한 뒤 사용한다.
- `Optional`과 Stream을 무조건 연결하기보다 null 가능성과 결과의 의미를 먼저 표현한다.

코드의 길이보다 팀원이 변환 과정을 한 번에 이해할 수 있는지가 선택 기준이다.
