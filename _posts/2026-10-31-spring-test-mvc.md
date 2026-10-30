---
layout: post
title: "Spring MVC 테스트 — @WebMvcTest와 MockMvc로 HTTP 계약 검증"
date: 2026-10-30 00:00:00 +0900
categories: [Spring]
tags: [Spring, Testing, WebMvcTest, MockMvc, Controller]
---
## Controller 테스트의 범위

Controller는 URL 매핑, 요청 바인딩, 검증, HTTP 상태 코드, JSON 응답을 담당한다. Service 단위 테스트만으로는 실제 HTTP 요청이 Controller에 올바르게 연결되는지 확인할 수 없다.

@WebMvcTest는 전체 애플리케이션을 띄우지 않고 MVC 관련 구성요소 중심으로 테스트 컨텍스트를 구성한다.

```java
@WebMvcTest(OrderController.class)
class OrderControllerTest {
    @Autowired MockMvc mockMvc;
    @MockitoBean OrderService orderService;

    @Test
    void returnsOrder() throws Exception {
        given(orderService.find(1L))
            .willReturn(new OrderResponse(1L, "CREATED"));

        mockMvc.perform(get("/api/orders/1"))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.id").value(1))
            .andExpect(jsonPath("$.status").value("CREATED"));
    }
}
```

Spring Boot 버전에 따라 Mock Bean 등록 애너테이션이 다를 수 있다. 최신 버전에서는 @MockitoBean을 사용할 수 있고, 기존 프로젝트에서는 @MockBean을 볼 수 있다.

## 검증 실패도 확인

```java
mockMvc.perform(post("/api/orders")
        .contentType(MediaType.APPLICATION_JSON)
        .content("""
            {"productId": null, "quantity": 0}
            """))
    .andExpect(status().isBadRequest());
```

이 테스트는 JSON 역직렬화, Bean Validation, 예외 처리, HTTP 상태 코드가 연결되어 동작하는지 확인한다.

## 인증이 있는 Controller

Spring Security가 적용된 테스트에서 인증을 무조건 비활성화하면 운영에서 발생할 401·403 문제를 놓칠 수 있다. 테스트 목적에 따라 인증 사용자를 설정하거나 실제 토큰 필터 경로를 검증해야 한다.

## @WebMvcTest와 @SpringBootTest

| 항목 | @WebMvcTest | @SpringBootTest |
|---|---|---|
| 범위 | MVC 계층 중심 | 전체 애플리케이션 |
| 실행 속도 | 상대적으로 빠름 | 상대적으로 느림 |
| 주요 검증 | 라우팅·바인딩·응답 | Bean 통합과 전체 흐름 |

**실무 기준:** Controller의 HTTP 계약은 MockMvc로 빠르게 검증하고, DB와 Service까지 연결된 시나리오는 통합 테스트에서 확인한다.
