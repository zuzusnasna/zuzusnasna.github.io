---
layout: post
title: "Spring AI로 PDF 문서에 질문하기: pgvector를 이용한 RAG 실습"
date: 2026-11-05 00:00:00 +0900
categories: ["Spring"]
section: "spring-ai"
tags: [Spring AI, RAG, pgvector, PDF]
---

## 실습 목표

이번에는 PDF를 업로드하고, 문서 내용에 질문하면 관련 부분을 찾아 답변하는 작은 RAG 기능을 구성했다. Spring Boot가 문서 처리와 검색을 맡고, React 화면에서 파일 업로드와 질문 입력을 처리한다. 문서 조각과 임베딩은 PostgreSQL의 pgvector 저장소에 넣는다.

질문을 그대로 모델에 보내는 대신, 문서에서 관련 내용을 먼저 찾은 뒤 그 내용을 답변의 근거로 전달하는 흐름이다.

## PDF를 읽고 벡터 저장소에 넣기

업로드한 PDF는 임시 파일로 저장한 다음 `PagePdfDocumentReader`로 읽는다. 페이지마다 별도의 `Document`를 만들도록 설정했고, 추출한 텍스트는 `TokenTextSplitter`로 나눠 `VectorStore`에 저장한다. 이 과정에서 Spring AI가 임베딩 생성과 pgvector 저장소 연결을 담당한다.

```java
List<Document> documents = pdfReaders.get();

if (documents.isEmpty() || documents.stream()
        .allMatch(document -> document.getText() == null || document.getText().isBlank())) {
    throw new IOException("PDF에서 텍스트를 읽지 못했습니다.");
}

TokenTextSplitter splitter = new TokenTextSplitter(1000, 400, 10, 5000, true);
List<Document> chunks = splitter.apply(documents);
vectorStore.accept(chunks);
```

페이지 단위로 읽은 뒤 다시 잘게 나누는 이유는 긴 문서 전체를 한 번에 비교하기보다, 질문과 가까운 문서 조각을 검색해 답변에 활용하기 위해서다. 텍스트를 추출하지 못하면 업로드 단계에서 오류를 돌려준다. 특히 이미지로만 된 스캔 PDF는 현재 코드만으로 읽지 못해 OCR 처리가 필요하다.

## 질문과 가까운 내용을 찾아 답변하기

`POST /api/documents/rag`에 질문이 들어오면 pgvector에서 유사한 문서 조각을 최대 5개 검색한다. 짧은 질문은 표현만으로 의도가 모호할 수 있어, 12자 이하인 경우 관련 개념과 배경을 덧붙인 검색도 한 번 더 수행한다. 두 검색 결과는 문서 내용이 완전히 같은 항목을 기준으로 중복을 제거한다.

검색된 내용을 프롬프트의 문서 영역에 넣고 질문과 함께 `ChatModel`에 전달한다. 프롬프트는 문서 발췌를 근거로 답하고, 문서에서 근거를 찾지 못한 경우에만 관련 정보를 찾을 수 없다고 답하도록 작성했다.

검색된 문서가 없거나 내용이 비어 있으면 모델을 호출하지 않고 안내 문구를 반환한다. 검색 개수와 프롬프트에 넣은 글자 수도 로그에 남겨 요청을 살펴볼 수 있게 했다.

## React 화면과 연결하기

화면에서는 파일 선택과 드래그 앤 드롭으로 PDF를 고른다. 선택한 파일은 `FormData`에 담아 `/api/documents/upload`로 전송하고, 업로드가 성공하면 질문 화면으로 전환한다. 질문은 `/api/documents/rag?question=...`에 보내고 응답을 대화 목록에 추가한다.

브라우저 쪽에서도 PDF 확장자나 MIME 타입을 확인하지만, 이 검사는 사용자 편의를 위한 입력 확인이다. 실제 파일을 받는 서버에서도 파일 형식과 크기를 검증해야 안전하다.

## 현재 구현에서 확인한 점

- 텍스트가 없는 PDF는 별도 안내와 함께 처리하지 않는다. 스캔 문서까지 지원하려면 OCR 단계를 추가해야 한다.
- 업로드한 문서 조각은 같은 벡터 저장소에 쌓인다. 현재 검색 요청에는 문서별 식별 조건이 없어, 여러 PDF를 올리면 이전 문서 내용도 함께 검색될 수 있다.
- 답변에 근거가 된 페이지나 문서 조각을 함께 표시하지 않는다. 검색 결과를 화면에 출처로 보여주면 답변을 확인하기 쉬워진다.
- 데이터베이스 접속 정보처럼 환경마다 달라지거나 보호해야 할 값은 설정 파일에 직접 두기보다 환경 변수로 관리하는 편이 낫다.

## 마무리

이번 실습을 통해 RAG에서 모델 호출은 전체 과정의 한 부분이라는 점을 확인했다. PDF에서 텍스트를 꺼내고, 적당한 크기로 나누고, 질문과 가까운 조각을 검색해 답변에 전달하는 과정이 함께 맞물려야 한다.

다음에는 업로드한 파일별로 검색 범위를 나누고, 답변에 출처 페이지를 표시하는 부분을 붙여 보고 싶다.

