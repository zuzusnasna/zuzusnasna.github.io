---
layout: post
title: "Iris 데이터로 KNN, SVM, Logistic Regression, Decision Tree 비교"
date: 2026-10-15 09:00:00 +0900
categories: [학습]
tags: [머신러닝, Python]
---

Iris 데이터셋으로 여러 분류 모델을 비교하면서 모델별 결과가 어떻게 달라지는지 확인했다.

## 데이터 준비

중복 데이터를 하나 제거한 뒤 클래스별 데이터 수는 다음과 같았다.

- Target 0: 50
- Target 1: 50
- Target 2: 49

훈련/테스트 데이터는 `test_size=0.2`, `random_state=20`으로 분리했다.

## 모델 결과

| 모델 | 정확도 |
|---|---:|
| KNN (`n_neighbors=7`) | 0.97 |
| SVC | 1.00 |
| Logistic Regression | 1.00 |
| Decision Tree (`max_depth=3`) | 0.93 |

단순히 정확도가 가장 높은 모델만 고르는 것이 아니라 데이터 크기와 모델의 특성, 과적합 가능성까지 함께 봐야 한다는 점을 배웠다.

## 예측 확인

`[5.1, 3.5, 1.4, 0.2]`는 setosa로, `[6.3, 3.3, 6.0, 2.5]`는 virginica로 예측되는 것을 확인했다.

작은 데이터셋에서도 전처리 → 분할 → 학습 → 평가 → 실제 샘플 예측의 흐름을 직접 실행해 본 것이 가장 큰 수확이었다.
