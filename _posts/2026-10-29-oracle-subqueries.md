---
layout: post
title: "Oracle SQL: 서브쿼리와 다중행 조건"
date: 2026-10-29 11:00:00 +0900
categories: [학습]
tags: [Oracle, SQL, Subquery, Database]
---

# 서브쿼리는 언제 필요한가?

예를 들어 101번 학과 학생들의 평균 몸무게보다 가벼운 학생을 찾고 싶다고 하자. 평균값을 먼저 알아내서 직접 SQL에 입력할 수도 있지만, 데이터가 바뀌면 평균도 달라진다. 평균을 구하는 SELECT를 조건 안에 넣으면 매번 최신 데이터 기준으로 비교할 수 있다.

<figure class="note-cover">
  <img src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/oracle/oracle-original.svg" alt="Oracle 데이터베이스 로고" style="width:96px;height:96px;object-fit:contain;margin:0 auto">
  <figcaption>Oracle SQL 실습 — 조회 결과를 다른 조회의 조건으로 사용하기</figcaption>
</figure>

## 1. 단일행 서브쿼리

서브쿼리가 하나의 값만 반환하면 `=`, `>`, `<`, `>=`, `<=`, `<>` 같은 단일 값 비교 연산자를 사용할 수 있다.

```sql
SELECT name, position
FROM professor
WHERE position = (
    SELECT position
    FROM professor
    WHERE name = '전은지'
);
```

안쪽 SELECT가 전은지 교수의 직급을 반환하고, 바깥쪽 SELECT가 그 직급에 해당하는 교수를 조회한다. 안쪽 쿼리가 두 행 이상 반환하면 단일행 서브쿼리 오류가 발생할 수 있으므로, 비교 기준이 유일한지 확인한다.

## 2. 여러 행을 반환하는 서브쿼리

서브쿼리가 여러 값을 반환할 수 있다면 `IN`, `ANY`, `ALL` 등을 사용한다.

### IN — 목록 중 하나와 일치

```sql
SELECT name, grade, deptno
FROM student
WHERE deptno IN (
    SELECT deptno
    FROM department
    WHERE college = 100
);
```

서브쿼리가 반환한 학과번호 중 하나에 속하는 학생을 조회한다.

### ANY — 하나 이상의 비교를 만족

```sql
SELECT studno, name, height
FROM student
WHERE height > ANY (
    SELECT height
    FROM student
    WHERE grade = '4'
);
```

위 조건은 4학년 학생들의 키 중 **적어도 하나보다 큰 경우**를 찾는다. 값이 여러 개라면 `> ANY`는 사실상 그 집합의 최솟값보다 큰지를 기준으로 이해할 수 있다.

### ALL — 모든 비교를 만족

```sql
SELECT studno, name, height
FROM student
WHERE height > ALL (
    SELECT height
    FROM student
    WHERE grade = '4'
);
```

4학년 학생들의 키를 모두 초과해야 하므로, 일반적인 숫자 데이터에서는 그 집합의 최댓값보다 커야 한다.

| 연산자 | 뜻 | 예시 해석 |
|---|---|---|
| `IN` | 값 목록 중 일치하는 값이 있음 | 해당 학과 중 하나 |
| `> ANY` | 하나 이상의 값보다 큼 | 최솟값보다 큼 |
| `> ALL` | 모든 값보다 큼 | 최댓값보다 큼 |
| `EXISTS` | 서브쿼리 결과가 한 행 이상 존재 | 조건을 만족하는 데이터가 있음 |
| `NOT EXISTS` | 서브쿼리 결과가 없음 | 조건을 만족하는 데이터가 없음 |

## 3. EXISTS와 NOT EXISTS

`EXISTS`는 서브쿼리에서 조건에 맞는 행이 있는지 확인한다. 특정 데이터가 존재하는지 여부가 목적일 때 사용한다.

```sql
SELECT p.profno, p.name
FROM professor p
WHERE EXISTS (
    SELECT 1
    FROM student s
    WHERE s.profno = p.profno
);
```

교수별로 연결된 학생이 한 명 이상 있는 교수만 조회한다. 이 예제는 바깥쪽 교수 행을 안쪽 쿼리에서 참조하므로 상관 서브쿼리이기도 하다.

반대로 연결된 학생이 한 명도 없는 교수는 `NOT EXISTS`로 찾을 수 있다.

```sql
SELECT p.profno, p.name
FROM professor p
WHERE NOT EXISTS (
    SELECT 1
    FROM student s
    WHERE s.profno = p.profno
);
```

## 4. 상관 서브쿼리

상관 서브쿼리는 안쪽 SELECT가 바깥쪽 행의 값을 참조한다. 아래 쿼리는 각 학생이 속한 학과의 평균 키를 계산하고, 그 평균보다 키가 큰 학생을 찾는다.

```sql
SELECT s1.name,
       s1.deptno,
       s1.height
FROM student s1
WHERE s1.height > (
    SELECT AVG(s2.height)
    FROM student s2
    WHERE s2.deptno = s1.deptno
);
```

`s1.deptno`가 바깥쪽 쿼리의 값이다. 이 조건이 있기 때문에 학생마다 자신의 학과 평균과 비교하게 된다.

상관 서브쿼리가 무조건 느린 것은 아니다. 실제 성능은 데이터 양, 인덱스, 옵티마이저 계획 등에 따라 달라지므로 대량 데이터에서는 실행 계획과 측정 결과로 판단한다.

## 5. 다중 컬럼 서브쿼리

두 컬럼의 조합을 함께 비교할 수도 있다.

```sql
SELECT empno, ename, deptno, sal
FROM emp
WHERE (deptno, sal) IN (
    SELECT deptno, sal
    FROM emp
    WHERE comm IS NOT NULL
);
```

이 쿼리는 수당이 있는 사원들의 `(deptno, sal)` 조합과 같은 조합을 가진 사원을 찾는다.

## 6. 서브쿼리를 작성할 때 확인할 것

- [ ] 안쪽 SELECT가 한 행을 반환하는가, 여러 행을 반환하는가?
- [ ] 단일 값 비교가 맞는가, `IN / ANY / ALL`이 필요한가?
- [ ] `EXISTS`를 쓰는 경우 바깥쪽 행과 연결되는 조건이 있는가?
- [ ] NULL이 포함될 수 있는 비교인지 확인했는가?
- [ ] 실행 계획과 실제 데이터 양을 고려했는가?

## 시험 포인트

- `IN`: 여러 결과 중 하나와 일치
- `ANY`: 적어도 하나의 비교를 만족
- `ALL`: 모든 비교를 만족
- `EXISTS`: 결과 존재 여부 확인
- `NOT EXISTS`: 결과가 없을 때 참
- 상관 서브쿼리: 안쪽 쿼리가 바깥쪽 행의 값을 사용
