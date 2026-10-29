---
layout: post
title: "팀 프로젝트 : SwingFit — 골프 스윙 영상 분석 앱"
date: 2026-09-25 09:00:00 +0900
categories: [프로젝트]
tags: [SwingFit, Kotlin, TensorFlow Lite, Computer Vision]
---

## 프로젝트 개요

한신대학교 캡스톤디자인 팀 프로젝트로 개발한 Android 기반 골프 스윙 분석 애플리케이션이다.

스마트폰 영상에서 골프공을 검출하고 프레임별 위치를 추적해 이동 궤적, 임팩트 시점, 초기 속도, 발사각, 예상 캐리 거리를 분석한다.

## 처리 흐름

```text
영상 선택
 ↓
ROI 설정
 ↓
프레임 추출
 ↓
640 × 640 전처리
 ↓
TensorFlow Lite 추론
 ↓
골프공 Detection
 ↓
Tracking
 ↓
Impact Search
 ↓
비행 데이터 계산
```

## 주요 기술

- Kotlin / Android
- TensorFlow Lite
- GPU Delegate / XNNPACK
- Media3 ExoPlayer
- MediaMetadataRetriever
- Coroutine
- Canvas Overlay

## 어려웠던 부분

모바일에서 영상 프레임을 모두 분석하면 처리 비용이 커지기 때문에 ROI를 제한하고 필요한 구간을 단계적으로 탐색했다.

또한 GPU Delegate를 사용할 수 없는 기기에서는 CPU로 전환할 수 있도록 처리해 실행 환경에 따른 실패 가능성을 줄였다.

## 배운 점

AI 기능을 모바일 앱에 넣는 것만큼 **모델 추론 비용과 영상 처리 비용을 줄이는 구조**가 중요하다는 것을 경험했다.
