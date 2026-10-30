# 개발 공부 기록

Java, Spring, JPA, MyBatis, API 설계와 테스트부터 데이터베이스·운영까지 공부한 내용을 기록하는 개인 기술 블로그입니다.

## Blog

- [개발 공부 기록](https://zuzusnasna.github.io/)
- [글쓰기](https://zuzusnasna.github.io/write/)

## 글 작성 흐름

1. [글쓰기](https://zuzusnasna.github.io/write/)에서 제목, 날짜, 태그, 본문을 작성합니다.
2. 굵게, 밑줄, 제목, 코드 블록, 인용, 목록, 링크 등의 Markdown 서식을 사용할 수 있습니다.
3. `Markdown 저장`으로 Jekyll 게시글 파일을 내려받습니다.
4. 내려받은 `.md` 파일을 `_posts/` 디렉터리에 추가합니다.
5. GitHub Pages가 Jekyll로 사이트를 다시 빌드하면 블로그에 게시됩니다.

## 게시글 구조

게시글은 `_posts/YYYY-MM-DD-제목.md` 형식으로 저장합니다.

예:

```text
_posts/
└── 2026-10-30-jpa-flush.md
```

파일 내부에는 Jekyll front matter와 Markdown 본문이 들어갑니다.

```yaml
---
layout: post
title: "JPA Flush 동작 흐름"
date: 2026-10-30 00:00:00 +0900
categories: [학습]
tags: [Java, JPA]
---

## Flush란?

작성한 학습 내용을 Markdown으로 기록합니다.
```

## 기술 스택

- Jekyll
- GitHub Pages
- Markdown
- HTML / CSS / JavaScript
