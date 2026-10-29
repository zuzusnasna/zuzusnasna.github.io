---
layout: post
title: "Oracle SQL 기초: SELECT, DESC, DISTINCT, AS"
date: 2026-10-06 09:00:00 +0900
categories: [학습]
tags: [Oracle, SQL, SELECT]
---

이번 수업에서는 테이블의 데이터를 조회하고, 테이블 구조를 확인하고, 중복을 제거하거나 출력 컬럼에 별칭을 붙이는 기본 문법을 정리했다.

## 1. SELECT — 데이터 조회

`SELECT`는 조회할 컬럼을 지정하고, `FROM`은 데이터를 가져올 테이블을 지정한다.

```sql
SELECT studno, name, height, weight
FROM student;
```

학생 테이블에서 학번, 이름, 키, 몸무게만 조회한다. 테이블의 모든 컬럼을 확인하고 싶다면 `*`를 사용할 수 있다.

```sql
SELECT *
FROM department;
```

필요한 컬럼만 지정하면 결과를 읽기 쉽고, 어떤 데이터를 확인하려는지 쿼리에서 분명하게 드러난다. 모든 컬럼이 필요한 경우가 아니라면 조회 목적에 맞게 컬럼을 지정하는 방식이 유용하다.

## 2. DESC — 테이블 구조 확인

테이블에 어떤 컬럼이 있고 자료형이 무엇인지 모를 때 `DESC`로 구조를 확인한다.

```sql
DESC student;
DESC professor;
DESC department;
```

주로 확인하는 정보는 컬럼명, 자료형, NULL 허용 여부다. 예를 들어 수업 실습에서 `department` 테이블의 `dname` 컬럼 자료형은 `VARCHAR2`로 확인했다.

## 3. DISTINCT — 중복 제거

학생 테이블에서 학과번호를 조회하면 같은 학과에 속한 학생 수만큼 학과번호가 반복될 수 있다.

```sql
SELECT deptno
FROM student;
```

학과번호의 종류만 확인하려면 `DISTINCT`를 붙인다.

```sql
SELECT DISTINCT deptno
FROM student;
```

이 쿼리는 중복된 학과번호를 한 번씩만 출력한다. 여러 컬럼에 `DISTINCT`를 적용하면 각 컬럼의 개별 값이 아니라 **선택한 컬럼 조합 전체**가 중복인지 판단한다는 점도 기억할 필요가 있다.

## 4. AS — 컬럼 별칭 지정

컬럼 별칭은 조회 결과에서 표시할 이름을 지정한다.

```sql
SELECT profno AS 교수NO,
       name AS 이름,
       position AS 직급,
       deptno AS 부서번호
FROM professor;
```

실제 테이블의 컬럼명이 바뀌는 것은 아니다. 조회 결과에서 보이는 이름만 지정한다. 별칭을 사용하면 결과를 읽는 사람이 각 값의 의미를 이해하기 쉬워진다.

## 5. 실습 문제와 쿼리 정리

### 테이블 구조 확인

```sql
DESC department;
```

### 교수의 이름, 직급, 급여, 학과번호 조회

```sql
SELECT name,
       position,
       sal,
       deptno
FROM professor;
```

### 학생의 학번, 이름, 사용자 ID 조회

```sql
SELECT studno,
       name,
       userid
FROM student;
```

### 교수 직급을 중복 없이 조회

```sql
SELECT DISTINCT position
FROM professor;
```

수업 실습에서 확인한 직급 예시는 교수, 부교수, 조교수, 전임강사였다. 실제 결과는 테이블에 저장된 데이터에 따라 달라질 수 있다.

### 컬럼에 별칭 붙이기

```sql
SELECT profno AS 교수NO,
       name AS 이름,
       position AS 직급,
       deptno AS 부서번호
FROM professor;
```

### 불필요한 서브쿼리 줄이기

다음 쿼리는 같은 테이블에서 사번을 다시 조회하는 서브쿼리를 사용한다.

```sql
SELECT profno, name, position, deptno
FROM professor
WHERE profno IN (
    SELECT profno
    FROM professor
    WHERE profno >= 9907
);
```

이 경우에는 서브쿼리 없이 조건을 직접 작성하면 된다.

```sql
SELECT profno AS 교수NO,
       name AS 이름,
       position AS 직급,
       deptno AS 부서번호
FROM professor
WHERE profno >= 9907;
```

결과를 결정하는 조건이 같은 테이블의 사번 컬럼에 직접 적용되므로, 단순한 조건을 불필요하게 한 번 더 조회할 이유가 없다.

## 시험 전에 구분하기

| 문법 | 역할 |
|---|---|
| `SELECT` | 조회할 컬럼 지정 |
| `FROM` | 조회할 테이블 지정 |
| `*` | 모든 컬럼 조회 |
| `DESC` | 테이블 구조 확인 |
| `DISTINCT` | 중복 결과 제거 |
| `AS` | 조회 결과의 컬럼 별칭 지정 |
| `WHERE` | 조건에 맞는 행 조회 |

## 오늘 정리한 내용

- [x] SELECT
- [x] FROM
- [x] DESC
- [x] DISTINCT
- [x] AS
- [ ] WHERE
- [ ] ORDER BY
- [ ] GROUP BY
- [ ] JOIN

이번 노트의 범위는 기본 조회와 결과 표시 방식이다. WHERE, ORDER BY, GROUP BY, JOIN은 다음 수업 노트에서 각각 조건 검색, 정렬, 그룹화, 테이블 결합으로 나누어 정리한다.
