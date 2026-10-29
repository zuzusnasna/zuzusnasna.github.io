---
layout: post
title: "Oracle SQL: 조인 종류와 테이블 연결"
date: 2026-10-29 10:00:00 +0900
categories: [학습]
tags: [Oracle, SQL, JOIN, Database]
---

# 조인을 왜 사용할까?

학생 테이블에는 학번과 학과번호가 있고, 학과 테이블에는 학과번호와 학과명이 있다고 하자. 학생 이름만 조회하는 것으로는 소속 학과의 이름을 알 수 없다. 두 테이블의 공통 키인 `deptno`를 이용해 필요한 정보를 한 결과로 묶는 작업이 **JOIN**이다.

<figure class="note-cover">
  <img src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/oracle/oracle-original.svg" alt="Oracle 데이터베이스 로고" style="width:96px;height:96px;object-fit:contain;margin:0 auto">
  <figcaption>Oracle SQL 실습 — 테이블 간 관계를 조회로 연결하기</figcaption>
</figure>

## 1. 조인 조건이 없으면: CROSS JOIN

두 테이블의 모든 행을 서로 조합한다. A 테이블에 10행, B 테이블에 5행이 있다면 결과는 50행이다.

```sql
SELECT s.name,
       d.dname
FROM student s
CROSS JOIN department d;
```

콤마로 테이블만 나열하고 연결 조건을 작성하지 않아도 Cartesian Product가 발생할 수 있다.

```sql
SELECT s.name, d.dname
FROM student s, department d;
```

의도적으로 모든 조합을 만들려는 상황이 아니라면 조인 조건이 빠지지 않았는지 확인한다.

## 2. INNER JOIN: 일치하는 행만 조회

학생의 학과번호와 학과 테이블의 학과번호가 일치하는 데이터만 조회한다.

```sql
SELECT s.studno,
       s.name,
       d.dname,
       d.loc
FROM student s
INNER JOIN department d
    ON s.deptno = d.deptno;
```

같은 조건은 Oracle의 전통적인 문법으로도 작성할 수 있다.

```sql
SELECT s.studno, s.name, d.dname
FROM student s, department d
WHERE s.deptno = d.deptno;
```

ANSI JOIN은 테이블을 연결하는 조건을 `ON`에 분리해서 적기 때문에 조인 조건과 일반 필터 조건을 읽기 쉽다.

## 3. NATURAL JOIN과 JOIN USING

두 테이블에서 같은 이름을 가진 컬럼을 조인 기준으로 사용할 때 간단히 작성할 수 있다.

```sql
SELECT studno, name, deptno, dname
FROM student
NATURAL JOIN department;
```

`NATURAL JOIN`은 이름이 같은 모든 컬럼을 자동으로 조인 조건으로 사용한다. 테이블에 같은 이름의 컬럼이 추가되면 의도하지 않은 기준이 될 수 있어, 실무에서는 조건을 명확히 지정하는 편이 안전하다.

```sql
SELECT s.studno, s.name, deptno, d.dname
FROM student s
JOIN department d USING (deptno);
```

| 구분 | NATURAL JOIN | JOIN USING |
|---|---|---|
| 조인 컬럼 | 같은 이름을 자동 선택 | 괄호 안에 직접 지정 |
| ON 사용 | 함께 사용할 수 없음 | 함께 사용할 수 없음 |
| 공통 컬럼 출력 | 한 번 출력 | 한 번 출력 |

## 4. OUTER JOIN: 한쪽 테이블의 행을 보존하기

### 상황

학생 중에는 지도교수가 배정되지 않은 학생이 있을 수 있다. 일반 INNER JOIN만 사용하면 교수 정보가 연결되지 않는 학생이 결과에서 빠진다. 학생은 모두 보여주고, 교수가 없는 경우에는 교수 이름을 NULL로 표시하려면 LEFT OUTER JOIN을 사용한다.

```sql
SELECT s.name AS student_name,
       p.name AS professor_name
FROM student s
LEFT OUTER JOIN professor p
    ON s.profno = p.profno;
```

- `LEFT OUTER JOIN`: 왼쪽(student)의 모든 행을 보존한다.
- `RIGHT OUTER JOIN`: 오른쪽(professor)의 모든 행을 보존한다.
- `FULL OUTER JOIN`: 양쪽의 모든 행을 보존한다. 반대쪽과 연결되지 않는 컬럼은 NULL이 된다.

Oracle의 전통적인 외부 조인 표기에서는 NULL을 허용할 쪽에 `(+)`를 붙인다.

```sql
-- 학생은 모두 유지
WHERE s.profno = p.profno(+)

-- 교수는 모두 유지
WHERE s.profno(+) = p.profno
```

처음 배우거나 새 SQL을 작성할 때는 의미가 분명한 ANSI JOIN 문법을 우선 사용하면 조인 방향을 읽기 쉽다.

## 5. SELF JOIN: 같은 테이블을 두 역할로 사용

사원 테이블에 사원번호 `empno`와 관리자 사원번호 `mgr`가 함께 저장되어 있다고 하자. 관리자도 같은 사원 테이블에 존재하므로 테이블을 두 번 참조한다.

```sql
SELECT e.ename AS employee_name,
       m.ename AS manager_name
FROM emp e
LEFT JOIN emp m
    ON e.mgr = m.empno;
```

`e`는 사원 역할, `m`은 관리자 역할이다. 별칭을 두 개 사용해야 각 컬럼이 어느 역할의 데이터인지 구분할 수 있다.

## 6. 조인 결과를 점검하는 순서

1. 어떤 테이블이 기준인지 정한다.
2. 두 테이블을 연결하는 키가 무엇인지 확인한다.
3. 연결 데이터가 없는 행도 보여줘야 하는지 판단한다.
4. 예상보다 행이 많으면 조인 조건 누락 또는 일대다 관계를 확인한다.
5. 조회 컬럼이 어느 테이블에 속하는지 별칭으로 명확히 적는다.

## 시험 포인트

- `CROSS JOIN`: 모든 행 조합
- `INNER JOIN`: 조건이 일치하는 행
- `LEFT / RIGHT / FULL OUTER JOIN`: 왼쪽 / 오른쪽 / 양쪽 행 보존
- `NATURAL JOIN`: 같은 이름 컬럼 자동 연결
- `USING`: 공통 컬럼을 직접 지정
- `SELF JOIN`: 같은 테이블을 서로 다른 별칭으로 두 번 참조
- `A.col = B.col(+)`는 B쪽을 NULL 허용으로 처리하는 Oracle 구문이다.
