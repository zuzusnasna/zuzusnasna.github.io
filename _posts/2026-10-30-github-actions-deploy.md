---
layout: post
title: "배포 : GitHub Actions로 빌드와 배포를 자동화한 흐름"
date: 2026-10-30 21:00:00 +0900
categories: [학습]
tags: [GitHub Actions, CI/CD, Docker, AWS]
---

프로젝트를 수정할 때마다 서버에 직접 접속해 빌드하고 실행하는 방식은 반복 작업이 많고 실수하기 쉽다. 그래서 GitHub Actions를 이용해 변경 사항을 배포 과정과 연결했다.

## 기본 흐름

```text
git push / merge
      ↓
GitHub Actions
      ↓
Build / Test
      ↓
Docker Image
      ↓
EC2 Deploy
      ↓
Container Restart
```

## CI와 CD

CI는 코드가 변경될 때 빌드와 테스트를 자동으로 검증하는 과정이고 CD는 검증된 결과를 실제 환경에 전달하는 과정이다.

## 실패했을 때

Action이 성공했다고 애플리케이션이 반드시 정상 동작하는 것은 아니다. 빌드 성공과 실제 서버 실행 성공은 별개의 단계다.

```text
Build 성공
 ≠
배포 성공
 ≠
서비스 정상
```

## 배운 점

자동 배포의 핵심은 명령어 하나를 자동으로 실행하는 것이 아니라 **코드 변경 → 검증 → 배포 → 실행 확인이라는 흐름을 반복 가능하게 만드는 것**이다.
