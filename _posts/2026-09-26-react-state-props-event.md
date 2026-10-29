---
layout: post
title: "React Study : Props와 State를 구분해서 생각하기"
date: 2026-09-26 09:00:00 +0900
categories: [학습]
tags: [React, JavaScript]
---

React를 처음 사용할 때 가장 많이 헷갈렸던 부분은 Props와 State의 차이였다.

## Props

부모 컴포넌트가 자식 컴포넌트로 전달하는 값이다.

```jsx
function UserCard({ name }) {
  return <div>{name}</div>;
}

<UserCard name="홍길동" />
```

자식 컴포넌트가 받은 Props를 직접 변경하는 것이 아니라 부모가 새로운 값을 전달하는 구조다.

## State

컴포넌트 내부에서 변경되는 값을 관리한다.

```jsx
const [count, setCount] = useState(0);

setCount(count + 1);
```

State가 변경되면 React가 다시 렌더링한다.

## 실제 화면에서의 흐름

```text
부모 State 변경
      ↓
새로운 Props 전달
      ↓
자식 컴포넌트 렌더링
```

## 배운 점

React 화면을 직접 찾아서 바꾸는 방식보다 **데이터가 바뀌고 그 결과로 UI가 다시 그려진다**고 생각하는 것이 훨씬 편했다.
