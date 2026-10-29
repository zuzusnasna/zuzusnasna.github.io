---
layout: post
title: "팀 프로젝트 : Meet-Up — 외부 API를 서비스 데이터로 바꾸는 과정"
date: 2026-10-26 09:00:00 +0900
categories: [프로젝트]
tags: [Meet-Up, Spring Boot, Redis, API]
---

<figure class="project-visual project-diagram">
<svg viewBox="0 0 760 150" role="img" aria-label="외부 대중교통 API 데이터를 서비스 응답으로 변환하는 흐름">
<rect x="8" y="35" width="155" height="72" rx="3" fill="#f3e7e2" stroke="#bd4b35"/><text x="85" y="65" text-anchor="middle" font-size="14" fill="#242832">외부 API</text><text x="85" y="85" text-anchor="middle" font-size="11" fill="#6f727b">원본 응답</text>
<path d="M163 71 H205" stroke="#bd4b35" stroke-width="2"/><path d="M198 65 L205 71 L198 77" fill="none" stroke="#bd4b35" stroke-width="2"/>
<rect x="205" y="35" width="155" height="72" rx="3" fill="#fff" stroke="#dedde1"/><text x="282" y="65" text-anchor="middle" font-size="14" fill="#242832">DTO 변환</text><text x="282" y="85" text-anchor="middle" font-size="11" fill="#6f727b">필드 정규화</text>
<path d="M360 71 H402" stroke="#bd4b35" stroke-width="2"/><path d="M395 65 L402 71 L395 77" fill="none" stroke="#bd4b35" stroke-width="2"/>
<rect x="402" y="35" width="155" height="72" rx="3" fill="#fff" stroke="#dedde1"/><text x="479" y="65" text-anchor="middle" font-size="14" fill="#242832">서비스 로직</text><text x="479" y="85" text-anchor="middle" font-size="11" fill="#6f727b">검증·캐시</text>
<path d="M557 71 H599" stroke="#bd4b35" stroke-width="2"/><path d="M592 65 L599 71 L592 77" fill="none" stroke="#bd4b35" stroke-width="2"/>
<rect x="599" y="35" width="153" height="72" rx="3" fill="#f3e7e2" stroke="#bd4b35"/><text x="675" y="65" text-anchor="middle" font-size="14" fill="#242832">REST 응답</text><text x="675" y="85" text-anchor="middle" font-size="11" fill="#6f727b">프론트엔드 전달</text>
</svg><figcaption>외부 API 응답을 그대로 노출하지 않고 내부 DTO와 서비스 규칙을 거쳐 반환하는 구조.</figcaption></figure>

외부 대중교통 API를 연결하면서 어려웠던 부분은 API를 호출하는 것보다 **외부 데이터 형식을 우리 서비스에서 사용할 수 있는 형태로 바꾸는 것**이었다.

## 외부 API와 내부 모델

```text
External API
   ↓
Response DTO
   ↓
Service 변환
   ↓
Domain 형태
   ↓
React
```

외부 API 응답을 Controller에서 그대로 화면에 전달하지 않고 중간 변환 계층을 두면 외부 시스템의 변경이 내부 코드에 미치는 영향을 줄일 수 있다.

## 막차 문제

첫 번째 노선의 막차를 탈 수 있다고 전체 귀가가 가능한 것은 아니었다. 환승역에 도착했을 때 다음 노선의 막차가 끝났다면 실제 경로는 성립하지 않는다.

따라서 구간별 도착 시간과 다음 환승 가능 여부를 확인해야 했다.

## Redis 캐시

같은 경로를 반복 요청하면 외부 API 호출 비용이 커질 수 있어 Redis를 사용했다. 하지만 캐시 데이터가 항상 최신인 것은 아니므로 기준 변경이나 새로고침에서는 최신 데이터를 다시 확인하도록 했다.

## 배운 점

외부 API 프로젝트에서는 **호출 코드보다 데이터 정규화와 실패 상황을 고려한 도메인 설계**가 더 중요할 수 있다는 것을 배웠다.

## 더 깊게 이해하기: 외부 API는 불안정한 의존성이다

외부 API는 네트워크 지연, 응답 형식 변경, 호출 제한, 일시적인 장애를 통제할 수 없다. 따라서 외부 응답을 그대로 내부 도메인 모델로 사용하기보다 필요한 필드만 추출해 내부 DTO나 도메인 모델로 변환하는 경계를 두는 편이 안전하다. 외부 API의 응답 형식이 바뀌어도 변경 범위를 연동 계층에 가둘 수 있기 때문이다.

타임아웃을 지정하지 않은 호출은 외부 시스템이 응답하지 않을 때 요청 스레드를 오래 점유할 수 있다. 재시도도 무조건 많이 하는 것이 답은 아니다. 호출이 이미 성공했지만 응답만 유실된 경우 중복 작업을 만들 수 있으므로, 멱등성 여부와 재시도 가능한 오류를 구분해야 한다.

### 연동 설계 체크리스트
- 연결 타임아웃과 응답 타임아웃을 설정했는가?
- 4xx와 5xx, 네트워크 오류를 구분해 처리하는가?
- 외부 응답이 비어 있거나 필드가 누락된 경우를 검증하는가?
- API 키와 개인정보를 로그에 남기지 않는가?
- 외부 API 장애가 내부 서비스 전체의 장애로 확산되지 않도록 제한하는가?

외부 연동 기능은 정상 응답을 받는 데서 끝나지 않는다. 실패가 발생했을 때 사용자에게 어떤 대체 경험을 제공할지도 설계의 일부다.


## 외부 교통 데이터가 서비스 기능이 되기까지

외부 API 응답을 화면에서 바로 사용하는 대신, 서비스가 필요로 하는 데이터만 추려 내부 응답 형태로 바꾸는 경계를 두었다. 이렇게 하면 외부 API의 필드 이름이나 응답 구조가 바뀌어도 화면과 도메인 로직 전체가 영향을 받는 것을 줄일 수 있다.

~~~java
// 개념을 보여 주는 축약 예시
ExternalRouteResponse external = client.fetchRoute(request);

RouteResult result = new RouteResult(
    external.getRouteName(),
    external.getDepartureTime(),
    external.getArrivalTime()
);
return result;
~~~

위 코드는 구조를 설명하기 위한 축약 예시다. 실제 클래스와 필드 이름을 그대로 옮긴 코드는 아니다. 핵심은 외부 응답 DTO와 프론트엔드에 반환할 모델을 분리한다는 점이다.

## 막차와 환승은 구간 단위로 판단해야 했다

출발 노선의 막차가 남아 있다는 사실만으로 최종 목적지까지 갈 수 있는 것은 아니다. 첫 구간 도착 시각에 환승할 다음 노선이 운행 중인지 확인해야 한다. 경로 전체를 하나의 시간으로만 판단하면 환승 구간에서 실제로 연결되지 않는 경로를 가능하다고 표시할 수 있다.

따라서 경로 결과를 검토할 때는 출발·도착 시각뿐 아니라 구간별 이동과 환승 시점이 이어지는지 확인해야 했다. 이 판단은 외부 API가 반환한 결과를 그대로 표시하는 것과 서비스에서 실제로 사용할 수 있는 경로를 판단하는 것이 다르다는 점을 보여 준다.

## Redis 캐시는 호출 비용과 최신성 사이의 선택

동일한 경로를 반복 조회할 때 매번 외부 API를 호출하면 응답 지연과 호출 제한에 영향을 받을 수 있어 Redis 캐시를 고려했다. 반대로 캐시만 신뢰하면 외부 데이터가 변경된 뒤에도 오래된 결과를 보여 줄 수 있다.

캐시를 적용할 때는 어떤 요청을 같은 결과로 볼지, 어느 시점에 새로 조회해야 하는지, 외부 API 실패 시 캐시된 데이터를 보여 줄 수 있는지 결정해야 한다. 캐시는 외부 호출을 줄이는 수단이지, 데이터 최신성 문제를 자동으로 해결하는 기능은 아니다.

### 이 기능을 검증할 때

- 외부 응답의 필수 필드가 누락되면 어떻게 처리하는가?
- 다음 환승 노선의 막차가 끝난 경우 해당 경로를 가능한 것으로 표시하지 않는가?
- 같은 요청을 반복했을 때 캐시가 호출 수를 줄이는가?
- 캐시가 없거나 외부 API가 실패해도 응답 형식이 일관적인가?
