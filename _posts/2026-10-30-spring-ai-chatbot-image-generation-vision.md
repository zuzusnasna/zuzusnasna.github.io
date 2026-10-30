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

AI에게 상품 정보를 직접 제공하고 해당 정보를 기반으로 답변하도록 유도한다.

이 방식은 상품 정보가 많지 않은 간단한 실습에서 사용할 수 있다.

다만 실제 쇼핑몰에서는 상품 정보를 코드에 직접 작성하기보다 DB나 외부 데이터에서 조회하여 AI에 전달하는 방식이 적절하다.

---

# 5. Postman을 이용한 챗봇 테스트

## 5-1. API 요청 설정

```text
Method : POST
URL    : http://localhost:8090/chat
```

Headers:

```text
Content-Type : application/json
```

Body → raw → JSON

## 5-2. 테스트 1 : 갤럭시 AI 북

요청:

```json
{
    "userId": "kglim",
    "message": "갤럭시 AI 북"
}
```

예상 응답 내용:

- 상품명: 갤럭시 AI 북
- 가격: 1,500,000원
- 특징: AI 기능 탑재, 가벼운 무게, 긴 배터리 사용 시간
- 재고: 구매 가능

## 5-3. 테스트 2 : AI 스마트 워치

요청:

```json
{
    "userId": "kglim",
    "message": "AI 스마트 워치"
}
```

예상 응답 내용:

- 상품명: AI 스마트 워치
- 가격: 350,000원
- 특징: 건강 모니터링, 스마트폰 연동, 방수
- 재고: 품절, 5일 후 재입고 예정

## 5-4. 테스트 3 : 상품 목록

요청:

```json
{
    "userId": "kglim",
    "message": "AI 제품 리스트"
}
```

예상 응답:

등록된 두 상품의 정보를 안내한다.

## 5-5. 테스트 4 : 일반적인 AI 질문

요청:

```json
{
    "userId": "kglim",
    "message": "OPEN AI란?"
}
```

기존 시스템 프롬프트에서는 등록된 상품 외의 정보에 대해서도 일반적인 정보를 제공하도록 설정했다.

따라서 상품 정보가 아닌 일반적인 질문에도 답변할 수 있다.

---

# 6. 시스템 프롬프트 변경에 따른 답변 제어

기존 프롬프트:

```text
내부에 없는 정보일 경우,
정중히 안내하면서도 일반적인 정보가
유사한 내용을 최대한 제공해 주세요.
```

변경 프롬프트:

```text
내부에 없는 정보일 경우,
정중히 "죄송합니다. 제품이 없습니다."
라고 답변해 주세요.
```

### 변경 전후 비교

| 질문 | 변경 전 | 변경 후 |
|---|---|---|
| 갤럭시 AI 북 | 상품 정보 안내 | 상품 정보 안내 |
| AI 스마트 워치 | 상품 정보 안내 | 상품 정보 안내 |
| OPEN AI란? | 일반적인 설명 가능 | 제품이 없다는 안내 |
| 구름이 뭐지? | 일반적인 설명 가능 | 제품이 없다는 안내 |

### 핵심 개념

시스템 프롬프트를 변경하면 AI의 역할과 답변 범위를 제어할 수 있다.

같은 질문을 입력하더라도 시스템 프롬프트에 정의된 규칙에 따라 서로 다른 답변이 생성될 수 있다.

단, 프롬프트는 모델의 응답을 유도하는 지침이지 보안이나 데이터 접근을 강제하는 완전한 통제 수단은 아니다. 실제 서비스에서는 서버 측에서 상품 존재 여부를 검증하는 것이 안전하다.

---

# 7. Spring AI Vision (이미지 분석)

## 7-1. Vision이란?

Vision은 AI가 텍스트뿐만 아니라 이미지를 함께 입력받아 이미지에 포함된 내용을 분석하는 기능이다.

일반 채팅이 텍스트를 기반으로 답변한다면 Vision은 이미지와 질문을 함께 전달하여 이미지의 내용을 이해하고 답변을 생성한다.

### 일반 채팅 / 이미지 생성 / Vision 비교

| 구분 | 입력 | 출력 |
|---|---|---|
| 일반 채팅 | 텍스트 | 텍스트 |
| 이미지 생성 | 텍스트 | 이미지 |
| Vision | 텍스트 + 이미지 | 텍스트 |

예시:

```text
일반 채팅

"부산 맛집 알려줘"
       ↓
텍스트 답변
```

```text
이미지 생성

"우주복 입은 고양이 그려줘"
       ↓
이미지 생성
```

```text
Vision

"이 사진 속 음식이 뭐야?"
       +
    음식 사진
       ↓
음식 분석 및 설명
```

## 7-2. Vision의 내부 구조

Vision은 별도의 이미지 생성 API가 아니라 이미지 입력을 지원하는 멀티모달 채팅 모델을 활용하는 방식이다.

Spring AI에서는 기존 ChatClient의 UserMessage에 이미지 Media를 추가하여 전달할 수 있다.

```text
UserMessage
   |
   ├── text
   |     "이 사진 분석해줘"
   |
   └── media
         └── image/png
               └── 이미지 데이터
```

즉, AI에게 질문과 이미지를 동시에 전달하는 구조이다.

---

# 8. Spring AI Vision 구현 방법

이미지를 전달하는 방법은 크게 세 가지로 나눌 수 있다.

## 8-1. 프로젝트 내부 이미지 사용

프로젝트의 `resources` 폴더에 저장된 이미지를 사용하는 방법이다.

```java
ClassPathResource image =
        new ClassPathResource("images/food.jpg");

String result = chatClient.prompt()
        .user(u -> u.text("이 음식의 이름과 예상 칼로리를 알려줘")
                    .media(MimeTypeUtils.IMAGE_JPEG, image))
        .call()
        .content();
```

### 처리 과정

```text
resources/images/food.jpg
          ↓
ClassPathResource
          ↓
이미지 데이터 읽기
          ↓
ChatClient에 질문 + 이미지 전달
          ↓
AI 이미지 분석
          ↓
텍스트 결과 반환
```

수업 실습이나 미리 준비한 이미지 분석에 적합하다.

## 8-2. 사용자 업로드 이미지 사용

사용자가 직접 업로드한 이미지를 분석하는 방법이다.

Spring MVC의 `MultipartFile`을 활용한다.

```java
.media(
    MimeType.valueOf(file.getContentType()),
    file.getResource()
)
```

### 처리 과정

```text
사용자 이미지 업로드
          ↓
MultipartFile
          ↓
이미지 MIME Type 확인
          ↓
getResource()
          ↓
ChatClient에 이미지 전달
          ↓
AI 분석 결과 반환
```

실제 쇼핑몰이나 웹 서비스에서 사용자가 이미지를 직접 첨부하는 기능을 구현할 때 활용할 수 있다.

## 8-3. 인터넷 이미지 URL 사용

인터넷에 공개된 이미지 URL을 이용하여 이미지를 전달하는 방법이다.

```java
.media(
    MimeTypeUtils.IMAGE_PNG,
    new URL("https://example.com/cat.png")
)
```

### 처리 과정

```text
이미지 URL
    ↓
URL 객체 생성
    ↓
ChatClient에 이미지 전달
    ↓
AI 이미지 분석
    ↓
텍스트 결과 반환
```

실제 사용 시 해당 이미지에 접근할 수 있어야 하며, URL의 이미지 형식과 모델의 입력 지원 여부도 확인해야 한다.

---

# 9. Vision의 실제 활용 분야

| 분야 | 활용 사례 |
|---|---|
| 금융·회계 | 영수증, 명함 등 이미지 정보 추출 |
| 쇼핑몰 | 상품 사진을 기반으로 상품 설명 및 태그 생성 |
| 제조 | 제품 사진을 이용한 외관 불량 분석 |
| 교육 | 손글씨 수학 풀이 분석 |
| 데이터 분석 | 차트 이미지를 기반으로 데이터 추세 해석 |

### 실제 서비스 활용 예시

쇼핑몰에 Vision을 적용한다면 다음과 같은 흐름으로 구현할 수 있다.

```text
① 사용자가 상품 사진 업로드
           ↓
② Spring Boot에서 이미지 수신
           ↓
③ Spring AI ChatClient에 전달
           ↓
④ Vision 모델이 이미지 분석
           ↓
⑤ 상품 특징 및 설명 생성
           ↓
⑥ 분석 결과를 사용자에게 제공
```

---

# 10. 프론트엔드 실행 (React + Vite)

Spring AI 챗봇을 웹 화면에서 사용하기 위해 React와 Vite 기반 프론트엔드를 실행한다.

### 10-1. 프로젝트 경로

```text
C:\edu\SpringAI\Labs\springai-chatbot-ui
```

### 10-2. 패키지 설치

프로젝트 폴더에서 터미널을 실행한다.

```bash
npm install
```

실행 결과:

```text
added 158 packages, and audited 159 packages

35 packages are looking for funding

16 vulnerabilities
```

`npm install`은 `package.json`에 정의된 패키지를 설치한다.

### 10-3. 개발 서버 실행

```bash
npm run dev
```

실행 결과:

```text
VITE v7.0.6 ready

Local:   http://localhost:5173/
Network: http://192.168.1.118:5173/
```

브라우저에서 다음 주소로 접속한다.

```text
http://localhost:5173/
```

### 10-4. npm audit 주의사항

설치 과정에서 다음 메시지가 출력되었다.

```text
16 vulnerabilities
(1 low, 2 moderate, 13 high)
```

이는 설치된 패키지 중 보안 취약점이 보고된 패키지가 있다는 의미이다.

확인 명령어:

```bash
npm audit
```

자동 수정 가능한 항목 수정:

```bash
npm audit fix
```

주의할 점:

`npm audit fix --force`는 의존성의 주요 버전을 변경할 수 있으므로 무조건 실행하지 않는다. 수정 후에는 빌드 및 기능 테스트가 필요하다.

---

# 11. 전체 학습 내용 정리

| 개념 | 핵심 내용 |
|---|---|
| Spring AI | Spring Boot에서 AI 모델을 연동하는 프레임워크 |
| Image Generation | 텍스트 프롬프트를 기반으로 이미지 생성 |
| ImageModel | 이미지 생성 모델 호출 |
| ImageOptions | 이미지 생성 옵션 설정 |
| ImagePrompt | 이미지 생성 요청 구성 |
| ImageResponse | 이미지 생성 결과 수신 |
| System Prompt | AI의 역할과 답변 규칙 정의 |
| ChatClient | AI 채팅 모델과 상호작용하는 인터페이스 |
| Vision | 텍스트와 이미지를 함께 입력하여 이미지 분석 |
| UserMessage | 사용자 메시지 구성 |
| Media | 이미지 등의 멀티모달 데이터 전달 |
| MultipartFile | 사용자가 업로드한 파일 처리 |
| Vite | 프론트엔드 개발 서버 및 빌드 도구 |

## 핵심 흐름

```text
Spring AI
   |
   ├── Image Generation
   |      ├── ImageOptions
   |      ├── ImagePrompt
   |      ├── ImageModel
   |      └── ImageResponse
   |
   ├── Chatbot
   |      ├── ChatClient
   |      ├── System Prompt
   |      └── 사용자 질문 및 답변
   |
   └── Vision
          ├── UserMessage
          ├── Media
          └── 이미지 분석 결과
```

### 오늘의 한 줄 정리

> Spring AI를 활용하면 Spring Boot 환경에서 텍스트 기반 챗봇뿐만 아니라 프롬프트를 이용한 이미지 생성과 이미지 분석까지 구현할 수 있으며, System Prompt를 통해 AI의 역할과 답변 방향도 설정할 수 있다.