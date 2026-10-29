---
layout: post
title: "배포 : Docker와 컨테이너를 사용하면서 이해한 것"
date: 2026-10-30 18:00:00 +0900
categories: [학습]
tags: [Docker, AWS, Linux]
---

프로젝트를 EC2에 배포하면서 Docker를 단순히 실행 명령어로만 보지 않고 **애플리케이션 실행 환경을 패키징하는 방법**으로 이해하게 됐다.

## Image와 Container

```text
Dockerfile
   ↓ build
Image
   ↓ run
Container
```

Image는 실행에 필요한 파일과 환경을 포함하고 Container는 그 이미지를 실행한 인스턴스다.

## Compose

여러 서비스를 함께 실행해야 하는 경우 Docker Compose로 관리할 수 있다.

```text
nginx
 ├─ app-1
 ├─ app-2
 ├─ mysql
 └─ redis
```

## 환경 변수

DB 주소나 비밀번호 같은 환경별 설정을 이미지에 하드코딩하지 않고 `.env`나 배포 환경 변수로 분리했다.

## 배운 점

Docker의 장점은 단순히 서버에서 실행하기 편하다는 것보다 **개발/배포 환경의 차이를 줄이고 여러 서비스를 동일한 방식으로 관리할 수 있다는 점**이었다.
