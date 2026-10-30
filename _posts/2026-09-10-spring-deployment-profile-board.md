---
layout: post
title: "Profile과 게시판 실습"
date: 2026-10-29 00:00:00 +0900
categories: [학습]
tags: [Spring Boot, Profile, JPA, Spring Security, Validation]
---

오늘은 Spring Boot의 Profile 설정을 확인하고, Spring Security와 JPA를 사용해 게시판 실습을 진행했다.

## Profile

개발 환경처럼 설정값이 달라지는 경우 Profile을 사용해 환경별 설정을 나눌 수 있다.

```text
application.yml
application-local.yml
application-test.yml
```

실행할 Profile에 따라 데이터베이스 주소나 기능 설정을 다르게 적용할 수 있다.

```yaml
spring:
  profiles:
    active: local
```

실습에서는 Profile을 이용해 설정 파일을 분리하는 구조와 실제 실행 시 어떤 설정이 적용되는지를 확인했다.

## 게시판 실습

게시판 기능은 회원 인증부터 게시글의 생성·조회·수정·삭제까지 하나의 흐름으로 연결했다.

```text
회원가입
  ↓
Spring Security 로그인
  ↓
게시글 작성
  ↓
작성자 연결
  ↓
수정 / 삭제
  ↓
권한 확인
```

게시글 수정과 삭제에서는 현재 로그인한 사용자가 해당 게시글의 작성자인지 확인하도록 구성했다. 로그인 여부만 확인하면 다른 사용자의 게시글까지 변경할 수 있기 때문에 인증과 별도로 권한 확인이 필요하다.

## Validation

입력값은 Controller에서 검증하고 잘못된 요청은 서비스 로직으로 넘어가기 전에 처리한다.

```java
@PostMapping("/posts")
public String create(@Valid @ModelAttribute PostForm form,
                     BindingResult bindingResult) {
    if (bindingResult.hasErrors()) {
        return "post/form";
    }

    postService.create(form);
    return "redirect:/posts";
}
```

`@Valid`는 객체의 검증 조건을 실행하고, `BindingResult`를 통해 검증 결과를 확인할 수 있다.

## 비밀번호와 트랜잭션

회원 비밀번호는 평문으로 저장하지 않고 BCrypt 같은 해시 방식으로 처리한다.

게시글 작성이나 수정처럼 여러 데이터 변경이 하나의 작업으로 묶여야 하는 경우에는 `@Transactional`을 사용해 트랜잭션 경계를 설정한다.

이번 실습에서는 실제 배포 환경을 구성한 것이 아니라 **Spring Boot에서 게시판 기능이 어떤 계층과 기술을 거쳐 동작하는지**에 집중했다.
