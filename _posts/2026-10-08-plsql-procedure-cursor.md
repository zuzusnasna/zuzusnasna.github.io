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

## 더 깊게 이해하기: 프로시저와 커서는 어디에 적합한가

프로시저는 데이터베이스 안에서 반복적으로 수행되는 업무 규칙이나 데이터 처리 절차를 묶어 재사용할 수 있게 한다. 커서는 SQL 결과 집합을 행 단위로 순회할 때 사용할 수 있지만, 단순 집계나 일괄 변경을 행마다 처리하면 불필요한 반복 비용이 생길 수 있다. 가능한 경우 집합 기반 SQL로 해결하고, 행별 계산이나 복잡한 단계가 필요한 경우 커서를 고려한다.

커서를 사용한다면 열기, 행 가져오기, 종료 조건, 닫기의 흐름을 명확히 해야 한다. 예외가 발생했을 때도 커서와 트랜잭션의 상태를 고려해야 한다. 업무 처리 도중 일부 행만 성공한 상태를 허용할지, 전체를 하나의 단위로 롤백할지도 요구사항이다.

### 설계 전 질문
- 이 작업을 UPDATE와 GROUP BY 등 집합 연산으로 표현할 수 있는가?
- 한 행씩 처리해야 하는 업무 규칙이 실제로 존재하는가?
- 처리 건수와 실패 건을 어떻게 기록하고 재처리할 것인가?
- 트랜잭션 범위를 너무 크게 잡아 잠금이 오래 유지되지 않는가?

커서는 목적이 아니라 수단이다. 행 단위 처리가 필요한 이유를 먼저 설명할 수 있어야 한다.
