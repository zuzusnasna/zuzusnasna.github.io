---
layout: post
title: "부트캠프 : Oracle DDL, DML, 제약조건과 테이블 설계"
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
