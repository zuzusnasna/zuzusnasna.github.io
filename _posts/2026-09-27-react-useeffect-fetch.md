---
layout: post
title: "React Study : useEffect와 API 호출 흐름"
date: 2026-10-21 00:00:00 +0900
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

## 더 깊게 이해하기: Effect는 렌더링 계산이 아니다

렌더링은 현재 props와 state를 바탕으로 화면을 계산하는 과정이고, Effect는 화면과 외부 시스템을 동기화할 때 사용한다. API 호출, 타이머, 이벤트 리스너처럼 React 바깥의 시스템과 연결하는 작업이 대표적이다. 단순히 다른 state를 계산해 저장하는 용도로 Effect를 사용하면 불필요한 렌더링과 상태 불일치가 생길 수 있다.

비동기 요청에서는 컴포넌트가 사라지거나 검색어가 바뀐 뒤 이전 요청의 응답이 도착하는 상황도 고려해야 한다. AbortController를 사용하거나 요청 식별자를 비교해 오래된 응답이 최신 화면을 덮지 않도록 처리할 수 있다.

### 검증할 상황
- 최초 렌더링과 의존성 변경 시 요청이 각각 몇 번 발생하는가?
- 로딩·성공·실패 상태가 명확히 구분되는가?
- 화면이 사라졌거나 검색 조건이 바뀐 뒤 오래된 응답이 반영되지 않는가?
- 개발 모드의 Strict Mode에서 Effect가 재실행될 수 있다는 점을 고려했는가?

Effect 의존성 배열을 비워 오류를 숨기기보다, 어떤 값과 외부 시스템을 동기화해야 하는지 먼저 정의하는 것이 올바른 해결 방법이다.
