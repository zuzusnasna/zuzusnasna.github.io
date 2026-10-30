---
layout: post
title: "Cursor로 직종별 급여 계산하기"
date: 2026-07-16 00:00:00 +0900
categories: [학습]
tags: [Oracle, PL/SQL, Cursor]
---

커서를 배우면서 연습한 예제는 직종에 따라 급여 계산 방식이 달라지는 상황이다. 모든 직원에게 같은 계산식을 적용할 수 없기 때문에 각 행의 직종을 확인하고 급여를 계산하도록 구성했다.

## 1. 처리 규칙 정하기

| 직종 | 계산 방식 |
|---|---|
| 정규직 | 월급 |
| 시간직 | 근무시간 × 시간급 |
| 일용직 | 시간급 + 식대 |

수업 예제에서는 다음과 같은 데이터를 사용했다.

```sql
CREATE TABLE salary_info (
    empno    NUMBER,
    ename    VARCHAR2(20),
    job_type VARCHAR2(20),
    monthly  NUMBER,
    hours    NUMBER,
    hourly   NUMBER,
    meal     NUMBER
);

INSERT INTO salary_info VALUES (10, '홍길동', '정규직', 120, NULL, NULL, NULL);
INSERT INTO salary_info VALUES (11, '김유신', '시간직', NULL, 10, 100, NULL);
INSERT INTO salary_info VALUES (12, '이순신', '일용직', NULL, NULL, 120, 10);
COMMIT;
```

예제 데이터에 규칙을 적용하면 정규직은 120, 시간직은 10 × 100 = 1000, 일용직은 120 + 10 = 130으로 계산된다. 이 숫자는 수업 예제에 입력한 값 기준이다.

## 2. Cursor와 IF로 행마다 계산하기

```sql
DECLARE
    CURSOR sal_cursor IS
        SELECT empno, ename, job_type, monthly, hours, hourly, meal
          FROM salary_info;

    v_pay NUMBER;
BEGIN
    FOR emp IN sal_cursor LOOP
        IF emp.job_type = '정규직' THEN
            v_pay := NVL(emp.monthly, 0);
        ELSIF emp.job_type = '시간직' THEN
            v_pay := NVL(emp.hours, 0) * NVL(emp.hourly, 0);
        ELSIF emp.job_type = '일용직' THEN
            v_pay := NVL(emp.hourly, 0) + NVL(emp.meal, 0);
        ELSE
            v_pay := 0;
        END IF;

        DBMS_OUTPUT.PUT_LINE(
            '사번: ' || emp.empno ||
            ', 직종: ' || emp.job_type ||
            ', 급여: ' || v_pay
        );
    END LOOP;
END;
/
```

코드에서 중요한 부분은 세 가지다.

- `FOR emp IN sal_cursor`: 조회 결과를 한 행씩 `emp` 레코드에 담아 반복한다.
- `IF / ELSIF`: 현재 행의 `job_type`에 따라 계산식을 바꾼다.
- `NVL(값, 0)`: 값이 `NULL`이면 0으로 바꿔 계산한다. 예를 들어 정규직 행에는 `hours`와 `hourly`가 비어 있으므로 직종에 맞는 컬럼만 사용한다.

## 3. 계산 결과를 테이블에 저장하기

화면 출력 대신 급여 결과를 테이블에 남기려면 결과 테이블을 만들고, 반복문 안에서 계산한 값을 INSERT하면 된다.

```sql
CREATE TABLE salary_result (
    empno     NUMBER,
    ename     VARCHAR2(50),
    job_type  VARCHAR2(20),
    pay       NUMBER,
    paid_date DATE DEFAULT SYSDATE
);
```

수업 예제에서는 이 계산 절차를 `proc_calculate_salary` 프로시저로 저장하고, 반복문 안에서 계산한 값을 `salary_result`에 INSERT한 뒤 COMMIT하도록 구성했다. 프로시저를 만들면 같은 코드를 매번 다시 작성하지 않고 호출할 수 있다.

```sql
BEGIN
    proc_calculate_salary;
END;
/

SELECT * FROM salary_result;
```

실제 운영 코드로 옮길 때는 실행할 때마다 같은 급여 행이 중복 저장되지 않도록 해야 한다. 예를 들어 지급 월을 식별하는 컬럼과 중복 방지 규칙을 둘지, 재실행 시 기존 결과를 어떻게 처리할지는 업무 요구사항에 따라 정해야 한다. 이 부분은 수업 예제에서 완성된 기능이 아니라 실제 적용 전에 검토할 사항이다.

## 4. 커서를 꼭 써야 할까?

이 예제에서 커서를 사용한 이유는 각 행의 `job_type`에 따라 서로 다른 계산 규칙을 적용하는 흐름을 연습하기 위해서다. 하지만 실제 데이터 처리에서는 먼저 SQL의 CASE 표현식이나 집합 기반 INSERT로 한 번에 계산할 수 있는지 검토하는 것이 좋다.

- 행별 분기와 절차가 필요한 경우: Cursor를 검토한다.
- 동일한 규칙으로 대량 계산·갱신할 수 있는 경우: 집합 기반 SQL을 우선 검토한다.

## 정리

이 실습은 단순히 커서 문법을 작성하는 데서 끝나지 않는다. 처리 대상 조회 → 한 행씩 읽기 → 직종별 계산 → 출력 또는 결과 테이블 저장 순서로 업무를 구성했다. 결과를 저장하는 프로시저로 확장할 경우에는 중복 실행과 트랜잭션 처리까지 함께 생각해야 한다.
