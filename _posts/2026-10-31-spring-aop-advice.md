---
layout: post
title: "Spring AOP Advice와 Pointcut — 공통 로직 적용 범위 제어"
date: 2026-10-25 00:00:00 +0900
categories: [Spring]
tags: [Spring, AOP, Advice, Pointcut, Around]
---
## Advice의 실행 시점

AOP Advice는 대상 메서드 실행과 관련된 부가 동작을 정의한다.

| Advice | 동작 시점 |
|---|---|
| @Before | 대상 메서드 실행 전 |
| @AfterReturning | 정상 반환 후 |
| @AfterThrowing | 예외 발생 후 |
| @After | 성공·실패와 관계없이 종료 후 |
| @Around | 실행 전후를 직접 제어 |

@Around는 대상 메서드 실행을 감싸며 ProceedingJoinPoint.proceed()를 호출해야 실제 메서드가 실행된다.

## Pointcut으로 적용 대상을 제한한다

```java
@Aspect
@Component
class AuditAspect {
    @Before("execution(* com.example.application..*(..))")
    void beforeServiceCall(JoinPoint joinPoint) {
        log.info("method={}", joinPoint.getSignature());
    }
}
```

execution 표현식은 패키지, 클래스, 메서드, 인자 형태 등을 기준으로 적용 대상을 지정한다. 범위를 지나치게 넓게 잡으면 프레임워크 내부나 의도하지 않은 메서드까지 Advice가 적용될 수 있다.

## 로그와 예외 처리

공통 로깅은 편리하지만 요청 본문이나 인자 전체를 무조건 출력하면 개인정보와 토큰이 로그에 남을 수 있다. 필요한 식별자와 처리 시간만 기록하고 민감 정보는 마스킹한다.

@AfterThrowing에서 예외를 기록하더라도 예외를 삼켜 정상 처리로 바꾸지 않도록 한다. 장애 추적을 위해 원래 예외 전파 정책을 유지해야 한다.

## AOP를 쓰지 말아야 할 때

업무 규칙이나 상태 변경의 핵심 흐름을 AOP에 숨기면 실제 실행 경로를 파악하기 어려워진다. 반복되는 로깅, 성능 측정, 트랜잭션처럼 여러 계층에 횡단하는 기능에 한정해 사용하는 편이 좋다.

**정리:** AOP의 유지보수성은 적용 범위가 명확할 때 확보된다. Advice 종류와 Pointcut 표현식을 이해하고, 로그의 민감 정보와 예외 전파를 함께 설계한다.
