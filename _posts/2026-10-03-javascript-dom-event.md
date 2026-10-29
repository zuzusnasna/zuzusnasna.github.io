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
