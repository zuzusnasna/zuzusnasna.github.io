---
layout: post
title: "Redis Sorted Set의 개념과 ZCOUNT로 순위 조회하기"
date: 2026-08-21 00:00:00 +0900
categories: [학습]
tags: [Redis, Sorted Set, ZCOUNT]
---

Redis의 여러 자료구조 중 Sorted Set을 공부하면서 점수에 따라 데이터를 정렬하고 특정 멤버의 순위를 빠르게 계산하는 방법을 정리했다.

## Redis Sorted Set이란

Sorted Set은 하나의 멤버에 `score`를 함께 저장하는 자료구조다. 같은 키 안에서 score를 기준으로 멤버가 정렬되기 때문에 순위, 우선순위, 점수 기반 조회처럼 순서가 필요한 데이터에 사용할 수 있다.

```text
queue
 ├─ userA : 100
 ├─ userB : 120
 └─ userC : 150
```

기본 명령은 `ZADD`로 데이터를 추가한다.

```bash
ZADD queue 100 userA
ZADD queue 120 userB
ZADD queue 150 userC
```

## 순위 조회

Sorted Set의 장점은 score를 기준으로 범위를 조회할 수 있다는 것이다.

```bash
ZRANGE queue 0 -1 WITHSCORES
```

특정 사용자의 score보다 작은 멤버 수를 구하면 앞에 있는 데이터의 개수를 계산할 수 있다.

```bash
ZCOUNT queue -inf 119
```

`userB`의 score가 120이라면 120보다 작은 score를 가진 멤버 수를 세어 앞에 있는 사용자 수를 구할 수 있다.

```text
앞에 있는 사용자 수 + 1 = 현재 순위
```

## Spring에서 사용하기

Spring Data Redis를 사용하면 `ZSetOperations`로 Sorted Set을 다룰 수 있다.

```java
@RequiredArgsConstructor
@Service
public class QueueService {

    private final StringRedisTemplate redisTemplate;

    public void add(String key, String userId, double score) {
        redisTemplate.opsForZSet().add(key, userId, score);
    }

    public Long countBefore(String key, double score) {
        return redisTemplate.opsForZSet().count(key, Double.NEGATIVE_INFINITY, score - 1);
    }
}
```

실제 점수의 범위와 동점 처리 방식에 따라 조회 조건은 달라질 수 있다. 특히 같은 score를 여러 멤버가 가질 수 있다면 추가적인 정렬 기준이나 고유한 score 정책을 함께 정해야 한다.

## 언제 사용하면 좋은가

Sorted Set은 다음과 같은 상황에 적합하다.

- 대기열 순위 조회
- 점수 순위표
- 우선순위가 있는 작업 목록
- 특정 점수 범위 조회
- 시간이나 점수를 기준으로 정렬된 데이터 관리

반대로 단순히 문자열이나 객체를 저장하고 빠르게 꺼내는 것이 목적이라면 String, Hash, List 같은 다른 자료구조가 더 적합할 수 있다.

## 핵심 정리

Redis를 사용할 때 중요한 것은 Redis를 단순 캐시로 생각하는 것이 아니라 **데이터의 접근 방식에 맞는 자료구조를 선택하는 것**이다.

Sorted Set은 `member + score` 구조를 이용해 정렬과 범위 조회를 제공하고, `ZCOUNT`를 활용하면 특정 score를 기준으로 앞에 있는 데이터의 개수를 계산할 수 있다.
