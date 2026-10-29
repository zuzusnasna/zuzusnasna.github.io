---
layout: post
title: "개인 프로젝트 : EMS — 장비 관리 시스템"
date: 2026-09-20 09:00:00 +0900
categories: [프로젝트]
tags: [EMS, Spring Boot, React, Oracle]
---

## 프로젝트 개요

제조 현장의 장비 정보를 등록하고 조회·수정·삭제하는 **장비 관리 시스템**을 구현했다.

### 주요 기능

- 장비 CRUD
- 장비명·유형·위치·상태 검색 및 필터링
- 공장별 장비 현황 대시보드
- 장비 상태 변경 이력 관리
- 로그인 및 세션 관리
- JUnit / Mockito 테스트
- Swagger / OpenAPI 문서화

## 기술 구성

- Backend: Java, Spring Boot, Spring Data JPA
- Database: Oracle
- Frontend: React, Vite
- Test: JUnit, Mockito
- API: REST, Swagger

## 프로젝트에서 중요하게 본 부분

단순 CRUD로 끝내지 않고 장비 상태가 변경될 때 **변경 전 상태, 변경 후 상태, 변경 사유, 변경 사용자, 변경 일시**를 별도 이력으로 남기도록 구성했다.

이 기능을 통해 현재 상태만 보는 것과 상태가 어떻게 변했는지 추적하는 것은 다른 요구사항이라는 점을 배웠다.

## 프로젝트에서 얻은 것

Spring Boot의 Controller → Service → Repository 흐름과 React → REST API 연결을 직접 구현하면서 웹 애플리케이션의 기본 구조를 잡을 수 있었다.
