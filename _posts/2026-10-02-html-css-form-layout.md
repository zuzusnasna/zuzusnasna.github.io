---
layout: post
title: "HTML Form과 CSS로 입력 화면 구성하기"
date: 2026-10-02 09:00:00 +0900
categories: [학습]
tags: [HTML, CSS]
---

웹 애플리케이션에서 사용자가 입력한 값을 서버로 보내려면 `form` 구조를 이해해야 한다.

## Form 기본 구조

```html
<form action="/login" method="post">
  <input type="text" name="username">
  <input type="password" name="password">
  <button type="submit">로그인</button>
</form>
```

`name` 속성은 서버에서 전달된 값을 구분할 때 사용한다. 이후 Servlet에서 `request.getParameter("username")`처럼 읽게 된다.

## CSS의 역할

HTML이 구조라면 CSS는 그 구조를 화면에 배치하고 표현한다.

```css
form {
  width: 320px;
  margin: 0 auto;
}

input {
  width: 100%;
  box-sizing: border-box;
}
```

## 정리

화면 개발에서 HTML → CSS → JavaScript 순으로 역할을 나누면 구조, 표현, 동작을 구분해서 생각할 수 있다.
