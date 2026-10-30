---
title: "Java FileChannel — 대용량 파일을 채널로 처리하기"
date: 2026-10-30
categories: [Spring]
tags: [Java, NIO, FileChannel, ByteBuffer]
---

## FileChannel이란?

FileChannel은 파일 데이터를 읽고 쓰는 채널이다. ByteBuffer와 함께 사용하며 파일의 특정 위치에서 읽거나 쓰는 작업을 지원한다.

## Channel과 Buffer

Channel은 데이터가 오가는 통로이고 Buffer는 읽거나 쓸 데이터를 담는 공간이다. 읽기 작업에서는 데이터를 버퍼에 채운 다음 flip()으로 읽기 모드로 전환한다. 소비를 마치면 clear()로 다음 데이터를 받을 준비를 한다.

## Buffer의 주요 상태 전환

| 메서드 | 역할 |
| --- | --- |
| allocate() | 버퍼 생성 |
| flip() | 쓰기 모드에서 읽기 모드로 전환 |
| get() | 버퍼에서 데이터 읽기 |
| clear() | 버퍼를 다시 채울 수 있도록 초기화 |
| compact() | 아직 소비하지 않은 데이터를 앞으로 이동 |

## 위치 기반 접근

FileChannel은 현재 위치를 확인하거나 변경할 수 있고, 지정한 위치에서 읽거나 쓸 수도 있다. 대용량 파일의 일부 구간을 처리할 때 유용하다.

## 성능과 주의점

FileChannel이 항상 스트림보다 빠른 것은 아니다. 파일 시스템, 버퍼 크기, 접근 패턴, 운영체제에 따라 성능이 달라진다. 실제 환경에서 측정하고 채널과 버퍼 자원을 적절히 관리한다.
