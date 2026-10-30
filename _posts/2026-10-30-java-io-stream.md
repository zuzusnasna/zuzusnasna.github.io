---
title: "Java I/O Stream — InputStream과 OutputStream으로 파일 다루기"
date: 2026-08-04 00:00:00 +0900
categories: [Spring]
tags: [Java, IO, InputStream, OutputStream, File]
---

## 1. Java I/O란?

I/O(Input/Output)는 프로그램이 파일이나 네트워크 등 외부 데이터와 입출력하는 작업이다. Java는 바이트 단위와 문자 단위의 스트림을 제공해 데이터를 읽고 쓸 수 있게 한다.

## 2. 바이트 스트림

InputStream과 OutputStream은 바이트 단위로 데이터를 처리한다. 이미지, PDF 등 바이너리 파일을 다룰 때 사용할 수 있다.

```java
try (InputStream in = new FileInputStream("input.bin");
     OutputStream out = new FileOutputStream("copy.bin")) {

    byte[] buffer = new byte[8192];
    int bytesRead;

    while ((bytesRead = in.read(buffer)) != -1) {
        out.write(buffer, 0, bytesRead);
    }
}
```

한 바이트씩 읽는 대신 버퍼를 사용하면 입출력 호출 횟수를 줄일 수 있다.

## 3. 문자 스트림

Reader와 Writer는 문자 데이터를 처리한다. 텍스트 파일을 다룰 때 사용하며, 인코딩을 명시해야 환경에 따른 문자 깨짐을 줄일 수 있다.

```java
try (BufferedReader reader = Files.newBufferedReader(
         Path.of("message.txt"), StandardCharsets.UTF_8);
     BufferedWriter writer = Files.newBufferedWriter(
         Path.of("copy.txt"), StandardCharsets.UTF_8)) {

    String line;
    while ((line = reader.readLine()) != null) {
        writer.write(line);
        writer.newLine();
    }
}
```

## 4. try-with-resources

파일 스트림은 사용 후 닫아야 운영체제 자원을 반환할 수 있다. try-with-resources는 AutoCloseable을 구현한 자원을 블록 종료 시 자동으로 닫는다.

직접 close()를 호출하는 것보다 예외가 발생하더라도 자원을 정리하기 쉽다.

## 5. 백엔드에서의 활용

파일 업로드·다운로드, 로그 파일 처리, CSV 내보내기 등에서 I/O를 사용한다. 큰 파일을 한 번에 메모리에 올리기보다 버퍼를 사용해 일정 크기씩 처리하는 것이 메모리 사용량 관리에 유리하다.

입출력은 CPU 연산보다 외부 장치의 응답을 기다리는 시간이 큰 작업일 수 있다. 파일 크기와 동시 요청 수를 고려해 처리 방식을 선택해야 한다.
