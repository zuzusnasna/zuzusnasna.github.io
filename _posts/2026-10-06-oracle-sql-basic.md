---
layout: post
title: "Oracle SQL 기본 문법과 데이터 조회 흐름"
date: 2026-10-06 09:00:00 +0900
categories: [학습]
tags: [Oracle, SQL]
---

Oracle을 공부하면서 SQL의 기본은 결국 **필요한 데이터를 정확하게 선택하고 조건을 붙이는 것**이라는 점부터 정리했다.

## 기본 조회

```sql
SELECT employee_id, name, salary
FROM employee
WHERE salary >= 3000
ORDER BY salary DESC;
```

## 데이터 변경

```sql
INSERT INTO employee (employee_id, name, salary)
VALUES (1, '홍길동', 3500);

UPDATE employee
SET salary = 4000
WHERE employee_id = 1;

DELETE FROM employee
WHERE employee_id = 1;
```

실무에서는 특히 `WHERE` 조건을 잘못 작성하면 대량 데이터가 변경될 수 있기 때문에 조회 → 조건 확인 → 변경 순서로 작업하는 습관이 중요했다.

## 그룹 함수

`COUNT`, `SUM`, `AVG`, `MAX`, `MIN`과 `GROUP BY`를 사용하면 단순 행 조회를 넘어 통계성 데이터를 만들 수 있다.

SQL은 애플리케이션 코드보다 먼저 **어떤 데이터를 어떤 조건으로 가져와야 하는지**를 생각하는 것이 중요하다고 정리했다.

## 더 깊게 이해하기: SQL은 결과 집합을 정의한다

SQL은 행을 하나씩 처리하는 명령형 코드보다, 어떤 결과 집합이 필요한지 선언하는 언어에 가깝다. 같은 결과를 여러 쿼리로 만들 수 있지만, 실제 실행 비용은 테이블 크기·인덱스·통계 정보·조건의 선택도에 따라 달라진다. 따라서 문법을 이해한 다음에는 결과의 정확성과 실행 계획을 함께 살펴야 한다.

`WHERE`는 그룹화 전의 행을 필터링하고, `HAVING`은 그룹화 결과를 필터링한다. `ORDER BY`를 지정하지 않으면 결과 순서는 보장되지 않는다. 테스트에서 우연히 일정하게 보이는 순서에 의존해서는 안 된다.

### 안전한 실습 절차
1. SELECT로 대상 행을 먼저 조회한다.
2. UPDATE나 DELETE의 WHERE 조건을 동일하게 검증한다.
3. 트랜잭션 안에서 변경 결과와 영향받은 행 수를 확인한다.
4. 결과가 맞으면 커밋하고, 예상과 다르면 롤백한다.
5. 대량 데이터에서는 실행 계획과 인덱스 사용 여부를 확인한다.

데이터 변경 SQL은 실행 자체보다 어떤 행이 영향을 받는지 확인하는 절차가 중요하다.
