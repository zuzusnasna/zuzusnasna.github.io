---
layout: post
title: "부트캠프 : Cursor는 언제 사용하는가"
date: 2026-10-20 09:00:00 +0900
categories: [학습]
tags: [Oracle, PL/SQL]
---

Cursor를 공부하면서 단순히 문법을 외우기보다 **여러 행을 하나씩 처리해야 하는 업무**를 떠올리는 것이 이해에 도움이 됐다.

## 왜 필요한가

SQL은 여러 행을 한 번에 처리하는 데 강하지만, 각 행마다 서로 다른 계산이나 조건을 적용해야 하는 경우가 있다.

예를 들어 직원별 급여 형태가 정규직, 시간제, 일급제로 나뉘고 각각 계산 방식이 다르다면 행 단위 처리가 필요할 수 있다.

```sql
FOR emp IN (
    SELECT employee_id, salary_type, salary
    FROM employee
) LOOP
    IF emp.salary_type = 'FULL_TIME' THEN
        -- 정규직 계산
        NULL;
    ELSIF emp.salary_type = 'PART_TIME' THEN
        -- 시간제 계산
        NULL;
    END IF;
END LOOP;
```

## 프로젝트에 적용한다면

휴대폰 사용량, 카드 사용 내역, 배달 주문 이력처럼 고객별 데이터를 모아서 등급을 갱신하는 작업에도 행 단위 처리가 필요할 수 있다.

다만 모든 데이터를 Cursor로 처리하는 것이 좋은 것은 아니다. 가능한 경우 집합 연산 SQL이 더 효율적일 수 있기 때문에 **정말 행 단위 업무가 필요한지 먼저 판단**해야 한다.
