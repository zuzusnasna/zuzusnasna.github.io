---
layout: post
title: "부트캠프 : CSS 선택자와 레이아웃을 이해한 과정"
date: 2026-10-02 09:00:00 +0900
categories: [학습]
tags: [CSS, HTML]
---

CSS를 배우면서 처음 헷갈렸던 부분은 선택자와 레이아웃이었다.

## 선택자

```css
p { color: black; }
.notice { font-weight: bold; }
#login-form { width: 300px; }
```

태그 선택자는 같은 태그 전체에 적용하고, class는 여러 요소에 재사용하며 id는 특정 요소를 식별할 때 사용한다.

## Box Model

HTML 요소의 크기는 단순히 `width`와 `height`만으로 결정되지 않는다.

```text
margin
 └ border
    └ padding
       └ content
```

`box-sizing: border-box`를 사용하면 지정한 width 안에 padding과 border를 포함시킬 수 있어 화면 크기를 계산하기 편했다.

## Flex

```css
.container {
  display: flex;
  justify-content: space-between;
  align-items: center;
}
```

가로 배치, 세로 정렬, 간격 조정처럼 실제 화면에서 자주 필요한 배치를 쉽게 만들 수 있었다.

## 배운 점

CSS는 속성을 하나씩 외우기보다 **요소의 크기 → 위치 → 정렬 → 반응형** 순서로 생각하면 문제를 해결하기 쉬웠다.
