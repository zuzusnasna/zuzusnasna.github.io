---
layout: post
title: "Spring AI와 Eclipse를 활용한 AI 애플리케이션 개발"
date: 2026-11-02 00:00:00 +0900
categories: ["Spring"]
section: spring-ai
tags: ["Spring", "Spring AI", "Eclipse", "Spring Boot", "AI", "API"]
---
# Spring AI와 Eclipse를 활용한 AI 애플리케이션 개발

## 1. Spring AI란?

Spring AI는 Spring 애플리케이션에서 AI 모델을 쉽게 연결하고 사용할 수 있도록 지원하는 프레임워크이다.

기존에는 AI 모델의 API를 직접 호출하고 HTTP 요청과 응답을 처리해야 했다면, Spring AI를 사용하면 Spring에서 제공하는 객체와 메서드를 통해 AI 모델을 간편하게 사용할 수 있다.

### 주요 특징

- Spring Boot 기반 애플리케이션과 자연스럽게 연동
- OpenAI, Anthropic, Ollama 등 다양한 AI 모델 지원
- 프롬프트 작성 및 AI 응답 처리 지원
- 모델을 변경하더라도 애플리케이션 코드를 비교적 적게 수정
- 임베딩, 벡터 데이터베이스, RAG 등 확장 기능 지원

### Spring AI의 동작 구조

```text
사용자
  |
  v
Spring Boot 애플리케이션
  |
  v
Spring AI
  |
  v
AI 모델 API
  |
  v
AI 모델 응답
  |
  v
Spring Boot
  |
  v
사용자에게 결과 전달
```

Spring AI는 AI 모델 자체가 아니라, Spring 애플리케이션과 AI 모델 사이에서 통신을 편리하게 처리해 주는 프레임워크이다.

---

## 2. Eclipse에서 Spring AI 프로젝트 생성하기

Spring AI는 Spring Boot 프로젝트에 의존성을 추가하여 사용한다.

### 2-1. 프로젝트 생성

Eclipse에서 Spring Starter Project를 선택하거나 Spring Initializr를 이용해 프로젝트를 생성한다.

| 항목 | 설정 |
|---|---|
| Project | Maven 또는 Gradle |
| Language | Java |
| Spring Boot | Spring AI와 호환되는 버전 |
| Packaging | Jar |
| Java | 21 |
| Dependencies | Spring Web |

Spring AI의 버전은 사용하는 Spring Boot 버전과 호환되는 조합으로 선택해야 한다.

### 2-2. Maven 의존성 설정

Spring AI의 버전 관리는 BOM을 이용하는 방식이 일반적이다.

`pom.xml`

```xml
<properties>
    <java.version>21</java.version>
    <spring-ai.version>호환되는 Spring AI 버전</spring-ai.version>
</properties>

<dependencyManagement>
    <dependencies>
        <dependency>
            <groupId>org.springframework.ai</groupId>
            <artifactId>spring-ai-bom</artifactId>
            <version>${spring-ai.version}</version>
            <type>pom</type>
            <scope>import</scope>
        </dependency>
    </dependencies>
</dependencyManagement>

<dependencies>
    <!-- Spring Web -->
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-web</artifactId>
    </dependency>

    <!-- OpenAI 모델 연동 -->
    <dependency>
        <groupId>org.springframework.ai</groupId>
        <artifactId>spring-ai-starter-model-openai</artifactId>
    </dependency>
</dependencies>
```

> Spring AI는 버전에 따라 Starter 이름이나 설정 방식이 달라질 수 있으므로 공식 문서의 해당 버전 예제를 확인해야 한다.

---

## 3. AI 모델 API 연결하기

Spring AI는 여러 AI 모델을 지원하지만, 여기서는 OpenAI 모델을 연결하는 예제를 사용한다.

AI 모델을 사용하려면 해당 서비스에서 발급받은 API Key가 필요하다.

### 3-1. API Key 설정

`application.properties`

```properties
spring.ai.openai.api-key=${OPENAI_API_KEY}
spring.ai.openai.chat.options.model=gpt-4o-mini
```

API Key를 코드에 직접 작성하면 안 된다.

운영체제 환경 변수나 실행 환경의 환경 변수로 관리한다.

Windows PowerShell 예시:

```powershell
$env:OPENAI_API_KEY="발급받은_API_KEY"
```

이후 같은 PowerShell 창에서 Eclipse를 실행하거나, Eclipse 실행 환경에 환경 변수를 별도로 설정한다.

### 3-2. API Key가 필요한 이유

API Key는 애플리케이션이 외부 AI 서비스에 접근할 수 있도록 인증하는 값이다.

```text
Spring Boot
    |
    | API Key 포함
    v
AI 서비스 API
    |
    | 인증 및 요청 처리
    v
AI 모델 응답
```

API Key는 비밀번호와 비슷한 역할을 하므로 GitHub 저장소에 업로드하지 않는다.

---

## 4. ChatClient를 이용한 AI 응답 처리

Spring AI에서는 `ChatClient`를 이용해 AI 모델에 프롬프트를 전달하고 응답을 받을 수 있다.

### 4-1. ChatClient란?

`ChatClient`는 AI 모델과 대화하기 위한 인터페이스이다.

개발자는 프롬프트를 전달하고 AI의 응답을 문자열 등의 형태로 받을 수 있다.

### 4-2. ChatClient Bean 생성

```java
@Configuration
public class AiConfig {

    @Bean
    public ChatClient chatClient(ChatClient.Builder builder) {
        return builder.build();
    }
}
```

- `@Configuration`: 설정 클래스임을 나타낸다.
- `@Bean`: Spring 컨테이너에 객체를 등록한다.
- `ChatClient.Builder`: ChatClient 객체를 생성하기 위한 빌더이다.
- `build()`: 실제 ChatClient 객체를 생성한다.

### 4-3. AI 응답을 반환하는 Service

```java
@Service
public class AiService {

    private final ChatClient chatClient;

    public AiService(ChatClient chatClient) {
        this.chatClient = chatClient;
    }

    public String ask(String question) {

        return chatClient.prompt()
                .user(question)
                .call()
                .content();
    }
}
```

주요 메서드의 역할은 다음과 같다.

| 메서드 | 역할 |
|---|---|
| `prompt()` | 프롬프트 요청 시작 |
| `user()` | 사용자 질문 전달 |
| `call()` | AI 모델에 요청 전송 |
| `content()` | AI 응답 내용 반환 |

### 4-4. Controller 작성

```java
@RestController
@RequestMapping("/api/ai")
public class AiController {

    private final AiService aiService;

    public AiController(AiService aiService) {
        this.aiService = aiService;
    }

    @GetMapping("/ask")
    public String ask(@RequestParam String question) {
        return aiService.ask(question);
    }
}
```

브라우저 또는 API 테스트 도구에서 다음과 같이 요청한다.

```http
GET http://localhost:8080/api/ai/ask?question=스프링이란 무엇인가요?
```

요청이 들어오면 다음 순서로 실행된다.

```text
1. 사용자가 질문 전달
        |
        v
2. AiController
        |
        v
3. AiService
        |
        v
4. ChatClient
        |
        v
5. OpenAI API 호출
        |
        v
6. AI 응답 수신
        |
        v
7. 사용자에게 응답 반환
```

---

## 5. Prompt란?

Prompt는 AI 모델에 전달하는 입력 또는 지시문이다.

단순한 질문뿐 아니라 AI가 어떤 역할을 수행하고 어떤 형식으로 답변해야 하는지 지정할 수 있다.

### 5-1. User Prompt

사용자가 AI에게 전달하는 질문이다.

```java
String response = chatClient.prompt()
        .user("Spring Boot의 특징을 설명해 주세요.")
        .call()
        .content();
```

### 5-2. System Prompt

AI의 역할이나 응답 방향을 지정하는 지시문이다.

```java
String response = chatClient.prompt()
        .system("당신은 Java와 Spring을 가르치는 강사입니다.")
        .user("Spring Boot를 설명해 주세요.")
        .call()
        .content();
```

| 구분 | 역할 |
|---|---|
| System Prompt | AI의 역할과 응답 기준 설정 |
| User Prompt | 실제 사용자의 질문 전달 |

예를 들어 System Prompt에서 AI를 Java 강사로 지정하면, 사용자의 질문에 강사 역할에 맞는 방식으로 답변하도록 유도할 수 있다.

---

## 6. ChatClient와 기존 REST API 호출 비교

기존에는 외부 API를 호출하기 위해 HTTP 요청과 응답을 직접 처리해야 했다.

Spring AI를 사용하면 AI 모델 호출에 필요한 과정을 추상화된 인터페이스로 처리할 수 있다.

| 구분 | 직접 REST API 호출 | Spring AI |
|---|---|---|
| 요청 구성 | 직접 HTTP 요청 생성 | ChatClient 사용 |
| 인증 | 직접 인증 헤더 설정 | 설정 파일 등을 통해 관리 |
| 응답 처리 | JSON 파싱 직접 구현 | 응답 객체 및 메서드 활용 |
| 모델 변경 | API 요청 구조 수정 가능 | 모델별 Starter 및 설정 변경 |
| 확장 기능 | 직접 구현 필요 | 임베딩, RAG 등 지원 |

Spring AI가 모든 개발 과정을 자동으로 처리하는 것은 아니다. 인증 정보, 모델 설정, 예외 처리, 사용량 관리 등은 애플리케이션에서 적절하게 관리해야 한다.

---

## 7. Spring AI 사용 시 주의사항

1. **API Key 보안**
   - API Key를 Java 코드나 GitHub에 직접 작성하지 않는다.
   - 환경 변수 또는 안전한 비밀 정보 관리 기능을 사용한다.

2. **API 호출 비용**
   - 외부 AI 서비스는 사용량에 따라 비용이 발생할 수 있다.
   - 요청 횟수와 입력 토큰을 관리해야 한다.

3. **응답 지연**
   - AI 모델의 응답 시간은 일반적인 DB 조회보다 길 수 있다.
   - 사용자 요청이 오래 대기하지 않도록 타임아웃과 비동기 처리를 고려한다.

4. **예외 처리**
   - API Key 오류, 네트워크 오류, 요청 제한, 모델 오류 등에 대한 처리가 필요하다.

5. **모델 버전 관리**
   - 사용 중인 모델 이름과 Spring AI 버전을 명확하게 관리한다.

---

## 8. 핵심 정리

| 개념 | 설명 |
|---|---|
| Spring AI | Spring 애플리케이션에서 AI 모델을 쉽게 연동하는 프레임워크 |
| ChatClient | AI 모델에 프롬프트를 전달하고 응답을 받는 인터페이스 |
| Prompt | AI 모델에 전달하는 질문이나 지시문 |
| System Prompt | AI의 역할과 응답 방향을 지정 |
| User Prompt | 사용자가 실제로 전달하는 질문 |
| API Key | 외부 AI 서비스 인증 정보 |
| RAG | 외부 문서나 데이터 검색 결과를 활용해 AI 응답을 보완하는 방식 |
| Embedding | 텍스트를 의미를 담은 숫자 벡터로 변환하는 과정 |

### 전체 실행 흐름

```text
Eclipse
  |
  v
Spring Boot 프로젝트
  |
  v
Controller
  |
  v
Service
  |
  v
ChatClient
  |
  v
Spring AI
  |
  v
외부 AI 모델 API
  |
  v
응답 반환
```

**핵심은 Spring AI가 AI 모델을 직접 학습시키는 도구가 아니라, 기존 Spring Boot 애플리케이션에서 외부 AI 모델을 쉽게 연결하고 활용할 수 있도록 도와주는 프레임워크라는 점이다.**
