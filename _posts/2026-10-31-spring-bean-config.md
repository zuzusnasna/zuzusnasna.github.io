---
layout: post
title: "Spring Bean 등록 방식 — Component Scan과 Java Config의 선택"
date: 2026-10-31 09:10:00 +0900
categories: [Spring]
tags: [Spring, Bean, ComponentScan, Configuration, Bean Registration]
---
## Bean을 등록하는 두 가지 방식

Spring Bean은 컴포넌트 스캔으로 자동 등록하거나 @Configuration 클래스의 @Bean 메서드로 명시적으로 등록할 수 있다.

```java
@Service
public class MemberService {
}
```

@Component, @Service, @Repository, @Controller는 컴포넌트 스캔 대상이 되는 대표 애너테이션이다. @SpringBootApplication은 기본적으로 해당 클래스가 위치한 패키지와 하위 패키지를 스캔한다.

## Java Config

```java
@Configuration
public class ClientConfig {
    @Bean
    public ExternalClient externalClient() {
        return new ExternalClient("https://api.example.com");
    }
}
```

직접 수정할 수 없는 외부 라이브러리 객체나 생성 과정에 별도 설정이 필요한 객체는 @Bean 등록이 적합하다.

## 어떤 방식을 선택할까

- 애플리케이션 내부의 서비스·컴포넌트: @Component 계열
- 외부 라이브러리 객체: @Bean
- 환경에 따라 구현체를 바꿀 때: @Profile 또는 @Conditional 계열
- 설정값을 객체로 묶을 때: @ConfigurationProperties

## Component Scan에서 자주 발생하는 문제

패키지 위치가 스캔 범위 밖이면 Bean을 찾지 못한다. 반대로 스캔 범위를 너무 넓히면 의도하지 않은 Bean이 등록될 수 있다. 애플리케이션 진입 클래스를 공통 최상위 패키지에 두고 기능별 하위 패키지로 구조화하는 것이 관리하기 쉽다.

동일 타입 Bean이 여러 개 등록되면 NoUniqueBeanDefinitionException이 발생할 수 있다. 이때 무조건 @Primary를 붙이기보다 어떤 구현이 기본인지, 각 구현을 어디서 사용할지 명확히 정한다.

**정리:** 자동 스캔은 내부 컴포넌트 등록에 편리하고 Java Config는 생성 과정을 명시해야 하는 객체에 적합하다. 등록 방식보다 Bean의 범위와 선택 기준이 중요하다.
