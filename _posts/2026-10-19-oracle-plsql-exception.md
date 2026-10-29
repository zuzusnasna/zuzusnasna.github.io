---
layout: post
title: "부트캠프 : PL/SQL 예외 처리와 프로시저 설계"
date: 2026-10-19 09:00:00 +0900
categories: [학습]
tags: [Oracle, PL/SQL]
---

PL/SQL에서는 SQL을 실행하는 것뿐 아니라 조건문, 반복문, 예외 처리를 이용해 DB 안에서 업무 로직을 처리할 수 있다.

## 기본 구조

```sql
DECLARE
    v_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_count FROM employee;
    DBMS_OUTPUT.PUT_LINE(v_count);
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;
/
```

`DECLARE → BEGIN → EXCEPTION` 구조를 기준으로 생각하면 블록의 역할을 나누기 쉽다.

## 예외 처리

예외가 발생했을 때 아무 처리 없이 종료시키기보다 예상 가능한 오류를 명확하게 처리한다.

```sql
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('조회 결과가 없습니다.');
```

## 프로시저 설계

프로시저는 반복해서 실행할 DB 업무를 하나의 단위로 묶을 때 유용하다. 매개변수를 받아 데이터를 변경하거나 조회하는 업무를 재사용할 수 있다.

## 배운 점

PL/SQL은 단순 SQL보다 **데이터를 처리하는 업무 흐름 자체를 DB 안에 표현할 수 있는 언어**라는 점이 핵심이었다.
