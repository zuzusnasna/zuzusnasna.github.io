---
layout: post
title: "Oracle VIEW, SEQUENCE, INDEX를 정리한 이유"
date: 2026-10-21 09:00:00 +0900
categories: [학습]
tags: [Oracle, SQL]
---

Oracle에는 테이블 외에도 조회와 데이터 관리에 도움을 주는 여러 객체가 있다.

## VIEW

복잡한 조회 SQL을 하나의 논리적인 이름으로 제공할 수 있다.

```sql
CREATE VIEW employee_summary AS
SELECT employee_id, name, department_id
FROM employee;
```

원본 데이터를 복사하는 것이 아니라 조회 정의를 저장한다는 점이 중요했다.

## SEQUENCE

숫자 키를 자동으로 증가시키는 데 사용할 수 있다.

```sql
CREATE SEQUENCE member_seq
START WITH 1
INCREMENT BY 1;
```

```sql
INSERT INTO member(member_id, name)
VALUES(member_seq.NEXTVAL, '홍길동');
```

## INDEX

조건 검색을 빠르게 하기 위한 데이터 구조다.

```sql
CREATE INDEX idx_employee_department
ON employee(department_id);
```

하지만 인덱스는 저장 공간과 쓰기 비용이 추가되기 때문에 많이 만든다고 좋은 것이 아니다.

## 배운 점

DB 객체는 각각 목적이 다르다. **조회 구조는 VIEW, 키 생성은 SEQUENCE, 검색 최적화는 INDEX**처럼 사용 목적을 기준으로 구분하면 기억하기 쉬웠다.

## 더 깊게 이해하기: View, Sequence, Index는 서로 다른 문제를 해결한다

View는 조회 로직을 이름 붙여 재사용하고 테이블 구조의 일부를 감추는 데 활용할 수 있다. 하지만 일반적인 View는 결과 데이터를 별도 저장하는 것이 아니므로 복잡한 View를 조회한다고 비용이 자동으로 줄어들지는 않는다. Sequence는 고유한 번호를 생성하는 도구지만 연속된 번호나 트랜잭션 롤백 시 번호 회수를 보장하지 않는다. Index는 조회 경로를 빠르게 찾도록 돕지만 추가 저장 공간과 DML 비용이 발생한다.

세 기능을 하나의 최적화 도구처럼 생각하지 않고 각각의 목적을 분리해야 한다. 조회 로직 재사용은 View, 식별자 생성은 Sequence, 검색 비용 개선은 Index가 담당한다.

### 선택 기준
- View가 중복 SQL을 줄이는지, 권한 경계를 명확히 하는지 확인한다.
- Sequence의 번호가 연속적이어야 한다는 잘못된 가정을 하지 않는다.
- 인덱스는 실제 WHERE·JOIN·ORDER BY 패턴과 데이터 선택도를 기준으로 설계한다.
- 인덱스 추가 전후의 실행 계획과 DML 비용을 함께 확인한다.

DB 객체는 존재 자체가 목적이 아니다. 어떤 문제를 해결하려고 도입했는지와 운영 비용이 무엇인지 설명할 수 있어야 한다.


## 4. 인덱스 유형과 설계

인덱스는 검색 경로를 제공하지만, 모든 컬럼에 만들면 좋은 것은 아니다. 조회가 빨라질 수 있는 대신 저장 공간이 필요하고 INSERT·UPDATE·DELETE 때 인덱스도 함께 유지해야 한다.

### 고유 인덱스와 일반 인덱스

```sql
CREATE UNIQUE INDEX idx_dept_name
ON department(dname);

CREATE INDEX idx_stud_birthdate
ON student(birthdate);
```

고유 인덱스는 중복값을 허용하지 않는다. 일반 인덱스는 같은 값이 여러 행에 있어도 된다. 고유한 값이 필요하다는 업무 규칙은 UNIQUE 제약조건으로 표현하는 것이 보통이며, 제약조건을 만들 때 Oracle이 인덱스를 사용할 수도 있다.

### 결합 인덱스

```sql
CREATE INDEX idx_stud_dno_grade
ON student(deptno, grade);
```

결합 인덱스는 여러 컬럼을 하나의 키 순서로 구성한다. 위 인덱스는 `deptno`를 기준으로 탐색한 뒤 `grade` 조건을 함께 사용할 때 유리할 수 있다. 컬럼 순서는 실제 WHERE 조건, 조인, 정렬 패턴에 맞춰 정해야 한다.

### 함수 기반 인덱스

```sql
CREATE INDEX uppercase_idx
ON emp(UPPER(ename));

SELECT *
FROM emp
WHERE UPPER(ename) = 'KING';
```

조회 조건에서 `UPPER(ename)`을 사용하므로 같은 표현식에 인덱스를 만들 수 있다. 인덱스 표현식과 쿼리 조건이 맞는지 확인해야 한다.

### 인덱스 조회와 재구성

```sql
SELECT index_name, uniqueness
FROM user_indexes
WHERE table_name = 'STUDENT';

SELECT index_name, column_name
FROM user_ind_columns
WHERE table_name = 'STUDENT';

ALTER INDEX stud_no_pk REBUILD;
```

인덱스 재구성은 운영 상황과 실행 계획을 확인한 뒤 필요할 때 수행한다. `REBUILD`를 실행했다고 모든 쿼리가 자동으로 빨라지는 것은 아니다.

## 5. 인라인 뷰: FROM 안에서 결과를 한 번 더 조회하기

인라인 뷰는 FROM 절 안에 작성한 서브쿼리다. 별도의 View 객체를 생성하지 않고 현재 SQL 안에서 집계 결과를 테이블처럼 사용할 수 있다.

```sql
SELECT d.dname,
       s.avg_height,
       s.avg_weight
FROM (
    SELECT deptno,
           ROUND(AVG(height), 1) AS avg_height,
           ROUND(AVG(weight), 1) AS avg_weight
    FROM student
    GROUP BY deptno
) s
JOIN department d
  ON s.deptno = d.deptno;
```

안쪽 쿼리에서 학과별 평균 키와 평균 몸무게를 구하고, 바깥쪽 쿼리에서 학과명과 결합한다. 집계 단계와 표시 단계를 분리해 SQL의 목적을 읽기 쉽게 만든다.

학과별 최대 키 학생을 조회할 때도 인라인 뷰로 최대 키를 먼저 계산할 수 있다. 이때 최대 키만 비교하면 다른 학과에서 같은 키가 나온 학생도 결과에 포함될 수 있으므로, 학과번호도 함께 연결해야 정확하다.

```sql
SELECT d.dname, s.name, s.height
FROM (
    SELECT deptno, MAX(height) AS max_height
    FROM student
    GROUP BY deptno
) m
JOIN student s
  ON s.deptno = m.deptno
 AND s.height = m.max_height
JOIN department d
  ON d.deptno = s.deptno;
```

## 실습 체크리스트

- [ ] 인덱스가 필요한 조회 조건을 먼저 적어 본다.
- [ ] 단일 컬럼과 결합 인덱스의 차이를 비교한다.
- [ ] `USER_INDEXES`, `USER_IND_COLUMNS`에서 생성 결과를 확인한다.
- [ ] 인라인 뷰의 안쪽 SELECT 결과를 별도로 실행해 확인한다.
- [ ] 집계 결과를 원본 테이블과 조인할 때 그룹 키를 빠뜨리지 않는다.
