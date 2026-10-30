---
layout: post
title: "Java Files API — Path, 파일 읽기·쓰기와 안전한 경로 처리"
date: 2026-07-20 00:00:00 +0900
categories: [Spring]
tags: [Java, IO, NIO, Files, Path]
---

## 1. Path와 Files의 역할

Java NIO.2는 파일 시스템을 다루기 위한 Path와 Files API를 제공한다.

- Path: 파일이나 디렉터리의 경로를 표현한다.
- Files: Path를 대상으로 생성, 읽기, 쓰기, 복사, 이동, 삭제 등을 수행한다.

```java
Path path = Path.of("data", "members.txt");

System.out.println(path.getFileName());
System.out.println(path.toAbsolutePath());
System.out.println(Files.exists(path));
```

Path는 파일 자체가 아니라 파일 시스템상의 위치를 표현한다. 실제 파일 작업은 Files API를 통해 수행한다.

## 2. 디렉터리와 파일 생성

```java
Path directory = Path.of("data", "upload");
Files.createDirectories(directory);

Path file = directory.resolve("readme.txt");
Files.createFile(file);
```

createDirectories는 중간 경로를 포함해 디렉터리를 생성하고 이미 존재하면 그대로 둘 수 있다. createFile은 대상 파일이 이미 존재하면 예외가 발생한다.

## 3. 텍스트 파일 읽기와 쓰기

작은 텍스트 파일은 readString과 writeString으로 간단히 처리할 수 있다.

```java
Path path = Path.of("message.txt");

Files.writeString(
    path,
    "안녕하세요",
    StandardCharsets.UTF_8
);

String content = Files.readString(
    path,
    StandardCharsets.UTF_8
);
```

이 방식은 간결하지만 파일 전체 내용을 메모리에 읽어 온다. 파일이 매우 크다면 BufferedReader, InputStream, FileChannel 등 스트리밍 방식으로 나누어 처리하는 것이 적절하다.

## 4. 복사와 이동

```java
Path source = Path.of("source.txt");
Path copy = Path.of("backup.txt");
Path moved = Path.of("archive", "source.txt");

Files.copy(source, copy, StandardCopyOption.REPLACE_EXISTING);
Files.createDirectories(moved.getParent());
Files.move(copy, moved, StandardCopyOption.REPLACE_EXISTING);
```

기본적으로 대상 파일이 이미 있으면 복사나 이동이 실패할 수 있다. 덮어쓰기가 필요하다면 REPLACE_EXISTING 옵션을 고려한다.

ATOMIC_MOVE는 파일 시스템이 지원하는 경우 원자적 이동을 요청한다. 모든 파일 시스템에서 보장되는 것은 아니므로 예외 처리와 대체 동작을 고려해야 한다.

## 5. 파일 삭제와 예외

```java
boolean deleted = Files.deleteIfExists(Path.of("temp.txt"));
```

delete는 파일이 없거나 삭제할 수 없는 경우 예외가 발생할 수 있다. deleteIfExists는 파일이 존재할 때 삭제하고 존재하지 않으면 false를 반환한다.

파일 작업에서는 다음 예외 상황을 고려한다.

- 파일 또는 디렉터리가 존재하지 않음
- 접근 권한 부족
- 디렉터리가 비어 있지 않음
- 다른 프로세스가 파일을 사용 중
- 저장 공간 부족

## 6. 파일 업로드와 Path Traversal

서버에서 사용자가 전달한 파일명을 그대로 저장 경로에 연결하면 위험하다.

예를 들어 사용자가 `../../application.yml` 같은 경로를 전달하면 의도한 업로드 디렉터리 밖의 파일에 접근하려는 시도가 될 수 있다. 이를 Path Traversal이라고 한다.

```java
Path uploadRoot = Path.of("/var/app/uploads").toAbsolutePath().normalize();

String safeName = Paths.get(originalFilename)
        .getFileName()
        .toString();

Path target = uploadRoot.resolve(safeName).normalize();

if (!target.startsWith(uploadRoot)) {
    throw new SecurityException("허용되지 않은 경로");
}
```

이 코드는 경로 이탈을 방어하는 기본 예시다. 실제 서비스에서는 파일명을 서버에서 생성하고, 파일 크기·확장자·실제 콘텐츠 유형을 검증하며, 실행 파일이 업로드 디렉터리에서 실행되지 않도록 저장 위치를 분리해야 한다.

## 7. 대용량 파일 처리 기준

작은 설정 파일이나 텍스트 파일은 readString으로 충분할 수 있다. 반면 대용량 파일을 readAllBytes로 읽으면 파일 크기만큼 메모리를 확보해야 한다.

| 상황 | 고려할 API |
| --- | --- |
| 작은 텍스트 파일 | readString / writeString |
| 줄 단위 처리 | newBufferedReader |
| 바이너리 스트리밍 | InputStream / OutputStream |
| 큰 파일의 위치 기반 접근 | FileChannel |
| 디렉터리 탐색 | DirectoryStream / Files.walk |

## 핵심 정리

- Path는 경로를 표현하고 Files는 실제 파일 작업을 수행한다.
- readString은 간단하지만 파일 전체를 메모리에 올린다.
- 복사·이동 시 대상 존재 여부와 원자성 옵션을 고려한다.
- 업로드 파일명은 검증 없이 경로에 연결하면 안 된다.
- Path Traversal 방어와 크기·콘텐츠 검증을 함께 적용한다.
