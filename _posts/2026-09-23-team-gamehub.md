---
layout: post
title: "팀 프로젝트 : GameHub — Servlet 기반 게임 커뮤니티"
date: 2026-09-23 09:00:00 +0900
categories: [프로젝트]
tags: [GameHub, Java, Servlet, Oracle, JDBC]
---

## 프로젝트 개요

Java Servlet과 Oracle을 이용해 구현한 게임 커뮤니티 프로젝트다.

게임 카테고리별 게시판을 제공하고 회원, 등급, 역할, 게시글, 댓글, 좋아요, 카테고리 관리자 기능까지 구현했다.

## 구조

```text
Browser
  ↓ HTTP / JSON
Servlet
  ↓
DAO / DTO
  ↓ JDBC
Oracle
```

Servlet이 요청을 처리하고 DTO로 데이터를 전달한 뒤 DAO가 SQL을 실행하는 구조로 개발했다.

## 주요 기능

- 회원가입 / 로그인
- 게임 카테고리 관리
- 게시글 / 댓글 CRUD
- 대댓글
- 좋아요 / 싫어요
- 회원 레벨
- 역할 기반 권한
- 카테고리 관리자 신청
- 카테고리 이용 제한

## 프로젝트에서 어려웠던 부분

기능이 늘어날수록 Servlet, DAO, DTO와 화면 코드가 서로 영향을 주기 쉬웠다. 팀에서는 `feature → develop → main` 흐름으로 브랜치를 나누고 기능별로 통합하는 방식을 사용했다.

특히 게시글·댓글·권한처럼 서로 연결되는 기능은 DB 관계와 요청 흐름을 먼저 정리한 뒤 구현해야 충돌을 줄일 수 있었다.

## 배운 점

Spring을 사용하기 전 Servlet과 JDBC를 직접 연결해 보면서 **웹 요청 → 서버 처리 → DB 조회 → 응답**이라는 기본 흐름을 이해할 수 있었다.
