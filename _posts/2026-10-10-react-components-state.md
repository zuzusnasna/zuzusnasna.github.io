---
layout: post
title: "React 컴포넌트와 Props, State를 정리한 내용"
date: 2026-10-10 09:00:00 +0900
categories: [학습]
tags: [React, JavaScript]
---

React Study 저장소에서 실습한 내용을 기준으로 컴포넌트와 상태 관리의 기본을 정리했다.

## Component

화면을 기능 단위로 나누어 재사용할 수 있게 만든다.

```jsx
function Card({ title }) {
  return <div>{title}</div>;
}
```

## Props

부모 컴포넌트가 자식 컴포넌트에 데이터를 전달할 때 사용한다.

## State

화면에서 변경되는 값을 컴포넌트 내부에서 관리한다.

```jsx
const [count, setCount] = useState(0);

<button onClick={() => setCount(count + 1)}>
  {count}
</button>
```

## 배운 점

React에서는 화면을 직접 조작하기보다 **상태가 바뀌면 UI가 다시 계산된다**는 방식으로 생각하는 것이 중요했다.

Vite 프로젝트를 직접 구성하고 컴포넌트를 분리해 보면서 작은 화면부터 상태 기반 UI로 만드는 흐름을 익혔다.
