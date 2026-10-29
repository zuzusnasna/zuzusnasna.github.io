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
