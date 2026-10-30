---
layout: post
title: "Spring MVC — Controller, Service, Repository의 역할"
date: 2026-10-30 15:20:00 +0900
categories: [Spring]
tags: [Spring, MVC]
---

오늘은 Spring에서 HTTP 요청을 처리할 때 Controller, Service, Repository를 어떻게 나누는지 정리했다.

## 1. Controller

Controller는 HTTP 요청을 받고 필요한 기능을 호출하는 역할을 한다.

```java
@RestController
@RequestMapping("/members")
public class MemberController {
    private final MemberService service;

    public MemberController(MemberService service) {
        this.service = service;
    }

    @GetMapping("/{id}")
    public Member find(@PathVariable Long id) {
        return service.find(id);
    }
}
```

Controller에서 직접 SQL을 실행하지 않고 Service를 호출한다.

## 2. Service

Service는 비즈니스 로직을 담당한다.

```java
@Service
public class MemberService {
    private final MemberMapper mapper;

    public MemberService(MemberMapper mapper) {
        this.mapper = mapper;
    }

    public Member find(Long id) {
        Member member = mapper.findById(id);

        if (member == null) {
            throw new IllegalArgumentException("회원이 없습니다.");
        }

        return member;
    }
}
```

## 3. Repository / Mapper

DB 접근을 담당한다. MyBatis를 사용한다면 Mapper가 이 역할을 맡을 수 있다.

```java
@Mapper
public interface MemberMapper {
    Member findById(Long id);
}
```

요청 흐름은 다음처럼 볼 수 있다.

```text
Client
 ↓
Controller
 ↓
Service
 ↓
Mapper / Repository
 ↓
Database
```

응답은 반대 방향으로 올라온다.

각 계층이 자기 역할을 담당하도록 나누면 Controller에 요청 처리, 비즈니스 로직, DB 접근 코드가 한꺼번에 들어가는 것을 막을 수 있다.
