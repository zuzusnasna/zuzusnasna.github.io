---
layout: post
title: "k6로 부하 테스트하기: VU, Check, Threshold와 결과 측정"
date: 2026-08-11 00:00:00 +0900
categories: [학습]
tags: [k6, 성능 테스트, Load Test]
---

성능 테스트를 하면서 k6를 사용해 여러 사용자가 동시에 요청하는 상황을 만드는 방법과 결과를 어떻게 읽는지 정리했다.

## k6란

k6는 JavaScript로 테스트 시나리오를 작성하고 가상 사용자(Virtual User, VU)를 만들어 HTTP 등의 요청을 반복해서 보내는 부하 테스트 도구다.

단순히 요청을 많이 보내는 것보다 **어떤 부하를 만들었고 어떤 조건을 성공으로 볼 것인지**를 코드로 남길 수 있다는 점이 중요하다.

## 가장 기본적인 테스트

```javascript
import http from 'k6/http';
import { check } from 'k6';

export const options = {
  vus: 5,
  duration: '30s',
};

export default function () {
  const response = http.get('http://localhost:8080/api/posts');

  check(response, {
    'status is 200': (r) => r.status === 200,
  });
}
```

`vus`는 동시에 실행할 가상 사용자 수이고 `duration`은 테스트 시간을 의미한다.

실행은 다음처럼 한다.

```bash
k6 run script.js
```

## Check와 Threshold

`check()`는 개별 요청이 조건을 만족했는지 확인한다.

```javascript
check(response, {
  'status is 200': (r) => r.status === 200,
});
```

반면 `threshold`는 테스트 전체의 성능 기준을 정의한다.

```javascript
export const options = {
  thresholds: {
    http_req_failed: ['rate<0.01'],
    http_req_duration: ['p(95)<500'],
  },
};
```

여기서는 실패율이 1% 미만이고 요청의 p95 응답 시간이 500ms 미만이어야 테스트가 성공한 것으로 판단한다.

## 평균보다 p95를 보는 이유

평균 응답 시간이 100ms라고 해도 일부 요청이 2초 이상 걸릴 수 있다.

```text
평균   → 전체적인 경향
p90    → 느린 요청 일부까지 포함
p95    → 느린 요청을 포함한 사용자 경험 확인
p99    → 매우 느린 요청의 꼬리 확인
```

그래서 부하 테스트에서는 평균만 보고 성능이 좋다고 판단하지 않고 p95, p99와 실패율을 함께 확인하는 것이 좋다.

## VU를 늘리는 방법

단순히 `vus: 100`으로 크게 올리는 방법도 있지만, 실제 부하가 어떻게 증가하는지 보려면 `stages`를 사용할 수 있다.

```javascript
export const options = {
  stages: [
    { duration: '30s', target: 10 },
    { duration: '30s', target: 50 },
    { duration: '30s', target: 100 },
    { duration: '30s', target: 0 },
  ],
};
```

사용자를 단계적으로 증가시키면 어느 구간부터 응답 시간이 증가하거나 실패율이 올라가는지 관찰하기 쉽다.

## 테스트 결과를 기록할 때

성능 숫자만 기록하면 나중에 비교하기 어렵다. 최소한 다음 조건을 함께 남겨야 한다.

- VU 수
- 실행 시간
- 요청 종류
- 테스트 데이터 규모
- 테스트 환경
- 평균 응답 시간
- p95 / p99
- 요청 실패율
- 초당 처리량

예를 들어 `p95 200ms`라는 숫자만 적는 것보다 `VU 50, 1분, GET /api/posts, 테스트 데이터 10만 건`처럼 조건을 같이 적어야 다른 코드 변경과 비교할 수 있다.

## WebSocket도 측정할 수 있다

k6는 HTTP뿐 아니라 WebSocket 시나리오도 작성할 수 있다.

```javascript
import ws from 'k6/ws';

export default function () {
  ws.connect('ws://localhost:8080/ws', {}, function (socket) {
    socket.on('open', () => {
      socket.send('hello');
    });
  });
}
```

실시간 통신에서는 연결 성공 여부뿐 아니라 연결 유지 시간, 메시지 송수신, 실패율 등을 시나리오에 포함해야 한다.

결국 부하 테스트의 핵심은 **숫자를 크게 만드는 것이 아니라 실제로 확인하고 싶은 병목을 재현하고, 같은 조건으로 다시 측정할 수 있게 만드는 것**이다.
