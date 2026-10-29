---
layout: post
title: "배포 : Nginx Reverse Proxy를 사용하는 이유"
date: 2026-10-30 19:00:00 +0900
categories: [학습]
tags: [Nginx, Docker, AWS, Linux]
---

EC2 배포에서 Nginx를 앞단에 두면서 웹 서버와 애플리케이션 서버의 역할을 분리했다.

## 구조

```text
Client
  ↓ 80 / 443
Nginx
  ↓
Spring Boot : 8080
```

Nginx는 외부 요청을 받고 적절한 내부 애플리케이션으로 전달하는 Reverse Proxy 역할을 한다.

## 왜 직접 8080을 열지 않았나

외부에서 애플리케이션 포트에 직접 접근하도록 만들기보다 Nginx가 외부 진입점이 되면 TLS, 정적 파일, 라우팅, 여러 애플리케이션 인스턴스로의 전달 등을 한 곳에서 관리하기 편하다.

## 다중 인스턴스

```text
             Nginx
             /   \
          App1   App2
```

두 인스턴스로 확장하면 Nginx에서 요청을 분산할 수 있다.

## 배운 점

Reverse Proxy는 단순한 포트 전달이 아니라 **외부 트래픽과 내부 애플리케이션을 분리하는 배포 구조의 경계**라고 이해했다.
