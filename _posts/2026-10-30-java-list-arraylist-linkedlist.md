---
title: "Java List — ArrayList와 LinkedList의 차이"
date: 2026-10-30
categories: [Spring]
tags: [Java, Collection, List, ArrayList, LinkedList]
---

## List의 역할

List는 입력 순서를 유지하고 중복을 허용하는 자료구조 인터페이스다. 대표 구현체는 ArrayList와 LinkedList다.

## ArrayList

ArrayList는 내부적으로 배열을 사용한다. 인덱스를 이용한 조회가 빠르고, 끝에 요소를 추가하는 작업도 평균적으로 효율적이다. 다만 배열 중간에 삽입하거나 삭제하면 뒤쪽 요소를 이동해야 한다.

일반적인 목록 화면, 조회가 많은 데이터 처리에서 기본 선택으로 자주 사용한다.

## LinkedList

LinkedList는 각 노드가 이전 노드와 다음 노드를 연결하는 이중 연결 리스트다. 인덱스로 특정 요소를 조회하려면 노드를 따라 이동해야 한다. 이미 노드 위치를 알고 있다면 연결 변경은 효율적일 수 있지만, List 인덱스로 위치를 찾는 비용은 별도다.

## 비교

| 기준 | ArrayList | LinkedList |
| --- | --- | --- |
| 내부 구조 | 동적 배열 | 이중 연결 리스트 |
| 인덱스 조회 | 빠름 | 순차 탐색 |
| 중간 삽입·삭제 | 요소 이동 | 위치 탐색 후 연결 변경 |
| 메모리 | 상대적으로 적음 | 노드 연결 정보 추가 |

## 선택 기준

일반적인 조회와 반복 처리는 ArrayList가 적합한 경우가 많다. LinkedList는 Queue나 Deque 동작이 필요한 경우 함께 검토할 수 있다. 자료구조 이름만 보고 선택하기보다 실제 조회·삽입·삭제 비율을 기준으로 판단한다.
