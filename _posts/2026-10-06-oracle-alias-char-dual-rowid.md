---
layout: post
title: "Oracle SQL: Alias, 문자 타입, DUAL, SYSDATE, ROWID"
date: 2026-09-20 00:00:00 +0900
categories: [학습]
tags: [Oracle, SQL, Alias, DUAL, ROWID]
---

<figure class="note-cover">
  <img src="https://images.unsplash.com/photo-1518770660439-4636190af475?auto=format&fit=crop&w=1400&q=85" alt="회로 기판의 세부 모습">
  <figcaption>조회 결과의 이름, 자료형, 행 식별 방식을 함께 이해하기 위한 노트.</figcaption>
</figure>

## 1. 컬럼 별칭(Alias)

별칭은 조회 결과에 표시할 이름이다. 실제 테이블의 컬럼명이나 저장된 데이터가 바뀌는 것은 아니다.

```sql
SELECT dname dpt_name,
       deptno AS dn
FROM department;
```

`AS`는 생략할 수 있고 한글 별칭도 가능하다.

```sql
SELECT name 교수명,
       deptno 학과번호,
       sal 급여
FROM professor;
```

공백이나 특수문자가 들어간 별칭은 큰따옴표로 감싼다.

```sql
SELECT dname "Department Name",
       deptno "부서 번호#"
FROM department;
```

**실제 사용 상황:** 조회 결과를 관리 화면이나 CSV로 제공할 때 `deptno` 대신 `학과번호`라고 표시하면 사용자가 의미를 쉽게 이해할 수 있다. 별칭은 출력 이름만 바꾸며 테이블 구조를 변경하지 않는다.

## 2. 연결 연산자 `||`

컬럼과 문자열을 한 컬럼으로 이어 붙인다.

```sql
SELECT studno || ' ' || name AS student
FROM student;

SELECT name || '의 직책은 ' || position AS professor_info
FROM professor;
```

예를 들어 학번이 `9411`, 이름이 `홍길동`이면 첫 번째 쿼리는 `9411 홍길동`처럼 출력한다. 여러 문자열을 연결할 때는 `CONCAT`보다 `||`가 간결하게 읽히는 경우가 많다.

## 3. 산술 연산과 별칭

```sql
SELECT name,
       weight,
       weight * 2.2 AS weight_pound
FROM student;
```

급여를 12% 인상한 금액과 인상분을 함께 조회할 수 있다.

```sql
SELECT empno AS 사원번호,
       ename AS 이름,
       sal AS 급여,
       sal * 1.12 AS "New Salary",
       sal * 1.12 - sal AS Increase
FROM emp;
```

같은 SELECT 목록의 다른 계산식에서 방금 만든 별칭을 다시 계산식처럼 사용할 수는 없다. 계산식을 다시 작성하거나 서브쿼리/인라인 뷰로 한 단계 감싼다.

## 4. CHAR와 VARCHAR2

| 자료형 | 특징 | 예시 |
|---|---|---|
| `CHAR(10)` | 고정 길이. 남는 공간을 공백으로 채움 | `'sql       '` |
| `VARCHAR2(10)` | 가변 길이. 입력한 문자열 길이에 맞춰 저장 | `'sql'` |

```sql
CREATE TABLE ex_type (
    c CHAR(10),
    v VARCHAR2(10)
);

INSERT INTO ex_type VALUES ('sql', 'sql');

SELECT * FROM ex_type WHERE c = 'sql';
SELECT * FROM ex_type WHERE v = 'sql';
```

두 조건 모두 해당 행을 찾는다. Oracle의 문자 비교는 자료형과 비교 방식에 따라 공백 처리 규칙이 달라질 수 있으므로, `CHAR`와 `VARCHAR2`를 섞어 비교할 때는 후행 공백의 영향을 직접 확인하는 것이 좋다.

## 5. DUAL과 SYSDATE

`DUAL`은 계산식이나 함수 결과처럼 업무 테이블의 컬럼이 필요하지 않을 때 사용하는 Oracle의 한 행짜리 테이블이다.

```sql
SELECT 23 * 25 AS result FROM dual;
SELECT dummy FROM dual;
```

두 번째 쿼리는 일반적으로 `X`를 반환한다. `SYSDATE`는 데이터베이스 서버의 현재 날짜와 시간을 반환한다.

```sql
SELECT SYSDATE - 1 AS yesterday,
       SYSDATE AS today,
       SYSDATE + 1 AS tomorrow
FROM dual;

SELECT ADD_MONTHS(SYSDATE, 12) AS one_year_later
FROM dual;
```

DATE 값에 정수 1을 더하거나 빼면 하루를 더하거나 뺀다. 개월 단위 계산에는 `ADD_MONTHS`를 사용한다. 날짜별 보고서나 만료일 계산에 응용할 수 있으며, 실제 서비스에서는 서버 시각과 시간대 기준도 확인해야 한다.

## 6. ROWID와 ROWNUM

`ROWID`는 Oracle이 행의 저장 위치를 식별하는 데 사용하는 의사 컬럼이다.

```sql
SELECT ROWID, studno, name
FROM student;
```

| 구분 | ROWID | ROWNUM |
|---|---|---|
| 의미 | 행의 저장 위치 식별 정보 | 결과에 붙는 조회 순번 |
| 용도 | 행 위치 확인·진단 | 조회 건수 제한 등 |
| 고정성 | 테이블 이동 등으로 바뀔 수 있음 | 실행 방식과 정렬 순서에 따라 달라질 수 있음 |

ROWID를 업무 데이터의 영구적인 기본 키로 사용하지 말고, 업무적으로 행을 식별할 때는 기본 키를 사용한다.

## 시험 전에 기억할 것

- `AS`는 생략할 수 있고, 공백이 있는 별칭은 큰따옴표로 감싼다.
- `||`는 문자열을 연결한다.
- `CHAR`는 고정 길이, `VARCHAR2`는 가변 길이 문자열이다.
- `DUAL`은 함수나 계산식 결과를 조회할 때 사용할 수 있다.
- `SYSDATE + 1`은 하루 뒤, `ADD_MONTHS(SYSDATE, 12)`는 12개월 뒤다.
- `ROWID`는 저장 위치 식별 정보이고 `ROWNUM`은 조회 순번이다.
