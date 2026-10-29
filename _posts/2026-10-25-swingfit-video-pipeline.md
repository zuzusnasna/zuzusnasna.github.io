---
layout: post
title: "팀 프로젝트 : SwingFit — 모바일 영상 분석 파이프라인"
date: 2026-10-25 09:00:00 +0900
categories: [프로젝트]
tags: [SwingFit, Kotlin, TensorFlow Lite, Android]
---

<figure class="project-visual">
  <img src="https://raw.githubusercontent.com/zuzusnasna/SwingFit/main/app/src/main/res/mipmap-xxxhdpi/ic_launcher.webp" alt="SwingFit 앱 아이콘" loading="lazy">
  <figcaption>SwingFit 모바일 앱의 실행 아이콘.</figcaption>
</figure>

SwingFit에서는 스마트폰으로 촬영한 골프 스윙 영상을 분석하기 위해 영상 처리와 모델 추론을 하나의 흐름으로 연결했다.

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
Impact 탐색
 ↓
비행 데이터 계산
```

## ROI를 사용한 이유

영상 전체를 매 프레임 분석하면 처리해야 할 픽셀과 추론 비용이 커진다. 골프공이 존재할 가능성이 높은 영역을 먼저 제한하면 불필요한 계산을 줄일 수 있다.

## GPU와 CPU

GPU Delegate를 사용할 수 있는 환경에서는 추론 속도를 높이고 사용할 수 없는 환경에서는 CPU 기반 실행으로 전환할 수 있도록 구성했다.

## 배운 점

모바일 AI는 모델 정확도만 보는 문제가 아니다. **영상 크기, 프레임 수, ROI, 추론 장치, 메모리 사용량까지 전체 파이프라인의 비용을 고려해야 한다**는 것을 경험했다.

## 더 깊게 이해하기: 영상 분석은 단계별 비용을 분리해야 한다

영상 분석은 파일 읽기, 프레임 추출, 전처리, 모델 추론, 결과 후처리, 화면 표시가 이어지는 파이프라인이다. 전체 처리 시간이 길다는 사실만으로 모델 추론이 병목이라고 단정할 수 없다. 프레임 디코딩이나 이미지 크기 변경, 불필요하게 많은 프레임을 처리하는 단계가 더 큰 비용을 만들 수 있다.

모바일에서 TensorFlow Lite를 사용한다면 모델 정확도뿐 아니라 입력 크기, 메모리 사용량, 기기별 실행 시간, delegate 지원 여부도 고려해야 한다. GPU Delegate를 사용할 수 없는 연산이 있으면 일부 작업이 CPU로 돌아갈 수 있으므로 실제 기기에서 확인해야 한다.

### 실험을 기록하는 방법
- 입력 영상 길이와 해상도, 샘플링 간격을 고정한다.
- 전처리·추론·후처리 시간을 따로 측정한다.
- CPU와 GPU Delegate 등 실행 경로를 비교한다.
- 처리 속도를 높이면서 분석 결과의 품질이 떨어지지 않는지 확인한다.

최적화는 추론 속도만 높이는 작업이 아니다. 사용자에게 필요한 결과를 유지하면서 전체 파이프라인의 비용을 줄이는 과정이다.
