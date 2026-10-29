---
layout: post
title: "Oracle SQL: NULL 처리, 조건식과 그룹 함수"
date: 2026-10-29 09:00:00 +0900
categories: [학습]
tags: [Oracle, SQL, NULL, CASE, GROUP BY]
---

# 이번 내용의 흐름

이번 범위는 NULL 처리 함수에서 시작해 조건 분기, 그룹 함수, 그룹별 집계로 이어진다. 개별 함수를 외우는 것보다 **어떤 데이터를 어떤 기준으로 계산하려는지** 먼저 정하면 함수 선택이 쉬워진다.

<figure class="note-cover">
  <img src="https://images.unsplash.com/photo-1555949963-aa79dcee981c?auto=format&fit=crop&w=1400&q=85" alt="SQL 코드와 NULL 처리 예제">
  <figcaption>SQL 코드와 NULL 처리 예제 — Oracle SQL 학습 노트</figcaption>
</figure>

## 1. NULL을 포함한 금액 계산

### 상황

교수 테이블의 `sal`은 급여, `comm`은 수당이라고 하자. 수당이 없는 행은 `comm`이 0이 아니라 `NULL`일 수 있다. 이 상태에서 `sal + comm`을 계산하면 결과도 `NULL`이 된다.

```sql
SELECT name,
       sal,
       comm,
       sal + comm AS total
FROM professor;
```

수당이 없는 경우를 0으로 계산하려면 `NVL`을 사용한다.

```sql
SELECT name,
       sal,
       comm,
       sal + NVL(comm, 0) AS total
FROM professor;
```

| 함수 | 역할 | 언제 쓰나 |
|---|---|---|
| `NVL(a, b)` | a가 NULL이면 b 반환 | 기본값 하나로 대체 |
| `NVL2(a, b, c)` | a가 NULL이 아니면 b, NULL이면 c | NULL 여부에 따라 계산 분기 |
| `NULLIF(a, b)` | 두 값이 같으면 NULL, 다르면 첫 번째 값 | 같은 값을 NULL로 처리 |
| `COALESCE(a, b, ...)` | NULL이 아닌 첫 번째 값 반환 | 대체 후보가 여러 개일 때 |

```sql
SELECT name,
       sal,
       comm,
       NVL2(comm, sal + comm, sal) AS total,
       COALESCE(comm, sal, 0) AS first_available
FROM professor;
```

`NVL2`는 첫 번째 인수의 NULL 여부로 두 결과 중 하나를 고른다. `COALESCE`는 왼쪽부터 확인해 NULL이 아닌 첫 값을 반환한다.

## 2. 조건에 따라 값을 나누기: DECODE와 CASE

### 상황

학과 번호에 따라 표시할 학과명을 정하거나, 학과별로 다른 보너스 비율을 계산할 수 있다.

`DECODE`는 Oracle 전용 함수로 값이 같은지 비교하는 방식이다.

```sql
SELECT name,
       DECODE(deptno,
              101, '컴퓨터공학과',
              102, '멀티미디어학과',
              201, '전자공학과',
              '기타 학과') AS department_name
FROM professor;
```

조건이 범위이거나 비교 연산자를 사용해야 한다면 `CASE`가 더 알맞다.

```sql
SELECT name,
       deptno,
       sal,
       CASE
           WHEN deptno = 101 THEN sal * 0.10
           WHEN deptno = 102 THEN sal * 0.20
           WHEN deptno = 201 THEN sal * 0.30
           ELSE 0
       END AS bonus
FROM professor;
```

| 구분 | DECODE | CASE |
|---|---|---|
| 비교 방식 | 값 일치 비교 중심 | 범위·논리 조건 포함 |
| 이식성 | Oracle 전용 | 표준 SQL 문법 |
| 적합한 상황 | 코드값을 다른 값으로 치환 | 여러 업무 조건에 따라 결과 계산 |

## 3. 그룹 함수로 요약하기

행 하나씩 계산하는 대신 여러 행을 요약할 때 그룹 함수를 사용한다.

| 함수 | 의미 | NULL 처리 |
|---|---|---|
| `COUNT(*)` | 행 수 | NULL 컬럼이 있어도 행을 셈 |
| `COUNT(comm)` | comm의 NULL이 아닌 값 개수 | NULL 제외 |
| `SUM(sal)` | 합계 | NULL 값 제외 |
| `AVG(sal)` | 평균 | NULL 값 제외 |
| `MAX(sal)` / `MIN(sal)` | 최댓값 / 최솟값 | NULL 값 제외 |
| `STDDEV(sal)` | 표준편차 | NULL 값 제외 |
| `VARIANCE(sal)` | 분산 | NULL 값 제외 |

예를 들어 101번 학과 교수 중 수당이 실제로 입력된 행의 수를 세려면 다음과 같이 작성한다.

```sql
SELECT COUNT(*) AS professor_count,
       COUNT(comm) AS professor_with_commission,
       AVG(sal) AS average_salary,
       SUM(sal) AS total_salary
FROM professor
WHERE deptno = 101;
```

## 4. GROUP BY와 HAVING

### 상황

학과마다 교수 수와 급여 합계를 비교하고, 교수 수가 4명 이상인 학과만 보고 싶다고 하자.

```sql
SELECT deptno,
       COUNT(*) AS professor_count,
       SUM(sal) AS total_salary
FROM professor
GROUP BY deptno
HAVING COUNT(*) >= 4
ORDER BY deptno;
```

- `GROUP BY`: 같은 학과번호끼리 그룹을 만든다.
- `HAVING`: 그룹 함수 계산이 끝난 그룹에 조건을 적용한다.
- `ORDER BY`: 최종 결과를 정렬한다.

| WHERE | HAVING |
|---|---|
| 그룹화 전 행을 필터링 | 그룹화 후 그룹을 필터링 |
| 예: 특정 학과의 행만 집계 | 예: 교수 수가 4명 이상인 학과만 표시 |

## 5. 소계와 총계: ROLLUP, CUBE, GROUPING SETS

일반 `GROUP BY`는 지정한 기준별 결과를 만든다. 소계나 총계가 필요하면 그룹 확장 기능을 사용한다.

```sql
SELECT deptno,
       SUM(sal) AS total_salary
FROM professor
GROUP BY ROLLUP(deptno);
```

- `ROLLUP(deptno)`: 학과별 합계와 전체 총계를 만든다.
- `CUBE(deptno, position)`: 두 기준의 가능한 조합별 집계를 만든다.
- `GROUPING SETS`: 필요한 그룹 조합만 선택해서 집계한다.
- `GROUPING(deptno)`: 해당 행의 NULL이 실제 데이터인지 ROLLUP/CUBE가 만든 총계 표시인지 구분할 때 쓴다. 일반적으로 0은 일반 그룹, 1은 집계로 생긴 NULL을 뜻한다.

```sql
SELECT deptno,
       GROUPING(deptno) AS is_total,
       SUM(sal) AS total_salary
FROM professor
GROUP BY ROLLUP(deptno);
```

## 실습할 때 확인할 것

- [ ] `sal + comm`과 `sal + NVL(comm, 0)` 결과 비교
- [ ] `COUNT(*)`와 `COUNT(comm)` 차이 확인
- [ ] `WHERE` 조건과 `HAVING` 조건을 각각 적용해 결과 비교
- [ ] `GROUP BY` 결과에 `ROLLUP`을 추가해 총계 행 확인

## 시험 포인트

- `NVL`: NULL이면 대체값
- `NVL2`: NULL 여부에 따라 결과 선택
- `NULLIF`: 두 값이 같으면 NULL
- `COALESCE`: NULL이 아닌 첫 번째 값
- `DECODE`: Oracle 전용 값 비교, `CASE`: 범용 조건 분기
- `COUNT(*)`는 행 수, `COUNT(컬럼)`은 해당 컬럼의 NULL이 아닌 값 수
- `WHERE`는 그룹화 전, `HAVING`은 그룹화 후 조건
- `ROLLUP`은 단계별 소계와 총계, `CUBE`는 가능한 그룹 조합
