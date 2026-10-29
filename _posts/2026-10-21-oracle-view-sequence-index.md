---
layout: post
title: "부트캠프 : Oracle VIEW, SEQUENCE, INDEX를 정리한 이유"
date: 2026-10-21 09:00:00 +0900
categories: [학습]
tags: [Oracle, SQL]
---

Oracle에는 테이블 외에도 조회와 데이터 관리에 도움을 주는 여러 객체가 있다.

## VIEW

복잡한 조회 SQL을 하나의 논리적인 이름으로 제공할 수 있다.

```sql
CREATE VIEW employee_summary AS
SELECT employee_id, name, department_id
FROM employee;
```

원본 데이터를 복사하는 것이 아니라 조회 정의를 저장한다는 점이 중요했다.

## SEQUENCE

숫자 키를 자동으로 증가시키는 데 사용할 수 있다.

```sql
CREATE SEQUENCE member_seq
START WITH 1
INCREMENT BY 1;
```

```sql
INSERT INTO member(member_id, name)
VALUES(member_seq.NEXTVAL, '홍길동');
```

## INDEX

조건 검색을 빠르게 하기 위한 데이터 구조다.

```sql
CREATE INDEX idx_employee_department
ON employee(department_id);
```

하지만 인덱스는 저장 공간과 쓰기 비용이 추가되기 때문에 많이 만든다고 좋은 것이 아니다.

## 배운 점

DB 객체는 각각 목적이 다르다. **조회 구조는 VIEW, 키 생성은 SEQUENCE, 검색 최적화는 INDEX**처럼 사용 목적을 기준으로 구분하면 기억하기 쉬웠다.
