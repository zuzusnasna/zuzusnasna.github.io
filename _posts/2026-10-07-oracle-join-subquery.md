---
layout: post
title: "Oracle JOIN과 서브쿼리: 여러 테이블에서 필요한 데이터 찾기"
date: 2026-10-07 09:00:00 +0900
categories: [학습]
tags: [Oracle, SQL]
---

관계형 데이터베이스에서는 한 테이블에 모든 정보를 넣지 않기 때문에 여러 테이블을 연결해서 조회하는 일이 많다.

## JOIN

```sql
SELECT e.name, d.department_name
FROM employee e
JOIN department d
  ON e.department_id = d.department_id;
```

`JOIN`은 서로 다른 테이블의 관계를 이용해 하나의 결과로 묶는 방식이다.

대표적으로 `INNER JOIN`, `LEFT JOIN`을 구분해서 사용했다.

## 서브쿼리

다른 조회 결과를 조건으로 사용해야 할 때 서브쿼리를 활용할 수 있다.

```sql
SELECT name, salary
FROM employee
WHERE salary > (
    SELECT AVG(salary)
    FROM employee
);
```

## 배운 점

JOIN은 **테이블 사이의 관계**, 서브쿼리는 **조회 결과를 다시 조건으로 사용하는 것**이라고 구분하니 이해하기 쉬웠다.

이후 SQL 튜닝을 공부할 때도 같은 결과를 어떤 JOIN과 조건으로 만들었는지가 성능에 영향을 준다는 점으로 이어졌다.
