---
layout: post
title: "HTML Form과 CSS로 입력 화면 구성하기"
date: 2026-09-14 00:00:00 +0900
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

## 더 깊게 이해하기: 폼은 입력 화면이자 검증 경계다

폼은 사용자가 데이터를 입력하는 곳이므로, 어떤 값이 필요한지와 잘못된 입력을 어떻게 설명할지를 함께 설계해야 한다. HTML의 `required`, `type`, `min`, `max` 같은 제약은 기본적인 사용자 안내에 유용하지만, 브라우저 검증만으로 데이터가 안전하다고 볼 수는 없다. 요청은 개발자 도구나 별도 클라이언트로 조작될 수 있으므로 서버 검증이 반드시 필요하다.

입력 오류를 보여줄 때는 단순히 테두리 색만 바꾸지 말고 어떤 필드가 왜 잘못됐는지 텍스트로 알려줘야 한다. label과 입력 요소를 연결하고, 오류 메시지가 보조 기술에도 전달되도록 구성하는 것이 좋다.

### 폼 설계 체크리스트
- 필수 항목과 선택 항목이 구분되는가?
- 숫자·날짜·이메일 등 입력 목적에 맞는 타입을 사용했는가?
- 잘못된 입력에 수정 가능한 구체적인 메시지를 보여주는가?
- 서버에서도 길이, 범위, 형식, 권한을 검증하는가?
- 제출 중 중복 클릭과 네트워크 실패를 처리하는가?

좋은 폼은 데이터를 입력받는 데서 끝나지 않고, 잘못된 데이터를 안전하게 거절하고 사용자가 회복할 수 있게 돕는다.
