---
layout: post
title: "Spring AI 대화 기억(Chat Memory)"
date: 2026-11-02 00:00:00 +0900
categories: [Spring]
section: spring-ai
tags: [Spring AI, Chat Memory, ChatMemory, ChatMemoryRepository, RDBMS, VectorStore]
---


## 1. Chat Memory란?

**Chat Memory**는 AI 챗봇이 사용자와 이전에 나눈 대화를 저장하고, 다음 질문에 이전 대화 내용을 활용할 수 있도록 하는 기능이다.

LLM은 기본적으로 이전 API 호출 내용을 자동으로 기억하지 않는다.

```java
chatClient.prompt()
        .user("저는 Java 개발자입니다.")
        .call()
        .content();

chatClient.prompt()
        .user("제 직업은 무엇인가요?")
        .call()
        .content();
```

두 번째 요청에서는 첫 번째 요청의 내용을 자동으로 알 수 없다.

따라서 대화형 서비스를 만들려면

```text
사용자 질문
    ↓
대화 기록 저장
    ↓
다음 질문
    ↓
이전 대화 조회
    ↓
현재 질문 + 이전 대화
    ↓
LLM
```

과 같은 구조가 필요하다.

---

## 2. Chat Memory의 주요 구성요소

Spring AI의 대화 기억은 여러 구성요소가 역할을 나누어 처리한다.

| 구성요소 | 역할 |
|---|---|
| `ChatClient` | LLM 호출 |
| `ChatMemory` | 대화 기억을 관리 |
| `ChatMemoryRepository` | 대화 기록의 저장 및 조회 |
| `MessageChatMemoryAdvisor` | 이전 대화를 LLM 요청에 포함 |
| `conversationId` | 대화방 또는 사용자별 대화 구분 |

가장 중요한 차이는 다음과 같다.

```text
ChatMemory
→ 대화 기록을 "어떻게 관리할 것인가?"

ChatMemoryRepository
→ 대화 기록을 "어디에 저장할 것인가?"
```

즉,

```text
ChatMemory
    ↓
ChatMemoryRepository
    ↓
In-Memory / JDBC 등
```

과 같은 관계로 볼 수 있다.

---

## 3. MessageChatMemoryAdvisor

`Advisor`는 LLM을 호출하는 과정에 공통적인 처리를 추가할 수 있는 Spring AI의 기능이다.

대화 기억에서는 Advisor가 저장된 이전 대화를 가져와 **현재 LLM 요청에 포함시키는 역할**을 한다.

대표적으로 다음과 같은 방식이 있다.

| Advisor | 특징 |
|---|---|
| `MessageChatMemoryAdvisor` | 이전 대화를 Message 형태로 전달 |
| `PromptChatMemoryAdvisor` | 이전 대화를 Prompt 형태로 포함 |
| `VectorStoreChatMemoryAdvisor` | VectorStore를 이용해 관련 기억을 검색 |

일반적인 대화 기억에서는 `MessageChatMemoryAdvisor`를 사용하면 이해하기 쉽다.

---

## 4. ChatMemory 설정

예를 들어 최근 메시지를 최대 20개까지 기억하도록 설정할 수 있다.

```java
@Configuration
public class AiConfig {

    @Bean
    ChatMemory chatMemory() {
        return MessageWindowChatMemory.builder()
                .maxMessages(20)
                .build();
    }

    @Bean
    ChatClient chatClient(
            ChatClient.Builder builder,
            ChatMemory chatMemory) {

        return builder
                .defaultAdvisors(
                        MessageChatMemoryAdvisor
                                .builder(chatMemory)
                                .build()
                )
                .build();
    }
}
```

여기서

```java
.maxMessages(20)
```

은 **사용자 질문 20개**를 의미하는 것이 아니다.

사용자와 AI가 주고받은 **Message의 개수**를 기준으로 한다.

예를 들어

```text
User       1
Assistant  2
User       3
Assistant  4
...
```

처럼 각각의 메시지가 하나의 개수로 계산된다.

---

## 5. conversationId

대화 기억에서 중요한 개념이 `conversationId`이다.

사용자 A와 사용자 B의 대화가 서로 섞이면 안 되기 때문에 각각의 대화를 구분할 수 있는 ID가 필요하다.

예를 들어:

```text
conversationId = user1
```

```text
conversationId = user2
```

라면 서로 다른 대화 기록으로 관리할 수 있다.

---

## 6. ChatController에서 사용하기

```java
@RestController
@RequestMapping("/chat")
public class ChatController {

    private final ChatClient chatClient;

    public ChatController(ChatClient chatClient) {
        this.chatClient = chatClient;
    }

    @GetMapping
    public String chat(
            @RequestParam String message,
            @RequestParam String conversationId) {

        return chatClient.prompt()
                .user(message)
                .advisors(a -> a.param(
                        ChatMemory.CONVERSATION_ID,
                        conversationId
                ))
                .call()
                .content();
    }
}
```

호출은 다음과 같이 할 수 있다.

```text
/chat?conversationId=user1&message=저는 Java 개발자입니다.
```

이후:

```text
/chat?conversationId=user1&message=제 직업은 무엇인가요?
```

같은 `conversationId`를 사용하면 이전 대화를 찾아서 현재 질문과 함께 LLM에 전달할 수 있다.

---

## 7. 전체 동작 흐름

```text
첫 번째 요청
────────────────────────

User
"저는 Java 개발자입니다."
        ↓
ChatClient
        ↓
ChatMemory
        ↓
conversationId = user1
        ↓
대화 기록 저장


두 번째 요청
────────────────────────

User
"제 직업은 무엇인가요?"
        ↓
conversationId = user1
        ↓
ChatMemory에서 이전 대화 조회
        ↓
┌─────────────────────────┐
│ User: 저는 Java 개발자입니다. │
│ User: 제 직업은 무엇인가요?   │
└─────────────────────────┘
        ↓
LLM
        ↓
"Java 개발자입니다."
```

즉, ChatMemory는 **이전 대화를 찾아 현재 요청의 문맥으로 사용할 수 있도록 만드는 기능**이다.

---

## 8. In-Memory 대화 기억

가장 간단한 방식은 서버의 메모리(RAM)에 대화 기록을 저장하는 것이다.

```java
@Bean
ChatMemory chatMemory() {

    return MessageWindowChatMemory.builder()
            .chatMemoryRepository(
                    new InMemoryChatMemoryRepository()
            )
            .maxMessages(10)
            .build();
}
```

### 장점

- 설정이 간단하다.
- 별도의 DB가 필요하지 않다.
- 학습 및 테스트에 적합하다.

### 단점

- 서버가 종료되면 데이터가 사라진다.
- 여러 서버가 각각 다른 메모리를 사용한다.
- 운영 환경의 영구 저장소로 사용하기 어렵다.

따라서 **실습이나 간단한 테스트**에서 사용하기 좋다.

---

## 9. ChatMemory 직접 조회

필요하다면 저장된 대화를 직접 조회할 수도 있다.

```java
List<Message> messages =
        chatMemory.get("user1");
```

조회한 메시지를 확인할 수도 있다.

```java
for (Message message : messages) {
    System.out.println(message.getText());
}
```

대화 기록을 삭제할 수도 있다.

```java
chatMemory.clear("user1");
```

실습에서는 다음과 같이 테스트하면 좋다.

```text
사용자 A
conversationId = user1

사용자 B
conversationId = user2
```

A와 B가 서로 다른 대화 기록을 가지고 있는지 확인하면 `conversationId`의 역할을 이해하기 쉽다.

---

## 10. RDBMS에 대화 기억 저장

실제 서비스에서는 MySQL이나 PostgreSQL과 같은 **RDBMS에 대화 기록을 저장**하는 방법도 많이 고려한다.

```text
ChatClient
    ↓
ChatMemory
    ↓
ChatMemoryRepository
    ↓
MySQL / PostgreSQL
```

### 장점

- 서버를 재시작해도 대화 기록이 유지된다.
- 사용자별 대화 기록을 관리할 수 있다.
- 대화 내역 조회 및 삭제가 가능하다.
- 여러 애플리케이션 서버에서 동일한 데이터를 사용할 수 있다.
- DB 백업 및 운영 관리가 가능하다.

---

## 11. JDBC 기반 ChatMemory

Spring AI에서는 JDBC 기반의 `ChatMemoryRepository`를 사용할 수 있다.

Gradle 의존성 예시:

```gradle
implementation 'org.springframework.ai:spring-ai-starter-model-openai'
implementation 'org.springframework.ai:spring-ai-starter-model-chat-memory-repository-jdbc'

runtimeOnly 'com.mysql:mysql-connector-j'
```

DB 설정:

```properties
spring.datasource.url=jdbc:mysql://localhost:3306/aidb
spring.datasource.username=root
spring.datasource.password=1234
```

Spring AI 버전에 따라 JDBC 저장소의 스키마 초기화 설정 방식이 다를 수 있으므로 **사용 중인 버전의 공식 문서를 확인하는 것이 좋다.**

운영 환경에서는 애플리케이션 시작 시 DB 스키마를 자동 생성하기보다는 **Flyway 또는 Liquibase를 이용해 스키마 변경을 관리하는 방식**이 적합하다.

---

## 12. JDBC ChatMemory 설정

Repository를 Spring Bean으로 주입받아 `ChatMemory`를 구성할 수 있다.

```java
@Configuration
public class MemoryConfig {

    @Bean
    ChatMemory chatMemory(
            ChatMemoryRepository repository) {

        return MessageWindowChatMemory.builder()
                .chatMemoryRepository(repository)
                .maxMessages(20)
                .build();
    }
}
```

이렇게 구성하면 직접 MyBatis Mapper를 작성하지 않아도 Spring AI가 제공하는 JDBC Repository를 이용해 대화 기록을 관리할 수 있다.

다만 실제 서비스에서

- 대화 제목
- 생성일
- 사용자 권한
- 대화방 정보
- 검색 조건
- 읽음 여부

등을 별도로 관리해야 한다면 애플리케이션의 별도 테이블과 비즈니스 로직을 구성할 수 있다.

---

## 13. VectorStore 기반 대화 기억

일반적인 ChatMemory는 **최근 대화의 흐름을 유지하는 것**에 적합하다.

하지만 오래된 대화 중에서 현재 질문과 관련된 내용을 찾아야 하는 경우에는 VectorStore를 활용할 수 있다.

VectorStore 방식은 대략 다음과 같다.

```text
대화 내용
    ↓
Embedding
    ↓
VectorStore 저장
    ↓
사용자 질문
    ↓
Embedding
    ↓
유사도 검색
    ↓
관련 과거 대화
    ↓
LLM
```

예를 들어 사용자가 3개월 전에

```text
"저는 Oracle DB를 사용합니다."
```

라고 이야기했다고 하자.

최근 대화 기록에는 해당 내용이 없더라도 VectorStore에서 현재 질문과 관련된 과거 내용을 검색할 수 있다.

```text
현재 질문
"제가 사용하는 데이터베이스는?"
        ↓
VectorStore 검색
        ↓
"저는 Oracle DB를 사용합니다."
        ↓
LLM
        ↓
"Oracle DB를 사용한다고 말씀하셨습니다."
```

---

## 14. 일반 ChatMemory와 VectorStore 비교

| 구분 | 일반 ChatMemory | VectorStore |
|---|---|---|
| 검색 기준 | 최근 대화 / 대화 순서 | 의미적 유사도 |
| 저장 내용 | Message | 임베딩된 Document |
| 장점 | 최근 문맥 유지 | 오래된 관련 정보 검색 |
| 적합한 서비스 | 일반적인 챗봇 | 장기 기억이 필요한 AI |
| 핵심 목적 | 대화 흐름 유지 | 관련 기억 검색 |

둘은 서로 완전히 대체하는 관계라기보다는 **용도가 다르다.**

---

## 15. VectorStore에 기억 저장

예를 들어 대화 내용을 VectorStore에 저장할 수 있다.

```java
@Service
@RequiredArgsConstructor
public class MemoryService {

    private final VectorStore vectorStore;

    public void saveMemory(
            String conversationId,
            String message) {

        Document document = new Document(
                message,
                Map.of(
                        "conversationId", conversationId
                )
        );

        vectorStore.add(List.of(document));
    }
}
```

이후 현재 질문과 유사한 기억을 검색한다.

```java
List<Document> memories =
        vectorStore.similaritySearch(
                SearchRequest.builder()
                        .query("제가 사용하는 DB는?")
                        .topK(3)
                        .build()
        );
```

검색된 결과를 LLM에 Context로 전달하면 오래된 대화 내용도 활용할 수 있다.

> 실제 구현에서는 VectorStore에 저장하는 과정, Embedding 모델, 메타데이터 필터링 등을 함께 고려해야 한다.

---

## 16. Cassandra 기반 대화 기억

대화 데이터가 매우 많고 여러 서버에서 높은 처리량이 필요한 경우에는 Cassandra와 같은 분산형 NoSQL 데이터베이스도 고려할 수 있다.

Cassandra는 대규모 분산 데이터 저장을 목적으로 하는 Wide-column 데이터베이스이다.

| 구분 | RDBMS | Cassandra |
|---|---|---|
| 데이터 모델 | 관계형 테이블 | Wide-column |
| 확장 | 수직 + 수평 확장 | 수평 확장 중심 |
| 질의 | SQL | CQL |
| 트랜잭션 | 강력한 트랜잭션 지원 | 제한적인 트랜잭션 |
| 적합한 환경 | 일반적인 챗봇 | 대규모 분산 시스템 |
| 학습 난이도 | 비교적 낮음 | 비교적 높음 |

다만 Cassandra를 사용한다고 해서 무조건 성능이 좋아지는 것은 아니다.

서비스의

- 데이터 규모
- 트래픽
- 조회 패턴
- 일관성 요구사항
- 운영 환경

등을 고려해서 저장소를 선택해야 한다.

또한 Spring AI에서 제공하는 Cassandra 관련 Repository 지원 여부는 **사용 중인 Spring AI 버전을 기준으로 확인**해야 한다.

---

## 17. Chat Memory 저장 방식 비교

전체적으로 정리하면 다음과 같다.

| 방식 | 저장 위치 | 장점 | 단점 | 추천 용도 |
|---|---|---|---|---|
| In-Memory | 서버 RAM | 간단함 | 서버 종료 시 삭제 | 학습 / 테스트 |
| RDBMS | MySQL / PostgreSQL | 영구 저장, 관리 편리 | DB 관리 필요 | 일반 서비스 |
| VectorStore | Vector DB | 의미 기반 검색 | Embedding 필요 | 장기 기억 |
| Cassandra | 분산 NoSQL | 대규모 수평 확장 | 운영 복잡도 높음 | 대규모 분산 서비스 |

---

## 18. Chat Memory 전체 구조

```text
                    ChatClient
                        │
                        ▼
                ChatMemory Advisor
                        │
                        ▼
                   ChatMemory
                        │
                        ▼
              ChatMemoryRepository
                        │
          ┌─────────────┼─────────────┐
          ▼             ▼             ▼
     In-Memory        JDBC        기타 저장소
          │             │
          ▼             ▼
         RAM       MySQL/PostgreSQL
```

VectorStore를 사용하는 경우에는 조금 다른 방식으로 볼 수 있다.

```text
사용자 대화
    ↓
Embedding
    ↓
VectorStore
    ↓
의미 기반 검색
    ↓
관련 기억
    ↓
Prompt Context
    ↓
LLM
```

---

## 19. Chat Memory와 이전 Prompt 내용의 관계

앞에서 배운 `AssistantMessage`와도 연결된다.

단순하게 이전 대화를 직접 Prompt에 넣는다면:

```text
SystemMessage
    ↓
UserMessage
    ↓
AssistantMessage
    ↓
UserMessage
```

처럼 이전 대화 전체를 직접 구성해야 한다.

하지만 ChatMemory를 사용하면 이러한 대화 기록 관리를 애플리케이션에서 직접 처리하는 부담을 줄일 수 있다.

```text
사용자 질문
    ↓
ChatClient
    ↓
ChatMemory Advisor
    ↓
이전 대화 조회
    ↓
현재 요청에 대화 기록 포함
    ↓
LLM
```

즉,

> **ChatMemory는 이전에 배운 Message와 Prompt를 실제 대화형 서비스에서 관리하기 위한 기능이라고 볼 수 있다.**

---

## 20. 핵심 정리

### ChatMemory

> AI 챗봇의 대화 기록을 관리하는 기능

### ChatMemoryRepository

> 대화 기록을 저장하고 조회하는 저장소

### MessageChatMemoryAdvisor

> 저장된 대화를 현재 LLM 요청에 포함시키는 역할

### conversationId

> 사용자 또는 대화방을 구분하는 식별자

### In-Memory

> 간단한 테스트에 적합하지만 서버 종료 시 데이터가 사라짐

### RDBMS

> 영구적인 대화 기록 관리에 적합

### VectorStore

> 오래된 대화 중 현재 질문과 관련된 내용을 의미적으로 검색할 때 적합

---

## 한 번에 이해하기

```text
LLM
→ 기본적으로 이전 대화를 기억하지 않음

ChatMemory
→ 이전 대화를 관리

ChatMemoryRepository
→ 대화를 저장하고 조회

Advisor
→ 이전 대화를 현재 LLM 요청에 연결

conversationId
→ 누구의 대화인지 구분

In-Memory
→ RAM에 저장

RDBMS
→ DB에 저장

VectorStore
→ 의미가 비슷한 과거 기억을 검색
```

따라서 일반적인 챗봇은 **RDBMS + ChatMemory**로 대화 기록을 관리할 수 있고, 오래된 정보까지 의미적으로 찾아야 하는 서비스라면 **VectorStore를 추가로 활용하는 구조**를 고려할 수 있다.