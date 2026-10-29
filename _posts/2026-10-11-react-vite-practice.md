---
layout: post
title: "React + Vite 실습에서 배운 프로젝트 구성"
date: 2026-10-11 09:00:00 +0900
categories: [학습]
tags: [React, Vite, JavaScript]
---

React Study에서 Vite 기반 프로젝트를 만들고 컴포넌트를 분리하는 실습을 진행했다.

## 기본 흐름

```text
main.jsx
   ↓
App.jsx
   ↓
Component
   ↓
화면 렌더링
```

Vite는 개발 서버와 빌드 환경을 빠르게 구성할 수 있어 React 실습 프로젝트를 시작하기 편했다.

## 실습하면서 확인한 부분

- `package.json`의 의존성 관리
- `main.jsx`에서 React 진입점 확인
- `App.jsx`에서 화면 구성
- 컴포넌트 파일 분리
- CSS 파일 분리
- `npm run dev`와 `npm run build` 차이

## 배운 점

프레임워크를 사용하는 것보다 **프로젝트의 진입점과 빌드 과정을 직접 확인하는 것**이 이후 오류를 해결할 때 도움이 됐다.
