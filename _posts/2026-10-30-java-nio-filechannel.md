---
layout: post
title: "Java FileChannel과 ByteBuffer — NIO 파일 처리 원리"
date: 2026-08-22 00:00:00 +0900
permalink: /spring/2026/10/30/java-nio-filechannel/
categories: [Spring]
tags: [Java, NIO, FileChannel, ByteBuffer, Channel]
---

## 1. NIO와 Channel

Java NIO(New I/O)는 기존 스트림 기반 I/O와 다른 방식으로 입출력을 다룰 수 있도록 Channel과 Buffer 등의 API를 제공한다.

Stream은 데이터를 읽거나 쓰는 흐름을 중심으로 사용한다. Channel은 데이터가 오가는 통로이고 Buffer는 읽거나 쓸 데이터를 담는 공간이다.

FileChannel은 파일을 읽고 쓰는 채널이며 ByteBuffer와 함께 사용하는 경우가 많다.

## 2. ByteBuffer의 구조

ByteBuffer는 데이터를 담는 메모리 공간과 함께 position, limit, capacity 상태를 관리한다.

| 속성 | 의미 |
| --- | --- |
| capacity | 버퍼가 가질 수 있는 전체 크기 |
| position | 다음 읽기 또는 쓰기가 수행될 위치 |
| limit | 읽거나 쓸 수 있는 범위의 끝 |
| mark | position을 되돌리기 위해 표시한 위치 |

버퍼의 상태를 이해하면 flip과 clear가 왜 필요한지 알 수 있다.

## 3. 쓰기 모드와 읽기 모드 전환

```java
ByteBuffer buffer = ByteBuffer.allocate(10);

buffer.put((byte) 'A');
buffer.put((byte) 'B');

buffer.flip();

while (buffer.hasRemaining()) {
    System.out.println((char) buffer.get());
}

buffer.clear();
```

처음에는 데이터를 넣는 쓰기 모드다. put을 수행하면 position이 증가한다. 데이터를 모두 넣은 다음 flip을 호출하면 position은 0으로 돌아가고 limit은 기존 position으로 설정되어 읽을 범위가 정해진다.

읽기를 마친 후 clear를 호출하면 다시 버퍼 전체를 채울 수 있는 상태가 된다. clear는 데이터를 실제로 0으로 지우는 메서드가 아니라 상태를 초기화하는 메서드다.

## 4. 주요 Buffer 메서드

| 메서드 | 역할 |
| --- | --- |
| allocate(n) | 지정한 크기의 버퍼 생성 |
| put() | 버퍼에 데이터 기록 |
| flip() | 쓰기 후 읽기 모드로 전환 |
| get() | 버퍼에서 데이터 읽기 |
| clear() | 전체 버퍼를 다시 쓰기 가능한 상태로 설정 |
| compact() | 아직 읽지 않은 데이터를 앞으로 이동 |
| rewind() | 처음부터 다시 읽도록 position 이동 |

compact는 읽지 않은 데이터가 남아 있을 때 그 데이터를 버퍼 앞으로 옮기고 이어서 데이터를 채울 수 있게 한다.

## 5. FileChannel로 파일 읽기

```java
Path path = Path.of("input.txt");

try (FileChannel channel = FileChannel.open(path, StandardOpenOption.READ)) {
    ByteBuffer buffer = ByteBuffer.allocate(8192);

    while (channel.read(buffer) != -1) {
        buffer.flip();

        while (buffer.hasRemaining()) {
            byte value = buffer.get();
            // 읽은 바이트 처리
        }

        buffer.clear();
    }
}
```

channel.read(buffer)는 버퍼에 읽은 바이트 수를 반환한다. -1은 파일 끝을 의미한다. 읽은 후 flip으로 읽기 모드로 전환하고, 소비가 끝나면 clear로 다음 데이터를 받을 준비를 한다.

## 6. FileChannel로 파일 쓰기

```java
Path path = Path.of("output.txt");
byte[] data = "Hello NIO".getBytes(StandardCharsets.UTF_8);

try (FileChannel channel = FileChannel.open(
        path,
        StandardOpenOption.CREATE,
        StandardOpenOption.WRITE,
        StandardOpenOption.TRUNCATE_EXISTING)) {

    ByteBuffer buffer = ByteBuffer.wrap(data);

    while (buffer.hasRemaining()) {
        channel.write(buffer);
    }
}
```

write는 버퍼의 모든 데이터를 한 번에 기록한다고 보장하지 않는다. 따라서 hasRemaining()을 확인하며 버퍼가 모두 기록될 때까지 반복하는 패턴이 안전하다.

## 7. 위치 기반 접근

FileChannel은 파일의 특정 위치를 읽거나 쓸 수 있다. 대용량 파일의 특정 구간을 처리하거나 파일 일부를 수정할 때 유용하다.

```java
try (FileChannel channel = FileChannel.open(
        Path.of("data.bin"), StandardOpenOption.READ)) {

    ByteBuffer buffer = ByteBuffer.allocate(128);
    int read = channel.read(buffer, 1024); // 1024 위치부터 읽기
}
```

위치 기반 read/write는 채널의 현재 position을 변경하지 않고 지정한 위치를 대상으로 작업한다.

## 8. Direct Buffer와 성능 주의점

ByteBuffer는 JVM 힙에 할당하는 Heap Buffer와 JVM 힙 외부 메모리를 사용하는 Direct Buffer를 제공한다.

- Heap Buffer: 생성과 관리가 상대적으로 단순하고 일반 객체처럼 GC 관리 대상이다.
- Direct Buffer: 네이티브 I/O에서 복사 부담을 줄이는 데 유리할 수 있지만 할당과 해제 비용, 메모리 관리 특성을 고려해야 한다.

Direct Buffer가 항상 빠른 것은 아니다. 파일 크기, 접근 패턴, 운영체제, 버퍼 크기에 따라 성능이 달라지므로 실제 환경에서 측정해야 한다.

## 9. FileChannel과 일반 Stream 선택

| 기준 | Stream | FileChannel |
| --- | --- | --- |
| 사용 방식 | 순차적 읽기·쓰기 | 버퍼 기반 읽기·쓰기 |
| 위치 접근 | 일반적으로 순차 처리 | 위치 기반 접근 지원 |
| API 난이도 | 비교적 간단 | 버퍼 상태 관리 필요 |
| 활용 | 일반 파일·텍스트 처리 | 대용량·위치 기반 파일 처리 |

NIO가 기존 I/O보다 모든 상황에서 빠른 것은 아니다. 요구사항이 단순하면 Stream이 더 읽기 쉬울 수 있다. 위치 기반 접근이나 버퍼 제어가 필요할 때 FileChannel을 검토한다.

## 핵심 정리

- Channel은 데이터 통로, Buffer는 데이터 저장 공간이다.
- ByteBuffer는 position, limit, capacity로 상태를 관리한다.
- 읽기 전에 flip, 다음 쓰기 전에 clear 또는 compact를 사용한다.
- FileChannel의 write는 일부만 기록될 수 있으므로 반복 처리가 필요하다.
- Direct Buffer와 NIO가 항상 더 빠른 것은 아니며 실제 환경에서 측정해야 한다.
