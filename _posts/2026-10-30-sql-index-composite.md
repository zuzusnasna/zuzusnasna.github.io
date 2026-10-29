---
layout: post
title: "SQL Tuning : 인덱스는 컬럼보다 조회 조건을 보고 설계한다"
date: 2026-10-30 16:00:00 +0900
categories: [학습]
tags: [SQL Tuning, Oracle, MySQL]
---

인덱스를 공부하면서 가장 중요한 것은 인덱스 개수가 아니라 **실제 조회 패턴과 실행 계획**이었다.

## 단일 인덱스

```sql
CREATE INDEX idx_member_email ON member(email);
```

자주 특정 이메일로 조회한다면 효과가 있을 수 있다.

## 복합 인덱스

```sql
CREATE INDEX idx_order_member_status
ON orders(member_id, status);
```

여러 컬럼을 함께 조건으로 사용하는 경우 고려할 수 있다.

## 순서가 중요한 이유

복합 인덱스는 컬럼 순서에 따라 활용 방식이 달라진다. 따라서 단순히 WHERE에 등장하는 컬럼을 모두 넣는 것이 아니라 **선택도, 정렬, 범위 조건, 실제 쿼리 패턴**을 같이 봐야 한다.

## 실행 계획

인덱스를 추가한 뒤에는 실제 실행 계획과 실행 시간을 확인해야 한다.

```sql
EXPLAIN SELECT * FROM orders
WHERE member_id = 10 AND status = 'PAID';
```

## 배운 점

튜닝은 "인덱스를 추가하자"가 아니라 **왜 느린지 측정하고 실행 계획을 확인한 뒤 필요한 변경만 하는 과정**이다.
