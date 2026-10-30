---
layout: post
title: "Spring AI - Chatbot, Image Generation, Vision"
date: 2026-10-30 00:00:00 +0900
categories: [Spring]
section: spring-ai
tags: [Spring, AI]
---

# Spring AI - Chatbot, Image Generation, Vision

## 1. Spring AI란?

Spring AI는 Spring 애플리케이션에서 AI 모델을 쉽게 사용할 수 있도록 지원하는 프레임워크이다.

OpenAI와 같은 AI 모델을 Spring Boot 프로젝트에 연동하여 다양한 AI 기능을 구현할 수 있다.

### 주요 활용 기능

| 기능 | 입력 | 출력 | 활용 |
|---|---|---|---|
| 일반 채팅(Chat) | 텍스트 | 텍스트 | 질문 및 답변 |
| 이미지 생성(Image Generation) | 텍스트 | 이미지 | 프롬프트 기반 이미지 생성 |
| 이미지 분석(Vision) | 텍스트 + 이미지 | 텍스트 | 이미지 내용 분석 |

### 기능별 이해

- 일반 채팅: 사용자가 질문하면 AI가 답변을 생성한다.
- 이미지 생성: 사용자가 원하는 이미지를 설명하면 AI가 이미지를 생성한다.
- Vision: 사용자가 이미지를 첨부하면 AI가 이미지 내용을 분석하고 설명한다.

비유하면 다음과 같다.

- 일반 채팅: 전화 상담
- 이미지 생성: 사용자의 설명을 바탕으로 그림 제작
- Vision: 영상 통화처럼 화면을 함께 보면서 상담

---

# 2. Spring AI 이미지 생성 (Image Generation)

## 2-1. 이미지 생성이란?

사용자가 입력한 텍스트 프롬프트를 기반으로 AI가 새로운 이미지를 생성하는 기능이다.

예를 들어,

```text
입력 : 우주복을 입은 고양이를 그려줘.

         ↓

Spring AI

         ↓

OpenAI 이미지 생성 모델

         ↓

출력 : 생성된 이미지 URL
```

Spring AI에서는 `ImageModel`을 활용하여 이미지 생성 모델을 호출할 수 있다.

## 2-2. 이미지 생성 컨트롤러

```java
@GetMapping("/imgGen")
@ResponseBody
public String generateImage(
        @RequestParam("request") String request) {

    // 1. 사용자 요청 확인
    System.out.println("*******************" + request);

    // 2. 이미지 생성 옵션 설정
    ImageOptions options = ImageOptionsBuilder.builder()
            .withModel("dall-e-3")
            .withWidth(1024)
            .withHeight(1024)
            .build();

    // 3. 프롬프트 생성
    ImagePrompt prompt = new ImagePrompt(request, options);

    // 4. 이미지 생성 모델 호출
    ImageResponse response = imageModel.call(prompt);

    // 5. 생성된 이미지 URL 추출
    String imageUrl = response.getResult().getOutput().getUrl();

    System.out.println("생성된 이미지의 URL : " + imageUrl);

    // 6. URL 반환
    return imageUrl;
}
```

### 코드 분석

| 코드 | 역할 |
|---|---|
| `@GetMapping("/imgGen")` | GET 방식 요청 처리 |
| `@ResponseBody` | 반환값을 HTTP 응답 본문으로 전달 |
| `@RequestParam` | URL의 요청 파라미터 추출 |
| `ImageOptions` | 이미지 생성 모델 및 크기 설정 |
| `ImagePrompt` | 사용자 프롬프트와 생성 옵션 구성 |
| `imageModel.call()` | 이미지 생성 모델 호출 |
| `getUrl()` | 생성된 이미지 URL 추출 |

## 2-3. 실제 실행 흐름

브라우저에서 다음 주소로 요청한다.

```text
http://localhost:8080/imgGen?request=우주복 입은 고양이
```

처리 과정:

```text
① 브라우저 GET 요청
        ↓
② @RequestParam
   request = "우주복 입은 고양이"
        ↓
③ ImageOptions 생성
   모델 및 이미지 크기 설정
        ↓
④ ImagePrompt 생성
   프롬프트 + 옵션
        ↓
⑤ imageModel.call()
        ↓
   OpenAI 이미지 생성 모델
        ↓
⑥ ImageResponse 수신
        ↓
⑦ 생성된 이미지 URL 추출
        ↓
⑧ 브라우저에 URL 문자열 반환
```

**주의:** `@ResponseBody`를 사용했기 때문에 브라우저에 이미지 자체가 표시되는 것이 아니라 이미지 URL 문자열이 반환된다. 실제 이미지를 화면에 표시하려면 프론트엔드에서 해당 URL을 이미지 요소의 `src`로 사용해야 한다.

---

# 3. Spring AI를 활용한 쇼핑몰 챗봇

## 3-1. 프로젝트 시나리오

온라인 쇼핑몰의 고객 상담 업무를 자동화하는 AI 챗봇을 구현한다.

고객이 상품에 대해 질문하면 미리 정의한 상품 정보를 기반으로 답변을 생성한다.

### 주요 기능

1. 상품 정보 제공
   - 상품명, 가격, 특징, 재고 상태 안내

2. 대화 문맥 유지
   - 이전 대화 내용을 기억하여 자연스러운 대화 진행

3. 시스템 프롬프트 활용
   - 챗봇의 역할과 답변 규칙을 미리 정의
   - 일관된 응답 형식 유지

## 3-2. 프로젝트 의존성 설정

주요 의존성:

| 의존성 | 역할 |
|---|---|
| Spring AI OpenAI Starter | OpenAI 모델 연동 |
| Lombok | Getter, Setter 등 반복 코드 간소화 |
| Spring Boot DevTools | 개발 중 자동 재시작 등 지원 |
| Spring Web | REST API 구현 |

Spring AI 의존성은 프로젝트에서 사용하는 Spring Boot 버전과 호환되는 버전으로 설정한다.

## 3-3. OpenAI API Key 설정

`application.properties`에 API Key를 설정한다.

```properties
spring.ai.openai.api-key=${OPENAI_API_KEY}
```

실제 API Key는 환경변수로 관리한다.

Windows PowerShell 예시:

```powershell
$env:OPENAI_API_KEY="발급받은_API_KEY"
```

API Key는 GitHub에 업로드하지 않는다.

---

# 4. System Prompt (시스템 프롬프트)

## 4-1. 시스템 프롬프트란?

시스템 프롬프트는 AI가 어떤 역할을 수행하고 어떤 규칙에 따라 답변해야 하는지 미리 정의하는 지침이다.

일반적인 사용자 질문과 달리 AI의 역할, 답변 방식, 제한 사항 등을 설정할 수 있다.

예를 들어 쇼핑몰 챗봇이라면 다음과 같은 규칙을 설정할 수 있다.

- 친절한 고객 상담원 역할
- 등록된 상품 정보 기반으로 답변
- 상품 가격 및 재고 정보 안내
- 등록되지 않은 상품에 대한 답변 제한

## 4-2. 시스템 프롬프트 작성

```java
private final String systemPrompt = """
    당신은 "Awesome Tech"라는 회사의 E-커머스 고객 지원 챗봇입니다.
    항상 친절하고 명확하게 답변해야 합니다.

    사용자가 상품에 대해서 물으면 아래 정보를 기반으로 답해주세요.

    - 상품명: 갤럭시 AI 북
    - 가격: 1,500,000원
    - 특징: 최신 AI 기능이 탑재된 고성능 노트북,
      가볍고 배터리가 오래간다.
    - 재고: 현재 구매 가능

    - 상품명: AI 스마트 워치
    - 가격: 350,000원
    - 특징: 건강 모니터링이 가능하고,
      스마트폰과 연동 기능을 제공한다.
      방수 기능을 포함한다.
    - 재고: 품절(5일 후 재입고 예정)

    내부에 없는 정보일 경우,
    정중히 안내하면서도 일반적인 정보가
    유사한 내용을 최대한 제공해 주세요.
    """;
```

### 시스템 프롬프트의 역할

AI에게 상품 정보를 직접 제공하고