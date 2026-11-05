---
layout: post
title: "Spring AI PGVector를 이용한 RAG 실습"
date: 2026-11-02 00:00:00 +0900
categories: ["Spring"]
section: spring-ai
tags: [Spring AI, PGVector, RAG]
---


앞서 RAG에서 문서를 **Embedding → VectorStore 저장 → 유사도 검색**하는 과정을 학습했다.

이번 실습에서는 PostgreSQL에 **pgvector 확장**을 추가하고 Spring AI의 `VectorStore`로 사용하는 과정을 확인한다.

전체 흐름은 다음과 같다.

```text
PDF
 ↓
PDF Reader
 ↓
Document
 ↓
Chunking
 ↓
Embedding
 ↓
PGVector
 ↓
Similarity Search
 ↓
검색 결과
```

---

## 1. PGVector란?

**pgvector**는 PostgreSQL에서 벡터 데이터를 저장하고 유사도 검색을 수행할 수 있도록 해주는 확장 기능이다.

일반적인 PostgreSQL 테이블처럼 데이터를 관리하면서 벡터 검색까지 사용할 수 있다는 것이 장점이다.

```text
PostgreSQL
 └── pgvector
      ├── 벡터 저장
      └── 유사도 검색
```

Spring AI에서는 `VectorStore`를 통해 PGVector를 사용할 수 있다.

---

## 2. Docker로 PostgreSQL + pgvector 실행

가장 간단한 방법은 pgvector가 포함된 이미지를 사용하는 것이다.

```bash
docker run -d \
  --name pgvector-db \
  -e POSTGRES_USER=reguser \
  -e POSTGRES_PASSWORD=1004 \
  -e POSTGRES_DB=regdb \
  -p 5432:5432 \
  ankane/pgvector
```

DB에 접속한 뒤 확장을 활성화한다.

```sql
CREATE EXTENSION IF NOT EXISTS vector;
```

> `vector`가 pgvector 확장의 정확한 이름이다.

---

## 3. Spring Boot 의존성

Spring AI에서 PGVector 기반 RAG를 구성하려면 다음과 같은 기능이 필요하다.

```text
Spring AI
 ├── PGVector VectorStore
 ├── PDF Document Reader
 ├── Embedding Model
 └── PostgreSQL Driver
```

프로젝트에서 사용하는 Spring AI 버전에 맞는 PGVector starter와 PostgreSQL Driver를 추가한다.

---

## 4. PostgreSQL과 PGVector 설정

```properties
spring.datasource.url=jdbc:postgresql://localhost:5432/ragdb
spring.datasource.username=raguser
spring.datasource.password=ragpass
spring.datasource.driver-class-name=org.postgresql.Driver

spring.ai.vectorstore.pgvector.index-type=HNSW
spring.ai.vectorstore.pgvector.distance-type=COSINE_DISTANCE
spring.ai.vectorstore.pgvector.dimensions=1536
spring.ai.vectorstore.pgvector.initialize-schema=true
```

각 설정의 역할은 다음과 같다.

| 설정 | 역할 |
|---|---|
| `index-type` | 벡터 검색에 사용할 인덱스 방식 |
| `distance-type` | 벡터 간 유사도를 계산하는 방식 |
| `dimensions` | Embedding 벡터의 차원 수 |
| `initialize-schema` | VectorStore에 필요한 스키마 초기화 |

### HNSW

`HNSW`는 대규모 벡터에서 빠르게 유사한 벡터를 찾기 위한 근사 최근접 이웃(ANN) 검색 인덱스 방식이다.

### COSINE_DISTANCE

두 벡터의 방향을 비교하여 의미적 유사도를 측정하는 방식이다.

### dimensions

Embedding 모델이 생성하는 벡터의 차원 수와 맞아야 한다.

예를 들어 Embedding 모델이 1536차원 벡터를 생성한다면:

```properties
spring.ai.vectorstore.pgvector.dimensions=1536
```

처럼 설정한다.

> 벡터 차원은 사용하는 Embedding 모델에 따라 달라진다. 따라서 `1536`을 항상 고정값으로 사용하는 것은 아니다.

---

## 5. VectorStore 테이블

Spring AI가 PGVector를 VectorStore로 사용하면 벡터와 문서 관련 정보를 저장할 수 있는 테이블이 생성된다.

개념적으로는 다음과 같다.

```text
PostgreSQL
    ↓
vector_store
 ├── 문서 내용
 ├── embedding vector
 └── metadata
```

즉, PDF에서 추출한 문서가 Embedding을 거쳐 벡터 형태로 저장되고 이후 검색에 사용된다.

---

## 6. PDF 문서 읽기

RAG를 사용하려면 먼저 PDF의 내용을 Spring AI가 처리할 수 있는 `Document` 형태로 가져와야 한다.

```java
PdfDocumentReaderConfig config =
        PdfDocumentReaderConfig.builder()
                .withPageTopMargin(0)
                .withPageExtractedTextFormatter(
                        ExtractedTextFormatter.builder()
                                .withNumberOfBottomTextLinesToDelete(0)
                                .build()
                )
                .withPagesPerDocument(1)
                .build();

PagePdfDocumentReader pdfReader =
        new PagePdfDocumentReader(fileResource, config);
```

### 설정 의미

| 설정 | 의미 |
|---|---|
| `withPageTopMargin(0)` | 페이지 상단에서 제거할 영역 |
| `withPageExtractedTextFormatter()` | PDF에서 추출한 텍스트 가공 |
| `withNumberOfBottomTextLinesToDelete(0)` | 페이지 하단에서 제거할 줄 수 |
| `withPagesPerDocument(1)` | 1페이지를 하나의 `Document`로 생성 |

결과적으로:

```java
List<Document> docs = pdfReader.get();
```

를 통해 PDF의 내용을 `Document` 목록으로 가져올 수 있다.

---

## 7. 왜 PDF를 바로 Embedding하지 않을까?

PDF 전체를 하나의 Document로 만들면 문서가 너무 커질 수 있다.

```text
PDF 전체
   ↓
하나의 Document
   ↓
너무 많은 내용
   ↓
검색 정확도 ↓
```

따라서 PDF를 적절한 크기의 **Chunk**로 나눈 뒤 Embedding한다.

```text
PDF
 ↓
Document
 ↓
Chunk
 ↓
Embedding
 ↓
VectorStore
```

이 과정을 **Chunking**이라고 한다.

---

## 8. TokenTextSplitter

Spring AI에서는 `TokenTextSplitter` 등을 사용하여 문서를 토큰 기준으로 나눌 수 있다.

예를 들어:

```java
TokenTextSplitter splitter =
        new TokenTextSplitter(
                1000,
                400,
                10,
                5000,
                true
        );
```

각 값은 다음과 같은 의미를 가진다.

| 값 | 의미 |
|---:|---|
| `1000` | Chunk의 목표 크기 |
| `400` | Chunk 사이의 Overlap |
| `10` | 너무 작은 Chunk를 만들지 않기 위한 최소 크기 |
| `5000` | 절대 최대 크기 |
| `true` | 가능한 자연스러운 문장 단위로 분할 |

> 생성자 인자와 기본 동작은 사용하는 Spring AI 버전에 따라 확인해야 한다.

---

## 9. Chunk Overlap

특히 중요한 부분이 **Overlap**이다.

예를 들어 다음과 같이 문서를 나눈다고 하자.

```text
Chunk 1
[내용 A][내용 B][내용 C]

Chunk 2
          [내용 C][내용 D][내용 E]
```

Chunk 1의 마지막 부분과 Chunk 2의 처음 부분을 겹치게 만든다.

이렇게 하면 Chunk 경계에서 문맥이 끊기는 문제를 줄일 수 있다.

```text
Overlap
   ↓
문맥 손실 감소
   ↓
검색 품질 개선 가능
```

단, Overlap이 무조건 클수록 좋은 것은 아니다.

너무 크게 설정하면:

- 저장해야 할 Chunk 증가
- Embedding 비용 증가
- 검색 결과에 중복 내용 증가

등의 문제가 발생할 수 있다.

따라서 문서의 특성에 맞게 조정해야 한다.

---

## 10. 전체 RAG 데이터 적재 과정

지금까지의 내용을 하나로 연결하면 다음과 같다.

```text
PDF 파일
   ↓
PagePdfDocumentReader
   ↓
Document
   ↓
TokenTextSplitter
   ↓
Chunk
   ↓
EmbeddingModel
   ↓
Vector
   ↓
PGVector
```

각 단계의 역할은 다음과 같다.

| 단계 | 역할 |
|---|---|
| PDF Reader | PDF에서 텍스트 추출 |
| Document | Spring AI에서 처리할 문서 객체 |
| TextSplitter | 문서를 작은 Chunk로 분할 |
| EmbeddingModel | Chunk를 벡터로 변환 |
| PGVector | 벡터와 문서 정보를 저장 |
| Similarity Search | 질문과 가까운 문서 검색 |

---

## 11. 검색 과정

문서가 PGVector에 저장되었다면 사용자의 질문을 기준으로 검색할 수 있다.

```text
사용자 질문
"적금 중도해지하면 어떻게 되나요?"
        ↓
Embedding
        ↓
PGVector 검색
        ↓
유사한 Chunk
        ↓
Top-K
        ↓
LLM Context
        ↓
답변
```

즉, **문서를 저장하는 과정**과 **질문을 검색하는 과정**을 구분해서 이해하는 것이 중요하다.

---

## 12. PDF RAG 실습에서 확인할 것

실습에서는 다음 과정을 순서대로 확인하면 된다.

### ① PostgreSQL 실행

```bash
docker ps
```

### ② pgvector 확장 확인

```sql
CREATE EXTENSION IF NOT EXISTS vector;
```

### ③ Spring Boot 실행

PostgreSQL과 PGVector 설정이 정상적으로 연결되는지 확인한다.

### ④ PDF 업로드

PDF Reader를 통해 `Document` 목록으로 변환한다.

### ⑤ Chunking

`TokenTextSplitter`로 문서를 작은 단위로 분할한다.

### ⑥ Embedding 및 저장

각 Chunk를 Embedding하여 PGVector에 저장한다.

```text
PDF
 ↓
Document
 ↓
Chunk
 ↓
Embedding
 ↓
vector_store
```

### ⑦ 질문 테스트

Postman 등을 이용하여 질문을 전달하고 관련 문서가 검색되는지 확인한다.

---

## 13. 핵심 정리

이번 실습에서 가장 중요한 것은 **PGVector가 RAG에서 어떤 역할을 하는지** 이해하는 것이다.

```text
              RAG

PDF
 ↓
Document
 ↓
Chunking
 ↓
Embedding
 ↓
┌──────────────────┐
│    PostgreSQL    │
│     + pgvector   │
│                  │
│ VectorStore      │
└──────────────────┘
          ↑
          │ Similarity Search
          │
      사용자 질문
          ↓
        Embedding
          ↓
      관련 문서 검색
          ↓
       LLM Context
          ↓
        AI 답변
```

### 한 줄 정리

> **PGVector는 PostgreSQL에 Embedding 벡터를 저장하고 유사도 검색을 수행하여 RAG의 검색 저장소 역할을 한다.**

그리고 전체 과정을 간단히 기억하면 된다.

```text
PDF → Document → Chunk → Embedding → PGVector
                                           ↓
질문 → Embedding → Similarity Search → 관련 문서 → LLM
```