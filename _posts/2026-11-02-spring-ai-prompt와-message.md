---
layout: post
title: "Spring AI Prompt와 Message"
date: 2026-11-02 00:00:00 +0900
categories: [Spring]
section: spring-ai
tags: [Spring AI, Prompt, PromptTemplate, Message, LLM]
---

# Spring AI - Prompt와 Message

## 1. Prompt란?

Spring AI에서 **Prompt**는 LLM에게 전달할 입력을 구조화한 객체이다.

단순히 문자열 하나를 전달하는 것이 아니라,

- 어떤 역할을 수행해야 하는지
- 사용자가 무엇을 요청했는지
- 이전 대화에서 어떤 내용이 있었는지

등을 **Message 형태로 구성하여 LLM에 전달**할 수 있다.

```text
Prompt
 ├── SystemMessage
 ├── UserMessage
 ├── AssistantMessage
 └── ToolMessage ...
```

즉, Prompt는 **LLM에게 전달할 하나의 입력 묶음**이라고 이해하면 된다.

---

# 2. PromptTemplate

프롬프트를 매번 문자열로 직접 작성하면 같은 형식의 프롬프트가 반복된다.

이때 `PromptTemplate`을 사용하면 **변수를 포함한 프롬프트를 템플릿으로 만들어 재사용**할 수 있다.

## 기본 예제

```java
PromptTemplate template = new PromptTemplate("""
        You are a friendly assistant.
        Write a short greeting message to {name}
        about the topic: {topic}.
        """);

var prompt = template.create(Map.of(
        "name", name,
        "topic", topic
));
```

### 동작 과정

```text
PromptTemplate
        ↓
{name}, {topic} 변수 존재
        ↓
Map으로 실제 값 전달
        ↓
변수 치환
        ↓
Prompt 생성
        ↓
LLM 호출
```

예를 들어

```java
Map.of(
    "name", "홍길동",
    "topic", "Spring"
)
```

을 전달하면 다음과 같이 만들어진다.

```text
You are a friendly assistant.
Write a short greeting message to 홍길동
about the topic: Spring.
```

그리고 생성된 Prompt를 LLM에 전달한다.

```java
return chatClient
        .prompt(prompt)
        .call()
        .content();
```

### 핵심

| 요소 | 역할 |
|---|---|
| `PromptTemplate` | 프롬프트의 틀 정의 |
| `{name}` | 치환될 변수 |
| `Map.of()` | 실제 변수 값 전달 |
| `template.create()` | 실제 Prompt 생성 |
| `chatClient.prompt()` | LLM 호출 준비 |
| `.call()` | LLM 호출 |
| `.content()` | 응답 내용 추출 |

---

# 3. Message란?

Spring AI에서는 LLM에 전달하는 대화 내용을 **Message 객체**로 표현할 수 있다.

Message에는 단순한 내용뿐만 아니라 **역할(Role)**이 함께 존재한다.

대표적인 Message는 다음과 같다.

| Message | 역할 | 의미 |
|---|---|---|
| `SystemMessage` | system | AI의 역할, 규칙, 행동 지침 |
| `UserMessage` | user | 사용자의 질문이나 요청 |
| `AssistantMessage` | assistant | AI가 이전에 생성한 응답 |
| `ToolMessage` | tool | 외부 도구 호출 결과 |

핵심은 다음과 같다.

```text
System → "어떻게 행동할 것인가?"
User → "무엇을 요청했는가?"
Assistant → "이전에 AI가 무엇이라고 답했는가?"
Tool → "외부 도구에서 어떤 결과가 나왔는가?"
```

---

# 4. SystemMessage

`SystemMessage`는 LLM의 **역할과 행동 규칙**을 지정한다.

예를 들어 AI에게 개발자 역할을 부여할 수 있다.

```java
new SystemMessage("""
    You are a senior software engineer.
    Always answer concisely and include code examples in Java.
""");
```

그러면 사용자의 질문이

```text
Spring에서 DI가 뭐야?
```

일 때 AI는 SystemMessage의 지침을 참고하여 답변을 생성한다.

### 활용 예

```text
너는 여행 전문가이다.
답변은 한국어로 작성한다.
여행 일정을 표 형태로 제공한다.
```

또는

```text
너는 Java 백엔드 개발자이다.
코드 예제를 포함해서 설명한다.
불필요한 설명은 줄인다.
```

### 핵심

> `SystemMessage` = **AI가 어떻게 행동해야 하는지를 정의**

---

# 5. UserMessage

`UserMessage`는 실제 사용자가 전달한 질문이나 요청이다.

```java
new UserMessage(
    "Explain dependency injection in Spring Boot."
);
```

예를 들어 실제 서비스에서는

```text
사용자
 ↓
"서울 맛집 추천해줘"
 ↓
UserMessage
 ↓
LLM
```

과 같은 구조가 된다.

UserMessage에는 텍스트뿐만 아니라 **이미지 등의 멀티모달 입력**도 포함할 수 있다.

예를 들어 이미지와 함께 질문하는 경우에는 이미지 Media를 포함하여 전달할 수 있다.

```text
UserMessage
 ├── Text
 │    └── "이 이미지를 설명해줘"
 │
 └── Media
      └── image.png
```

### 핵심

> `UserMessage` = **사용자가 AI에게 전달하는 실제 요청**

---

# 6. AssistantMessage

`AssistantMessage`는 **LLM이 이전에 생성한 응답**을 나타낸다.

예를 들어 사용자가

```text
사용자:
Spring이 뭐야?
```

라고 질문했고,

```text
AI:
Spring은 Java 기반 애플리케이션 개발을 위한 프레임워크입니다.
```

라고 답했다고 하자.

이전 AI의 응답을 다음 요청에 포함시키면:

```java
new AssistantMessage(
    "Spring은 Java 기반 애플리케이션 개발을 위한 프레임워크입니다."
);
```

LLM이 이전 답변을 참고할 수 있다.

---

# 7. LLM은 기본적으로 Stateless이다

LLM API를 사용할 때 중요한 개념이다.

LLM은 일반적으로 **이전 API 호출 내용을 자동으로 기억하지 않는다.**

예를 들어 첫 번째 요청에서

```text
User:
내 이름은 홍길동이야.
```

라고 전달하고,

두 번째 요청에서

```text
User:
내 이름이 뭐라고?
```

라고 보내더라도,

두 번째 요청에 첫 번째 대화 내용이 포함되어 있지 않다면 모델은 그 내용을 알 수 없다.

즉,

```text
1번째 요청
User → "내 이름은 홍길동이야."
        ↓
       LLM
        ↓
      응답

2번째 요청
User → "내 이름이 뭐라고?"
        ↓
       LLM
```

두 요청이 **자동으로 연결되는 것이 아니다.**

---

# 8. 그렇다면 대화 기억은 어떻게 만드는가?

이전 대화 내용을 다음 요청의 Prompt에 다시 포함하면 된다.

예를 들어:

```text
SystemMessage
"너는 친절한 AI야."

UserMessage
"내 이름은 홍길동이야."

AssistantMessage
"안녕하세요 홍길동님."

UserMessage
"내 이름이 뭐라고?"
```

전체 내용을 Prompt로 만들어 LLM에 전달한다.

```java
List<Message> messages = List.of(
    new SystemMessage("You are a friendly AI assistant."),
    new UserMessage("내 이름은 홍길동이야."),
    new AssistantMessage("안녕하세요 홍길동님."),
    new UserMessage("내 이름이 뭐라고?")
);

Prompt prompt = new Prompt(messages);

String reply = chatClient
        .prompt(prompt)
        .call()
        .content();
```

LLM 입장에서는 다음과 같은 입력을 받는 것이다.

```text
System
└─ You are a friendly AI assistant.

User
└─ 내 이름은 홍길동이야.

Assistant
└─ 안녕하세요 홍길동님.

User
└─ 내 이름이 뭐라고?
```

따라서 마지막 질문에

```text
홍길동님이라고 하셨습니다.
```

와 같이 답변할 수 있다.

---

# 9. 대화 기억의 실제 흐름

실제 채팅 서비스에서는 대략 다음과 같은 흐름으로 동작한다.

```text
① 사용자가 질문
        ↓
② UserMessage 생성
        ↓
③ LLM 호출
        ↓
④ AI 응답 생성
        ↓
⑤ AssistantMessage로 대화 기록
        ↓
⑥ 다음 질문 발생
        ↓
⑦ 이전 대화 + 새로운 UserMessage 구성
        ↓
⑧ 다시 LLM 호출
```

즉, **대화 기억은 LLM 자체가 가지고 있는 것이 아니라 애플리케이션이 대화 이력을 관리하고 다시 전달하는 방식**이다.

실제 서비스에서는 이 대화 기록을 DB나 메모리 등에 저장하고 필요한 범위만 Prompt에 포함하는 방식으로 구현할 수 있다.

---

# 10. Prompt와 Message의 관계

두 개념을 혼동하기 쉽다.

### Message

하나의 대화 단위이다.

```text
SystemMessage
UserMessage
AssistantMessage
```

### Prompt

여러 Message를 하나로 묶어서 LLM에 전달하는 입력이다.

```text
Prompt
 ├── SystemMessage
 ├── UserMessage
 ├── AssistantMessage
 └── UserMessage
```

따라서 관계를 정리하면:

```text
Message
   ↓
여러 Message를 구성
   ↓
Prompt
   ↓
ChatClient
   ↓
LLM
   ↓
Response
```

---

# 11. 전체 예제

```java
import org.springframework.ai.chat.client.ChatClient;
import org.springframework.ai.chat.messages.*;
import org.springframework.ai.chat.prompt.Prompt;

import java.util.List;

public class MessageExample {

    private final ChatClient chatClient;

    public MessageExample(ChatClient chatClient) {
        this.chatClient = chatClient;
    }

    public String generatePlan() {

        List<Message> messages = List.of(
            new SystemMessage(
                "You are a professional travel planner."
            ),

            new UserMessage(
                "Make a 3-day itinerary for Seoul."
            )
        );

        Prompt prompt = new Prompt(messages);

        return chatClient
                .prompt(prompt)
                .call()
                .content();
    }
}
```

### 실행 구조

```text
SystemMessage
"너는 전문 여행 플래너야."
        +
UserMessage
"서울 3일 여행 일정을 만들어줘."
        ↓
      Prompt
        ↓
   ChatClient
        ↓
       LLM
        ↓
     Response
```

---

# 12. 여러 대화가 포함된 Prompt

이전 대화까지 포함하면 다음과 같이 구성할 수 있다.

```java
List<Message> chat = List.of(
    new SystemMessage(
        "You are a friendly AI assistant."
    ),

    new UserMessage(
        "Who won the FIFA World Cup in 2022?"
    ),

    new AssistantMessage(
        "Argentina won the 2022 FIFA World Cup."
    ),

    new UserMessage(
        "Who was their captain?"
    )
);

Prompt prompt = new Prompt(chat);

String reply = chatClient
        .prompt(prompt)
        .call()
        .content();

System.out.println(reply);
```

LLM은 이전 메시지를 보고

```text
Argentina
```

를 `their`가 가리키는 대상으로 이해할 수 있다.

즉,

```text
User
"Who won the FIFA World Cup in 2022?"
        ↓
Assistant
"Argentina won..."
        ↓
User
"Who was their captain?"
```

처럼 **이전 대화의 문맥을 함께 전달**하는 것이다.

---

# 13. PromptTemplate과 Message의 차이

둘은 서로 대체하는 개념이 아니다.

| 구분 | PromptTemplate | Message |
|---|---|---|
| 목적 | 프롬프트를 템플릿화 | 대화 역할과 내용을 표현 |
| 핵심 | 변수 치환 | Role + Content |
| 예시 | `{name}`, `{topic}` | System/User/Assistant |
| 주요 활용 | 반복되는 프롬프트 | 대화 구성 및 히스토리 |
| 관계 | Prompt를 만들기 위한 방법 | Prompt를 구성하는 요소 |

예를 들어 상품 챗봇이라면:

```text
PromptTemplate
    ↓
상품 정보와 사용자 질문을 변수로 삽입
    ↓
Prompt 생성
    ↓
Message 구성
    ↓
LLM 호출
```

처럼 함께 사용할 수도 있다.

---

# 14. ToolMessage

AI가 외부 도구를 호출하는 경우에는 **도구의 실행 결과를 다시 모델에게 전달**해야 할 수 있다.

예를 들어:

```text
사용자
"서울 날씨 알려줘"
        ↓
LLM
"날씨 API를 호출해야겠다."
        ↓
Tool 호출
getWeather("Seoul")
        ↓
날씨 API
"22℃ / 맑음"
        ↓
Tool 결과
        ↓
LLM
        ↓
"현재 서울은 22℃이고 맑습니다."
```

이때 도구 호출 결과를 모델에 전달하는 역할을 `ToolMessage`가 담당한다.

> `ToolMessage` = **외부 도구 실행 결과를 대화 흐름에 포함시키기 위한 메시지**

Spring AI에서 Tool Calling을 사용할 때 함께 이해하면 좋은 개념이다.

---

# 15. 전체 구조

Spring AI에서 Prompt 관련 개념을 전체적으로 연결하면 다음과 같다.

```text
                    Spring AI
                        │
                        ▼
                   PromptTemplate
                        │
                 변수 값 치환
                        │
                        ▼
                  Message 구성
                        │
        ┌───────────────┼───────────────┐
        ▼               ▼               ▼
   SystemMessage   UserMessage   AssistantMessage
        │               │               │
        │               │               │
      규칙/역할       사용자 질문       이전 AI 응답
        │               │               │
        └───────────────┼───────────────┘
                        ▼
                      Prompt
                        │
                        ▼
                   ChatClient
                        │
                        ▼
                       LLM
                        │
                        ▼
                     Response
```

---

# 16. 핵심 정리

### Prompt

> LLM에게 전달할 **전체 입력 단위**

### PromptTemplate

> 반복되는 프롬프트를 **변수 기반 템플릿으로 관리**

### SystemMessage

> AI의 **역할과 규칙**을 정의

### UserMessage

> **사용자의 질문과 요청**을 전달

### AssistantMessage

> **이전 AI의 응답**을 전달하여 대화 문맥 유지

### ToolMessage

> 외부 **도구 실행 결과**를 모델에게 전달

---

## 한 번에 이해하기

```text
Prompt
= LLM에게 전달할 전체 대화

Message
= Prompt를 구성하는 각각의 대화 단위

PromptTemplate
= Prompt를 쉽게 만들기 위한 템플릿

SystemMessage
= "너는 어떻게 행동해야 해"

UserMessage
= "내가 이것을 요청할게"

AssistantMessage
= "이전에 네가 이렇게 답했어"

ToolMessage
= "외부 도구에서 이런 결과가 나왔어"
```

그리고 가장 중요한 부분은 다음이다.

> **LLM은 기본적으로 이전 호출 내용을 자동으로 기억하지 않는다.**
>
> 따라서 대화형 서비스를 만들려면 애플리케이션에서 이전 대화 기록을 관리하고, 필요한 대화 내용을 다음 Prompt에 다시 포함해야 한다.