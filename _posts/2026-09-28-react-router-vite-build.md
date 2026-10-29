---
layout: post
title: "React Study : React Router와 Vite 빌드 흐름"
date: 2026-09-28 09:00:00 +0900
categories: [학습]
tags: [React, Vite, JavaScript]
---

React 프로젝트에서는 여러 화면을 하나의 애플리케이션에서 관리해야 하기 때문에 라우팅과 빌드 구조를 함께 이해할 필요가 있었다.

## Router

```jsx
<Routes>
  <Route path="/" element={<Home />} />
  <Route path="/login" element={<Login />} />
  <Route path="/rooms/:roomId" element={<Room />} />
</Routes>
```

URL에 따라 다른 컴포넌트를 렌더링할 수 있다.

## Vite

Vite는 개발 서버와 번들링 환경을 빠르게 구성할 수 있다.

```bash
npm run dev
npm run build
```

`dev`는 개발 서버에서 빠르게 확인하는 용도이고 `build`는 배포할 결과물을 만드는 과정이다.

## 실제 오류에서 배운 점

React 프로젝트에서 JSX 문법이 깨지거나 `node_modules`가 손상되면 애플리케이션 코드가 아니라 빌드 환경에서 오류가 발생할 수 있다. 이때는 오류가 발생한 레이어를 먼저 구분해야 한다.

## 배운 점

프론트엔드도 코드만 보는 것이 아니라 **소스 → 개발 서버 → 빌드 → 정적 파일 → 배포 서버**의 전체 흐름을 이해해야 문제를 빨리 찾을 수 있었다.
