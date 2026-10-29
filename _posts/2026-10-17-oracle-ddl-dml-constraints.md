---
layout: post
title: "Oracle DDL, DML, 제약조건과 테이블 설계"
date: 2026-10-17 09:00:00 +0900
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
