---
layout: post
title: "Spring AI RAG(검색 증강 생성)"
date: 2026-11-02 00:00:00 +0900
categories: ["Spring"]
section: spring-ai
tags: ["GitHub Actions와 CI/CD"]
---

# Spring AI RAG(검색 증강 생성)

## 1. RAG란?

**RAG(Retrieval-Augmented Generation, 검색 증강 생성)**는 LLM이 답변하기 전에 외부 데이터에서 관련 정보를 검색하고, 검색 결과를 LLM의 Context로 함께 전달하는 방식이다.

LLM이 직접 알 수 없는 사내 문서, 최신 정보, 개인 데이터 등을 답변에 활용할 수 있다.

```text
사용자 질문
    ↓
관련 문서 검색
    ↓
검색 결과를 Context로 추가
    ↓
LLM
    ↓
답변
```

### RAG가 필요한 이유

LLM에 관련 데이터를 제공하지 않으면 존재하지 않는 정보를 그럴듯하게 생성하는 **환각(Hallucination)**이 발생할 수 있다.

RAG는 필요한 정보를 외부 데이터에서 검색하여 LLM에게 제공하기 때문에 이런 문제를 줄일 수 있다.

---

# 2. RAG와 Fine-tuning

| 구분 | RAG | Fine-tuning |
|---|---|---|
| 방법 | 외부 문서를 검색하여 전달 | 모델을 추가 학습 |
| 지식 업데이트 | 문서만 변경 | 재학습 필요 |
| 비용 | 비교적 낮음 | 상대적으로 높음 |
| 최신 정보 반영 | 쉬움 | 재학습 필요 |
| 적합한 경우 | 사내 문서, 최신 데이터 | 특정 작업/말투 학습 |

예를 들어 회사의 상품 정책이 변경되었다면 RAG는 새로운 문서를 다시 적재하면 된다.

따라서 **자주 변경되는 지식을 LLM에 제공해야 하는 경우 RAG가 적합하다.**

---

# 3. RAG 전체 흐름

RAG는 크게 **문서 적재(Ingestion)**와 **질의(Query)**로 나뉜다.

## ① Ingestion - 문서 적재

문서를 미리 읽고 VectorStore에 저장한다.

```text
PDF / Word / Web / DB
        ↓
    문서 읽기
        ↓
      Chunking
        ↓
     Embedding
        ↓
    VectorStore
```

### Chunking

긴 문서를 작은 단위로 나누는 과정이다.

```text
긴 문서
 ↓
Chunk 1
Chunk 2
Chunk 3
...
```

너무 큰 Chunk는 불필요한 내용이 많이 포함되고, 너무 작은 Chunk는 문맥이 끊길 수 있다.

따라서 문서 구조와 질문 유형에 맞게 적절한 크기를 설정해야 한다.

---

## ② Query - 사용자 질문

사용자가 질문하면 질문을 벡터로 변환하고 관련 문서를 검색한다.

```text
사용자 질문
    ↓
Embedding
    ↓
VectorStore 검색
    ↓
관련 Chunk 검색
    ↓
Prompt에 Context 추가
    ↓
LLM
    ↓
답변
```

---

# 4. RAG 핵심 개념

| 개념 | 설명 | 실무 포인트 |
|---|---|---|
| Embedding | 텍스트를 의미를 표현하는 벡터로 변환 | 저장/검색에 일관된 모델 사용 |
| 벡터 차원 | 벡터의 길이 | VectorStore 설정과 Embedding 모델 차원 일치 |
| Chunking | 긴 문서를 작은 단위로 분할 | 너무 크거나 작지 않게 조정 |
| VectorStore | 벡터 저장 및 검색 | PostgreSQL이라면 pgvector 활용 가능 |
| 유사도 검색 | 질문과 의미가 가까운 문서 검색 | 단어가 달라도 의미가 비슷하면 검색 가능 |
| Top-K | 최대 검색 결과 개수 | 검색 품질과 Context 크기에 영향 |
| Threshold | 최소 유사도 기준 | 관련 없는 문서 제거 |
| Metadata Filter | 메타데이터 기반 검색 제한 | 사용자/부서/권한별 검색에 중요 |

---

# 5. Embedding

Embedding은 텍스트를 숫자 벡터로 변환하는 과정이다.

```text
"강아지가 귀엽다"
        ↓
Embedding
        ↓
[0.21, -0.14, 0.73, ...]
```

의미가 비슷한 문장은 벡터 공간에서도 가까운 위치에 있을 가능성이 높다.

```text
"강아지가 귀엽다"
        ↕ 가까움
"강아지가 정말 사랑스럽다"

"오늘 주식 가격은?"
        ↕ 멂
```

이러한 특성을 이용하여 **의미 기반 검색**을 수행한다.

---

# 6. VectorStore

VectorStore는 Embedding된 벡터를 저장하고 유사한 벡터를 검색하는 저장소이다.

일반적인 SQL 검색이 정확한 값이나 조건을 기준으로 검색한다면, VectorStore는 질문과 문서의 **의미적 유사도**를 이용하여 검색한다.

```text
질문
"청년 적금 중도해지하면 이자 어떻게 돼?"
        ↓
VectorStore
        ↓
"청년도약적금 중도해지 시 이자율..."
"중도해지 시 비과세 혜택..."
```

---

# 7. Top-K와 Similarity Threshold

RAG 검색 품질을 결정하는 중요한 설정이다.

예를 들어 검색 결과가 다음과 같다고 하자.

| 순위 | 문서 | 유사도 |
|---:|---|---:|
| 1 | 청년도약적금 중도해지 이자율 | 0.91 |
| 2 | 중도해지 시 비과세 혜택 | 0.87 |
| 3 | 청년도약적금 가입 조건 | 0.74 |
| 4 | 일반 정기적금 중도해지 | 0.68 |
| 5 | 주택청약 해지 절차 | 0.52 |

## Top-K

**최대 몇 개의 검색 결과를 가져올 것인지** 결정한다.

```text
K = 1
→ 1번만 검색

K = 3
→ 1~3번 검색

K = 10
→ 관련도가 낮은 문서까지 포함될 가능성 증가
```

K가 너무 작으면 필요한 정보가 빠지고, 너무 크면 관련 없는 정보가 섞여 LLM의 답변 품질이 떨어질 수 있다.

---

## Similarity Threshold

**검색 결과가 최소 어느 정도 관련되어야 하는지** 결정한다.

```java
SearchRequest.builder()
        .topK(5)
        .similarityThreshold(0.7)
        .build();
```

위 결과에서는:

```text
0.91 → 통과
0.87 → 통과
0.74 → 통과
0.68 → 제외
0.52 → 제외
```

따라서 1~3번만 LLM에 전달된다.

### Top-K와 Threshold

```text
Top-K
→ 최대 몇 개까지 가져올 것인가?

Threshold
→ 최소 어느 정도 관련되어야 가져올 것인가?
```

둘을 함께 사용하면 검색 결과의 양과 관련성을 동시에 조절할 수 있다.

> 유사도 점수의 범위와 의미는 사용하는 VectorStore 및 검색 방식에 따라 달라질 수 있으므로 실제 환경에서 확인해야 한다.

---

# 8. Threshold가 필요한 이유

관련 문서가 아예 없는 질문을 생각해보자.

```text
질문:
"오늘 서울 날씨 어때?"
```

금융 문서만 저장된 VectorStore에서도 Top-K를 사용하면 가장 덜 관련된 문서를 가져올 수 있다.

```text
외화예금 환율 안내       0.41
서울 지점 영업시간       0.38
영업점 휴무 안내         0.35
```

하지만:

```java
.topK(3)
.similarityThreshold(0.7)
```

로 설정하면 모두 기준 미달이므로 검색 결과가 없어진다.

```text
검색 결과 없음
      ↓
"제공된 문서에서 해당 정보를 찾을 수 없습니다."
```

따라서 Threshold는 **관련 없는 문서를 Context에 넣지 않기 위한 검색 필터**로 활용할 수 있다.

단, Threshold만으로 환각을 완전히 막을 수 있는 것은 아니다.

---

# 9. RAG 검색 튜닝

처음부터 특정 값을 정하기보다 실제 질문을 테스트하면서 조정한다.

```text
관련 질문
0.82
0.78
0.75

관련 없는 질문
0.41
0.38
```

이처럼 점수 분포를 확인한 뒤 적절한 기준을 찾는다.

| 문제 | 조정 |
|---|---|
| 필요한 정보가 빠짐 | Top-K 증가 |
| 관련 없는 문서가 섞임 | Top-K 감소 |
| 엉뚱한 문서가 계속 검색됨 | Threshold 증가 |
| 관련 문서까지 탈락 | Threshold 감소 |
| 문맥이 자주 끊김 | Chunk 크기 조정 |
| 오래된 관련 정보 검색 실패 | 검색 전략/Chunking 개선 |

---

# 10. Metadata Filter

실제 서비스에서는 단순한 유사도 검색만으로 부족한 경우가 많다.

문서에 다음과 같은 Metadata를 저장할 수 있다.

```text
department = finance
year = 2026
documentType = product
```

검색할 때 조건을 추가하면 검색 범위를 제한할 수 있다.

```text
전체 문서
    ↓
Metadata Filter
    ↓
금융부서 + 2026년 문서
    ↓
유사도 검색
    ↓
Top-K
```

특히 사용자별 문서나 권한별 문서를 다루는 서비스에서는 중요하다.

---

# 11. Spring AI에서의 RAG

Spring AI에서는 RAG의 각 단계를 다음 구성요소로 연결할 수 있다.

| 역할 | Spring AI |
|---|---|
| 문서 | `Document` |
| 문서 읽기 | `TikaDocumentReader` 등 |
| 청크 분할 | `TokenTextSplitter` 등 |
| Embedding | `EmbeddingModel` |
| 벡터 저장/검색 | `VectorStore` |
| LLM 호출 | `ChatClient` |
| RAG 연결 | `QuestionAnswerAdvisor`, `RetrievalAugmentationAdvisor` |

전체 구조는 다음과 같다.

```text
문서
 ↓
DocumentReader
 ↓
Document
 ↓
TextSplitter
 ↓
Chunk
 ↓
EmbeddingModel
 ↓
VectorStore
```

질문이 들어오면:

```text
사용자 질문
 ↓
VectorStore 검색
 ↓
관련 문서
 ↓
Prompt Context
 ↓
ChatClient
 ↓
LLM
 ↓
답변
```

---

# 12. RAG와 Chat Memory

앞에서 배운 Chat Memory와 RAG는 목적이 다르다.

| 구분 | Chat Memory | RAG |
|---|---|---|
| 목적 | 이전 대화 기억 | 외부 지식 검색 |
| 대상 | 사용자와 AI의 대화 | 문서 / DB / 외부 데이터 |
| 검색 | 최근 대화 중심 | 의미적 유사도 |
| 저장 | Memory / DB | VectorStore |
| 예시 | "내 이름 기억해?" | "회사 휴가 규정 알려줘" |

둘을 함께 사용할 수도 있다.

```text
사용자 질문
    ↓
┌──────────────┐
│ Chat Memory  │ → 이전 대화
└──────────────┘
        +
┌──────────────┐
│     RAG      │ → 관련 문서
└──────────────┘
        ↓
      Prompt
        ↓
       LLM
        ↓
      답변
```

즉,

> **Chat Memory = 사용자와의 대화 맥락**

> **RAG = 외부 데이터에 대한 지식 검색**

으로 구분하면 된다.

---

# 13. 핵심 정리

```text
RAG
→ 외부 데이터를 검색하여 LLM의 Context로 제공

Embedding
→ 텍스트를 벡터로 변환

Chunking
→ 긴 문서를 작은 검색 단위로 분할

VectorStore
→ 벡터를 저장하고 유사한 문서를 검색

Top-K
→ 최대 몇 개의 문서를 가져올지 결정

Threshold
→ 최소 어느 정도 관련되어야 검색 결과로 사용할지 결정

Metadata Filter
→ 사용자/부서/권한 등의 조건으로 검색 범위 제한
```

### RAG의 핵심 흐름

```text
[문서 적재]

문서
 ↓
Chunking
 ↓
Embedding
 ↓
VectorStore


[질의]

사용자 질문
 ↓
Embedding
 ↓
VectorStore 검색
 ↓
Top-K + Threshold
 ↓
관련 문서
 ↓
Prompt Context
 ↓
LLM
 ↓
답변
```

결국 RAG의 핵심은 **LLM을 다시 학습시키는 것이 아니라, 필요한 외부 지식을 검색해서 LLM에게 함께 제공하는 것**이다.