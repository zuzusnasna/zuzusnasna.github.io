---
layout: post
title: "Java Buffered I/O — 버퍼 스트림과 대용량 데이터 처리"
date: 2026-10-15 00:00:00 +0900
categories: [Spring]
tags: [Java, IO, BufferedReader, BufferedInputStream, Buffer]
---

## 1. 버퍼를 사용하는 이유

입출력은 메모리와 파일, 네트워크, 외부 장치 사이에서 데이터를 주고받는 작업이다. 작은 단위로 매번 읽고 쓰면 호출 횟수가 많아져 처리 비용이 커질 수 있다.

버퍼(Buffer)는 데이터를 일정량 메모리에 모아 두었다가 묶어서 처리하도록 도와준다. 예를 들어 파일에서 한 바이트씩 읽는 대신 일정 크기의 데이터를 미리 읽어 두고 애플리케이션이 그 안에서 소비하는 방식이다.

## 2. 바이트 스트림과 문자 스트림

Java I/O는 데이터 성격에 따라 바이트 스트림과 문자 스트림을 구분한다.

| 구분 | 주요 클래스 | 용도 |
| --- | --- | --- |
| 바이트 입력·출력 | InputStream, OutputStream | 이미지, 압축 파일 등 바이너리 |
| 문자 입력·출력 | Reader, Writer | 텍스트 데이터 |

문자 데이터는 문자 인코딩을 고려해야 한다. 파일을 읽을 때 기본 문자셋에 의존하기보다 UTF-8처럼 인코딩을 명시하는 것이 안전하다.

## 3. BufferedInputStream

BufferedInputStream은 내부 버퍼를 이용해 바이트 입력을 효율적으로 처리한다.

```java
try (InputStream in = new BufferedInputStream(
        Files.newInputStream(Path.of("image.bin")))) {

    byte[] buffer = new byte[8192];
    int length;

    while ((length = in.read(buffer)) != -1) {
        // buffer의 0부터 length 바이트까지 처리
    }
}
```

read(buffer)는 실제 읽은 바이트 수를 반환한다. 마지막에 읽을 데이터가 없으면 -1을 반환하므로 반환값만큼만 처리해야 한다. 배열 전체를 항상 유효 데이터로 간주하면 마지막 블록에서 이전 데이터가 섞일 수 있다.

## 4. BufferedReader

텍스트 파일은 BufferedReader와 readLine()을 이용해 한 줄씩 처리할 수 있다.

```java
Path path = Path.of("server.log");

try (BufferedReader reader =
        Files.newBufferedReader(path, StandardCharsets.UTF_8)) {

    String line;
    while ((line = reader.readLine()) != null) {
        if (line.contains("ERROR")) {
            System.out.println(line);
        }
    }
}
```

파일 전체를 한 번에 메모리에 적재하지 않고 순차 처리하므로 큰 로그 파일을 분석할 때 유용하다.

## 5. 버퍼 크기와 성능

버퍼 크기가 커지면 입출력 호출 횟수를 줄일 수 있지만 무조건 큰 버퍼가 빠른 것은 아니다. 동시 작업이 많으면 각 작업의 버퍼가 메모리를 점유한다.

예를 들어 100개의 작업이 각각 1MB 버퍼를 사용하면 버퍼만으로 약 100MB가 필요하다. 처리량, 파일 크기, 동시 실행 수, 메모리 제한을 고려해야 한다.

성능을 비교할 때는 다음 조건을 맞춰야 한다.

- 동일한 파일과 데이터 크기
- 동일한 저장 장치와 실행 환경
- 충분한 반복 측정
- JVM 워밍업과 운영체제 파일 캐시 영향
- 처리 시간뿐 아니라 메모리 사용량

## 6. try-with-resources로 자원 해제

파일 스트림은 운영체제 자원을 사용하므로 사용이 끝나면 닫아야 한다. try-with-resources를 사용하면 블록이 끝날 때 자동으로 close()가 호출된다.

```java
try (BufferedWriter writer = Files.newBufferedWriter(
        Path.of("result.txt"),
        StandardCharsets.UTF_8)) {
    writer.write("처리 결과");
    writer.newLine();
}
```

직접 close()를 호출하는 방식보다 예외 상황에서도 자원 해제를 보장하기 쉽다.

## 7. 백엔드에서 활용하는 경우

- 대용량 CSV 내보내기: 전체 결과를 한 번에 메모리에 만들지 않고 일정량씩 기록
- 로그 분석: 파일을 한 줄씩 읽으며 조건 검색
- 파일 업로드: 입력 스트림을 일정 크기 버퍼로 나누어 저장
- 파일 다운로드: 응답 출력 스트림에 데이터를 순차적으로 기록

파일 크기 제한, 인코딩, 예외 처리, 스트림 종료를 함께 고려해야 한다.

## 핵심 정리

- 버퍼는 작은 입출력 작업을 모아 호출 부담을 줄이는 데 도움을 준다.
- 바이너리는 바이트 스트림, 텍스트는 문자 스트림을 사용한다.
- read()의 반환 길이를 기준으로 실제 데이터 범위를 처리한다.
- 큰 파일은 전체 적재보다 스트리밍 방식이 메모리 측면에서 유리하다.
- try-with-resources로 입출력 자원을 안전하게 닫는다.
