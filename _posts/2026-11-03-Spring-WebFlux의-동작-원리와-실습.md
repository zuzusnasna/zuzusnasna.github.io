---
layout: post
title: "Spring WebFlux의 동작 원리와 실습"
date: 2026-11-03 00:00:00 +0900
categories: ["Spring"]
section: spring-ai
tags: ["Spring", "Spring Boot", "WebFlux", "Reactive", "Mono", "Flux", "Thymeleaf", "SSE"]
---
# Spring WebFlux의 동작 원리와 실습

## 1. Spring Boot 웹 애플리케이션의 기본 동작

일반적인 Spring Boot 웹 프로그램은 사용자의 요청을 Controller가 받아 처리한 후 응답을 반환한다.

간단한 예제를 보면 다음과 같다.

```java
@GetMapping("/member")
public String member() {
    return "홍길동";
}
```

사용자가 `/member`를 요청하면 Controller가 `"홍길동"`을 반환한다.

실제 애플리케이션에서는 데이터베이스에서 회원 정보를 조회하는 등의 작업이 추가된다.

```java
@GetMapping("/member")
public Member member() {
    return memberService.findById(1L);
}
```

실제 처리 흐름은 다음과 같다.

```text
사용자
  ↓
HTTP 요청
  ↓
Controller
  ↓
Service
  ↓
Repository / MyBatis
  ↓
Database
  ↓
응답
```

여기서 DB 조회처럼 **처리가 완료될 때까지 기다려야 하는 작업**이 발생한다.

이것을 이해하기 위해 먼저 Blocking과 Non-Blocking의 차이를 알아야 한다.

---

# 2. Blocking과 Non-Blocking

## 2.1 Blocking이란?

**Blocking은 특정 작업이 끝날 때까지 현재 스레드가 기다리는 것**이다.

예를 들어 JDBC 또는 MyBatis를 이용하여 DB를 조회한다고 하자.

```java
Member member = memberMapper.findById(1L);
```

DB 조회에 3초가 걸린다면 해당 코드를 실행한 스레드는 DB 응답이 올 때까지 기다린다.

```text
Thread
  │
  ├── DB 요청
  │
  ├── 기다림 ───────────────┐
  │                         │
  │                         │ 3초
  │                         │
  └── 결과 수신 ←───────────┘
```

중요한 점은 **Spring MVC 서버 전체가 멈추는 것은 아니라는 것**이다.

Spring MVC는 여러 요청을 여러 스레드가 처리하므로 다른 스레드는 다른 사용자의 요청을 처리할 수 있다.

### 식당으로 비유하면

```text
직원
 ↓
손님 주문 접수
 ↓
주방에 주문 전달
 ↓
음식이 나올 때까지 기다림
 ↓
음식 전달
```

직원이 음식이 나올 때까지 다른 일을 하지 못하는 상황과 비슷하다.

---

# 3. Non-Blocking이란?

**Non-Blocking은 작업의 완료를 기다리는 동안 현재 스레드를 붙잡아 두지 않는 방식**이다.

식당 직원이 주문을 주방에 전달한 후 음식이 준비되는 동안 다른 손님의 주문을 받는 상황으로 생각할 수 있다.

```text
직원
 │
 ├── 손님 A 주문
 │
 ├── 주방에 전달
 │
 ├── 손님 B 주문
 │
 ├── 손님 C 주문
 │
 └── A 음식 완성 → 전달
```

즉, I/O 작업이 완료될 때까지 스레드가 대기하지 않고 다른 작업을 처리할 수 있다.

WebFlux의 핵심은 바로 이 **논블로킹 I/O를 이용하여 스레드가 I/O 대기에 묶이는 것을 줄이는 것**이다.

---

# 4. Spring WebFlux란?

**Spring WebFlux는 비동기·논블로킹 방식의 웹 애플리케이션을 개발할 수 있도록 제공되는 Spring의 리액티브 웹 프레임워크이다.**

Spring MVC와 비교하면 다음과 같다.

| 구분 | Spring MVC | Spring WebFlux |
|---|---|---|
| 기본 처리 모델 | 동기·블로킹 중심 | 비동기·논블로킹 중심 |
| 서버 모델 | 요청당 스레드 모델 | 이벤트 루프 기반 |
| 단일 데이터 | `Member` | `Mono<Member>` |
| 여러 데이터 | `List<Member>` | `Flux<Member>` |
| 주요 활용 | 일반적인 CRUD | 스트리밍, 대규모 동시 I/O |
| 대표 기술 | Servlet / Tomcat | Reactive / Netty |

단, WebFlux가 **항상 Spring MVC보다 빠르다는 의미는 아니다.**

특히 일반적인 CRUD 애플리케이션에서는 성능 차이가 크지 않을 수 있다.

WebFlux의 장점은 **동시 요청이 많고 I/O 대기 시간이 긴 상황에서 스레드를 효율적으로 활용할 수 있다는 것**이다.

---

# 5. WebFlux의 핵심 개념 — Mono와 Flux

WebFlux에서는 Reactor에서 제공하는 `Mono`와 `Flux`를 사용한다.

## 5.1 Mono

`Mono`는 **0개 또는 1개의 데이터**를 발행한다.

기존 Java 코드에서는 다음과 같이 표현할 수 있다.

```java
String name = "홍길동";
```

Reactor에서는 다음과 같이 표현한다.

```java
Mono<String> name = Mono.just("홍길동");
```

### 구독하기

```java
Mono<String> mono = Mono.just("홍길동");

mono.subscribe(data -> {
    System.out.println(data);
});
```

결과:

```text
홍길동
```

`subscribe()`는 데이터가 발행될 때 실행할 동작을 등록한다.

---

## 5.2 Flux

`Flux`는 **0개부터 여러 개의 데이터**를 발행한다.

기존 Java에서는 다음과 같이 여러 데이터를 표현할 수 있다.

```java
List<String> names =
        List.of("홍길동", "김철수", "이영희");
```

Flux에서는 다음과 같이 표현한다.

```java
Flux<String> names =
        Flux.just("홍길동", "김철수", "이영희");
```

구독하면 각각의 데이터가 순차적으로 전달된다.

```java
names.subscribe(data -> {
    System.out.println(data);
});
```

결과:

```text
홍길동
김철수
이영희
```

---

# 6. Mono와 Flux의 차이

| 타입 | 데이터 개수 | 예시 |
|---|---:|---|
| `Mono<T>` | 0~1개 | 회원 한 명 조회 |
| `Flux<T>` | 0~N개 | 회원 목록 조회 |

예를 들어 회원 한 명을 조회한다면:

```java
Mono<Member> findMember(Long id)
```

여러 명의 회원을 조회한다면:

```java
Flux<Member> findMembers()
```

기존 코드와 비교하면 다음과 같다.

```text
기존 Spring MVC

Member
List<Member>


Spring WebFlux

Mono<Member>
Flux<Member>
```

---

# 7. Mono와 Flux 주요 연산

초급 단계에서는 `just()`, `map()`, `filter()`를 우선 이해하면 된다.

| 메서드 | 의미 |
|---|---|
| `just()` | 데이터를 발행 |
| `map()` | 데이터를 다른 형태로 변환 |
| `filter()` | 조건에 맞는 데이터만 통과 |

예제:

```java
Flux<Integer> numbers =
        Flux.just(1, 2, 3, 4, 5);

numbers
        .filter(n -> n % 2 == 0)
        .map(n -> n * 10)
        .subscribe(System.out::println);
```

처리 과정:

```text
1 → 홀수 → 제거
2 → 짝수 → ×10 → 20
3 → 홀수 → 제거
4 → 짝수 → ×10 → 40
5 → 홀수 → 제거
```

결과:

```text
20
40
```

---

# 8. WebFlux 실시간 데이터 스트리밍

WebFlux의 특징을 확인하기 좋은 예제가 스트리밍이다.

다음 Controller는 1초마다 데이터를 생성한다.

```java
@GetMapping(
        value = "/clock",
        produces = MediaType.TEXT_EVENT_STREAM_VALUE
)
public Flux<String> clock() {

    return Flux.interval(Duration.ofSeconds(1))
            .map(n -> "현재 카운트: " + n)
            .take(5);
}
```

## 코드 분석

### `Flux.interval()`

```java
Flux.interval(Duration.ofSeconds(1))
```

1초마다 숫자를 생성한다.

```text
0
1
2
3
4
...
```

### `map()`

```java
.map(n -> "현재 카운트: " + n)
```

숫자를 문자열로 변환한다.

### `take(5)`

```java
.take(5)
```

5개의 데이터만 발행하고 종료한다.

### 전체 결과

```text
1초 후 → 현재 카운트: 0
2초 후 → 현재 카운트: 1
3초 후 → 현재 카운트: 2
4초 후 → 현재 카운트: 3
5초 후 → 현재 카운트: 4
```

---

# 9. TEXT_EVENT_STREAM과 SSE

```java
produces = MediaType.TEXT_EVENT_STREAM_VALUE
```

는 서버가 데이터를 한 번에 모두 반환하는 것이 아니라 **이벤트 스트림 형태로 순차적으로 전달한다는 의미**이다.

이러한 방식을 SSE(Server-Sent Events)라고 한다.

클라이언트에서는 `EventSource`를 이용해 서버의 이벤트를 받을 수 있다.

```javascript
const eventSource = new EventSource("/clock");

eventSource.onmessage = function(event) {
    console.log(event.data);
};
```

서버가 데이터를 생성할 때마다 클라이언트에서 메시지를 받을 수 있다.

---

# 10. WebFlux 성능의 핵심

WebFlux를 공부할 때 가장 중요한 부분이다.

Spring MVC도 멀티스레드 기반이기 때문에 여러 사용자의 요청을 동시에 처리할 수 있다.

예를 들어 Tomcat의 요청 처리 스레드가 200개라고 가정하자.

동시에 1,000명의 사용자가 요청하면 모든 요청을 한 번에 1,000개의 스레드가 처리하는 것이 아니다.

일부 요청은 스레드를 할당받아 처리하고, 나머지는 대기하게 된다.

그런데 여기서 중요한 문제가 있다.

하나의 요청이 다음과 같이 처리된다고 가정해 보자.

```text
Java 비즈니스 로직 : 10ms
DB 조회 대기       : 490ms
-------------------------
전체 처리 시간     : 500ms
```

스레드는 실제 CPU 연산보다 **DB 응답을 기다리는 시간에 훨씬 오래 머무른다.**

---

# 11. Spring MVC와 WebFlux의 차이

Spring MVC에서는 다음과 같은 상황이 발생할 수 있다.

```text
Thread 1
 └─ DB 요청
     └─ 490ms 동안 대기

Thread 2
 └─ DB 요청
     └─ 490ms 동안 대기

Thread 3
 └─ DB 요청
     └─ 490ms 동안 대기
```

스레드가 DB 응답을 기다리고 있다.

반면 논블로킹 WebFlux에서는 I/O 작업이 완료되기를 기다리는 동안 다른 작업을 처리할 수 있다.

```text
Event Loop
 │
 ├─ 요청 A → DB 요청 → 대기하지 않고 다른 작업
 │
 ├─ 요청 B → 외부 API 요청
 │
 ├─ 요청 C → 다른 작업
 │
 └─ 요청 A DB 응답 도착 → 후속 처리
```

따라서 WebFlux의 핵심은 단순히 **스레드가 적다는 것**이 아니다.

> **I/O 대기 때문에 스레드가 묶이는 것을 줄이는 것**

이것이 핵심이다.

---

# 12. Spring MVC와 WebFlux를 언제 사용할까?

| 환경 | Spring MVC | Spring WebFlux |
|---|---|---|
| 동시 사용자 10~50명 | 적합 | 큰 차이 없을 수 있음 |
| 일반적인 CRUD | 적합 | 큰 이점이 없을 수 있음 |
| MyBatis + JDBC | 적합 | 블로킹으로 장점 감소 |
| 외부 API 대기 2~3초 | 스레드 점유 증가 | 논블로킹 구조라 유리할 수 있음 |
| 수천 개의 동시 I/O | 스레드 부담 증가 가능 | 효율적일 수 있음 |
| CPU 연산 중심 | 적합 | 특별한 이점 없음 |
| SSE / 스트리밍 | 가능 | 적합 |
| AI 응답 스트리밍 | 가능 | 적합 |

---

# 13. 스레드를 늘리면 되지 않을까?

Spring MVC에서 요청을 처리하는 스레드 수를 늘리는 방법도 있다.

예를 들어:

```text
기존 → 200개
변경 → 500개
```

스레드가 많아지면 동시에 처리할 수 있는 요청이 증가할 수 있다.

하지만 스레드 수를 무작정 늘리는 것이 해결책은 아니다.

스레드가 증가하면 다음과 같은 비용도 증가한다.

- 메모리 사용량 증가
- 스레드 스케줄링 비용 증가
- 컨텍스트 스위칭 비용 증가

따라서 적절한 스레드 수를 설정해야 한다.

---

# 14. Java 21 Virtual Thread

Java 21부터는 **Virtual Thread(가상 스레드)**를 사용할 수 있다.

가상 스레드는 기존 플랫폼 스레드보다 훨씬 가볍게 많은 동시 작업을 처리할 수 있도록 만들어진 스레드이다.

따라서 현재의 Spring 애플리케이션에서는 단순히

```text
Spring MVC vs WebFlux
```

만 비교할 필요가 없다.

다음 세 가지를 함께 고려할 수 있다.

```text
① Spring MVC + 플랫폼 스레드

② Spring MVC + Virtual Thread

③ Spring WebFlux + 논블로킹 I/O
```

특히 기존의 동기식 코드 구조를 유지하면서 많은 동시 I/O 요청을 처리해야 한다면 Virtual Thread도 좋은 선택지가 될 수 있다.

---

# 15. Spring Boot + MyBatis에서는?

현재 많이 사용하는 다음과 같은 구조를 생각해 보자.

```text
Spring Boot
    ↓
MyBatis
    ↓
JDBC
    ↓
MySQL / Oracle
```

MyBatis와 JDBC는 기본적으로 블로킹 방식으로 DB에 접근한다.

따라서 Controller만 WebFlux 방식으로 변경한다고 해서 DB 조회가 자동으로 논블로킹이 되는 것은 아니다.

예를 들어:

```java
@GetMapping("/member")
public Mono<Member> member() {

    Member member =
            memberMapper.findById(1L);

    return Mono.just(member);
}
```

겉으로는 `Mono<Member>`를 반환하지만 실제 DB 조회는 이미 블로킹 방식으로 실행되었다.

즉,

```text
Mono를 사용한다
        ≠
모든 작업이 논블로킹이다
```

이것은 WebFlux에서 매우 중요한 개념이다.

---

# 16. WebFlux를 사용하기 좋은 경우

다음과 같은 상황에서는 WebFlux 도입을 고려할 수 있다.

### 여러 외부 API 호출

```text
Spring Boot
   ├── 외부 API A
   ├── 외부 API B
   └── 외부 API C
```

많은 I/O 요청을 동시에 처리해야 하는 경우 논블로킹 구조의 장점을 활용할 수 있다.

### 실시간 스트리밍

```text
서버
 ↓
데이터 1
 ↓
데이터 2
 ↓
데이터 3
 ↓
데이터 4
```

SSE와 같은 실시간 데이터 전송에 적합하다.

### Spring AI 스트리밍

AI 모델의 응답을 한 번에 받는 대신 생성되는 텍스트를 순차적으로 사용자에게 전달하는 경우 WebFlux의 리액티브 스트림을 활용할 수 있다.

---

# 17. WebFlux + Thymeleaf 실습

WebFlux가 Controller뿐만 아니라 Thymeleaf와 함께 사용되는 예제를 만들어 보자.

프로젝트 구조:

```text
webflux-thymeleaf/
│
├── src/main/java/com/example/demo/
│   ├── DemoApplication.java
│   │
│   └── controller/
│       ├── PageController.java
│       └── StreamController.java
│
├── src/main/resources/
│   ├── templates/
│   │   └── index.html
│   │
│   └── application.properties
│
└── build.gradle
```

---

# 18. build.gradle

```gradle
plugins {
    id 'java'
    id 'org.springframework.boot' version '3.5.7'
    id 'io.spring.dependency-management' version '1.1.7'
}

group = 'com.example'
version = '0.0.1-SNAPSHOT'

java {
    toolchain {
        languageVersion = JavaLanguageVersion.of(17)
    }
}

repositories {
    mavenCentral()
}

dependencies {
    implementation 'org.springframework.boot:spring-boot-starter-webflux'
    implementation 'org.springframework.boot:spring-boot-starter-thymeleaf'

    testImplementation 'org.springframework.boot:spring-boot-starter-test'
    testImplementation 'io.projectreactor:reactor-test'
}

tasks.named('test') {
    useJUnitPlatform()
}
```

핵심 의존성은 다음 두 가지이다.

```gradle
implementation 'org.springframework.boot:spring-boot-starter-webflux'
implementation 'org.springframework.boot:spring-boot-starter-thymeleaf'
```

---

# 19. application.properties

```properties
spring.application.name=webflux-thymeleaf
server.port=8080

spring.thymeleaf.prefix=classpath:/templates/
spring.thymeleaf.suffix=.html
spring.thymeleaf.cache=false
```

Thymeleaf 템플릿은 다음 위치에 저장한다.

```text
src/main/resources/templates/
```

---

# 20. PageController

Thymeleaf 화면을 반환하는 Controller이다.

```java
package com.example.demo.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class PageController {

    @GetMapping("/")
    public String index() {
        return "index";
    }
}
```

`return "index"`는 다음 파일을 찾는다는 의미이다.

```text
src/main/resources/templates/index.html
```

여기서 중요한 점은 **WebFlux를 사용하더라도 일반적인 Thymeleaf Controller 작성 방식은 크게 달라지지 않는다.**

---

# 21. StreamController

이번에는 WebFlux의 `Flux`를 사용해 실시간 데이터를 전송한다.

```java
package com.example.demo.controller;

import java.time.Duration;

import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import reactor.core.publisher.Flux;

@RestController
public class StreamController {

    @GetMapping(
        value = "/stream",
        produces = MediaType.TEXT_EVENT_STREAM_VALUE
    )
    public Flux<String> stream() {

        return Flux.interval(Duration.ofSeconds(1))
                .map(i -> "서버 메시지 " + (i + 1) + " 도착")
                .take(5);
    }
}
```

### 코드 분석

```java
Flux.interval(Duration.ofSeconds(1))
```

1초마다 데이터를 생성한다.

```java
.map(i -> "서버 메시지 " + (i + 1) + " 도착")
```

숫자를 화면에 표시할 문자열로 변환한다.

```java
.take(5)
```

5개의 메시지만 전송한다.

```java
produces = MediaType.TEXT_EVENT_STREAM_VALUE
```

SSE 방식으로 데이터를 스트리밍한다.

---

# 22. index.html

`src/main/resources/templates/index.html`

```html
<!DOCTYPE html>
<html xmlns:th="http://www.thymeleaf.org" lang="ko">
<head>
    <meta charset="UTF-8">
    <title>WebFlux + Thymeleaf 실습</title>
</head>

<body>

<h2>Spring WebFlux 실시간 메시지</h2>

<p>
    서버에서 1초마다 데이터를 전송합니다.
</p>

<button onclick="startStream()">
    스트리밍 시작
</button>

<button onclick="stopStream()">
    중지
</button>

<div id="messages"></div>

<script>

    let eventSource = null;

    function startStream() {

        stopStream();

        document.getElementById("messages").innerHTML = "";

        eventSource = new EventSource("/stream");

        eventSource.onmessage = function(event) {

            const div = document.createElement("div");

            div.textContent = event.data;

            document.getElementById("messages")
                    .appendChild(div);
        };

        eventSource.onerror = function() {
            stopStream();
        };
    }

    function stopStream() {

        if (eventSource !== null) {
            eventSource.close();
            eventSource = null;
        }
    }

</script>

</body>
</html>
```

---

# 23. 전체 동작 흐름

브라우저에서 `/`에 접속하면 다음과 같이 동작한다.

```text
브라우저
   │
   │ GET /
   ↓
PageController
   │
   ↓
index.html
   │
   │ 스트리밍 시작 버튼
   ↓
EventSource("/stream")
   │
   ↓
StreamController
   │
   ↓
Flux.interval()
   │
   ├── 1초 → 서버 메시지 1
   ├── 2초 → 서버 메시지 2
   ├── 3초 → 서버 메시지 3
   ├── 4초 → 서버 메시지 4
   └── 5초 → 서버 메시지 5
```

즉, HTML 화면 자체는 Thymeleaf가 담당하고 실시간 데이터 전달은 WebFlux + SSE가 담당한다.

---

# 24. curl로 스트리밍 확인

서버를 실행한 후 다음 명령을 사용할 수 있다.

```bash
curl -N http://localhost:8080/stream
```

`-N` 옵션을 사용하면 버퍼링을 줄여 스트리밍 데이터를 즉시 확인할 수 있다.

예상 결과:

```text
data:서버 메시지 1 도착

data:서버 메시지 2 도착

data:서버 메시지 3 도착

data:서버 메시지 4 도착

data:서버 메시지 5 도착
```

---

# 25. Spring MVC와 WebFlux + Thymeleaf 비교

| 항목 | Spring MVC + Thymeleaf | WebFlux + Thymeleaf |
|---|---|---|
| HTML 화면 | Thymeleaf | Thymeleaf |
| Controller | `@Controller` | `@Controller` |
| REST Controller | `@RestController` | `@RestController` |
| 일반 반환값 | 객체, String | `Mono`, `Flux` 등 |
| 데이터 처리 | 동기·블로킹 중심 | 비동기·논블로킹 중심 |
| 실시간 스트리밍 | 구현 가능 | 리액티브 방식으로 구현하기 좋음 |
| SSE | 지원 | 적합 |
| DB 접근 | JDBC / JPA / MyBatis | 논블로킹 드라이버 사용 시 리액티브 처리 |
| 서버 모델 | Servlet 기반 | Reactive 기반 |

---

# 26. 핵심 정리

### Blocking

작업이 끝날 때까지 현재 스레드가 기다리는 방식이다.

```text
작업 시작
   ↓
기다림
   ↓
작업 완료
   ↓
다음 작업
```

### Non-Blocking

작업 완료를 기다리는 동안 현재 스레드를 다른 작업에 활용할 수 있는 방식이다.

```text
작업 시작
   ↓
다른 작업 수행
   ↓
작업 완료
   ↓
후속 처리
```

### Spring WebFlux

비동기·논블로킹 기반의 리액티브 웹 프레임워크이다.

### Mono

```text
0 ~ 1개의 데이터
```

```java
Mono<Member>
```

회원 한 명 조회와 같은 작업에 사용할 수 있다.

### Flux

```text
0 ~ N개의 데이터
```

```java
Flux<Member>
```

여러 회원이나 스트리밍 데이터에 사용할 수 있다.

---

# 27. 가장 중요한 포인트

WebFlux를 공부할 때 다음 내용을 구분해야 한다.

```text
WebFlux 사용
      ≠
자동으로 모든 작업이 논블로킹
```

예를 들어:

```java
Mono<Member> member() {

    Member member =
            memberMapper.findById(1L);

    return Mono.just(member);
}
```

Controller의 반환 타입은 `Mono`이지만 MyBatis의 DB 조회는 블로킹 방식이다.

따라서 실제 논블로킹 구조를 만들려면 DB, HTTP 클라이언트 등 **I/O를 수행하는 부분까지 논블로킹 기술을 사용해야 한다.**

---

# 28. 어떤 기술을 선택할까?

```text
일반적인 Spring Boot CRUD
        ↓
Spring MVC
        ↓
JPA / MyBatis / JDBC
```

대부분의 일반적인 웹 서비스에서는 이 구조만으로 충분하다.

반면:

```text
대규모 동시 I/O
        ↓
Spring WebFlux
        ↓
논블로킹 HTTP Client
        ↓
논블로킹 DB Driver
        ↓
SSE / Streaming
```

과 같은 환경에서는 WebFlux의 장점을 활용할 수 있다.

그리고 Java 21 이상에서는 다음과 같은 선택지도 함께 고려할 수 있다.

```text
Spring MVC + Virtual Thread
```

따라서 **"WebFlux가 MVC보다 무조건 좋다"가 아니라 애플리케이션의 I/O 특성과 동시성 요구사항에 따라 선택하는 것**이 핵심이다.
---

## 한 줄 정리

> **Spring MVC는 요청을 처리하는 스레드가 I/O 작업을 기다리는 구조에 적합하고, Spring WebFlux는 논블로킹 I/O를 기반으로 많은 동시 요청이나 스트리밍을 효율적으로 처리하기 위한 프레임워크이다.**