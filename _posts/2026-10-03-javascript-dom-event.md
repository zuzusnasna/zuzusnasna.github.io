---
layout: post
title: "부트캠프 : JavaScript 변수, DOM, 이벤트 처리"
date: 2026-10-03 09:00:00 +0900
categories: [학습]
tags: [JavaScript, HTML]
---

JavaScript 실습에서는 문법 자체보다 브라우저 화면과 연결되는 과정이 중요했다.

## 변수와 함수

```javascript
const name = "hong";
let age = 40;

const message = () => {
  return name + " is " + age + " years old";
};
```

`const`는 재할당하지 않는 값을 표현하고 `let`은 값이 변경될 수 있을 때 사용한다.

## DOM

HTML 요소를 JavaScript에서 가져와 내용을 변경할 수 있다.

```javascript
const demo = document.getElementById("demo");
demo.innerHTML = "Hello";
```

실습 중 `Cannot set properties of null` 오류를 만났는데, DOM을 가져오는 시점에 해당 id의 요소가 존재하지 않았기 때문에 발생했다. **선택한 요소가 실제 HTML에 존재하는지와 실행 시점을 확인하는 것**이 핵심이었다.

## 이벤트

```javascript
document.getElementById("btn").addEventListener("click", () => {
  console.log("clicked");
});
```

사용자의 클릭이나 입력 같은 이벤트가 발생하면 JavaScript가 특정 함수를 실행하도록 연결할 수 있다.

## 배운 점

JavaScript는 단순 계산 언어가 아니라 **HTML을 선택하고 이벤트를 받아 화면을 변경하는 브라우저 프로그래밍 언어**라는 점을 실습으로 이해했다.

## 더 깊게 이해하기: DOM은 데이터가 아니라 현재 문서 구조다

DOM은 브라우저가 HTML을 객체 트리로 표현한 것이다. JavaScript가 DOM을 직접 수정하면 화면은 바뀌지만, 애플리케이션의 데이터와 DOM이 서로 다른 상태를 갖게 될 수 있다. 작은 예제에서는 문제가 없어도 UI가 복잡해질수록 상태를 어디서 관리하는지 명확해야 한다.

이벤트는 발생한 요소에서 상위 요소로 전파될 수 있다. 이벤트 위임을 사용하면 목록 항목마다 핸들러를 붙이지 않고 부모에서 클릭을 처리할 수 있지만, 실제 클릭 대상과 이벤트를 처리할 요소를 구분해야 한다. 기본 동작을 막는 `preventDefault()`와 전파를 막는 `stopPropagation()`은 목적이 다르다.

### 디버깅할 때 확인할 것
- DOM 요소를 찾지 못했을 때 null 검사를 하는가?
- 스크립트가 DOM 생성 전에 실행되지 않는가?
- 이벤트가 중복 등록되어 핸들러가 여러 번 실행되지 않는가?
- 입력값을 HTML 문자열로 삽입할 때 XSS 위험을 만들지 않는가?

DOM 조작은 동작을 만들기 위한 수단이다. 화면 상태가 복잡해진다면 상태와 UI를 선언적으로 연결하는 프레임워크가 어떤 문제를 해결하는지 비교해 볼 수 있다.
