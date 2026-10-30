---
layout: post
title: "Oracle SQL: WHERE 조건 검색과 집합 연산자"
date: 2026-09-15 00:00:00 +0900
categories: [학습]
tags: [Oracle, SQL, WHERE, UNION]
---

<figure class="note-cover">
  <img src="https://images.unsplash.com/photo-1555949963-aa79dcee981c?auto=format&fit=crop&w=1400&q=85" alt="코드 편집기가 열린 개발 환경">
  <figcaption>WHERE 조건으로 필요한 행만 선택하고, 집합 연산자로 조회 결과를 비교한다.</figcaption>
</figure>

## 1. WHERE와 비교 연산자

`WHERE`는 조건을 만족하는 행만 조회한다.

```sql
SELECT studno, name, deptno
FROM student
WHERE grade = '1';

SELECT studno, name, grade, deptno, weight
FROM student
WHERE weight <= 70;
```

| 연산자 | 의미 |
|---|---|
| `=` | 같다 |
| `!=`, `<>` | 같지 않다 |
| `>`, `<` | 초과, 미만 |
| `>=`, `<=` | 이상, 이하 |

## 2. AND, OR, NOT

1학년이면서 몸무게가 70kg 이상인 학생은 두 조건을 모두 만족해야 한다.

```sql
SELECT studno, name, grade, weight
FROM student
WHERE grade = '1'
  AND weight >= 70;
```

반대로 아래 쿼리는 둘 중 하나만 만족해도 조회한다.

```sql
SELECT studno, name, grade, weight
FROM student
WHERE grade = '1'
   OR weight >= 70;
```

조건이 섞이면 괄호로 의도를 명확히 한다.

```sql
SELECT name, grade, deptno
FROM student
WHERE deptno = '102'
  AND (grade = 1 OR grade = 4);
```

이 쿼리는 학과번호가 102이면서 1학년 또는 4학년인 학생을 찾는다.

## 3. BETWEEN과 IN

`BETWEEN`은 양 끝값을 포함한다.

```sql
SELECT studno, name, weight
FROM student
WHERE weight BETWEEN 50 AND 70;
```

이는 `weight >= 50 AND weight <= 70`과 같은 범위다. 여러 값 중 하나와 일치하는 행은 `IN`으로 찾는다.

```sql
SELECT name, grade, deptno
FROM student
WHERE deptno IN (102, 201);
```

이는 `deptno = 102 OR deptno = 201`로 풀어 쓸 수 있다.

## 4. LIKE와 ESCAPE

| 기호 | 의미 |
|---|---|
| `%` | 문자가 0개 이상 |
| `_` | 임의의 한 글자 |

```sql
SELECT name FROM student WHERE name LIKE '김%';
SELECT name FROM student WHERE name LIKE '%훈';
SELECT name FROM student WHERE name LIKE '김_영';
```

`LIKE` 패턴에서 `%`나 `_` 자체를 찾으려면 `ESCAPE`로 이스케이프 문자를 지정한다.

```sql
SELECT name
FROM student
WHERE name LIKE '황보\_%' ESCAPE '\';
```

## 5. NULL은 = 로 비교하지 않는다

NULL은 값이 없거나 알 수 없는 상태를 나타낸다. 따라서 `comm = NULL`은 올바른 NULL 검색 조건이 아니다.

```sql
SELECT name, comm
FROM professor
WHERE comm IS NULL;

SELECT userid, name, profno
FROM student
WHERE profno IS NOT NULL;
```

NULL이 포함된 산술식은 결과도 NULL이 될 수 있다. 예를 들어 `sal + comm`에서 `comm`이 NULL이면 결과가 NULL이다. 업무 규칙상 NULL을 0으로 처리해야 한다면 `NVL(comm, 0)`처럼 명시한다.

## 6. 집합 연산자

두 SELECT 결과를 합치거나 비교한다. 각 SELECT의 컬럼 개수는 같아야 하고, 대응 컬럼의 자료형도 호환되어야 한다.

```sql
SELECT studno, name FROM stud_heavy
UNION
SELECT studno, name FROM stud_101;
```

| 연산자 | 결과 |
|---|---|
| `UNION` | 합친 뒤 중복 행 제거 |
| `UNION ALL` | 중복 행도 유지 |
| `INTERSECT` | 양쪽 결과에 공통으로 있는 행 |
| `MINUS` | 첫 번째 결과에서 두 번째 결과를 제외 |

중복이 필요하지 않다면 `UNION ALL`도 고려할 수 있다. 무조건 `UNION`을 사용하기보다 결과에서 중복을 제거해야 하는지 먼저 판단한다.

## 7. 조회 결과로 테이블 만들기: CTAS

```sql
CREATE TABLE stud_heavy AS
SELECT *
FROM student
WHERE weight >= 70
  AND grade = '1';
```

CTAS는 SELECT 결과를 바탕으로 새 테이블을 생성한다. 원본 테이블의 모든 제약조건과 인덱스를 자동으로 그대로 복제하는 용도는 아니므로, 실제 업무에 사용할 경우 필요한 제약조건과 인덱스를 별도로 확인한다.

## 시험 전에 기억할 것

- `BETWEEN`은 시작값과 끝값을 포함한다.
- `IN`은 여러 값 중 하나와 일치하는지 확인한다.
- `LIKE`에서 `%`는 0개 이상, `_`는 한 글자다.
- NULL 검색에는 `IS NULL`, `IS NOT NULL`을 사용한다.
- `UNION`은 중복 제거, `UNION ALL`은 중복 유지, `INTERSECT`는 교집합, `MINUS`는 차집합이다.
