---
layout: post
title: "Proxy Pattern — 실제 객체 접근을 제어하는 프록시 패턴"
date: 2026-10-19 00:00:00 +0900
categories: [학습]
tags: [Java, 디자인패턴, Proxy]
---

## 1. Proxy Pattern이란?

Proxy Pattern(프록시 패턴)은 **실제 객체와 사용자 사이에 대리 객체를 두어 실제 객체에 대한 접근을 제어하는 패턴**이다.

부동산 중개인을 생각하면 이해하기 쉽다. 집을 보러 가는 사람이 집주인과 모든 절차를 직접 처리하는 대신 중개인을 통해 정보를 확인하고 절차를 진행한다.

프로그램에서도 실제 객체를 직접 호출하기 전에 권한 확인, 로깅, 캐싱 등의 작업을 수행하도록 프록시를 둘 수 있다.

## 2. 실제 사례: 관리자 전용 문서 조회

문서 조회 기능을 인터페이스로 정의한다.

```java
interface DocumentService {
    void read();
}
```

실제 문서를 반환하는 객체다.

```java
class RealDocumentService implements DocumentService {
    @Override
    public void read() {
        System.out.println("중요 문서 내용을 조회합니다.");
    }
}
```

프록시는 실제 객체 호출 전에 권한을 검사한다.

```java
class DocumentProxy implements DocumentService {
    private final DocumentService realService;
    private final boolean admin;

    DocumentProxy(DocumentService realService, boolean admin) {
        this.realService = realService;
        this.admin = admin;
    }

    @Override
    public void read() {
        if (!admin) {
            System.out.println("접근 권한이 없습니다.");
            return;
        }

        System.out.println("접근 로그 기록");
        realService.read();
    }
}
```

사용하는 쪽은 실제 객체와 동일한 인터페이스를 통해 호출한다.

```java
public class Main {
    public static void main(String[] args) {
        DocumentService service =
                new DocumentProxy(new RealDocumentService(), false);
        service.read();

        DocumentService adminService =
                new DocumentProxy(new RealDocumentService(), true);
        adminService.read();
    }
}
```

## 3. 실행 흐름

```text
클라이언트
    |
DocumentService
    |
DocumentProxy
    |
권한 확인 / 로그 기록
    |
RealDocumentService
```

권한이 없으면 실제 객체를 호출하지 않는다. 권한이 있으면 프록시가 실제 객체에 작업을 위임한다.

## 4. 실제 적용 사례

- 접근 권한 검사
- 자주 조회하는 데이터 캐싱
- 실제 객체 생성이 무거울 때 지연 생성(Lazy Loading)
- 원격 서버의 객체를 로컬 객체처럼 호출
- 메서드 실행 시간과 호출 내역 기록

Spring AOP의 프록시 기반 동작이나 JPA의 지연 로딩 프록시도 프록시 개념을 이해하는 데 좋은 사례다. 다만 실제 프레임워크 구현은 여기의 단순 예제보다 복잡하다.

**핵심:** 실제 객체 앞에 대리 객체를 두고 접근 전후의 부가 작업이나 접근 제어를 수행한다.
