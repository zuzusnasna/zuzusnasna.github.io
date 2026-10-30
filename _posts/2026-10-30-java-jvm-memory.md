---
title: "Java JVM Memory — Stack과 Heap의 역할"
date: 2026-10-30
categories: [Spring]
tags: [Java, JVM, Stack, Heap, Memory]
---

## 1. JVM 메모리 구조를 알아야 하는 이유

Java 코드는 JVM(Java Virtual Machine) 위에서 실행된다. JVM은 프로그램 실행에 필요한 메모리 영역을 나누어 관리한다. 객체가 어디에 생성되고 지역 변수와 메서드 호출 정보가 어디에 저장되는지 이해하면 메모리 오류를 분석하는 데 도움이 된다.

## 2. 주요 메모리 영역

### Heap

객체와 배열이 생성되는 영역이다. 여러 스레드가 공유하며, 사용하지 않는 객체는 Garbage Collector의 관리 대상이 된다.

```java
User user = new User("Kim");
```

위 코드에서 User 객체는 Heap에 생성되고, user 참조 변수는 메서드가 실행되는 스레드의 Stack 프레임에서 관리된다.

### Java Stack

스레드마다 별도의 Stack이 존재한다. 메서드가 호출될 때마다 Stack Frame이 만들어지고, 메서드의 지역 변수와 매개변수, 연산 중간값 등이 관리된다. 메서드 실행이 끝나면 해당 프레임이 제거된다.

### Method Area

클래스 메타데이터, 런타임 상수 풀 등 클래스 수준의 정보가 저장되는 논리적 영역이다. HotSpot JVM에서는 관련 런타임 메타데이터를 주로 Metaspace에서 관리한다.

### PC Register와 Native Method Stack

각 스레드의 현재 실행 위치를 추적하는 PC Register가 있으며, Native Method Stack은 JNI 등을 통한 네이티브 메서드 실행을 지원한다.

## 3. Stack과 Heap 비교

| 구분 | Stack | Heap |
| --- | --- | --- |
| 관리 단위 | 스레드별 | JVM 내 공유 |
| 주요 대상 | 메서드 프레임, 지역 변수 | 객체, 배열 |
| 생명 주기 | 메서드 호출과 종료 | 참조 가능성 및 GC |
| 대표 오류 | StackOverflowError | OutOfMemoryError |

## 4. 메모리 오류 사례

- StackOverflowError: 재귀 호출이 종료되지 않거나 호출 깊이가 지나치게 깊을 때 발생할 수 있다.
- OutOfMemoryError: 객체가 과도하게 생성되거나 메모리 누수 등으로 필요한 메모리를 확보하지 못할 때 발생할 수 있다.

## 5. 백엔드 개발에서의 활용

서버에서 요청마다 큰 객체를 계속 생성하거나 캐시에 데이터를 무제한으로 쌓으면 Heap 사용량이 증가할 수 있다. 반대로 재귀 호출이나 지나치게 깊은 메서드 호출은 Stack에 부담을 준다.

메모리 문제를 만났을 때 단순히 힙 크기만 늘리기보다, 객체 생성량·참조가 유지되는 이유·스레드별 호출 흐름을 함께 확인해야 한다.
