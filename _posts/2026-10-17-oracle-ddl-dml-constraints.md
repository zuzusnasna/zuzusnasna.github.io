---
layout: post
title: "Oracle DDL, DML, 제약조건과 테이블 설계"
date: 2026-09-08 00:00:00 +0900
categories: [학습]
tags: [Oracle, SQL, Database]
---

Oracle 실습에서는 SQL 문법을 외우는 것보다 **테이블을 어떻게 설계하고 데이터의 무결성을 어떻게 지킬지**를 같이 생각했다.

## DDL과 DML

DDL은 테이블 같은 데이터베이스 구조를 정의하는 명령이고 DML은 실제 데이터를 다룬다.

```sql
CREATE TABLE member (
    member_id NUMBER PRIMARY KEY,
    name VARCHAR2(50) NOT NULL,
    email VARCHAR2(100) UNIQUE
);
```

```sql
INSERT INTO member VALUES (1, '홍길동', 'hong@test.com');
UPDATE member SET name = '김철수' WHERE member_id = 1;
DELETE FROM member WHERE member_id = 1;
```

## 제약조건

- PRIMARY KEY : 행을 식별
- FOREIGN KEY : 테이블 간 관계 유지
- UNIQUE : 중복 방지
- NOT NULL : 필수 값 보장
- CHECK : 허용 범위 제한

애플리케이션에서 검증하더라도 DB 제약조건은 마지막 안전장치 역할을 한다.

## 배운 점

테이블 설계는 단순히 컬럼을 만드는 작업이 아니라 **업무 규칙을 데이터베이스 구조에 반영하는 과정**이었다.

## 더 깊게 이해하기: 데이터 무결성은 DB에서도 강제해야 한다

DDL은 테이블과 제약 조건 같은 구조를 정의하고, DML은 저장된 데이터를 조회하거나 변경한다. 애플리케이션에서 입력을 검증하더라도 다른 프로그램이나 운영 SQL이 같은 테이블을 수정할 수 있으므로, 반드시 지켜야 하는 규칙은 데이터베이스 제약 조건으로도 표현하는 것이 안전하다.

PRIMARY KEY는 행을 식별하고 중복과 NULL을 허용하지 않는다. FOREIGN KEY는 참조 대상의 존재를 보장하고, UNIQUE는 중복을 제한한다. CHECK는 값의 범위를 제한할 수 있지만, 제약 조건이 업무 규칙 전체를 표현할 수 있는 것은 아니므로 DB와 애플리케이션의 책임을 구분해야 한다.

### 변경 전에 확인할 것
- 기존 데이터가 새 제약 조건을 위반하지 않는가?
- 제약 조건 이름과 목적이 명확한가?
- 삭제 시 참조 행을 어떻게 처리할지 결정했는가?
- 스키마 변경을 배포할 때 기존 애플리케이션과 호환되는가?

제약 조건은 잘못된 데이터가 들어온 뒤 찾아내는 장치가 아니라 잘못된 상태가 저장되지 않도록 막는 마지막 방어선이다.


## 4. 제약조건을 조회하고 상태를 바꾸기

제약조건은 이름을 붙여 관리하면 나중에 특정 규칙을 수정하거나 비활성화할 때 찾기 쉽다.

```sql
SELECT constraint_name, constraint_type, status
FROM user_constraints
WHERE table_name = 'SUBJECT';
```

| 타입 | 의미 |
|---|---|
| `P` | PRIMARY KEY |
| `R` | FOREIGN KEY |
| `U` | UNIQUE |
| `C` | CHECK 또는 NOT NULL |

컬럼 기준으로 어떤 제약조건이 걸려 있는지 확인하려면 `USER_CONS_COLUMNS`를 함께 조회한다.

```sql
SELECT table_name, column_name, constraint_name
FROM user_cons_columns
WHERE table_name IN ('STUDENT', 'PROFESSOR', 'DEPARTMENT');
```

특정 제약조건을 제거하거나 일시적으로 비활성화할 수도 있다.

```sql
ALTER TABLE subject
DROP CONSTRAINT subject_term_ck;

ALTER TABLE sugang
DISABLE CONSTRAINT sugang_pk;

ALTER TABLE sugang
DISABLE CONSTRAINT sugang_studno_fk;

ALTER TABLE sugang
ENABLE CONSTRAINT sugang_pk;

ALTER TABLE sugang
ENABLE CONSTRAINT sugang_studno_fk;
```

`DISABLE`은 제약조건을 삭제하는 것이 아니라 검사를 멈추는 것이다. 다시 `ENABLE`할 때는 기존 데이터가 제약조건을 위반하지 않는지 확인해야 한다. 비활성화 상태에서 중복이나 잘못된 참조가 들어갔다면 활성화가 실패할 수 있다.

## 5. 자동 생성 키와 지연 제약조건

Oracle의 IDENTITY 컬럼은 행을 입력할 때 번호를 자동으로 생성할 수 있다.

```sql
CREATE TABLE employee (
    employee_id NUMBER(7)
        GENERATED ALWAYS AS IDENTITY
        CONSTRAINT employee_id_no_pk PRIMARY KEY,
    name VARCHAR2(25)
        CONSTRAINT employee_name_nn NOT NULL,
    address VARCHAR2(25),
    deptno NUMBER(2),
    phone_number VARCHAR2(20)
);
```

`GENERATED ALWAYS AS IDENTITY`는 ID 값을 자동으로 생성한다. `NOT NULL`은 이름이 반드시 입력되어야 한다는 규칙이다.

제약조건 검사 시점도 지정할 수 있다.

```sql
CONSTRAINT employee_id_no_pk PRIMARY KEY
DEFERRABLE INITIALLY DEFERRED
```

지연 가능한 제약조건은 트랜잭션 중간이 아니라 COMMIT 시점에 검사하도록 설정할 수 있다. 반대로 일반적인 즉시 검사 제약조건은 SQL 실행 시점에 위반 여부를 확인한다. 이 옵션은 모든 제약조건에 무조건 적용하는 설정이 아니라, 트랜잭션 내에서 일시적으로 참조 관계가 바뀌는 등 검사 시점이 중요한 상황에 사용한다.

인덱스를 저장할 테이블스페이스를 지정하는 `USING INDEX TABLESPACE` 옵션도 있지만, 해당 테이블스페이스가 실제로 존재하고 사용 권한이 있어야 한다.

## 6. 외래키는 실제 참조 대상을 확인한다

```sql
ALTER TABLE employee
ADD CONSTRAINT employee_deptno_fk
FOREIGN KEY (deptno)
REFERENCES dept(deptno);
```

이 제약조건이 활성화되어 있다면 `employee.deptno`에 입력하는 값은 부모 테이블 `dept.deptno`에 존재해야 한다. 존재하지 않는 부서 번호를 입력하면 참조 무결성 오류가 발생한다.

Oracle에서 빈 문자열 `''`은 NULL로 처리된다. 따라서 빈 문자열 입력이 NOT NULL 제약조건을 통과할 것이라고 가정하면 안 된다.

## 실습 전후 확인

- [ ] `USER_CONSTRAINTS`에서 제약조건 이름과 상태를 조회한다.
- [ ] 중복 기본키 입력이 거부되는지 확인한다.
- [ ] 외래키가 존재하지 않는 부모 키를 거부하는지 확인한다.
- [ ] 제약조건을 비활성화한 뒤 상태가 `DISABLED`로 표시되는지 확인한다.
- [ ] 다시 활성화할 때 기존 데이터가 규칙을 만족하는지 확인한다.
