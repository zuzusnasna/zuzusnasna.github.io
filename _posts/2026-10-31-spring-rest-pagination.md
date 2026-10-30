---
layout: post
title: "REST 목록 API 페이징 — Offset과 Cursor 기반 조회"
date: 2026-10-31 11:10:00 +0900
categories: [Spring]
tags: [Spring, REST, Pagination, Pageable, Cursor]
---
## 전체 목록 반환의 한계

데이터가 늘어날수록 모든 행을 한 번에 반환하면 DB 전송량, 메모리, 응답 시간이 증가한다. 목록 API는 페이지 단위로 반환하고 클라이언트가 다음 데이터를 요청할 수 있도록 설계한다.

## Offset 기반 페이지

Spring Data의 Pageable은 페이지 번호와 크기, 정렬을 전달하는 데 편리하다. 다만 페이지 번호가 커지면 DB가 많은 행을 건너뛰어야 하므로 대용량 데이터에서는 성능이 떨어질 수 있다.

정렬 기준이 유일하지 않으면 페이지를 이동하는 동안 중복이나 누락처럼 보이는 결과가 생길 수 있다. 생성 시각과 ID처럼 안정적인 복합 정렬 기준을 둔다.

## Cursor 기반 페이지

Cursor 방식은 마지막으로 읽은 정렬 키를 기준으로 다음 데이터를 가져온다.

```sql
SELECT id, title, created_at
FROM post
WHERE created_at < :lastCreatedAt
   OR (created_at = :lastCreatedAt AND id < :lastId)
ORDER BY created_at DESC, id DESC
LIMIT :size
```

실제 구현에서는 정렬 조건과 WHERE 조건이 일치해야 한다. 커서 값은 클라이언트가 임의로 조작하지 못하도록 검증하거나 불투명한 토큰으로 인코딩할 수 있다.

## Page와 Slice

Page는 전체 건수와 페이지 수를 제공하므로 count 쿼리가 추가될 수 있다. Slice는 다음 페이지 존재 여부 중심으로 제공해 전체 건수가 필요 없는 화면에서 효율적일 수 있다.

## 선택 기준

- 관리자 검색처럼 페이지 번호와 전체 건수가 필요하면 Offset/Page
- 무한 스크롤이나 대량 피드처럼 다음 데이터만 필요하면 Cursor
- 데이터 변경이 잦은 목록은 안정적인 정렬 키와 중복 방지 기준 필요

**정리:** 페이징 전략은 UI 요구사항, 데이터 크기, 정렬 안정성에 따라 달라진다. 단순히 Pageable을 사용하기 전에 전체 건수가 필요한지부터 결정한다.
