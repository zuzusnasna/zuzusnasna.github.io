---
layout: post
title: "부트캠프 : 식별관계와 비식별관계를 구분하는 기준"
date: 2026-10-18 09:00:00 +0900
categories: [학습]
tags: [Oracle, SQL, Database]
---

DB 설계에서 식별관계와 비식별관계를 처음 배울 때는 용어보다 **자식 테이블의 기본키가 부모 키에 의존하는지**를 보는 것이 가장 이해하기 쉬웠다.

## 식별관계

부모의 기본키가 자식의 기본키 구성에 포함되는 관계다.

```text
CUSTOMER
PK customer_id
      ↓
ACCOUNT
PK customer_id + account_no
```

자식이 부모 없이 독립적인 식별자를 가지기 어려운 구조에서 사용될 수 있다.

## 비식별관계

부모의 키는 자식의 외래키로만 사용하고 자식은 자신의 기본키를 별도로 가진다.

```text
CUSTOMER
PK customer_id
      ↓ FK
ACCOUNT
PK account_id
FK customer_id
```

일반적인 업무 시스템에서는 엔티티를 독립적으로 식별하고 관리하기 편해 비식별관계를 많이 사용한다.

## 설계할 때 생각할 것

관계형 DB에서는 단순히 선을 연결하는 것보다 **누가 누구의 존재에 의존하는지**, **자식 데이터가 독립적으로 식별되어야 하는지**를 먼저 판단해야 한다.
