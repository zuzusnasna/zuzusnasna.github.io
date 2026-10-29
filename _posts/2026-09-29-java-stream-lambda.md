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
