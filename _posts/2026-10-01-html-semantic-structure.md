---
layout: post
title: "부트캠프 : HTML 문서 구조와 시맨틱 태그"
date: 2026-10-28 00:00:00 +0900
categories: [학습]
tags: [HTML]
---

HTML을 처음 배울 때는 태그를 많이 외우는 것보다 **문서가 어떤 구조로 이루어지는지**를 이해하는 것이 먼저였다.

## 기본 문서 구조

```html
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>페이지 제목</title>
</head>
<body>
  <header>헤더</header>
  <main>본문</main>
  <footer>푸터</footer>
</body>
</html>
```

`head`에는 문서의 메타 정보가 들어가고 실제 화면에 보여줄 내용은 `body`에 작성한다.

## 시맨틱 태그

`div`만 사용하는 것보다 `header`, `nav`, `main`, `section`, `article`, `footer`처럼 의미를 나타내는 태그를 사용하는 것이 구조를 이해하기 쉽다.

```html
<main>
  <section>
    <h2>공지사항</h2>
    <article>첫 번째 글</article>
    <article>두 번째 글</article>
  </section>
</main>
```

## form과 입력 요소

사용자가 입력한 데이터를 서버로 보내려면 `form`, `input`, `select`, `textarea`, `button` 등의 요소를 조합한다.

```html
<form action="/login" method="post">
  <input type="text" name="username">
  <input type="password" name="password">
  <button type="submit">로그인</button>
</form>
```

`name` 속성이 실제 서버에 전달되는 데이터의 이름이 된다는 것도 실습하면서 확인했다.

## 배운 점

HTML은 화면을 꾸미는 언어라기보다 **문서의 구조와 의미를 표현하는 언어**라고 생각하면 이후 CSS와 JavaScript를 붙일 때 훨씬 이해하기 쉬웠다.

## 더 깊게 이해하기: 시맨틱 태그는 문서의 목차를 만든다

`header`, `nav`, `main`, `article`, `section`, `aside`, `footer`는 콘텐츠의 역할을 드러낸다. 이 요소들은 단순히 div를 대체하는 꾸밈용 태그가 아니다. 특히 `main`은 페이지의 핵심 콘텐츠를 나타내고, `nav`는 주요 탐색 링크를 묶으며, `article`은 독립적으로 배포하거나 재사용할 수 있는 콘텐츠에 적합하다.

시맨틱 요소를 사용한다고 접근성이 자동으로 완성되는 것은 아니다. 제목 계층, 링크 텍스트, 폼 label, 키보드 포커스와 함께 설계해야 한다. 이름만 의미 있는 태그로 바꾸고 내부 구조를 무시하면 문서의 탐색 가능성이 좋아지지 않는다.

### 구조를 검토하는 방법
- 페이지의 주요 콘텐츠가 하나의 명확한 `main` 안에 있는가?
- 독립적인 게시글과 그 안의 하위 주제를 적절히 구분했는가?
- 화면에 보이는 제목과 실제 heading 계층이 일치하는가?
- 의미가 없는 wrapper를 무조건 늘리지 않고 구조를 설명할 수 있는가?

HTML을 작성한 뒤 CSS를 끄고 읽어도 정보의 계층이 이해된다면 구조가 비교적 잘 잡혀 있다는 신호다.
