---
layout: post
title: "PL/SQL 기본 구조와 Procedure, Cursor"
date: 2026-09-13 00:00:00 +0900
categories: [학습]
tags: [Oracle, PL/SQL, Procedure, Cursor]
---

Oracle SQL은 조회·삽입·수정·삭제 같은 데이터 작업을 수행한다. PL/SQL은 여기에 변수, 조건문, 반복문, 예외 처리를 더해 여러 SQL과 업무 규칙을 하나의 블록으로 작성할 수 있게 한다.

## 1. PL/SQL 블록 구조

기본 구조는 선언부, 실행부, 예외 처리부로 나뉜다. 선언부와 예외 처리부는 필요한 경우에만 작성한다.

```sql
BEGIN
    DBMS_OUTPUT.PUT_LINE('HELLO WORLD');
END;
/
```

- `BEGIN ~ END`: 실제 실행할 문장을 작성한다.
- `DBMS_OUTPUT.PUT_LINE`: 실행 결과를 출력한다. SQL Developer에서는 DBMS 출력 창을 활성화해야 결과를 확인할 수 있다.
- 마지막 `/`: SQL Developer나 SQL*Plus에서 PL/SQL 블록을 실행할 때 사용하는 실행 구분자다.

변수가 필요하면 `DECLARE`에 선언한다.

```sql
DECLARE
    v_no   NUMBER(4);
    v_name VARCHAR2(20);
BEGIN
    v_no := 100;
    v_name := 'kglim';

    DBMS_OUTPUT.PUT_LINE(v_no);
    DBMS_OUTPUT.PUT_LINE(v_name || '입니다');
END;
/
```

`:=`는 PL/SQL에서 값을 대입하는 연산자다. `||`는 문자열을 연결한다.

## 2. 테이블의 자료형을 변수에 연결하기

컬럼 자료형을 직접 적는 대신 `%TYPE`을 사용하면 해당 컬럼의 자료형을 따라간다. 한 행의 여러 컬럼을 함께 다루려면 `%ROWTYPE`을 사용할 수 있다.

```sql
DECLARE
    v_empno emp.empno%TYPE;
    v_emp   emp%ROWTYPE;
BEGIN
    SELECT empno
      INTO v_empno
      FROM emp
     WHERE empno = 7788;

    SELECT *
      INTO v_emp
      FROM emp
     WHERE empno = 7788;

    DBMS_OUTPUT.PUT_LINE(v_empno || '-' || v_emp.ename || '-' || v_emp.sal);
END;
/
```

- `%TYPE`: 특정 컬럼의 자료형을 가져온다.
- `%ROWTYPE`: 테이블 또는 커서가 반환하는 행의 구조를 가져온다.
- `SELECT ... INTO`: 조회 결과를 PL/SQL 변수에 담는다. 이 방식은 결과가 정확히 한 행이어야 한다. 행이 없으면 `NO_DATA_FOUND`, 여러 행이면 `TOO_MANY_ROWS` 예외가 발생한다.

## 3. 조건문과 반복문

조건에 따라 처리할 내용이 다르면 `IF / ELSIF / ELSE`를 사용한다.

```sql
DECLARE
    v_sal emp.sal%TYPE;
BEGIN
    SELECT sal
      INTO v_sal
      FROM emp
     WHERE empno = 7788;

    IF v_sal >= 2000 THEN
        DBMS_OUTPUT.PUT_LINE('당신의 급여는 BIG ' || v_sal);
    ELSE
        DBMS_OUTPUT.PUT_LINE('당신의 급여는 SMALL ' || v_sal);
    END IF;
END;
/
```

반복문은 반복 조건에 따라 선택한다.

```sql
DECLARE
    v_total NUMBER := 0;
BEGIN
    FOR i IN 1..100 LOOP
        v_total := v_total + i;
    END LOOP;

    DBMS_OUTPUT.PUT_LINE('1~100 총합 : ' || v_total);
END;
/
```

위 코드는 1부터 100까지 누적해서 더하므로 결과는 `5050`이다. 반복문 안의 `v_total := v_total + i`가 매 반복마다 합계를 갱신한다.

## 4. Procedure는 작업을 저장해 재사용한다

프로시저는 여러 SQL과 처리 절차를 데이터베이스 객체로 저장하고, 필요할 때 호출할 수 있게 한다.

```sql
CREATE OR REPLACE PROCEDURE usp_update_emp (
    p_empno IN emp.empno%TYPE
)
IS
BEGIN
    UPDATE emp
       SET sal = 0
     WHERE empno = p_empno;
END;
/
```

호출은 다음과 같이 한다.

```sql
EXEC usp_update_emp(7788);
```

여기서 `IN` 매개변수는 호출할 때 입력받는 값이다. 실제 업무에 적용할 때는 변경 대상과 트랜잭션 처리 방식을 확인해야 한다. 예제 실행 후 데이터를 확정하지 않으려면 테스트 환경에서 `ROLLBACK` 여부를 확인한다.

프로시저는 `OUT` 매개변수로 결과를 돌려줄 수도 있다. 수업 예제에서는 사번을 입력받고 이름과 급여를 반환하는 형태를 사용했다.

## 5. Cursor는 여러 행을 한 행씩 처리한다

SQL의 집합 연산은 여러 행을 한 번에 처리한다. 반면 각 행의 값에 따라 서로 다른 계산을 해야 한다면 커서로 조회 결과를 순회할 수 있다.

명시적 커서의 기본 흐름은 다음과 같다.

1. `CURSOR ... IS SELECT ...`로 조회문을 정의한다.
2. `OPEN`으로 조회를 시작한다.
3. `FETCH`로 행을 변수에 가져온다.
4. `%NOTFOUND`로 더 가져올 행이 없는지 확인한다.
5. `CLOSE`로 커서를 닫는다.

```sql
DECLARE
    CURSOR c_emp IS
        SELECT empno, ename, sal
          FROM emp
         WHERE deptno = 30;

    v_empno emp.empno%TYPE;
    v_ename emp.ename%TYPE;
    v_sal   emp.sal%TYPE;
BEGIN
    OPEN c_emp;

    LOOP
        FETCH c_emp INTO v_empno, v_ename, v_sal;
        EXIT WHEN c_emp%NOTFOUND;

        DBMS_OUTPUT.PUT_LINE(v_empno || '-' || v_ename || '-' || v_sal);
    END LOOP;

    CLOSE c_emp;
END;
/
```

수업 노트의 `deptno = 30` 예제는 해당 부서에 속한 사원들을 한 행씩 출력한다. `FETCH` 뒤에 종료 조건을 확인해야 마지막 행 이후에 잘못된 변수 값을 처리하지 않는다.

같은 작업은 커서 FOR LOOP로 간단히 표현할 수도 있다.

```sql
BEGIN
    FOR emp_record IN (
        SELECT empno, ename
          FROM emp
         WHERE deptno = 30
    ) LOOP
        DBMS_OUTPUT.PUT_LINE(emp_record.empno || '-' || emp_record.ename);
    END LOOP;
END;
/
```

FOR LOOP 방식은 커서 열기, 행 가져오기, 닫기 작업을 직접 작성하지 않아도 되어 코드가 짧다.

## 6. 예외 처리

`SELECT ... INTO`는 결과가 한 행이라는 전제가 있다. 조회 결과가 없거나 여러 행이면 예외를 처리할 수 있다.

```sql
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('조회 결과가 없습니다.');
    WHEN TOO_MANY_ROWS THEN
        DBMS_OUTPUT.PUT_LINE('조회 결과가 여러 행입니다.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('기타 오류가 발생했습니다.');
```

`WHEN OTHERS`는 나머지 예외를 처리하는 구문이다. 실제 프로그램에서는 오류를 무조건 숨기기보다 오류 코드와 메시지를 남겨 원인을 확인할 수 있게 해야 한다.

## 정리

| 기능 | 사용하는 이유 |
|---|---|
| 변수, `%TYPE`, `%ROWTYPE` | 값을 저장하고 테이블 자료형과 연결 |
| `IF`, 반복문 | 조건에 따른 분기와 반복 처리 |
| Procedure | 자주 쓰는 작업 절차를 저장하고 호출 |
| Cursor | 여러 행을 순회하며 행별 처리 |
| Exception | 조회 실패나 실행 오류를 처리 |

커서가 항상 정답은 아니다. `UPDATE`, `GROUP BY` 같은 SQL로 한 번에 처리할 수 있는 작업이라면 집합 연산을 먼저 검토하고, 행마다 다른 업무 규칙을 적용해야 할 때 커서를 고려한다.
