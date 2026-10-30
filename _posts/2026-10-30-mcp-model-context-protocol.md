---
layout: post
title: "MCP (Model Context Protocol)"
date: 2026-10-30 00:00:00 +0900
categories: [Java]
section: java-io
tags: [MCP]
---

# MCP (Model Context Protocol)

## 1. MCP란?

MCP(Model Context Protocol)는 AI 애플리케이션이 외부 도구와 데이터에 연결할 수 있도록 만든 **표준 통신 프로토콜**이다.

일반적인 LLM은 학습된 데이터와 전달받은 입력을 기반으로 답변을 생성하지만, 외부 데이터베이스나 파일 시스템 등의 정보에 직접 접근할 수는 없다.

MCP를 활용하면 외부 시스템에서 제공하는 기능과 데이터를 AI 애플리케이션에 연결할 수 있다.

### MCP를 사용하는 이유

예를 들어 사용자가 다음과 같이 질문했다고 가정한다.

```text
우리 회사의 10월 매출을 조회하고
지난달과 비교해 줘.
```

일반적인 LLM은 회사 내부 데이터베이스에 직접 접근할 수 없기 때문에 실제 매출을 조회할 수 없다.

하지만 MCP를 사용하면 데이터베이스 조회 기능을 제공하는 외부 MCP Server와 연결하여 필요한 정보를 가져올 수 있다.

```text
사용자
  |
  | "10월 매출을 조회해 줘."
  ↓
AI 애플리케이션
  |
  ↓
MCP Client
  |
  ↓
MCP Server
  |
  ↓
데이터베이스 조회 Tool
  |
  ↓
10월 매출 데이터 반환
  |
  ↓
AI가 데이터 분석 및 답변 생성
```

즉, MCP는 AI가 외부 시스템의 기능과 데이터에 접근할 수 있도록 연결해 주는 역할을 한다.

---

## 2. MCP의 주요 구성 요소

MCP는 크게 Host, Client, Server로 구성된다.

### 2-1. MCP Host

MCP를 사용하는 AI 애플리케이션 자체를 의미한다.

사용자의 요청을 받고 AI 모델을 실행하며 MCP Client를 통해 외부 기능을 이용한다.

예시:
- Spring AI 애플리케이션
- Claude Desktop
- MCP를 지원하는 AI 애플리케이션

### 2-2. MCP Client

MCP Host 내부에서 MCP Server와 통신하는 구성 요소이다.

MCP Server가 제공하는 도구나 데이터를 확인하고 요청을 전달하는 역할을 한다.

예를 들어 매출 조회 기능이 필요하다면 해당 기능을 제공하는 MCP Server에 요청한다.

### 2-3. MCP Server

외부 시스템의 기능과 데이터를 MCP 프로토콜에 맞게 제공하는 서버이다.

예를 들어 회사 데이터베이스에 접근할 수 있는 MCP Server를 만들면 AI 애플리케이션에서 매출 조회 기능을 사용할 수 있다.

### 2-4. MCP가 제공하는 주요 기능

MCP Server는 대표적으로 다음 세 가지 기능을 제공한다.

| 구성 요소 | 역할 | 예시 |
|---|---|---|
| Tool | 실행 가능한 기능 제공 | `getSales()` |
| Resource | 읽을 수 있는 데이터 제공 | 문서, 설정 데이터 |
| Prompt | 재사용 가능한 프롬프트 제공 | 매출 분석 지침 |

#### Tool

AI가 외부 기능을 실행할 수 있도록 제공하는 기능이다.

```text
getSales()
getUserInfo()
searchProducts()
```

예를 들어 `getSales()`를 호출하면 데이터베이스에서 매출 정보를 조회할 수 있다.

#### Resource

AI 애플리케이션이 읽을 수 있는 외부 데이터를 제공한다.

예를 들어 다음과 같은 정보를 제공할 수 있다.

- 회사 업무 문서
- 상품 정보
- 시스템 설정 데이터
- 데이터베이스 관련 정보

#### Prompt

특정 작업을 수행할 때 재사용할 수 있도록 미리 정의한 프롬프트 템플릿이다.

예를 들어 매출 분석에 사용할 지침을 미리 정의하여 AI가 일관된 방식으로 분석하도록 할 수 있다.

---

## 3. MCP 구성 요소의 관계

```text
              MCP Host
         (Spring AI 애플리케이션)
                  |
                  |
              MCP Client
                  |
             MCP Protocol
                  |
              MCP Server
                  |
       ┌──────────┼──────────┐
       ↓          ↓          ↓
      Tool     Resource    Prompt
       |          |          |
    기능 실행   데이터 제공   지침 제공
       |
       ↓
   외부 시스템
 (DB, API, 파일 등)
```

전체적인 관계를 이해하는 것이 중요하다.

- Host: AI 애플리케이션 실행 환경
- Client: MCP Server와 연결
- Server: 외부 기능과 데이터 제공
- Tool: 실행할 수 있는 기능
- Resource: 읽을 수 있는 데이터
- Prompt: 재사용할 수 있는 지침

---

## 4. MCP와 일반적인 Tool Calling의 차이

Tool Calling은 AI 모델이 외부 기능을 호출하도록 하는 메커니즘이다.

예를 들어 AI가 사용자의 질문을 이해하고 `getSales()`라는 함수를 실행하도록 요청할 수 있다.

MCP는 이러한 외부 기능과 데이터를 표준화된 방식으로 연결하기 위한 프로토콜이다.

| 구분 | 일반 Tool Calling | MCP |
|---|---|---|
| 목적 | AI가 외부 기능 호출 | 외부 기능과 데이터 연결 표준화 |
| 도구 정의 | 애플리케이션에서 직접 정의 가능 | MCP Server에서 제공 가능 |
| 도구 연결 | 개발자가 개별 연동 | 표준 프로토콜 사용 |
| 재사용성 | 애플리케이션에 종속되기 쉬움 | 여러 MCP Client에서 재사용 가능 |
| 예시 | Spring AI `@Tool` | Spring AI MCP Client / Server |

### 일반 Tool Calling 예시

Spring AI에서 `@Tool`을 사용하여 기능을 직접 정의할 수 있다.

```java
@Tool(description = "회사의 매출 정보를 조회합니다.")
public String getSales() {
    return salesService.getMonthlySales();
}
```

이 기능은 애플리케이션에서 직접 정의하고 AI 모델이 호출할 수 있도록 연결한다.

### MCP 방식

```text
Spring AI 애플리케이션
        |
        ↓
    MCP Client
        |
        ↓
    MCP Server
        |
        ↓
    getSales()
        |
        ↓
   외부 데이터베이스
```

매출 조회 기능을 별도의 MCP Server에서 제공하면 해당 서버에 연결하는 다른 MCP Client에서도 기능을 활용할 수 있다.

### 핵심 차이

```text
Tool Calling
= AI가 기능을 호출하는 메커니즘

MCP
= 외부 기능과 데이터를 표준화하여 연결하는 프로토콜
```

MCP는 내부적으로 Tool Calling과 함께 활용될 수 있지만 두 개념이 동일한 것은 아니다.

---

## 5. MCP 통신 방식

MCP Server와 Client는 여러 방식으로 통신할 수 있다.

대표적으로 STDIO와 HTTP 기반 통신 방식이 있다.

### 5-1. STDIO

STDIO는 표준 입출력(Standard Input / Output)을 이용하여 통신하는 방식이다.

일반적으로 MCP Client가 MCP Server 프로세스를 실행하고 표준 입력과 출력으로 메시지를 주고받는다.

```text
       MCP Host
           |
           ↓
       MCP Client
           |
           ↓
     MCP Server 실행
           |
       STDIO 통신
           |
           ↓
        기능 실행
```

특징:
- 로컬 환경에서 사용하기 적합하다.
- 별도의 네트워크 서버를 실행하지 않아도 된다.
- Client가 Server 프로세스를 실행하는 형태로 구성할 수 있다.
- 로컬 파일이나 개발 도구 연결 등에 활용할 수 있다.

### 5-2. HTTP 기반 통신

HTTP를 이용하여 네트워크를 통해 MCP Client와 MCP Server가 통신하는 방식이다.

원격 서버에 MCP Server를 실행하고 Client가 URL을 통해 연결할 수 있다.

```text
        MCP Host
            |
            ↓
        MCP Client
            |
            ↓
       HTTP 통신
            |
            ↓
        MCP Server
            |
            ↓
         Tool 실행
```

특징:
- 원격 서버와 통신할 수 있다.
- 서버와 클라이언트가 서로 다른 환경에 있어도 연결할 수 있다.
- 여러 애플리케이션에서 공통 MCP Server를 활용할 수 있다.

참고로 초기 MCP에서는 HTTP + SSE 방식이 사용되었지만, 현재 표준 원격 전송 방식은 Streamable HTTP이다. SSE는 이전 방식과 호환성을 위해 사용되는 경우가 있다.

### 5-3. STDIO와 HTTP 비교

| 구분 | STDIO | HTTP 기반 |
|---|---|---|
| 통신 수단 | 표준 입출력 | 네트워크 |
| 서버 실행 | 주로 Client가 프로세스 실행 | 독립 서버 실행 가능 |
| 서버 주소 | 프로세스 실행 명령 | URL |
| 적합한 환경 | 로컬 도구 | 원격 서비스 |
| 활용 예시 | 로컬 파일 검색 | 외부 DB 조회 서비스 |

---

## 6. MCP 실제 활용 예시

### 회사 매출 분석 시스템

사용자가 AI 챗봇에 다음과 같이 질문한다.

```text
10월 매출을 조회하고 9월과 비교해 줘.
```

처리 과정:

```text
① 사용자 질문
       ↓
② MCP Host에서 요청 처리
       ↓
③ MCP Client가 사용 가능한 Tool 확인
       ↓
④ AI가 매출 조회 Tool 선택
       ↓
⑤ MCP Server에 요청 전달
       ↓
⑥ DB에서 10월 및 9월 매출 조회
       ↓
⑦ 조회 결과 반환
       ↓
⑧ AI가 매출 차이 분석
       ↓
⑨ 사용자에게 결과 전달
```

이 구조를 사용하면 AI가 직접 데이터베이스에 연결하지 않고도 MCP Server가 제공하는 기능을 통해 필요한 데이터를 활용할 수 있다.

---

## 7. 핵심 내용 정리

| 개념 | 핵심 내용 |
|---|---|
| MCP | AI와 외부 시스템을 연결하는 표준 프로토콜 |
| Host | AI 애플리케이션 실행 환경 |
| Client | MCP Server와 통신하는 구성 요소 |
| Server | 외부 기능과 데이터 제공 |
| Tool | 실행 가능한 기능 |
| Resource | 읽을 수 있는 데이터 |
| Prompt | 재사용 가능한 프롬프트 템플릿 |
| STDIO | 표준 입출력을 이용한 통신 |
| HTTP | 네트워크를 이용한 원격 통신 |

### 오늘의 핵심 정리

1. MCP는 AI 애플리케이션이 외부 도구와 데이터에 접근할 수 있도록 연결하는 표준 프로토콜이다.
2. Host는 AI 애플리케이션이고 Client는 Server와 통신하는 역할을 한다.
3. MCP Server는 Tool, Resource, Prompt를 제공할 수 있다.
4. Tool Calling은 AI가 기능을 호출하는 방식이고 MCP는 외부 기능을 연결하는 표준 프로토콜이다.
5. STDIO는 주로 로컬 환경에서, HTTP는 원격 서비스 연결에 적합하다.

### 한 줄 정리

> MCP는 AI가 외부 데이터와 기능을 활용할 수 있도록 서로 다른 애플리케이션 사이의 연결 방식을 표준화한 프로토콜이다.