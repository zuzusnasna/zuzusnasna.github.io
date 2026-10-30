---
layout: post
title: "MyBatis Mapper — XML, @Mapper, @Param 사용"
date: 2026-08-25 00:00:00 +0900
categories: [Spring]
tags: [MyBatis]
---

오늘은 MyBatis Mapper에서 SQL과 Java 메서드를 연결하는 방법을 정리했다.

## 1. XML Mapper

```java
@Mapper
public interface MemberMapper {
    Member findById(Long id);
}
```

```xml
<mapper namespace="com.example.mapper.MemberMapper">
    <select id="findById" resultType="Member">
        SELECT *
        FROM member
        WHERE id = #{id}
    </select>
</mapper>
```

`namespace`는 Mapper 인터페이스와 연결하고 `id`는 메서드 이름과 맞춰야 한다.

## 2. @Param

여러 파라미터를 SQL에서 이름으로 사용하려면 `@Param`을 사용할 수 있다.

```java
Member findByLogin(
    @Param("username") String username,
    @Param("password") String password
);
```

XML에서는 지정한 이름을 그대로 사용한다.

```xml
<select id="findByLogin" resultType="Member">
    SELECT *
    FROM member
    WHERE username = #{username}
      AND password = #{password}
</select>
```

## 3. Annotation 방식

간단한 SQL은 Mapper 인터페이스에 직접 작성할 수도 있다.

```java
@Select("""
    SELECT *
    FROM member
    WHERE id = #{id}
""")
Member findById(Long id);
```

간단한 SQL은 Annotation으로 처리하기 편하지만 SQL이 복잡해지고 동적 SQL이 많아지면 XML로 분리하는 편이 관리하기 쉽다.

```text
간단한 SQL → Annotation
복잡한 SQL → XML Mapper
```
