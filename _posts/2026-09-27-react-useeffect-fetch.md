---
layout: post
title: "React Study : useEffect와 API 호출 흐름"
date: 2026-09-27 09:00:00 +0900
categories: [학습]
tags: [React, JavaScript, REST API]
---

React에서 서버 데이터를 가져올 때는 컴포넌트가 렌더링되는 시점과 API 요청 시점을 구분해야 했다.

## useEffect

```jsx
useEffect(() => {
  fetch('/api/rooms')
    .then(response => response.json())
    .then(data => setRooms(data));
}, []);
```

빈 배열을 dependency로 주면 처음 마운트될 때 데이터를 가져오는 형태로 사용할 수 있다.

## 로딩과 오류

실제 서비스에서는 API 요청이 항상 즉시 성공한다고 가정하면 안 된다.

```text
요청 시작
 ↓
loading = true
 ↓
성공 → data 저장
실패 → error 저장
 ↓
loading = false
```

## 배운 점

React 화면을 만들 때 API 호출 코드만 작성하는 것보다 **로딩·성공·실패·재요청 상태를 함께 설계하는 것**이 실제 서비스에 가까운 UI를 만드는 방법이었다.
