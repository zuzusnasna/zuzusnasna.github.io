---
layout: post
title: "SQL 튜닝을 공부하면서 먼저 확인한 것"
date: 2026-10-16 09:00:00 +0900
categories: [학습]
tags: [Oracle, SQL Tuning, performance tuning]
---

SQL 성능 문제를 해결할 때 가장 먼저 쿼리를 고치는 것보다 **왜 느린지 확인하는 과정**이 중요하다는 것을 배웠다.

## 확인 순서

1. 실행되는 SQL 확인
2. 조건과 JOIN 구조 확인
3. 실행 계획 확인
4. 인덱스 사용 여부 확인
5. 실제 데이터 양과 선택도 확인
6. 변경 후 다시 측정

```sql
EXPLAIN PLAN FOR
SELECT *
FROM employee
WHERE department_id = 10;

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);
```

## 중요한 점

인덱스가 있다고 무조건 빨라지는 것은 아니다. 데이터 분포와 조건에 따라 Full Table Scan이 더 적절할 수도 있다.

튜닝은 추측으로 끝내는 작업이 아니라 **측정 → 원인 확인 → 변경 → 재측정**의 반복이라고 정리했다.
