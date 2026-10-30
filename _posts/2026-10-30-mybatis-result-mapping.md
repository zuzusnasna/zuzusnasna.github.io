---
layout: post
title: "MyBatis ResultMap — JOIN 결과를 객체 관계로 매핑하기"
date: 2026-08-19 00:00:00 +0900
categories: [Spring]
section: spring-data
tags: [Spring, MyBatis, ResultMap, Association, Collection]
---
## ResultType만으로 부족한 경우

단일 테이블 조회 결과는 컬럼과 DTO 필드 이름이 맞으면 resultType으로 간단히 매핑할 수 있다. 하지만 JOIN 결과를 부모·자식 객체 구조로 만들거나 컬럼 이름이 복잡하면 resultMap을 사용하는 편이 명확하다.

## 기본 ResultMap

```xml
<resultMap id="memberMap" type="MemberDto">
    <id property="id" column="member_id"/>
    <result property="name" column="member_name"/>
</resultMap>

<select id="findMember" resultMap="memberMap">
    SELECT id AS member_id, name AS member_name
    FROM member
    WHERE id = #{id}
</select>
```

id는 식별자 컬럼을 표시한다. 복합 키나 JOIN 결과를 다룰 때 식별자 매핑이 정확해야 객체 중복 처리에 유리하다.

## Association과 Collection

- association: 결과 한 건에 연결된 단일 객체를 매핑
- collection: 결과에 포함된 여러 자식 객체를 컬렉션으로 매핑

JOIN으로 부모와 자식 행이 반복되어 반환될 수 있으므로 부모 ID와 자식 ID를 명확히 지정한다. 잘못된 매핑은 같은 부모 객체가 중복 생성되거나 자식 목록이 누락되는 원인이 된다.

## 성능 고려

중첩 select 방식은 객체마다 별도 조회가 발생해 N+1 형태가 될 수 있다. 한 번의 JOIN으로 가져오는 방식은 쿼리 수를 줄일 수 있지만 결과 행이 늘어나고 중복 데이터가 전송될 수 있다. 데이터 양과 조회 목적에 따라 선택한다.

## 실무 체크

- 컬럼 별칭을 명확히 지정한다.
- 부모·자식 식별자를 id로 선언한다.
- 중첩 select 사용 시 실행 쿼리 수를 확인한다.
- 대량 조회에서 JOIN 결과 크기와 메모리 사용량을 측정한다.

**정리:** ResultMap은 복잡한 SQL 결과를 객체 구조로 변환하는 매핑 규칙이다. SQL 실행 횟수와 결과 행 수를 함께 확인해야 한다.
