---
layout: post
title: "GitHub Actions와 CI/CD"
date: 2026-11-02 00:00:00 +0900
categories: [Infra]
section: infra-cicd
tags: [GitHub Actions, CI/CD, DevOps, Docker]
---

# GitHub Actions와 CI/CD

## 1. GitHub Actions란?

GitHub Actions는 GitHub 저장소에서 발생하는 이벤트를 기준으로 **빌드, 테스트, 배포 등의 작업을 자동으로 실행할 수 있는 CI/CD 플랫폼**이다.

예를 들어 개발자가 `main` 브랜치에 코드를 push하면 다음과 같은 작업을 자동으로 실행할 수 있다.

```text
개발자
  ↓
Git Push
  ↓
GitHub Repository
  ↓
GitHub Actions
  ↓
빌드
  ↓
테스트
  ↓
Docker 이미지 빌드
  ↓
서버 배포
```

직접 서버에 접속해서 빌드하고 배포하는 과정을 자동화할 수 있다는 것이 핵심이다.

---

## 2. CI/CD란?

GitHub Actions를 이해하기 위해서는 먼저 CI/CD의 개념을 알아야 한다.

### CI - Continuous Integration

CI는 **지속적 통합(Continuous Integration)**을 의미한다.

개발자가 작성한 코드를 저장소에 통합할 때마다 자동으로 빌드와 테스트를 수행하여 코드에 문제가 없는지 확인한다.

예를 들어 다음과 같은 과정이다.

```text
개발자 코드 작성
      ↓
Git Push
      ↓
빌드
      ↓
테스트
      ↓
성공 → 코드 통합
실패 → 수정
```

CI를 사용하면 개발자가 직접 테스트하지 않아도 새로운 코드가 기존 코드에 문제를 일으키는지 빠르게 확인할 수 있다.

### CD - Continuous Delivery / Deployment

CD는 지속적 제공 또는 지속적 배포를 의미한다.

CI 과정에서 검증된 코드를 실제 서버에 자동으로 배포하는 과정이다.

```text
Git Push
   ↓
Build
   ↓
Test
   ↓
배포
   ↓
운영 서버 업데이트
```

Continuous Delivery는 배포 가능한 상태까지 자동으로 만드는 것에 초점을 두고,

Continuous Deployment는 검증이 완료된 코드를 실제 운영 환경까지 자동으로 배포하는 것에 초점을 둔다.

---

## 3. GitHub Actions의 기본 구조

GitHub Actions는 `.github/workflows` 디렉터리의 YAML 파일을 통해 동작을 정의한다.

```text
.github/
└── workflows/
    └── deploy.yml
```

예를 들어 다음과 같이 작성할 수 있다.

```yaml
name: Java CI

on:
  push:
    branches:
      - main

jobs:
  build:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout
        uses: actions/checkout@v4

      - name: Set up JDK
        uses: actions/setup-java@v4
        with:
          java-version: '21'
          distribution: 'temurin'

      - name: Build
        run: ./gradlew build
```

`main` 브랜치에 코드가 push되면 GitHub Actions가 실행되고 프로젝트를 빌드한다.

---

## 4. Workflow

Workflow는 GitHub Actions에서 **자동화할 전체 작업의 흐름**을 정의한다.

보통 다음과 같은 형태로 구성한다.

```text
Workflow
 ├── Trigger
 └── Jobs
      ├── Build
      ├── Test
      └── Deploy
```

YAML 파일 하나가 하나의 Workflow가 될 수 있다.

```yaml
name: Deploy Application

on:
  push:
    branches:
      - main

jobs:
  build:
    ...

  deploy:
    ...
```

---

## 5. Trigger

Trigger는 **Workflow를 언제 실행할 것인지** 정의한다.

대표적인 이벤트는 다음과 같다.

```yaml
on:
  push:
    branches:
      - main
```

`main` 브랜치에 push가 발생하면 실행된다.

Pull Request가 생성되었을 때 실행할 수도 있다.

```yaml
on:
  pull_request:
    branches:
      - main
```

또한 일정한 시간마다 실행하도록 설정할 수도 있다.

```yaml
on:
  schedule:
    - cron: '0 0 * * *'
```

즉, Trigger는

> "어떤 상황에서 자동화 작업을 시작할 것인가?"

를 결정한다.

---

## 6. Job

Job은 실제로 실행할 **작업 단위**이다.

```yaml
jobs:
  build:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout
        uses: actions/checkout@v4

      - name: Build
        run: ./gradlew build
```

하나의 Workflow 안에 여러 Job을 만들 수 있다.

```text
Workflow
│
├── build
│
├── test
│
└── deploy
```

Job은 기본적으로 서로 독립적으로 실행할 수 있으며 `needs`를 사용하면 실행 순서를 지정할 수 있다.

```yaml
jobs:
  test:
    ...

  deploy:
    needs: test
    ...
```

이 경우 `test`가 성공해야 `deploy`가 실행된다.

---

## 7. Step

Step은 Job 안에서 실행되는 **개별 작업**이다.

```yaml
steps:
  - name: Checkout
    uses: actions/checkout@v4

  - name: Build
    run: ./gradlew build

  - name: Test
    run: ./gradlew test
```

각 Step은 하나의 작업을 수행한다.

### uses

GitHub에서 제공하거나 다른 개발자가 만든 Action을 사용할 때 사용한다.

```yaml
uses: actions/checkout@v4
```

### run

직접 명령어를 실행할 때 사용한다.

```yaml
run: ./gradlew build
```

여러 명령어를 실행할 수도 있다.

```yaml
run: |
  chmod +x gradlew
  ./gradlew clean build
```

---

## 8. Runner

Runner는 GitHub Actions의 작업이 실제로 실행되는 환경이다.

```yaml
runs-on: ubuntu-latest
```

이 설정을 사용하면 GitHub에서 제공하는 Ubuntu 환경에서 Job이 실행된다.

대표적으로 다음과 같은 환경을 사용할 수 있다.

```yaml
runs-on: ubuntu-latest
runs-on: windows-latest
runs-on: macos-latest
```

즉,

```text
Workflow
   ↓
Job
   ↓
Runner
   ↓
Step 실행
```

구조로 이해할 수 있다.

---

## 9. GitHub Actions를 이용한 CI

Spring Boot 프로젝트에서는 다음과 같은 CI Workflow를 구성할 수 있다.

```yaml
name: Backend CI

on:
  pull_request:
    branches:
      - main

jobs:
  test:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout
        uses: actions/checkout@v4

      - name: Set up JDK
        uses: actions/setup-java@v4
        with:
          java-version: '21'
          distribution: 'temurin'

      - name: Test
        run: ./gradlew test

      - name: Build
        run: ./gradlew build
```

Pull Request가 생성되면 자동으로 테스트와 빌드를 수행한다.

```text
Pull Request
      ↓
GitHub Actions
      ↓
JDK 설치
      ↓
Gradle Test
      ↓
Gradle Build
      ↓
성공 / 실패
```

이렇게 하면 문제가 있는 코드가 `main`에 병합되는 것을 사전에 확인할 수 있다.

---

## 10. GitHub Actions를 이용한 CD

CI가 정상적으로 끝났다면 실제 서버에 배포할 수도 있다.

예를 들어 Docker를 사용하는 경우 다음과 같은 구조를 만들 수 있다.

```text
Git Push
   ↓
GitHub Actions
   ↓
Build
   ↓
Test
   ↓
Docker Image Build
   ↓
Docker Registry
   ↓
EC2
   ↓
Container Restart
```

서버에서는 새로운 Docker 이미지를 받아 컨테이너를 다시 실행한다.

```bash
docker compose pull
docker compose up -d
```

이 과정을 자동화하면 개발자가 직접 EC2에 접속하지 않아도 된다.

---

## 11. Secrets

배포 과정에서는 SSH Key, API Key, DB 비밀번호 등 외부에 노출되면 안 되는 값이 필요할 수 있다.

이런 값은 Workflow 파일에 직접 작성하면 안 된다.

```yaml
# 잘못된 방식
password: "123456"
```

대신 GitHub Repository의 Secrets에 저장하고 Workflow에서 사용한다.

```yaml
env:
  DB_PASSWORD: ${{ secrets.DB_PASSWORD }}
```

Secrets는 다음과 같은 민감한 정보를 관리할 때 사용한다.

- SSH Private Key
- 서버 접속 정보
- Docker Registry 인증 정보
- API Key
- 데이터베이스 비밀번호

---

## 12. CI/CD 전체 흐름

실제 프로젝트에서는 다음과 같은 형태로 구성할 수 있다.

```text
              GitHub Repository
                     │
                 Git Push
                     ↓
             GitHub Actions
                     │
             ┌───────┴───────┐
             ↓               ↓
           Build            Test
             │               │
             └───────┬───────┘
                     ↓
                  성공?
                     │
                    Yes
                     ↓
               Docker Build
                     ↓
                  Deploy
                     ↓
                    EC2
                     ↓
              Docker Container
```

결과적으로 개발자는

```text
코드 작성
   ↓
Git Push
```

까지만 수행하고 이후의 검증과 배포 과정을 자동화할 수 있다.

---

## 13. GitHub Actions를 사용하는 이유

### 1. 반복 작업 자동화

매번 직접 실행하던

```text
빌드
테스트
배포
```

과정을 자동화할 수 있다.

### 2. 코드 품질 검증

Pull Request가 생성될 때 테스트를 자동으로 실행하여 문제가 있는 코드를 빠르게 발견할 수 있다.

### 3. 배포 과정 단순화

개발자가 서버에 직접 접속하지 않고도 새로운 버전을 배포할 수 있다.

### 4. 배포 과정 표준화

누가 배포하더라도 동일한 Workflow를 사용하기 때문에 사람마다 다른 방식으로 배포하는 문제를 줄일 수 있다.

---

## 14. 실제 프로젝트에서의 활용

실제 프로젝트에서는 다음과 같이 구성할 수 있다.

```text
feature 브랜치
      ↓
Pull Request
      ↓
CI
 ├─ Build
 ├─ Test
 └─ Validation
      ↓
Merge
      ↓
main
      ↓
CD
 ├─ Docker Build
 ├─ 서버 접속
 ├─ Container Update
 └─ 서비스 재시작
```

특히 여러 명이 함께 개발하는 프로젝트에서는 **코드가 `main`에 병합되는 순간 자동으로 검증하고 배포할 수 있다는 점**이 중요하다.

---

## 15. 정리

GitHub Actions는 GitHub 저장소에서 발생하는 이벤트를 기반으로 개발 과정의 반복 작업을 자동화하는 도구이다.

핵심 구조는 다음과 같다.

```text
Workflow
   ↓
Trigger
   ↓
Job
   ↓
Runner
   ↓
Step
```

CI/CD까지 연결하면

```text
코드 작성
   ↓
Git Push
   ↓
Build
   ↓
Test
   ↓
Deploy
```

과정을 자동화할 수 있다.

결국 GitHub Actions의 핵심은 단순히 "빌드 명령을 자동으로 실행하는 것"이 아니라,

> **코드 변경부터 검증, 배포까지의 반복적인 개발 과정을 자동화하는 것**

이라고 볼 수 있다.