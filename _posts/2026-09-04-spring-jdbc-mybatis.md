---
layout: post
title: "Spring Boot 학습 : JDBC와 MyBatis 비교"
date: 2026-09-04 09:00:00 +0900
categories: [학습]
tags: [Spring Boot, JDBC, MyBatis, Database]
---

DB 접근 기술을 비교하면서 JDBC와 MyBatis가 어떤 문제를 해결하는지 정리했다.

## JDBC

Java 코드에서 SQL을 직접 실행하고 `ResultSet`을 통해 결과를 받아 객체로 변환한다.

장점은 동작 원리가 명확하다는 것이지만 반복 코드가 많아진다.

## MyBatis

SQL을 별도로 관리하면서 Java 객체와 결과를 연결해 JDBC의 반복 작업을 줄인다.

## 정리

```text
JDBC
Java → SQL → ResultSet → 객체 변환

MyBatis
Java → Mapper → SQL → 객체 매핑
```

DB 접근을 추상화하더라도 결국 SQL과 데이터베이스 동작을 이해해야 한다는 점을 배웠다.
