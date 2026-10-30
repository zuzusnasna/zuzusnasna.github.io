---
layout: post
title: "Oracle SQL: ORDER BY와 문자열·숫자·날짜 함수"
date: 2026-10-28 00:00:00 +0900
categories: [학습]
tags: [Oracle, SQL, ORDER BY, 함수]
---

<figure class="note-cover">
  <img src="https://images.unsplash.com/photo-1516321318423-f06f85e504b3?auto=format&fit=crop&w=1400&q=85" alt="노트북과 작업 공간">
  <figcaption>정렬과 함수는 조회 결과를 업무에서 읽고 활용하기 쉬운 형태로 바꾼다.</figcaption>
</figure>

## 1. ORDER BY — 결과 정렬

기본 정렬은 오름차순(`ASC`)이다. 내림차순은 `DESC`를 붙인다.

```sql
SELECT name, grade, tel
FROM student
ORDER BY name ASC;

SELECT ename, job, deptno, sal
FROM emp
ORDER BY deptno ASC, sal DESC;
```

두 번째 쿼리는 부서번호 오름차순으로 정렬한 뒤, 같은 부서 안에서는 급여가 높은 순으로 표시한다. 여러 정렬 기준은 작성한 순서대로 적용된다.

## 2. 문자열 함수

### UPPER, LOWER, INITCAP

```sql
SELECT userid, UPPER(userid)
FROM student
WHERE studno = '20101';

SELECT ename
FROM emp
WHERE LOWER(ename) = 'scott';

SELECT name, userid, INITCAP(userid)
FROM student
WHERE name = '김영균';
```

- `UPPER`: 영문을 대문자로 변환
- `LOWER`: 영문을 소문자로 변환
- `INITCAP`: 단어 첫 글자를 대문자로 바꾸고 나머지를 소문자로 변환

검색 조건에 컬럼 함수를 적용하면 대소문자를 구분하지 않는 비교가 가능하다. 다만 큰 테이블에서는 인덱스 활용에 영향을 줄 수 있어 실행 계획도 고려해야 한다.

### LENGTH, LENGTHB, SUBSTR, INSTR

```sql
SELECT dname, LENGTH(dname), LENGTHB(dname)
FROM department;

SELECT name, idnum, SUBSTR(idnum, 1, 6)
FROM student;

SELECT dname, INSTR(dname, '과')
FROM department;
```

`LENGTH`는 문자 수, `LENGTHB`는 바이트 수를 반환한다. `SUBSTR`은 문자열 일부를 추출하고 `INSTR`은 찾는 문자의 위치를 반환한다. 찾는 문자가 없으면 0을 반환한다. 주민등록번호 등 민감정보는 실제 서비스에서 불필요하게 저장하거나 노출하지 않도록 주의한다.

### CONCAT, LPAD, RPAD, LTRIM, RTRIM

```sql
SELECT name || '의 직책은 ' || position AS professor_info
FROM professor;

SELECT position,
       LPAD(position, 10, '*'),
       RPAD(userid, 12, '+')
FROM professor;

SELECT dname, RTRIM(dname, '과')
FROM department;
```

`LPAD`는 왼쪽, `RPAD`는 오른쪽을 채운다. `LTRIM`과 `RTRIM`은 각각 왼쪽과 오른쪽에서 지정한 문자를 제거한다.

## 3. 숫자 함수

| 함수 | 역할 | 예시 |
|---|---|---|
| `ROUND` | 반올림 | `ROUND(123.456, 2)` → 123.46 |
| `TRUNC` | 지정 자리 이하 버림 | `TRUNC(123.456, 2)` → 123.45 |
| `MOD` | 나머지 | `MOD(10, 3)` → 1 |
| `CEIL` | 올림 | `CEIL(19.7)` → 20 |
| `FLOOR` | 내림 | `FLOOR(12.9)` → 12 |

```sql
SELECT sal,
       sal / 22,
       ROUND(sal / 22, 1),
       TRUNC(sal / 22, 1)
FROM professor;
```

자리수에 음수를 주면 소수점 왼쪽에서 반올림하거나 버린다. 예를 들어 `ROUND(125, -1)`은 십의 자리 기준으로 반올림한다.

## 4. 날짜 함수

```sql
SELECT SYSDATE - 1 AS yesterday,
       SYSDATE AS today,
       SYSDATE + 1 AS tomorrow
FROM dual;

SELECT ADD_MONTHS(SYSDATE, 6) AS six_months_later,
       LAST_DAY(SYSDATE) AS month_end,
       NEXT_DAY(SYSDATE, '일') AS next_sunday
FROM dual;
```

`SYSDATE`는 현재 날짜와 시간을 반환한다. 날짜에 정수 1을 더하거나 빼면 하루 단위로 계산한다. `ADD_MONTHS`는 개월 수를 더하고, `LAST_DAY`는 해당 월의 마지막 날짜, `NEXT_DAY`는 지정한 요일의 다음 날짜를 반환한다.

```sql
SELECT ROUND(MONTHS_BETWEEN(SYSDATE, hiredate))
FROM professor;
```

`MONTHS_BETWEEN`은 두 날짜 사이의 개월 수를 계산한다. `ROUND(date)`는 날짜를 반올림하고 `TRUNC(date)`는 시각 부분을 제거해 해당 날짜의 자정으로 만든다.

## 5. TO_CHAR와 TO_DATE

`TO_CHAR`는 날짜나 숫자를 문자열 형식으로 바꾼다.

```sql
SELECT TO_CHAR(birthdate, 'YY-MM')
FROM student;

SELECT TO_CHAR(
         hiredate,
         'Month DD, YYYY',
         'NLS_DATE_LANGUAGE=ENGLISH'
       )
FROM professor;

SELECT TO_CHAR((sal + comm) * 12, '9,999')
FROM professor;
```

`TO_DATE`는 날짜 문자열을 DATE 값으로 변환한다. 문자열 형식과 포맷 모델을 맞춰 작성한다.

```sql
SELECT name, hiredate
FROM professor
WHERE hiredate = TO_DATE(
    'June 01,01',
    'Month DD,YY',
    'NLS_DATE_LANGUAGE=ENGLISH'
);
```

날짜 컬럼을 문자열과 직접 비교하면 세션의 날짜 형식 설정에 의존할 수 있다. 명시적으로 `TO_DATE`를 사용하면 문자열 해석 방식을 쿼리에 드러낼 수 있다.

## 시험 전에 기억할 것

- `ORDER BY`: 기본 ASC, 내림차순은 DESC
- `UPPER` / `LOWER` / `INITCAP`: 대소문자 변환
- `LENGTH` / `LENGTHB`: 문자 수 / 바이트 수
- `SUBSTR` / `INSTR`: 문자열 추출 / 위치 찾기
- `ROUND` / `TRUNC` / `CEIL` / `FLOOR`: 반올림 / 버림 / 올림 / 내림
- `ADD_MONTHS`, `LAST_DAY`, `NEXT_DAY`, `MONTHS_BETWEEN`: 날짜 계산
- `TO_CHAR`: 날짜·숫자 → 문자, `TO_DATE`: 문자 → 날짜
