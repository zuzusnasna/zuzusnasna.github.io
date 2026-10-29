---
layout: post
title: "Ubuntu에서 개발 환경을 확인할 때 자주 사용한 명령어"
date: 2026-10-12 09:00:00 +0900
categories: [학습]
tags: [Linux, Ubuntu, AWS]
---

EC2 서버를 다루면서 Linux 명령어는 개발 환경을 확인하는 도구라는 느낌으로 익히게 됐다.

## 프로세스와 자원 확인

```bash
top
free -h
df -h
ps aux
```

특히 `free -h`로 메모리와 swap을 확인하고 `top`으로 CPU와 I/O 상태를 확인하면 서버가 느려졌을 때 원인을 좁힐 수 있다.

## 파일과 로그 확인

```bash
ls -al
cd ~/RealTimeChat
tail -f app.log
```

## 배운 점

서버 문제를 만났을 때 바로 애플리케이션 코드를 수정하기보다 **CPU, 메모리, swap, 디스크, 프로세스 상태부터 확인하는 습관**을 만들었다.
