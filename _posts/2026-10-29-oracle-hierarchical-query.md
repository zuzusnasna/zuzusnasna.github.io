---
layout: post
title: "Oracle 계층형 질의: CONNECT BY로 조직도 조회하기"
date: 2026-08-27 00:00:00 +0900
categories: [학습]
tags: [Oracle, SQL, Hierarchical Query, CONNECT BY]
---

계층형 질의는 행 사이의 부모·자식 관계를 따라 데이터를 트리 형태로 조회하는 Oracle SQL 기능이다. 조직도, 상위 부서와 하위 부서, 관리자와 사원처럼 한 테이블 안에 관계가 표현되어 있을 때 활용할 수 있다.

## 1. START WITH와 CONNECT BY

- `START WITH`: 탐색을 시작할 루트 행을 지정한다.
- `CONNECT BY`: 부모와 자식 행을 연결하는 규칙을 지정한다.
- `PRIOR`: 부모 행의 값을 가리키는 데 사용한다.

학과 테이블에서 `deptno`는 학과 번호, `college`는 상위 대학 번호라고 가정하면 다음처럼 상위 조직에서 하위 조직으로 내려갈 수 있다.

```sql
SELECT deptno, dname, college
FROM department
START WITH deptno = 10
CONNECT BY PRIOR deptno = college;
```

`PRIOR deptno = college`는 부모 행의 `deptno`와 자식 행의 `college`를 연결한다. 따라서 부모의 번호를 상위 번호로 가지고 있는 하위 학과가 이어진다.

반대로 특정 하위 학과에서 부모 방향으로 올라가려면 시작 행과 연결 방향을 바꿔 작성한다.

```sql
SELECT deptno, dname, college
FROM department
START WITH deptno = 102
CONNECT BY PRIOR college = deptno;
```

## 2. LEVEL로 깊이 표시하기

`LEVEL`은 현재 행이 계층의 몇 번째 단계인지 나타낸다. 시작 행이 1이고 그 자식은 2, 손자는 3이 된다.

```sql
SELECT LEVEL,
       LPAD(' ', (LEVEL - 1) * 4) || dname AS organization
FROM department
START WITH dname = '공과대학'
CONNECT BY PRIOR deptno = college;
```

`LPAD`로 단계별 공백을 넣으면 결과를 조직도처럼 읽기 쉬워진다. 들여쓰기 폭은 `(LEVEL - 1) * 4` 부분으로 조정할 수 있다.

## 3. 특정 노드만 제외할지, 하위 경로도 제외할지

`WHERE` 조건은 계층 탐색 결과에서 행을 제외한다.

```sql
SELECT deptno, dname, college
FROM department
WHERE dname != '정보미디어학부'
START WITH college IS NULL
CONNECT BY PRIOR deptno = college;
```

이 경우 해당 행이 결과에서 빠져도 자식 행은 탐색 결과에 남을 수 있다. 특정 노드 아래의 경로까지 탐색하지 않으려면 조건을 `CONNECT BY`에 포함하는 방법을 검토한다.

```sql
SELECT deptno, college, dname, loc
FROM department
START WITH college IS NULL
CONNECT BY PRIOR deptno = college
       AND dname != '정보미디어학부';
```

두 조건의 차이는 결과에서 특정 행만 감출 것인지, 계층을 이어 가는 규칙 자체를 제한할 것인지에 있다.

## 4. 루트와 리프 노드

`CONNECT_BY_ROOT`는 현재 행이 속한 최상위 루트의 값을 반환한다.

```sql
SELECT LPAD(' ', 4 * (LEVEL - 1)) || ename AS employee_name,
       empno,
       CONNECT_BY_ROOT empno AS root_empno,
       LEVEL
FROM emp
START WITH job = 'PRESIDENT'
CONNECT BY PRIOR empno = mgr;
```

`CONNECT_BY_ISLEAF`는 현재 행이 더 이상 자식 행을 갖지 않는 리프 노드인지 표시한다.

```sql
SELECT LPAD(' ', 4 * (LEVEL - 1)) || ename AS employee_name,
       empno,
       CONNECT_BY_ISLEAF AS leaf_yn,
       LEVEL
FROM emp
START WITH job = 'PRESIDENT'
CONNECT BY NOCYCLE PRIOR empno = mgr;
```

- `1`: 리프 노드
- `0`: 하위 행이 있는 노드
- `NOCYCLE`: 순환 참조가 있을 때 무한한 계층 탐색을 피하도록 돕는다.

## 5. 루트부터 현재 행까지의 경로

`SYS_CONNECT_BY_PATH`는 루트에서 현재 행까지 거쳐 온 값을 문자열 경로로 만든다.

```sql
SELECT LPAD(' ', 4 * (LEVEL - 1)) || ename AS employee_name,
       empno,
       SYS_CONNECT_BY_PATH(ename, '/') AS employee_path
FROM emp
START WITH job = 'PRESIDENT'
CONNECT BY NOCYCLE PRIOR empno = mgr;
```

예를 들어 경로는 `/KING/JONES/SCOTT/ADAMS`처럼 표현될 수 있다. 실제 경로는 테이블 데이터에 따라 달라진다. 리프 노드만 보고 싶다면 `CONNECT_BY_ISLEAF = 1` 조건을 사용한다.

## 6. 형제 노드 정렬

계층형 결과 전체에 일반 `ORDER BY`를 적용하면 계층 순서를 의도와 다르게 보이게 할 수 있다. 같은 부모 아래의 형제 행만 정렬하려면 `ORDER SIBLINGS BY`를 사용한다.

```sql
SELECT LPAD(' ', 4 * (LEVEL - 1)) || ename AS employee_name,
       empno,
       LEVEL
FROM emp
START WITH job = 'PRESIDENT'
CONNECT BY NOCYCLE PRIOR empno = mgr
ORDER SIBLINGS BY ename;
```

## 7. 인라인 뷰와 계층형 질의는 역할이 다르다

인라인 뷰는 FROM 절 안의 서브쿼리로, 집계 결과나 계산 결과를 바깥 쿼리에서 테이블처럼 사용하게 한다. 계층형 질의는 부모·자식 연결을 따라 탐색한다. 조직도를 조회할 때 계층형 질의로 경로를 만들고, 별도로 인라인 뷰에서 집계한 결과를 결합하는 식으로 함께 사용할 수도 있지만 두 기능은 같은 개념이 아니다.

## 확인할 항목

- [ ] 루트가 의도한 행에서 시작하는가?
- [ ] `PRIOR`의 위치가 부모→자식 또는 자식→부모 탐색 방향과 맞는가?
- [ ] `WHERE` 조건과 `CONNECT BY` 조건의 차이를 확인했는가?
- [ ] 순환 참조 가능성이 있으면 `NOCYCLE`을 고려했는가?
- [ ] 계층 구조를 유지한 채 형제만 정렬하려면 `ORDER SIBLINGS BY`를 사용했는가?
