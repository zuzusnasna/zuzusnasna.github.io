---
layout: post
title: "HTML 기본 구조와 웹 페이지를 구성하는 태그"
date: 2026-10-01 09:00:00 +0900
categories: [학습]
tags: [HTML, CSS, JavaScript]
---

부트캠프에서 처음 웹 화면을 만들면서 HTML의 역할을 정리했다.

## HTML은 무엇을 하는가

HTML은 웹 페이지의 **구조와 의미**를 표현한다. 화면의 색상이나 동작보다 먼저 문서가 어떤 요소로 구성되는지를 정의한다.

```html
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>My Page</title>
</head>
<body>
  <h1>Hello</h1>
  <p>첫 번째 문장입니다.</p>
</body>
</html>
```

## 자주 사용한 요소

- `h1 ~ h6` : 제목
- `p` : 문단
- `a` : 링크
- `img` : 이미지
- `ul`, `ol`, `li` : 목록
- `form`, `input`, `button` : 사용자 입력
- `table` : 표

특히 `form`은 서버에 데이터를 전달하는 웹 애플리케이션의 기본 입력 구조라서 이후 Servlet과 연결할 때 중요했다.

## 배운 점

HTML을 단순히 화면을 만드는 문법으로 보기보다 **브라우저가 문서를 해석할 수 있도록 구조를 만드는 언어**로 이해하는 것이 중요했다.
