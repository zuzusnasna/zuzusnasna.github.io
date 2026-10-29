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

## 더 깊게 이해하기: View, Sequence, Index는 서로 다른 문제를 해결한다

View는 조회 로직을 이름 붙여 재사용하고 테이블 구조의 일부를 감추는 데 활용할 수 있다. 하지만 일반적인 View는 결과 데이터를 별도 저장하는 것이 아니므로 복잡한 View를 조회한다고 비용이 자동으로 줄어들지는 않는다. Sequence는 고유한 번호를 생성하는 도구지만 연속된 번호나 트랜잭션 롤백 시 번호 회수를 보장하지 않는다. Index는 조회 경로를 빠르게 찾도록 돕지만 추가 저장 공간과 DML 비용이 발생한다.

세 기능을 하나의 최적화 도구처럼 생각하지 않고 각각의 목적을 분리해야 한다. 조회 로직 재사용은 View, 식별자 생성은 Sequence, 검색 비용 개선은 Index가 담당한다.

### 선택 기준
- View가 중복 SQL을 줄이는지, 권한 경계를 명확히 하는지 확인한다.
- Sequence의 번호가 연속적이어야 한다는 잘못된 가정을 하지 않는다.
- 인덱스는 실제 WHERE·JOIN·ORDER BY 패턴과 데이터 선택도를 기준으로 설계한다.
- 인덱스 추가 전후의 실행 계획과 DML 비용을 함께 확인한다.

DB 객체는 존재 자체가 목적이 아니다. 어떤 문제를 해결하려고 도입했는지와 운영 비용이 무엇인지 설명할 수 있어야 한다.
