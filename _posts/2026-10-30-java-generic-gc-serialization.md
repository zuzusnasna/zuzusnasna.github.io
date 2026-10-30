---
layout: post
title: "Java Serialization — 객체를 데이터로 변환하는 직렬화"
date: 2026-10-30 12:10:00 +0900
categories: [Spring]
tags: [Java, Serialization]
---

객체를 프로그램 내부에서 사용하는 것과 파일이나 네트워크를 통해 전달하는 것은 다르다. 객체를 저장하거나 전송할 수 있는 형태로 바꾸는 과정을 직렬화라고 한다.

## 1. 직렬화와 역직렬화

- **직렬화(Serialization)**: 객체를 바이트 또는 데이터 형식으로 변환하는 과정
- **역직렬화(Deserialization)**: 변환된 데이터를 다시 객체로 복원하는 과정

```text
객체 ── 직렬화 ──> 데이터 ── 저장 또는 전송
객체 <─ 역직렬화 ── 데이터
```

## 2. JSON 직렬화 예시

서버에서 객체를 JSON으로 변환해 클라이언트에 응답하는 상황을 생각해 볼 수 있다.

```java
public class Member {
    private String name;
    private int age;

    public Member(String name, int age) {
        this.name = name;
        this.age = age;
    }

    public String getName() {
        return name;
    }

    public int getAge() {
        return age;
    }
}
```

```json
{
  "name": "홍길동",
  "age": 25
}
```

Spring Boot에서는 Jackson과 같은 라이브러리가 객체와 JSON 사이의 변환을 처리한다. 컨트롤러에서 객체를 반환하면 HTTP 응답 본문으로 JSON이 만들어지는 방식이다.

## 3. 실제 사용 사례

- REST API에서 서버가 DTO를 JSON 응답으로 변환
- 외부 API에 요청 데이터를 JSON으로 전달
- 객체 상태를 파일이나 저장소에 기록

직렬화는 단순히 객체를 출력하는 작업이 아니다. 서로 다른 프로그램이나 시스템이 데이터를 주고받을 수 있도록 표현 형식을 맞추는 과정이라는 점을 기억하자.
