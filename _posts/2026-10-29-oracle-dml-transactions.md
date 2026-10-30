---
layout: post
title: "Oracle SQL: INSERT, UPDATE, DELETE, MERGE와 트랜잭션"
date: 2026-10-16 00:00:00 +0900
categories: [학습]
tags: [Oracle, SQL, DML, Transaction]
---

# 조회 이후의 데이터 변경

SELECT가 데이터를 읽는 문장이라면 DML(Data Manipulation Language)은 테이블의 데이터를 입력·수정·삭제한다. 실무에서는 실행 전에 WHERE 조건과 대상 행을 확인하고, 변경 결과를 검증한 뒤 COMMIT하는 습관이 중요하다.

<figure class="note-cover">
  <img src="https://images.unsplash.com/photo-1555949963-aa79dcee981c?auto=format&fit=crop&w=1400&q=85" alt="데이터 변경 SQL 실습">
  <figcaption>데이터 변경 SQL 실습 — Oracle SQL 학습 노트</figcaption>
</figure>

## 1. INSERT — 데이터 입력

모든 컬럼에 값을 입력하려면 컬럼 순서와 값 순서가 맞아야 한다.

```sql
INSERT INTO student
VALUES (...);
```

일부 컬럼만 입력할 때는 컬럼 목록을 명시한다.

```sql
INSERT INTO professor
    (profno, name, position, hiredate, deptno)
VALUES
    (9920, '최윤식', '조교수',
     TO_DATE('2006/01/01', 'YYYY/MM/DD'),
     102);
```

생략한 컬럼은 NULL 또는 정의된 DEFAULT 값이 저장될 수 있다. NOT NULL 제약조건이 있는 컬럼을 생략하면 오류가 날 수 있다.

## 2. INSERT ... SELECT와 CTAS

다른 테이블의 조회 결과를 넣을 때는 `INSERT INTO ... SELECT`를 사용한다.

```sql
INSERT INTO t_student
SELECT *
FROM student;
```

테이블을 새로 만들면서 조회 결과를 복사하는 문법은 CTAS(Create Table As Select)다.

```sql
-- 구조와 데이터 복사
CREATE TABLE imsi_professor AS
SELECT *
FROM professor;

-- 조회 결과가 0행이므로 구조만 복사
CREATE TABLE test_professor AS
SELECT *
FROM professor
WHERE 1 = 0;
```

CTAS는 조회 결과의 컬럼 구조와 데이터 타입을 바탕으로 새 테이블을 만든다. 기존 테이블의 모든 제약조건과 인덱스까지 그대로 복사하는 기능은 아니므로 필요한 제약조건은 별도로 확인한다.

## 3. INSERT ALL과 INSERT FIRST

한 번 조회한 결과를 기준으로 여러 테이블에 데이터를 나눠 넣을 수 있다.

```sql
INSERT ALL
    WHEN height > 170 THEN
        INTO height_info VALUES (studno, name, height)
    WHEN weight > 70 THEN
        INTO weight_info VALUES (studno, name, weight)
SELECT studno, name, height, weight
FROM student;
```

- `INSERT ALL`: 조건을 만족하는 모든 INTO 절을 실행한다.
- `INSERT FIRST`: 위에서부터 조건을 확인해 처음 만족한 INTO 절만 실행한다.

조건이 겹치는 행을 여러 테이블에 모두 넣어야 하는지, 한 곳에만 넣어야 하는지에 따라 선택한다. 예제의 대상 테이블과 컬럼은 설명용이므로 실제 실습 테이블 구조에 맞춰야 한다.

## 4. UPDATE — 데이터 수정

특정 교수의 직급을 수정하는 예다.

```sql
UPDATE professor
SET position = '부교수'
WHERE profno = 9903;
```

WHERE를 생략하면 조건에 맞는 일부 행이 아니라 테이블의 모든 행이 수정된다. 실행 전에 같은 WHERE 조건으로 SELECT를 먼저 실행해 대상 행을 확인한다.

여러 컬럼을 서브쿼리 결과로 한 번에 수정할 수도 있다.

```sql
UPDATE student
SET (grade, deptno) = (
    SELECT grade, deptno
    FROM student
    WHERE studno = 10103
)
WHERE studno = 10201;
```

이 방식은 서브쿼리가 한 행만 반환해야 한다. 대상 학생과 기준 학생이 실제로 존재하는지도 확인한다.

## 5. DELETE — 데이터 삭제

```sql
DELETE FROM student
WHERE studno = 20103;
```

삭제도 WHERE 조건이 없으면 모든 행을 대상으로 한다. 삭제 전 대상 데이터를 SELECT로 확인하고, 업무상 복구가 필요할 수 있다면 트랜잭션 상태를 확인한 뒤 처리한다.

서브쿼리 결과를 조건으로 사용할 수도 있다.

```sql
DELETE FROM student
WHERE deptno = (
    SELECT deptno
    FROM department
    WHERE dname = '컴퓨터공학과'
);
```

## 6. MERGE — 있으면 수정, 없으면 입력

원본 데이터와 대상 데이터를 비교해 존재 여부에 따라 다른 작업을 수행한다.

```sql
MERGE INTO professor p
USING professor_temp f
ON (p.profno = f.profno)
WHEN MATCHED THEN
    UPDATE SET p.position = f.position
WHEN NOT MATCHED THEN
    INSERT (profno, name, position)
    VALUES (f.profno, f.name, f.position);
```

- `ON` 조건이 일치하면 `WHEN MATCHED`의 UPDATE가 실행된다.
- 일치하는 대상이 없으면 `WHEN NOT MATCHED`의 INSERT가 실행된다.

이 예시는 교수번호를 기준으로 동기화하는 상황이다. 실제 테이블의 컬럼과 제약조건에 맞게 INSERT 컬럼 목록을 작성해야 한다.

## 7. COMMIT과 ROLLBACK

```sql
COMMIT;
```

COMMIT은 현재 트랜잭션의 변경사항을 확정한다.

```sql
ROLLBACK;
```

ROLLBACK은 아직 COMMIT하지 않은 트랜잭션 변경사항을 취소한다. 이미 COMMIT한 변경을 일반 ROLLBACK으로 되돌릴 수는 없다.

### 안전하게 변경하는 순서

1. 변경 대상 SELECT
2. INSERT / UPDATE / DELETE 실행
3. 변경 후 SELECT로 결과 확인
4. 결과가 맞으면 COMMIT
5. 잘못됐다면 COMMIT 전에 ROLLBACK

## 실습 체크리스트

- [ ] INSERT에서 컬럼 목록을 지정해 입력
- [ ] CTAS의 `WHERE 1=0` 결과 확인
- [ ] INSERT ALL과 INSERT FIRST의 조건이 겹치는 데이터로 결과 비교
- [ ] UPDATE와 DELETE의 WHERE 조건을 먼저 SELECT로 검증
- [ ] COMMIT 전 ROLLBACK이 가능한지 테스트
- [ ] MERGE에서 일치하는 행과 일치하지 않는 행 각각 테스트

## 시험 포인트

- `INSERT INTO ... VALUES`: 직접 입력
- `INSERT INTO ... SELECT`: 조회 결과 입력
- CTAS + `WHERE 1=0`: 결과 데이터 없이 구조 생성
- `INSERT ALL`: 만족하는 조건을 모두 실행
- `INSERT FIRST`: 첫 번째로 만족하는 조건 실행
- `UPDATE`: 데이터 수정
- `DELETE`: 데이터 삭제
- `MERGE`: 일치하면 UPDATE, 없으면 INSERT
- `COMMIT`: 변경 확정
- `ROLLBACK`: 커밋 전 변경 취소
