---
layout: post
title: "PL/SQL의 Procedure, JOB, TRIGGER 구분하기"
date: 2026-10-28 09:00:00 +0900
categories: [학습]
tags: [Oracle, PL/SQL, Procedure, JOB, TRIGGER]
---

PL/SQL 수업에서 다룬 세 기능은 모두 데이터 처리와 관련 있지만, 실행되는 방식이 다르다. 프로시저는 필요할 때 호출하는 작업 단위이고, JOB은 정해진 시간에 실행하는 작업이며, 트리거는 특정 데이터 변경 이벤트에 반응해 자동 실행된다.

## 1. Procedure: 호출해서 실행하는 작업

프로시저는 반복해서 실행하는 SQL과 업무 규칙을 하나의 데이터베이스 객체로 묶어 두고 필요할 때 호출한다. 예를 들어 회원 주문 금액에 따라 회원 등급을 다시 계산하는 작업을 생각할 수 있다.

아래 코드는 설명을 위한 예시 스키마다. `members` 테이블에 `member_id`, `total_order_amount`, `grade`, `updated_at` 컬럼이 있다고 가정하며, 수업에서 실제로 사용한 테이블 구조라는 뜻은 아니다.

```sql
CREATE OR REPLACE PROCEDURE refresh_member_grade
IS
BEGIN
    UPDATE members
       SET grade =
           CASE
               WHEN total_order_amount >= 1000000 THEN 'VIP'
               WHEN total_order_amount >= 300000  THEN 'GOLD'
               ELSE 'BASIC'
           END,
           updated_at = SYSDATE;
END;
/
```

이 프로시저는 회원별 누적 주문 금액을 기준으로 등급을 다시 계산한다.

- `CREATE OR REPLACE PROCEDURE`: 프로시저를 생성하거나 기존 정의를 교체한다.
- `UPDATE members`: 회원 테이블의 등급을 갱신한다.
- `CASE`: 금액 구간에 따라 등급을 정한다.
- `updated_at = SYSDATE`: 갱신 시각을 기록한다.

실행은 다음과 같이 한다.

```sql
EXEC refresh_member_grade;
```

위 예제는 모든 회원을 한 번에 갱신한다. 특정 회원만 처리하고 싶다면 회원 ID를 입력 매개변수로 받고 `WHERE member_id = p_member_id` 조건을 추가할 수 있다. 실제 서비스에서는 등급 기준, NULL 금액 처리, 변경 행 수, 실행 권한과 트랜잭션 정책을 업무 규칙에 맞게 정해야 한다. 수업 실습 코드를 받으면 실제 테이블명과 조건으로 대체할 수 있다.

## 2. JOB: 정해진 시간에 실행

JOB은 매일 또는 매월 특정 시점처럼 시간과 주기를 기준으로 작업을 실행하는 데 적합하다. 수업 예제에서는 급여 계산 프로시저를 매월 마지막 주 금요일 정오에 실행하고 결과를 급여 결과 테이블에 저장하는 상황을 생각했다.

```text
정해진 실행 시각 도달
        ↓
JOB 실행
        ↓
급여 계산 Procedure 호출
        ↓
급여 결과 테이블에 저장
```

여기서는 JOB이 시간 기준 실행을 담당하고, 실제 계산 로직은 프로시저에 둔다. 다만 수업 자료에는 실행 시각에 대한 시나리오가 있고 JOB 생성 구문 전체는 포함되어 있지 않으므로, 위 흐름은 개념 설명이다.

## 3. TRIGGER: 데이터 변경 이벤트에 반응

트리거는 테이블에 INSERT, UPDATE, DELETE가 발생했을 때 자동으로 실행된다. 프로시저처럼 사용자가 직접 EXECUTE로 호출하는 방식이 아니다.

예를 들어 사원 테이블의 변경 작업을 기록하는 트리거는 다음과 같이 작성할 수 있다.

```sql
CREATE OR REPLACE TRIGGER emp_audit_tr
AFTER INSERT OR UPDATE OR DELETE ON emp2
BEGIN
    IF INSERTING THEN
        INSERT INTO emp_audit
        VALUES (emp_audit_tr_seq.NEXTVAL, USER, 'inserting', SYSDATE);
    ELSIF UPDATING THEN
        INSERT INTO emp_audit
        VALUES (emp_audit_tr_seq.NEXTVAL, USER, 'updating', SYSDATE);
    ELSIF DELETING THEN
        INSERT INTO emp_audit
        VALUES (emp_audit_tr_seq.NEXTVAL, USER, 'deleting', SYSDATE);
    END IF;
END;
/
```

이 예제의 `emp_audit_tr_seq`는 감사 테이블에 사용할 번호를 제공하는 시퀀스 이름이다. 실제로 실행하려면 수업 자료처럼 시퀀스와 `emp_audit` 테이블을 먼저 생성해야 한다.

### 문장 레벨과 행 레벨

`FOR EACH ROW`를 작성하지 않으면 문장 레벨 트리거다. 하나의 DML 문장이 여러 행을 변경해도 트리거는 문장 단위로 한 번 실행된다. `FOR EACH ROW`를 작성하면 영향을 받은 각 행마다 트리거가 실행된다.

| 구분 | 문장 레벨 | 행 레벨 |
|---|---|---|
| 실행 기준 | DML 문장 1회 | 영향을 받은 각 행 |
| `FOR EACH ROW` | 생략 | 작성 |
| `:OLD`, `:NEW` | 사용 불가 | 행의 변경 전·후 값 접근 |

행 레벨 트리거에서는 `:OLD`와 `:NEW`로 변경 전후 값을 확인할 수 있다.

- INSERT: `:NEW`에 새 값이 들어오고 `:OLD`는 NULL이다.
- UPDATE: `:OLD`는 변경 전 값, `:NEW`는 변경 후 값이다.
- DELETE: `:OLD`는 삭제 전 값이고 `:NEW`는 NULL이다.

예를 들어 재고 테이블을 입고 테이블과 맞추는 수업 실습에서는 입고 데이터가 INSERT되면 재고 테이블에 같은 데이터를 추가하고, UPDATE되면 재고의 이름을 변경하며, DELETE되면 재고 데이터도 삭제하도록 트리거를 작성했다.

## 4. 어떤 기능을 선택할까?

| 필요한 동작 | 선택 |
|---|---|
| 필요할 때 직접 실행 | Procedure |
| 정해진 시간이나 주기마다 실행 | JOB |
| INSERT·UPDATE·DELETE 발생 시 자동 실행 | TRIGGER |

세 기능은 서로 완전히 대체하는 것이 아니다. 예를 들어 급여 계산 로직은 프로시저로 만들고, JOB이 매월 정해진 시간에 프로시저를 호출하도록 구성할 수 있다. 반면 특정 데이터가 변경되는 순간 변경 이력을 남기는 작업은 트리거에 적합하다.

## 5. 실제 적용 전에 확인할 점

- 트리거가 한 문장에 한 번 실행되는지, 변경된 행마다 실행되는지 확인한다.
- 트리거 오류가 원래 INSERT·UPDATE·DELETE에 어떤 영향을 주는지 확인한다.
- JOB을 사용한다면 실행 시각뿐 아니라 실패 여부와 재실행 방법도 정한다.
- 프로시저를 재호출할 때 데이터가 중복 처리되지 않는지 확인한다.

수업에서 정리한 핵심은 실행 조건이다. 직접 호출하는 작업인지, 시간에 맞춰 실행할 작업인지, 데이터 변경에 반응할 작업인지를 먼저 구분하면 세 기능의 역할을 정하기 쉽다.
