---
layout: post
title: "Java List — ArrayList와 LinkedList의 내부 구조와 선택 기준"
date: 2026-09-08 00:00:00 +0900
categories: [Spring]
tags: [Java, Collection, List, ArrayList, LinkedList]
---

## 1. List의 역할

List는 데이터의 **순서를 유지하고 중복을 허용하는 컬렉션 인터페이스**다. 인덱스로 요소에 접근할 수 있기 때문에 화면에 표시할 목록, 검색 결과, 처리 순서가 있는 데이터에 자주 사용한다.

```java
List<String> names = new ArrayList<>();
names.add("민수");
names.add("지영");
names.add("민수");

System.out.println(names.get(0)); // 민수
System.out.println(names.size()); // 3
```

같은 값인 "민수"가 두 번 저장되고 입력 순서도 유지된다. List는 구현 방법을 강제하지 않고, 실제 저장 구조와 성능 특성은 구현 클래스가 결정한다.

## 2. ArrayList의 내부 구조

ArrayList는 내부적으로 배열을 사용한다. 배열의 특정 위치에 접근할 때 인덱스를 이용하므로 조회 비용이 일정한 편이다.

```java
List<Integer> numbers = new ArrayList<>();
numbers.add(10);
numbers.add(20);
numbers.add(30);

int value = numbers.get(1); // 20
numbers.set(1, 25);         // 두 번째 요소 변경
numbers.remove(0);          // 첫 번째 요소 제거
```

배열의 크기가 가득 차면 더 큰 배열을 만들고 기존 요소를 복사해 공간을 확보한다. 따라서 매번 추가할 때마다 배열을 새로 만드는 것은 아니지만, 용량을 늘리는 순간에는 복사 비용이 발생한다.

- 인덱스 조회: O(1)
- 끝에 추가: 평균적으로 O(1), 용량 확장 시 복사 비용 발생
- 중간 삽입·삭제: 뒤쪽 요소 이동 때문에 O(n)
- 특정 값 검색: O(n)

초기 용량을 알고 있다면 `new ArrayList<>(예상크기)`로 불필요한 확장을 줄일 수 있다.

## 3. LinkedList의 내부 구조

LinkedList는 각 요소가 이전 노드와 다음 노드를 가리키는 이중 연결 리스트다. 배열처럼 연속된 공간에 저장하지 않으며, 노드 간 연결로 순서를 표현한다.

```java
Deque<String> tasks = new LinkedList<>();
tasks.addFirst("긴급 작업");
tasks.addLast("일반 작업");

System.out.println(tasks.removeFirst()); // 긴급 작업
```

인덱스로 요소를 조회하면 앞이나 뒤에서 노드를 따라 이동해야 하므로 O(n)이 걸린다. 특정 노드의 위치를 이미 알고 있다면 연결을 바꾸는 작업은 효율적일 수 있지만, 일반적인 List 사용에서는 그 위치를 찾는 비용이 먼저 발생한다.

## 4. 두 구현체 비교

| 작업 | ArrayList | LinkedList |
| --- | --- | --- |
| 인덱스 조회 | O(1) | O(n) |
| 끝에 추가 | 평균 O(1) | O(1) |
| 중간 삽입·삭제 | 요소 이동 O(n) | 위치 탐색 O(n), 연결 변경 O(1) |
| 메모리 | 배열 중심 | 노드와 참조 필드 추가 |

LinkedList가 중간 삽입·삭제에 항상 빠르다고 단정하면 안 된다. 인덱스로 위치를 찾는 비용까지 고려해야 한다.

## 5. 반복문과 성능

ArrayList는 인덱스 기반 반복이 자연스럽다. LinkedList는 반복자를 이용해 순회하는 편이 적절하다.

```java
List<Integer> values = new ArrayList<>();

for (int i = 0; i < 100_000; i++) {
    values.add(i);
}

// ArrayList에서는 인덱스 접근이 효율적
for (int i = 0; i < values.size(); i++) {
    int value = values.get(i);
}
```

LinkedList에 같은 인덱스 반복을 적용하면 매번 노드를 탐색해 전체 순회가 O(n²) 수준으로 커질 수 있다. 반복자를 사용하면 한 번의 순회로 처리할 수 있다.

## 6. 실무에서 선택하는 기준

일반적인 조회·반복·끝에 추가하는 목록이라면 ArrayList를 기본 선택으로 고려한다. 큐나 덱처럼 양 끝에서 삽입·삭제하는 동작이 중요하다면 LinkedList 또는 ArrayDeque를 비교한다.

실제 선택은 자료구조 이름이 아니라 데이터 크기, 접근 패턴, 메모리 사용량을 기준으로 해야 한다. 특히 대부분의 서비스 코드에서는 ArrayList가 더 단순하고 캐시 친화적인 경우가 많다.

## 핵심 정리

- List는 순서와 중복을 허용하고 인덱스 접근을 제공한다.
- ArrayList는 동적 배열 기반이라 조회와 순회에 유리하다.
- LinkedList는 노드 연결 기반이며 인덱스 조회는 느리다.
- 중간 삽입·삭제도 위치 탐색 비용을 포함해 비교해야 한다.
- 일반 목록은 ArrayList를 우선 고려하고, 양 끝 작업이 중요하면 Deque 구현체도 검토한다.
