---
layout: post
title: "Spring AI 다중 메시지와 Chat Memory"
date: 2026-11-03 00:00:00 +0900
categories: ["Spring"]
section: spring-ai
tags: ["Spring", "Spring Boot", "Spring AI", "ChatClient", "Chat Memory", "Session", "LLM"]
---
# Spring AI 다중 메시지와 Chat Memory

## 1. Chat Memory란?

일반적인 AI API 호출은 사용자의 질문을 전달하고 응답을 받는 방식으로 동작한다.

```java
String response = chatClient.prompt()
        .user("내 이름은 홍길동이야.")
        .call()
        .content();
```

이후 다시 다음 질문을 전달한다고 가정해 보자.

```java
String response = chatClient.prompt()
        .user("내 이름이 뭐야?")
        .call()
        .content();
```

이 경우 AI가 이전 질문을 자동으로 기억한다고 보장할 수 없다.

일반적으로 LLM은 요청에 포함된 메시지를 기반으로 답변하기 때문이다.

따라서 이전 대화 내용을 다음 요청에도 함께 전달해야 한다.

이때 사용하는 개념이 **Chat Memory(대화 기록)**이다.

Chat Memory는 이전에 주고받은 메시지를 저장하고, 새로운 질문을 전달할 때 기존 대화 내용을 함께 제공하는 기능이다.

```text
첫 번째 질문
    ↓
AI 응답
    ↓
대화 기록 저장
    ↓
두 번째 질문
    ↓
이전 대화 기록 + 새로운 질문
    ↓
AI 응답
```

---

## 2. Spring AI의 메시지 종류

Spring AI에서는 대화 내용을 역할에 따라 구분하여 전달한다.

주요 메시지 종류는 다음과 같다.

| 메시지 | 역할 | 설명 |
|---|---|---|
| `SystemMessage` | 시스템 | AI의 역할과 답변 방식 지정 |
| `UserMessage` | 사용자 | 사용자가 전달하는 질문 |
| `AssistantMessage` | AI | AI가 생성한 응답 |

### 2-1. SystemMessage

AI가 어떤 역할을 수행하고 어떤 방식으로 답변해야 하는지 지정한다.

```java
SystemMessage systemMessage =
        new SystemMessage("당신은 친절한 Java 강사입니다.");
```

예를 들어 다음과 같이 설정할 수 있다.

- Java와 Spring을 전문적으로 설명하는 강사
- 초보자도 이해할 수 있도록 쉽게 설명
- 코드 예제를 함께 제공
- 불필요한 설명은 줄이고 핵심 위주로 답변

SystemMessage는 AI의 응답 방향을 설정하는 역할을 한다.

### 2-2. UserMessage

사용자가 AI에게 전달하는 실제 질문이다.

```java
UserMessage userMessage =
        new UserMessage("Spring Boot란 무엇인가요?");
```

사용자가 입력한 질문이나 요청이 UserMessage에 해당한다.

### 2-3. AssistantMessage

AI 모델이 생성한 응답이다.

```java
AssistantMessage assistantMessage =
        new AssistantMessage("Spring Boot는 Spring 기반의 애플리케이션 개발을 간편하게 해주는 프레임워크입니다.");
```

AI가 답변한 내용을 다시 대화 기록에 저장할 때 사용한다.

---

## 3. 여러 메시지를 함께 전달하기

LLM에 질문 하나만 전달하는 것이 아니라 여러 메시지를 하나의 대화 기록으로 전달할 수 있다.

```java
List<Message> messages = new ArrayList<>();

messages.add(
    new SystemMessage("당신은 Java 전문 강사입니다.")
);

messages.add(
    new UserMessage("Java가 무엇인가요?")
);

messages.add(
    new AssistantMessage("Java는 객체지향 프로그래밍 언어입니다.")
);

messages.add(
    new UserMessage("그렇다면 객체지향이란 무엇인가요?")
);
```

이렇게 구성하면 LLM은 다음과 같은 대화 흐름을 전달받는다.

```text
[System]
당신은 Java 전문 강사입니다.

[User]
Java가 무엇인가요?

[Assistant]
Java는 객체지향 프로그래밍 언어입니다.

[User]
그렇다면 객체지향이란 무엇인가요?
```

LLM은 전달받은 메시지의 역할과 내용을 바탕으로 답변을 생성한다.

즉, 이전 대화 내용을 함께 전달하면 앞선 대화와 연결되는 답변을 만들 수 있다.

---

## 4. ChatClient에 다중 메시지 전달하기

Spring AI의 `ChatClient`에서는 `messages()`를 사용하여 기존 대화 내용을 전달할 수 있다.

```java
String response = chatClient.prompt()
        .messages(chatMemory)
        .user(question)
        .call()
        .content();
```

각 메서드의 역할은 다음과 같다.

| 메서드 | 역할 |
|---|---|
| `prompt()` | 새로운 프롬프트 요청 시작 |
| `messages()` | 기존 대화 메시지 전달 |
| `user()` | 새로운 사용자 질문 추가 |
| `call()` | LLM에 요청 전송 |
| `content()` | AI 응답 내용 반환 |

여기서 중요한 부분은 다음 코드이다.

```java
.messages(chatMemory)
.user(question)
```

기존 대화 기록을 먼저 전달하고, 그 뒤에 새로운 질문을 추가한다.

따라서 LLM은 이전 대화와 새로운 질문을 함께 고려하여 답변할 수 있다.

---

## 5. Chat Memory 직접 구현하기

이번에는 대화 기록을 직접 관리하는 방식을 알아보자.

대화 기록을 저장할 자료구조로 `List<Message>`를 사용할 수 있다.

```java
List<Message> chatMemory = new ArrayList<>();
```

여기서 `Message`는 SystemMessage, UserMessage, AssistantMessage가 공통으로 구현하는 메시지 인터페이스이다.

대화가 진행될 때마다 메시지를 리스트에 추가한다.

### 5-1. 최초 대화 시작

대화가 처음 시작될 때는 AI의 역할을 지정하는 SystemMessage를 추가한다.

```java
List<Message> chatMemory = new ArrayList<>();

chatMemory.add(
    new SystemMessage("당신은 친절한 Java 강사입니다.")
);
```

### 5-2. 사용자 질문 추가

사용자가 질문하면 UserMessage를 추가한다.

```java
chatMemory.add(
    new UserMessage(question)
);
```

### 5-3. LLM에 대화 기록 전달

기존 대화 기록과 새로운 질문을 함께 전달한다.

```java
String response = chatClient.prompt()
        .messages(chatMemory)
        .call()
        .content();
```

이 방식에서는 질문을 `chatMemory`에 직접 추가한 뒤 `messages()`로 전달한다.

따라서 별도로 `.user(question)`을 다시 호출하면 같은 질문이 중복 전달될 수 있으므로 주의해야 한다.

### 5-4. AI 응답 저장

AI가 응답하면 해당 내용을 AssistantMessage로 변환하여 대화 기록에 추가한다.

```java
chatMemory.add(
    new AssistantMessage(response)
);
```

이렇게 저장해야 다음 질문에서도 이전 AI 응답을 함께 전달할 수 있다.

---

## 6. Session을 이용한 사용자별 Chat Memory 관리

여러 사용자가 동시에 AI 서비스를 이용한다면 사용자별로 대화 기록을 분리해야 한다.

모든 사용자가 하나의 `List<Message>`를 공유하면 다른 사용자의 대화 내용이 섞일 수 있다.

이를 방지하기 위해 HTTP Session에 사용자별 대화 기록을 저장할 수 있다.

### 6-1. Session이란?

HTTP는 기본적으로 요청과 요청 사이의 상태를 자동으로 유지하지 않는 Stateless 방식이다.

예를 들어 사용자가 첫 번째 요청에서 이름을 전달했더라도 두 번째 요청에서 서버가 그 내용을 자동으로 기억하지는 않는다.

Session은 이러한 요청 사이의 사용자 상태를 유지하기 위한 방법 중 하나이다.

```text
사용자 A
   ↓
Session A
   └── chatMemory A

사용자 B
   ↓
Session B
   └── chatMemory B
```

각 사용자는 서로 다른 Session을 사용하므로 대화 기록을 분리할 수 있다.

### 6-2. Session에서 대화 기록 가져오기

```java
List<Message> chatMemory =
        (List<Message>) session.getAttribute("chatMemory");
```

`getAttribute()`는 Session에 저장된 값을 가져오는 메서드이다.

처음 접속한 사용자라면 아직 대화 기록이 없으므로 `null`이 반환될 수 있다.

따라서 대화 기록이 없는 경우 새 리스트를 생성해야 한다.

```java
if (chatMemory == null) {

    chatMemory = new ArrayList<>();

    chatMemory.add(
        new SystemMessage("당신은 친절한 Java 강사입니다.")
    );

    session.setAttribute("chatMemory", chatMemory);
}
```

| 메서드 | 역할 |
|---|---|
| `getAttribute()` | Session에 저장된 값 조회 |
| `setAttribute()` | Session에 값 저장 |
| `getId()` | Session 식별자 조회 |
| `invalidate()` | Session 무효화 |

---

## 7. 전체 Chat Memory 구현 예제

다음은 Session에 대화 기록을 저장하고, 기존 대화와 새로운 질문을 LLM에 전달하는 Controller 예제이다.

```java
package com.example.demo.controller;

import java.util.ArrayList;
import java.util.List;

import org.springframework.ai.chat.client.ChatClient;
import org.springframework.ai.chat.messages.AssistantMessage;
import org.springframework.ai.chat.messages.Message;
import org.springframework.ai.chat.messages.SystemMessage;
import org.springframework.ai.chat.messages.UserMessage;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import jakarta.servlet.http.HttpSession;

@RestController
public class ChatController {

    private final ChatClient chatClient;

    public ChatController(ChatClient.Builder builder) {
        this.chatClient = builder.build();
    }

    @PostMapping("/chat")
    public String chat(
            @RequestParam String question,
            HttpSession session) {

        // 1. Session에서 기존 대화 기록 가져오기
        List<Message> chatMemory =
                (List<Message>) session.getAttribute("chatMemory");

        // 2. 대화 기록이 없다면 새로 생성
        if (chatMemory == null) {

            chatMemory = new ArrayList<>();

            chatMemory.add(
                new SystemMessage("당신은 친절한 Java 강사입니다.")
            );
        }

        // 3. 사용자 질문 저장
        chatMemory.add(
            new UserMessage(question)
        );

        // 4. 기존 대화 기록을 LLM에 전달
        String response = chatClient.prompt()
                .messages(chatMemory)
                .call()
                .content();

        // 5. AI 응답을 대화 기록에 저장
        chatMemory.add(
            new AssistantMessage(response)
        );

        // 6. Session에 대화 기록 저장
        session.setAttribute("chatMemory", chatMemory);

        return response;
    }
}
```

> 위 코드는 Spring MVC의 `HttpSession`을 사용하는 예제이다. Spring WebFlux에서는 Servlet 기반 `HttpSession` 대신 `WebSession`을 사용하는 등 요청 처리 환경에 맞는 세션 API를 사용해야 한다.

---

## 8. 전체 실행 흐름

사용자가 처음 질문을 입력하는 상황을 살펴보자.

### 첫 번째 질문

```text
사용자: Java가 무엇인가요?
```

Session에 대화 기록이 없으므로 새 리스트를 생성한다.

```text
chatMemory

[System]
당신은 친절한 Java 강사입니다.

[User]
Java가 무엇인가요?
```

이 메시지들을 LLM에 전달하고 응답을 받는다.

```text
[Assistant]
Java는 객체지향 프로그래밍 언어입니다.
```

응답을 다시 리스트에 저장한다.

### 두 번째 질문

```text
사용자: 객체지향이란 무엇인가요?
```

이번에는 Session에 이미 대화 기록이 존재한다.

따라서 기존 기록을 가져온 후 새로운 질문을 추가한다.

```text
chatMemory

[System]
당신은 친절한 Java 강사입니다.

[User]
Java가 무엇인가요?

[Assistant]
Java는 객체지향 프로그래밍 언어입니다.

[User]
객체지향이란 무엇인가요?
```

이렇게 전달하면 AI는 앞선 대화 내용을 참고하여 답변할 수 있다.

### 전체 구조

```text
사용자 질문
    ↓
HttpSession
    ↓
chatMemory 조회
    ↓
기존 대화 기록 확인
    ↓
새로운 UserMessage 추가
    ↓
ChatClient
    ↓
LLM 요청
    ↓
Assistant 응답
    ↓
AssistantMessage 추가
    ↓
Session에 대화 기록 저장
    ↓
사용자에게 응답 반환
```

---

## 9. Chat Memory 사용 시 주의사항

### 9-1. 대화 기록이 계속 증가하는 문제

대화가 길어질수록 `chatMemory`에 저장되는 메시지도 계속 증가한다.

LLM에 전달하는 대화 내용이 많아지면 다음과 같은 문제가 발생할 수 있다.

- 입력 토큰 증가
- API 사용 비용 증가
- 응답 시간 증가
- 모델의 컨텍스트 길이 초과

따라서 실무에서는 최근 대화만 유지하거나 오래된 대화를 요약하는 등의 관리가 필요하다.

### 9-2. Session과 영구 저장소의 차이

Session은 사용자별 대화 상태를 유지하는 간단한 방법이다.

하지만 서버 메모리에만 저장하는 경우 서버가 재시작되면 대화 기록이 사라질 수 있다.

| 저장 방식 | 특징 |
|---|---|
| `List<Message>` | 현재 실행 중인 코드에서 사용하는 대화 자료구조 |
| HTTP Session | 사용자별 대화 상태 유지 |
| Redis | 여러 서버에서 공유할 수 있는 세션 및 대화 데이터 저장 |
| RDBMS | 대화 내용을 영구적으로 저장하고 조회 |

대화 기록을 장기간 보관해야 하는 서비스라면 Redis나 RDBMS 등을 고려할 수 있다.

### 9-3. 사용자별 대화 분리

여러 사용자가 하나의 대화 기록을 공유하지 않도록 해야 한다.

Session이나 사용자 ID, Conversation ID 등을 기준으로 대화 기록을 분리해야 한다.

---

## 10. 핵심 정리

| 개념 | 역할 |
|---|---|
| `SystemMessage` | AI의 역할과 답변 방식 지정 |
| `UserMessage` | 사용자의 질문 저장 |
| `AssistantMessage` | AI의 응답 저장 |
| `List<Message>` | 여러 메시지를 순서대로 관리 |
| `ChatClient` | 메시지를 LLM에 전달하고 응답 수신 |
| `HttpSession` | 사용자별 대화 상태 유지 |
| `getAttribute()` | 기존 대화 기록 조회 |
| `setAttribute()` | 대화 기록 저장 |

### 가장 중요한 흐름

```text
1. Session에서 기존 대화 기록 조회
2. 기록이 없다면 새로운 List 생성
3. SystemMessage 등록
4. UserMessage 추가
5. ChatClient로 전체 대화 전달
6. AssistantMessage 추가
7. Session에 대화 기록 저장
```

**핵심은 AI가 이전 대화를 자동으로 기억하는 것이 아니라, 이전 메시지를 저장해 두었다가 새로운 요청을 보낼 때 함께 전달한다는 것이다.**

이것이 Spring AI에서 Chat Memory를 이해하는 가장 기본적인 원리이다.
