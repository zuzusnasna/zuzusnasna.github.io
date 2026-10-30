---
layout: post
title: "Oracle 사용자 권한, ROLE, SYNONYM과 TABLESPACE"
date: 2026-08-10 00:00:00 +0900
categories: [학습]
tags: [Oracle, SQL, Privilege, User, Tablespace]
---

Oracle 실습에서는 테이블을 만드는 것뿐 아니라 **누가 접속할 수 있고, 누구의 객체를 조회할 수 있는지**도 따로 관리했다. 사용자, 권한, ROLE, SYNONYM, TABLESPACE는 서로 다른 역할을 맡는다.

## 1. 시스템 권한과 객체 권한

시스템 권한은 데이터베이스에서 특정 작업을 수행할 수 있는 권한이다.

```sql
GRANT CREATE SESSION TO hr_mgr;
```

`CREATE SESSION`은 데이터베이스에 접속할 수 있게 한다. `CREATE TABLE`, `CREATE USER` 등은 각각 테이블 생성, 사용자 생성과 관련된 시스템 권한이다.

객체 권한은 특정 테이블이나 뷰 같은 객체에 대해 허용할 작업을 지정한다.

```sql
GRANT SELECT, INSERT, DELETE
ON scott.student
TO hr_clerk;
```

이 권한은 `scott.student` 객체에 한정된다. `SELECT`는 조회, `INSERT`는 입력, `DELETE`는 삭제 권한이다. 다른 사용자의 테이블은 보통 `사용자명.테이블명` 형식으로 지정한다.

```sql
SELECT *
FROM scott.student;
```

## 2. ROLE로 권한을 묶어 관리하기

비슷한 권한을 여러 사용자에게 하나씩 부여하면 관리가 번거롭다. ROLE은 권한을 묶어 재사용하는 단위다.

```sql
GRANT hr_clerk TO hr_mgr;
GRANT hr_clerk TO tiger;
```

위 예시는 `hr_clerk`라는 ROLE을 두 사용자에게 부여하는 형태다. ROLE에 어떤 테이블 권한이 포함되어 있는지, 현재 사용자에게 어떤 ROLE이 부여되었는지는 데이터 딕셔너리 뷰로 확인할 수 있다.

```sql
SELECT *
FROM role_tab_privs;

SELECT *
FROM user_role_privs;
```

## 3. 객체 권한을 조회하는 데이터 딕셔너리

현재 사용자가 다른 사용자에게 부여한 권한과 다른 사용자로부터 받은 권한은 조회 뷰가 다르다.

| 뷰 | 확인하는 내용 |
|---|---|
| `USER_TAB_PRIVS_MADE` | 현재 사용자가 부여한 객체 권한 |
| `USER_TAB_PRIVS_RECD` | 현재 사용자가 받은 객체 권한 |
| `USER_COL_PRIVS_MADE` | 현재 사용자가 부여한 컬럼 권한 |
| `USER_COL_PRIVS_RECD` | 현재 사용자가 받은 컬럼 권한 |
| `USER_ROLE_PRIVS` | 현재 사용자에게 부여된 ROLE |
| `ROLE_TAB_PRIVS` | ROLE에 부여된 테이블 권한 |

예를 들어 특정 테이블의 조회 권한을 다른 사용자에게 주려면 객체 소유자 또는 해당 권한을 부여할 수 있는 권한을 가진 사용자가 GRANT를 실행해야 한다.

```sql
GRANT SELECT
ON project
TO scott;
```

## 4. SYNONYM으로 객체 이름 줄이기

SYNONYM은 테이블이나 다른 객체에 별칭을 붙이는 기능이다. 객체 자체를 복사하거나 권한을 자동으로 부여하지는 않는다.

```sql
CREATE PUBLIC SYNONYM pub_employee
FOR employee;
```

이후 권한이 있는 사용자는 다음과 같이 별칭을 통해 객체를 참조할 수 있다.

```sql
SELECT *
FROM pub_employee;
```

공용 동의어는 여러 사용자가 이름을 사용할 수 있도록 공개하는 별칭이다. **동의어가 있다고 해서 원본 객체의 접근 권한까지 생기는 것은 아니다.** 따라서 원본 테이블에 대한 권한 부여가 별도로 필요하다.

```sql
GRANT SELECT ON employee TO kosa;
DROP PUBLIC SYNONYM pub_employee;
```

공용 동의어를 생성·삭제하는 작업은 적절한 권한이 있는 계정에서 수행해야 한다.

## 5. TABLESPACE와 사용자 생성

TABLESPACE는 데이터베이스 파일을 논리적으로 관리하는 저장 공간이다. DATAFILE은 그 공간을 구성하는 물리 파일이다.

```sql
CREATE TABLESPACE kosa
DATAFILE 'C:\\app\\kosa\\product\\21c\\oradata\\XE\\kosa.dbf'
SIZE 100M
AUTOEXTEND ON NEXT 10M
MAXSIZE 500M;
```

위 경로는 실습 환경의 예시이므로 실제 Oracle 설치 위치와 데이터 파일 경로에 맞게 변경해야 한다.

- `SIZE 100M`: 초기 크기
- `AUTOEXTEND ON`: 필요할 때 파일 확장 허용
- `NEXT 10M`: 확장 단위
- `MAXSIZE 500M`: 최대 크기

사용자를 생성할 때 기본 테이블스페이스와 임시 테이블스페이스를 지정할 수 있다.

```sql
CREATE USER kosa
IDENTIFIED BY kosa123
DEFAULT TABLESPACE kosa
TEMPORARY TABLESPACE temp;
```

Oracle 버전과 컨테이너 설정에 따라 사용자 생성 방식이 달라질 수 있다. 수업에서 사용한 `_oracle_script` 같은 내부 파라미터를 무조건 운영 환경에 적용하기보다는, 현재 접속한 컨테이너와 사용자 생성 정책을 먼저 확인해야 한다.

## 6. 실습 흐름

1. 필요한 TABLESPACE를 생성한다.
2. 사용자와 기본 저장 공간을 지정한다.
3. 객체 소유자 계정에서 테이블과 데이터를 만든다.
4. 필요한 시스템 권한·객체 권한을 부여한다.
5. 필요하면 SYNONYM으로 객체 이름을 간단하게 만든다.
6. 권한 조회 뷰에서 부여·수신 상태를 확인한다.

## 핵심 정리

- 시스템 권한은 데이터베이스 작업 권한, 객체 권한은 특정 객체에 대한 권한이다.
- ROLE은 여러 권한을 묶어 사용자에게 부여하기 위한 단위다.
- SYNONYM은 객체의 별칭이며 권한을 대신하지 않는다.
- TABLESPACE는 논리적 저장 공간이고 DATAFILE은 물리 파일이다.
- 권한 부여는 필요한 최소 범위로 제한하고, 실습 계정과 운영 계정의 권한을 구분한다.
