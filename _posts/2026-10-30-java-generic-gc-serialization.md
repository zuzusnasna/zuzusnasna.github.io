---
layout: post
title: "Java Serialization — 객체 직렬화, JSON 변환과 보안 주의점"
date: 2026-10-30 12:20:00 +0900
categories: [Spring]
tags: [Java, Serialization, JSON, ObjectInputStream, Jackson]
---

## 1. 직렬화란?

직렬화(Serialization)는 프로그램의 객체를 파일이나 네트워크로 전달할 수 있는 데이터 표현으로 변환하는 과정이다. 역직렬화(Deserialization)는 그 데이터를 다시 객체로 복원하는 과정이다.

```text
객체 ── Serialization ──> 바이트 또는 데이터 형식
객체 <─ Deserialization ── 데이터
```

직렬화 형식은 시스템 사이에서 데이터를 저장하거나 전달할 때 중요하다. Java 객체의 메모리 구조 자체를 그대로 보내는 것이 아니라 약속된 형식으로 표현해야 한다.

## 2. Java 기본 직렬화

Java는 Serializable 인터페이스를 구현한 객체를 ObjectOutputStream으로 직렬화할 수 있다.

```java
import java.io.Serializable;

public class Member implements Serializable {
    private static final long serialVersionUID = 1L;

    private String name;
    private int age;

    public Member(String name, int age) {
        this.name = name;
        this.age = age;
    }
}
```

파일에 기록하는 예시다.

```java
Member member = new Member("Kim", 25);

try (ObjectOutputStream out = new ObjectOutputStream(
        new FileOutputStream("member.dat"))) {
    out.writeObject(member);
}
```

역직렬화는 ObjectInputStream을 사용한다.

```java
try (ObjectInputStream in = new ObjectInputStream(
        new FileInputStream("member.dat"))) {
    Member member = (Member) in.readObject();
}
```

역직렬화 결과는 Object이므로 실제 타입으로 변환해야 한다. 클래스 구조가 바뀌면 호환성 문제가 발생할 수 있어 serialVersionUID를 명시적으로 관리하는 경우가 많다.

## 3. transient와 직렬화 제외

직렬화하지 않을 필드는 transient로 표시할 수 있다.

```java
class Account implements Serializable {
    private String username;
    private transient String temporaryToken;
}
```

temporaryToken은 기본 직렬화 대상에서 제외된다. 비밀번호나 인증 토큰처럼 민감한 정보를 무심코 직렬화하지 않도록 주의해야 한다. transient가 보안 저장을 대신하는 것은 아니며, 직렬화 형식과 저장 위치 자체를 안전하게 설계해야 한다.

## 4. JSON 직렬화

웹 API에서는 Java 기본 직렬화보다 JSON을 사용하는 경우가 일반적이다. JSON은 언어와 플랫폼에 비교적 독립적인 텍스트 데이터 형식이다.

```java
public class MemberResponse {
    private String name;
    private int age;

    public MemberResponse(String name, int age) {
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

응답 데이터는 다음과 같이 표현할 수 있다.

```json
{
  "name": "Kim",
  "age": 25
}
```

Spring Boot에서는 Jackson과 같은 메시지 변환기가 Java 객체와 JSON 사이의 변환을 처리한다. 컨트롤러가 DTO를 반환하면 HTTP 응답 본문으로 JSON이 생성되는 방식이다.

## 5. Java 기본 직렬화와 JSON 비교

| 기준 | Java 기본 직렬화 | JSON |
| --- | --- | --- |
| 표현 | Java 객체 그래프 기반 바이트 | 텍스트 데이터 |
| 언어 독립성 | Java 환경 중심 | 다양한 언어에서 사용 |
| 가독성 | 사람이 직접 읽기 어려움 | 사람이 읽기 쉬움 |
| 호환성 | 클래스 변경에 주의 | 스키마 변경 정책 필요 |
| 사용 사례 | 제한된 Java 내부 용도 | REST API, 외부 시스템 연동 |

## 6. 역직렬화 보안

신뢰할 수 없는 데이터에 ObjectInputStream을 사용해 역직렬화하는 것은 위험할 수 있다. 역직렬화 과정에서 객체 생성과 특정 동작이 연쇄적으로 발생할 수 있기 때문이다.

외부 입력을 역직렬화해야 하는 상황은 가급적 피하고, 꼭 필요하다면 허용할 클래스 제한, 데이터 검증, 라이브러리 업데이트 등 방어책을 적용해야 한다.

JSON도 무조건 안전한 것은 아니다. 입력 크기 제한, 필드 검증, 민감 정보 노출 방지, 다형성 타입 처리 설정 등을 점검해야 한다.

## 7. 백엔드에서 만나는 직렬화

- Controller 응답 DTO를 JSON으로 변환
- 외부 API 요청·응답 데이터 변환
- Redis 등에 데이터를 저장할 때 직렬화 방식 선택
- 메시지 브로커로 이벤트 객체 전달
- 파일이나 캐시에 데이터를 보관

특히 Redis나 메시지 브로커에 저장하는 데이터는 생산자와 소비자가 같은 형식을 이해해야 한다. 클래스 이름에 의존하는 직렬화는 배포 버전이 달라질 때 호환성 문제를 만들 수 있으므로 데이터 스키마와 버전 관리가 중요하다.

## 핵심 정리

- 직렬화는 객체를 전달·저장 가능한 형식으로 변환하는 과정이다.
- Java 기본 직렬화는 Serializable과 ObjectOutputStream을 사용한다.
- transient는 특정 필드를 기본 직렬화에서 제외한다.
- 웹 API에서는 JSON과 Jackson을 사용하는 방식이 일반적이다.
- 신뢰할 수 없는 데이터의 역직렬화는 보안 위험이 있으므로 형식과 입력을 검증해야 한다.
