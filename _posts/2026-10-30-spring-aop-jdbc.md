---
layout: post
title: "Spring AOP와 JDBC — 공통 기능과 DB 접근"
date: 2026-10-23 00:00:00 +0900
categories: [Spring]
tags: [Spring, AOP, JDBC]
---

오늘은 여러 곳에서 반복되는 기능을 분리하는 AOP와 Spring JDBC의 기본 사용법을 정리했다.

## 1. AOP

AOP는 Aspect Oriented Programming, 관점 지향 프로그래밍이다.

서비스마다 반복되는 로그, 트랜잭션, 실행 시간 측정 같은 공통 기능을 별도로 분리할 수 있다.

예를 들어 모든 서비스의 실행 시간을 직접 측정하면 다음 코드가 반복된다.

```java
long start = System.currentTimeMillis();

service();

long end = System.currentTimeMillis();
```

AOP에서는 공통 로직을 Aspect로 분리한다.

```java
@Aspect
@Component
public class TimeAspect {
    @Around("execution(* com.example.service..*(..))")
    public Object measure(ProceedingJoinPoint joinPoint)
            throws Throwable {

        long start = System.currentTimeMillis();
        Object result = joinPoint.proceed();
        long end = System.currentTimeMillis();

        System.out.println(
            joinPoint.getSignature() + " : " +
            (end - start) + "ms"
        );

        return result;
    }
}
```

서비스 코드에 실행 시간 측정 코드를 직접 넣지 않아도 공통 기능을 적용할 수 있다.

## 2. Spring JDBC

Spring JDBC에서는 `JdbcTemplate`을 이용해 DB 접근 코드를 간결하게 작성할 수 있다.

```java
@Repository
public class MemberRepository {
    private final JdbcTemplate jdbcTemplate;

    public MemberRepository(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    public int count() {
        return jdbcTemplate.queryForObject(
            "SELECT COUNT(*) FROM member",
            Integer.class
        );
    }
}
```

직접 JDBC를 사용하면 Connection, PreparedStatement, ResultSet 등의 반복 코드를 직접 관리해야 하지만 `JdbcTemplate`이 이런 반복 작업을 줄여준다.

## 3. JDBC와 MyBatis

둘 다 DB에 접근하지만 방식은 다르다.

```text
JDBC
→ Java에서 DB 작업을 직접 처리

Spring JDBC
→ JdbcTemplate으로 JDBC 반복 작업을 줄임

MyBatis
→ SQL을 직접 작성하고 Mapper로 연결
```

복잡한 SQL을 직접 제어해야 하면 MyBatis가 편할 수 있고, 단순한 JDBC 작업을 간결하게 처리하려면 `JdbcTemplate`을 사용할 수 있다.
