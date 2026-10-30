---
layout: post
title: "JPA Flush와 Commit — SQL 실행 시점과 트랜잭션의 차이"
date: 2026-10-30 00:00:00 +0900
categories: [Spring]
section: spring-data
tags: [Spring, JPA, Flush, Commit, Transaction]
---
## Flush와 Commit은 같은 말이 아니다

Flush는 영속성 컨텍스트의 변경 내용을 데이터베이스에 SQL로 동기화하는 과정이다. Commit은 트랜잭션을 최종 확정하는 과정이다. Flush가 실행되어 UPDATE SQL이 로그에 보여도 트랜잭션이 롤백되면 변경은 확정되지 않는다.

## 실행 예시

```java
@Transactional
public void updateName(Long id) {
    Member member = entityManager.find(Member.class, id);
    member.changeName("새 이름");

    entityManager.flush(); // SQL을 DB에 동기화
    // 이후 예외가 발생하면 트랜잭션은 롤백될 수 있다.
}
```

변경 감지는 영속 상태 Entity의 스냅샷과 현재 값을 비교해 변경 SQL을 만든다. 개발자가 매번 update 메서드를 호출하지 않아도 된다.

## Flush가 발생하는 대표 시점

- 트랜잭션 커밋 직전
- JPQL 등 쿼리 실행 전, 변경 내용과 조회 결과의 일관성이 필요할 때
- entityManager.flush()를 직접 호출할 때

Flush 모드와 쿼리 종류에 따라 세부 동작은 달라질 수 있다. SQL 실행 시점을 정확히 확인하려면 Hibernate SQL 로그와 바인딩 파라미터 로그를 함께 확인한다.

## 벌크 UPDATE 주의

JPQL 벌크 UPDATE나 DELETE는 영속성 컨텍스트의 개별 Entity 상태를 거치지 않고 DB에 직접 반영된다. 이미 로딩된 Entity는 이전 값으로 남을 수 있다.

```java
entityManager.flush();
int updated = entityManager.createQuery("""
    update Member m set m.active = false
    where m.lastLoginAt < :cutoff
    """).setParameter("cutoff", cutoff)
      .executeUpdate();
entityManager.clear();
```

벌크 연산 전 flush로 기존 변경을 반영하고, 실행 후 clear로 오래된 1차 캐시 상태를 비우는 패턴을 검토한다.

**정리:** SQL 로그가 찍혔다는 사실과 데이터가 커밋되었다는 사실은 다르다. Flush, Commit, Rollback의 차이를 알아야 트랜잭션 문제를 정확히 진단할 수 있다.
