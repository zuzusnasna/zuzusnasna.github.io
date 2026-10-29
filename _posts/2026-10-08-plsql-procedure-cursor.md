---
layout: post
title: "PL/SQL Procedure와 Cursor를 정리한 이유"
date: 2026-10-08 09:00:00 +0900
categories: [학습]
tags: [Oracle, PL/SQL]
---

## Procedure

Procedure는 특정 업무 로직을 하나의 실행 단위로 묶어 재사용할 때 사용한다.

```sql
CREATE OR REPLACE PROCEDURE update_salary(
    p_emp_id NUMBER,
    p_salary NUMBER
) AS
BEGIN
    UPDATE employee
    SET salary = p_salary
    WHERE employee_id = p_emp_id;
END;
/
```

## Cursor

Cursor는 여러 행을 순서대로 꺼내 처리해야 할 때 사용한다.

예를 들어 정규직, 시간제, 일급제처럼 각 직원의 조건에 따라 급여를 계산하는 업무라면 행 단위 처리가 필요할 수 있다.

```sql
FOR emp IN (SELECT employee_id, salary FROM employee) LOOP
    -- 행 단위 업무 처리
    NULL;
END LOOP;
```

## 정리

- 반복해서 호출할 업무 → Procedure
- 여러 행을 순차 처리 → Cursor

DB에서 어떤 업무를 한 번에 처리할지, 행 단위로 처리할지를 구분하는 것이 핵심이었다.
