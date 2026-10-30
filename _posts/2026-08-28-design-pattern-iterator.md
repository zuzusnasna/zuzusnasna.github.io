---
layout: post
title: "Iterator Pattern — 내부 구조를 숨기고 요소를 순회하는 반복자 패턴"
date: 2026-10-30 00:00:00 +0900
categories: [학습]
tags: [Java, 디자인패턴, Iterator]
---

## 1. Iterator Pattern이란?

Iterator Pattern(반복자 패턴)은 **컬렉션 내부의 데이터 구조를 노출하지 않고 요소를 하나씩 순회할 수 있도록 하는 패턴**이다.

사용자가 도서관의 책을 확인할 때 책이 선반에 어떤 방식으로 정리되어 있는지 알 필요는 없다. 정해진 순서에 따라 한 권씩 확인하면 된다.

프로그램에서도 배열, 리스트, 트리 등 내부 구조가 달라도 반복자를 통해 요소를 순회할 수 있다.

## 2. 직접 구현해 보는 반복자

반복자가 제공할 기능을 정의한다.

```java
interface MyIterator<T> {
    boolean hasNext();
    T next();
}
```

책 목록과 반복자를 제공하는 컬렉션을 만든다.

```java
import java.util.List;

class BookShelf {
    private final List<String> books;

    BookShelf(List<String> books) {
        this.books = List.copyOf(books);
    }

    public MyIterator<String> iterator() {
        return new MyIterator<>() {
            private int index = 0;

            @Override
            public boolean hasNext() {
                return index < books.size();
            }

            @Override
            public String next() {
                if (!hasNext()) {
                    throw new java.util.NoSuchElementException();
                }
                return books.get(index++);
            }
        };
    }
}
```

사용하는 쪽은 목록의 내부 필드나 인덱스를 직접 관리하지 않는다.

```java
public class Main {
    public static void main(String[] args) {
        BookShelf shelf = new BookShelf(
                List.of("Java", "Spring", "Database")
        );

        MyIterator<String> iterator = shelf.iterator();

        while (iterator.hasNext()) {
            System.out.println(iterator.next());
        }
    }
}
```

## 3. 실행 흐름

```text
BookShelf
    |
 iterator()
    |
 MyIterator
    |
hasNext() → next()
    |
책을 하나씩 반환
```

반복자는 현재 위치와 다음 요소를 가져오는 방법을 관리한다. 사용하는 코드는 컬렉션의 내부 구현에 의존하지 않는다.

## 4. Java에서의 활용

Java Collections Framework의 Iterator가 대표적인 예다.

```java
List<String> names = List.of("Kim", "Lee", "Park");

Iterator<String> iterator = names.iterator();

while (iterator.hasNext()) {
    System.out.println(iterator.next());
}
```

향상된 for문도 반복 가능한 객체를 순회하는 데 사용한다.

```java
for (String name : names) {
    System.out.println(name);
}
```

## 5. 실제 적용 사례

- 목록이나 검색 결과 순회
- 데이터베이스 조회 결과 처리
- 파일의 행 단위 읽기
- 트리나 그래프 탐색 결과 순회
- 컬렉션의 내부 자료구조를 숨기고 동일한 방식으로 접근

**핵심:** 컬렉션이 배열인지 리스트인지 몰라도 반복자 인터페이스를 통해 요소를 순서대로 확인할 수 있다.
