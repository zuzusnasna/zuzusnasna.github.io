---
layout: post
title: "MyBatis 시작 — JDBC와 MyBatis의 차이, Mapper 구조"
date: 2026-10-30 14:00:00 +0900
categories: [Spring]
tags: [MyBatis, JDBC]
---

오늘은 JDBC부터 MyBatis가 왜 필요한지, Java 코드와 SQL이 어떻게 연결되는지 정리했다.

## 1. JDBC

JDBC는 Java에서 데이터베이스에 접근하기 위한 기본 API다.

```java
Connection conn = DriverManager.getConnection(url, username, password);
PreparedStatement pstmt = conn.prepareStatement(
    "SELECT * FROM member WHERE id = ?"
);
pstmt.setLong(1, id);
ResultSet rs = pstmt.executeQuery();
```

직접 JDBC를 사용하면 DB 연결, SQL 실행, 결과 처리, 자원 해제까지 반복해서 작성해야 한다.

## 2. MyBatis

MyBatis는 SQL을 직접 작성하면서 JDBC에서 반복되는 DB 접근 코드를 줄여주는 SQL Mapper 프레임워크다.

```text
Java
 ↓
Mapper
 ↓
MyBatis
 ↓
JDBC
 ↓
Database
```

SQL은 XML에 작성할 수 있다.

```xml
<select id="findById" resultType="Member">
    SELECT *
    FROM member
    WHERE id = #{id}
</select>
```

MyBatis에서는 SQL을 자동으로 만들어주는 것보다 개발자가 SQL을 직접 제어하고 결과를 객체와 연결하는 데 초점이 있다.

## 3. Mapper

Mapper는 Java 코드에서 SQL을 호출하기 위한 인터페이스다.

```java
@Mapper
public interface MemberMapper {
    Member findById(Long id);
}
```

XML의 `namespace`는 Mapper 인터페이스와 연결되고 `id`는 메서드와 연결된다.

```xml
<mapper namespace="com.example.mapper.MemberMapper">
    <select id="findById" resultType="Member">
        SELECT * FROM member WHERE id = #{id}
    </select>
</mapper>
```

즉 Java에서는 메서드를 호출하고 실제 SQL은 Mapper에서 관리하는 구조다.
