---
layout: post
title: "MVC, REST API, Thymeleaf와 JPA 연관관계"
date: 2026-09-06 00:00:00 +0900
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

## 더 깊게 이해하기: 화면 렌더링과 API 응답은 다른 계약이다

서버 사이드 렌더링은 서버가 HTML을 만들어 브라우저에 전달한다. REST API는 보통 JSON과 HTTP 상태 코드를 반환하고, 화면 렌더링은 클라이언트가 담당한다. 둘 중 하나가 무조건 우수한 것이 아니라 화면 구성, 검색 엔진 노출, 프론트엔드 분리 정도, 배포 구조에 따라 선택이 달라진다.

HTTP 메서드도 역할에 맞게 사용해야 한다. 조회는 GET, 생성은 POST, 전체 교체는 PUT, 일부 변경은 PATCH, 삭제는 DELETE가 일반적인 의미다. 서버가 실제로 어떤 작업을 수행하는지와 메서드의 의미가 어긋나면 재시도나 캐시, API 문서에서 혼란이 생긴다.

### 설계 검토 질문
- 컨트롤러가 요청을 받고 서비스에 위임하며 응답을 만드는 책임을 분리했는가?
- 화면용 모델과 외부 API 응답 DTO가 서로의 변경에 불필요하게 영향을 주지 않는가?
- 성공·실패 상황에 맞는 상태 코드와 일관된 오류 응답을 반환하는가?
- Thymeleaf 템플릿에서 사용자 입력을 출력할 때 이스케이프 규칙을 지키는가?

컨트롤러 메서드를 늘리기 전에 사용자 흐름과 API 계약부터 정리하면, 화면 방식이 바뀌어도 비즈니스 로직을 재사용하기 쉽다.
