---
layout: post
title: "PL/SQL에서 JOB과 TRIGGER를 구분해서 사용하는 기준"
date: 2026-07-24 00:00:00 +0900
categories: [학습]
tags: [Oracle, PL/SQL]
---

Oracle에서 자동 실행이 필요한 기능을 공부하면서 JOB과 TRIGGER의 차이를 정리했다.

## JOB

JOB은 **정해진 시간이나 주기**에 작업을 실행할 때 사용한다.

예를 들어 매일 새벽 통계 데이터를 갱신하거나 오래된 데이터를 정리하는 작업이 해당된다.

## TRIGGER

TRIGGER는 **특정 데이터베이스 이벤트가 발생했을 때** 자동으로 실행된다.

예를 들어 장비의 상태가 `UPDATE`로 변경되었을 때 변경 이력을 기록하는 경우다.

```sql
CREATE OR REPLACE TRIGGER equipment_history_trg
AFTER UPDATE OF status ON equipment
FOR EACH ROW
BEGIN
    INSERT INTO equipment_history(equipment_id, old_status, new_status)
    VALUES (:OLD.id, :OLD.status, :NEW.status);
END;
/
```

## 기준

| 상황 | 적합한 기능 |
|---|---|
| 특정 시간에 실행 | JOB |
| 데이터 변경 직후 실행 | TRIGGER |
| 필요할 때 직접 호출 | PROCEDURE |

시간 기준인지, 데이터 이벤트 기준인지 먼저 생각하면 선택하기 쉬웠다.

## 더 깊게 이해하기: Trigger와 Job의 실행 시점을 분리하기

Trigger는 지정된 테이블 이벤트나 데이터베이스 이벤트가 발생했을 때 자동으로 실행된다. 반면 Job은 정해 둔 시간이나 주기에 따라 작업을 실행한다. 예를 들어 배터리 상태가 UPDATE로 바뀌었을 때 이력 행을 기록하는 것은 Trigger의 후보이고, 매일 새벽 사용량을 집계하는 것은 Job의 후보가 될 수 있다.

Trigger 안에 너무 많은 업무 로직을 넣으면 데이터를 변경한 SQL만 보고는 어떤 부수 효과가 발생하는지 파악하기 어려워진다. Job 역시 실패, 중복 실행, 실행 시간 초과, 재시도 정책을 고려해야 한다. 자동 실행된다는 이유로 운영 책임이 사라지는 것은 아니다.

### 운영에서 확인할 것
- Trigger가 어떤 이벤트와 조건에서 실행되는지 문서화했는가?
- 같은 UPDATE가 반복될 때 중복 이력이나 부작용이 생기지 않는가?
- Job 실행 결과와 실패 원인을 조회할 수 있는가?
- 재실행해도 결과가 중복되지 않는 멱등성을 확보했는가?

자동화 객체는 숨겨진 실행 경로를 만든다. 변경 이벤트와 정기 실행을 분리해 설계하고, 실행 이력과 실패 복구 방법까지 준비해야 한다.
