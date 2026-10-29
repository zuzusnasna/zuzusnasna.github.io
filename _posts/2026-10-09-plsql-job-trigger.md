---
layout: post
title: "PL/SQL에서 JOB과 TRIGGER를 구분해서 사용하는 기준"
date: 2026-10-09 09:00:00 +0900
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
