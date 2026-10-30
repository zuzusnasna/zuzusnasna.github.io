---
layout: post
title: "MyBatis CRUD — SELECT, INSERT, UPDATE, DELETE"
date: 2026-10-30 14:20:00 +0900
categories: [Spring]
tags: [MyBatis]
---

오늘은 MyBatis에서 기본적으로 사용하는 CRUD SQL을 정리했다.

## 1. SELECT

```xml
<select id="findById" resultType="Member">
    SELECT *
    FROM member
    WHERE id = #{id}
</select>
```

`resultType`은 조회 결과를 어떤 객체로 받을지 지정한다.

## 2. INSERT

```xml
<insert id="save">
    INSERT INTO member(username, password)
    VALUES(#{username}, #{password})
</insert>
```

Java 객체의 프로퍼티를 `#{}`로 SQL에 전달한다.

## 3. UPDATE

```xml
<update id="update">
    UPDATE member
    SET username = #{username}
    WHERE id = #{id}
</update>
```

## 4. DELETE

```xml
<delete id="delete">
    DELETE FROM member
    WHERE id = #{id}
</delete>
```

## 5. 생성된 PK 받기

DB에서 ID를 자동 생성한다면 생성된 키를 객체에 다시 넣을 수 있다.

```xml
<insert id="save"
        useGeneratedKeys="true"
        keyProperty="id">
    INSERT INTO member(username, password)
    VALUES(#{username}, #{password})
</insert>
```

```java
Member member = new Member();
member.setUsername("hong");
member.setPassword("1234");

mapper.save(member);

System.out.println(member.getId());
```

MyBatis CRUD에서 중요한 것은 SQL 문법 자체보다 `Java 객체 → Mapper → SQL → DB → 결과`로 데이터가 이동하는 흐름을 이해하는 것이다.
