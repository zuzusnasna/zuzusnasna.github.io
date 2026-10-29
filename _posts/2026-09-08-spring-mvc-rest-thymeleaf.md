---
layout: post
title: "Spring Boot 학습 : MVC, REST API, Thymeleaf와 JPA 연관관계"
date: 2026-09-08 09:00:00 +0900
categories: [학습]
tags: [Spring Boot, Spring MVC, REST API, Thymeleaf, JPA]
---

## Spring MVC

웹 요청을 Controller가 받고 필요한 서비스를 호출한 뒤 View 또는 데이터를 반환하는 구조를 익혔다.

## REST API

화면과 서버를 분리하면 서버는 JSON 형태의 데이터를 제공하고 React 같은 프론트엔드가 이를 사용한다.

```text
React
  ↓ HTTP / JSON
Spring Controller
  ↓
Service
  ↓
Repository
```

## Thymeleaf

서버에서 HTML을 렌더링하는 템플릿 엔진이다. Spring MVC와 함께 사용하면 서버 사이드 렌더링 구조를 이해하는 데 도움이 됐다.

## JPA 연관관계

객체의 참조와 DB의 외래키를 연결하면서 `@ManyToOne`, `@OneToMany` 등의 매핑을 학습했다.

이후 React + REST API 프로젝트를 만들 때도 서버와 화면의 책임을 분리하는 기준이 이때 잡혔다.
