---
layout: post
title: "Docker Volume - 컨테이너 데이터 영속성 관리와 MySQL 실습"
date: 2026-11-04 00:00:00 +0900
categories: ["Database"]
section: database-redis
tags: ["Docker", "Volume", "Bind Mount", "Named Volume", "MySQL", "Container"]
---
## 1. Docker 컨테이너의 문제점

Docker를 사용하면 MySQL, Redis, Nginx와 같은 프로그램을 컨테이너 형태로 실행할 수 있다.

컨테이너에 새로운 기능을 적용하거나 프로그램을 업데이트할 때는 일반적으로 새로운 이미지를 빌드하고 새로운 컨테이너를 실행하는 방식으로 교체한다.

그런데 이 과정에서 문제가 발생한다.

**컨테이너 내부에 저장된 데이터는 컨테이너를 삭제하면 함께 사라질 수 있다.**

예를 들어 MySQL 컨테이너에 데이터베이스와 테이블을 생성했다고 가정하자.

1. MySQL 컨테이너 실행
2. 데이터베이스 생성
3. 데이터 저장
4. 기존 컨테이너 삭제
5. 새로운 MySQL 컨테이너 실행

이렇게 하면 기존 컨테이너 내부에 저장했던 데이터가 사라진다.

MySQL처럼 데이터를 지속적으로 보관해야 하는 프로그램에서는 치명적인 문제다.

### 해결 방법: Docker Volume

Docker Volume은 컨테이너와 별도의 저장 공간을 사용하여 데이터를 영속적으로 보관하는 기능이다.

컨테이너가 삭제되거나 교체되어도 Volume에 저장된 데이터는 유지된다.

```text
기존 방식

[컨테이너]
 └── MySQL 데이터
       ↓
   컨테이너 삭제
       ↓
   데이터도 삭제


Volume 사용 방식

[컨테이너]
 └── MySQL
       │
       │ 데이터 읽기 / 쓰기
       ▼
[Docker Volume]
 └── MySQL 데이터
       ↓
   컨테이너 삭제
       ↓
   데이터 유지
```

즉, 컨테이너는 프로그램을 실행하는 공간이고 Volume은 데이터를 보관하는 공간이다.

---

## 2. Docker Volume 기본 명령어

### 2-1. Volume 생성

```bash
docker volume create [볼륨 이름]
```

실습:

```bash
docker volume create my-volume
```

`my-volume`이라는 이름의 Docker Volume이 생성된다.

### 2-2. Volume 목록 확인

```bash
docker volume ls
```

생성된 Volume 목록을 확인할 수 있다.

### 2-3. Volume 상세 정보 확인

```bash
docker volume inspect my-volume
```

출력 예시:

```json
[
  {
    "Driver": "local",
    "Mountpoint": "/var/lib/docker/volumes/my-volume/_data",
    "Name": "my-volume",
    "Scope": "local"
  }
]
```

| 항목 | 의미 |
|---|---|
| Driver | Volume을 관리하는 드라이버 |
| Mountpoint | 실제 데이터가 저장되는 경로 |
| Name | Volume 이름 |
| Scope | Volume의 적용 범위 |

`Mountpoint`는 Docker가 관리하는 실제 저장 위치다.

Linux 환경에서는 일반적으로 `/var/lib/docker/volumes/` 아래에 저장된다.

---

## 3. 컨테이너에서 Volume 사용하기

Volume을 생성했다면 컨테이너 실행 시 `-v` 옵션으로 연결할 수 있다.

### 기본 문법

```bash
docker run -v [볼륨 이름]:[컨테이너 내부 경로] [이미지 이름]
```

실습:

```bash
docker run -d \
  --name volume-test \
  -v my-volume:/data \
  nginx
```

| 옵션 | 의미 |
|---|---|
| `-d` | 백그라운드 실행 |
| `--name` | 컨테이너 이름 지정 |
| `-v my-volume:/data` | Volume을 컨테이너의 `/data`에 연결 |
| `nginx` | 실행할 이미지 |

여기서 중요한 부분은 다음과 같다.

```bash
-v my-volume:/data
```

- `my-volume`: Docker가 관리하는 Volume 이름
- `/data`: 컨테이너 내부에서 Volume에 접근할 경로

컨테이너 내부의 `/data`에 파일을 저장하면 실제 데이터는 `my-volume`에 저장된다.

---

## 4. Bind Mount와 Named Volume

Docker에서 호스트와 컨테이너의 저장 공간을 연결하는 대표적인 방법은 두 가지다.

### 4-1. Bind Mount

Bind Mount는 사용자가 직접 지정한 호스트 디렉터리를 컨테이너 내부 경로에 연결하는 방식이다.

즉, 호스트에 있는 특정 폴더를 컨테이너가 공유해서 사용하는 것이다.

**기본 문법**

```bash
docker run -v [호스트 경로]:[컨테이너 경로] [이미지]
```

Windows 실습:

```bash
docker run -d \
  --name nginx-test \
  -v "C:\Users\lim\data:/app/data" \
  nginx
```

위 명령어는 다음 경로를 연결한다.

```text
Windows 호스트
C:\Users\lim\data
        │
        │ Bind Mount
        ▼
Docker 컨테이너
/app/data
```

컨테이너 내부에서 `/app/data`에 파일을 생성하면 Windows의 실제 폴더에도 파일이 생성된다.

**컨테이너 내부에서 파일 생성**

```bash
docker exec -it nginx-test sh

cd /app/data

echo hello > test.txt

exit
```

Windows에서 다음 경로를 확인하면 `test.txt` 파일을 볼 수 있다.

```text
C:\Users\lim\data\test.txt
```

**Bind Mount의 장점**

- 호스트에서 파일을 직접 확인할 수 있다.
- 호스트와 컨테이너 간 파일 공유가 가능하다.
- 컨테이너를 삭제해도 호스트 폴더의 데이터는 유지된다.
- 개발 환경에서 소스 코드나 설정 파일을 공유할 때 유용하다.

### 4-2. Named Volume

Named Volume은 Docker가 직접 생성하고 관리하는 저장 공간이다.

**생성**

```bash
docker volume create mysql_data
```

**컨테이너 실행**

```bash
docker run -d \
  --name my-mysql \
  -v mysql_data:/var/lib/mysql \
  mysql:8.0
```

- `mysql_data`: Docker Volume 이름
- `/var/lib/mysql`: MySQL 데이터가 저장되는 컨테이너 내부 경로

Docker가 실제 저장 위치를 관리하므로 사용자가 직접 호스트 디렉터리를 지정할 필요가 없다.

### 4-3. 방식 비교

| 구분 | Bind Mount | Named Volume |
|---|---|---|
| 저장 위치 | 사용자가 지정한 호스트 경로 | Docker가 관리하는 경로 |
| 생성 방법 | 호스트 폴더 생성 | `docker volume create` |
| 데이터 유지 | O | O |
| 파일 직접 접근 | 쉬움 | 상대적으로 불편 |
| 주요 사용 목적 | 개발 파일 공유, 설정 파일 | DB 데이터, 운영 데이터 |
| 관리 주체 | 사용자 | Docker |

**정리**

- Bind Mount: 내가 지정한 폴더를 컨테이너와 공유한다.
- Named Volume: Docker가 관리하는 별도의 저장 공간을 컨테이너와 공유한다.

---

## 5. Docker MySQL 컨테이너 실행

이제 Docker를 이용해 MySQL 컨테이너를 실행해 보자.

### 5-1. MySQL 이미지 실행

```bash
docker run \
  -p 3306:3306 \
  -e MYSQL_ROOT_PASSWORD=password123 \
  -d mysql
```

여기서 `docker pull` 명령어를 먼저 실행하지 않아도 된다.

`docker run` 실행 시 로컬에 해당 이미지가 없다면 Docker가 Docker Hub에서 이미지를 자동으로 다운로드한다.

### 5-2. 실행 옵션 확인

| 옵션 | 의미 |
|---|---|
| `-p 3306:3306` | 호스트 3306 포트를 컨테이너 3306 포트에 연결 |
| `-e` | 컨테이너 환경변수 설정 |
| `MYSQL_ROOT_PASSWORD` | MySQL root 계정 비밀번호 |
| `-d` | 백그라운드 실행 |
| `mysql` | 실행할 이미지 |

`-e`는 컨테이너 실행 시 환경변수를 설정하는 옵션이다.

### 5-3. 컨테이너 실행 확인

```bash
docker ps
```

실행 중인 컨테이너를 확인한다.

모든 컨테이너를 확인하려면 다음 명령어를 사용한다.

```bash
docker ps -a
```

### 5-4. 컨테이너 로그 확인

```bash
docker logs [컨테이너 ID 또는 이름]
```

MySQL 초기화 과정이나 오류를 확인할 수 있다.

### 5-5. 컨테이너 내부 접속

```bash
docker exec -it [컨테이너 ID 또는 이름] bash
```

MySQL 컨테이너 내부에서 MySQL에 접속한다.

```bash
mysql -u root -p
```

비밀번호를 입력한다.

```text
password123
```

데이터베이스 확인:

```sql
SHOW DATABASES;
```

데이터베이스 생성:

```sql
CREATE DATABASE mydb;
```

종료:

```sql
EXIT;
```

---

## 6. 포트 충돌 문제 해결

Windows에서 MySQL을 이미 실행하고 있다면 Docker MySQL 컨테이너를 실행할 때 다음 오류가 발생할 수 있다.

```text
Error response from daemon:
Bind for 0.0.0.0:3306 failed:
port is already allocated
```

이 오류는 호스트의 3306 포트를 이미 다른 프로그램이 사용하고 있다는 의미다.

예를 들어 Windows에 설치된 MySQL 서비스가 3306 포트를 사용하고 있을 수 있다.

### 해결 방법 1. 다른 포트 사용

가장 간단한 방법은 Docker 컨테이너의 포트 매핑을 변경하는 것이다.

```bash
docker run -d \
  -p 3307:3306 \
  -e MYSQL_ROOT_PASSWORD=password123 \
  mysql
```

```text
Windows 호스트          Docker 컨테이너

localhost:3307  ──────>  3306
```

| 구분 | 포트 |
|---|---|
| Windows 로컬 MySQL | 3306 |
| Docker MySQL | 3307 |
| Docker 내부 MySQL | 3306 |

외부 프로그램이나 DB 클라이언트에서 Docker MySQL에 접속할 때는 다음 정보를 사용한다.

```text
Host: localhost
Port: 3307
Username: root
Password: password123
```

### 해결 방법 2. 기존 MySQL 서비스 중지

Windows에서 `Win + R`을 누르고 다음 명령어를 입력한다.

```text
services.msc
```

1. 서비스 목록에서 MySQL 서비스 찾기
2. 마우스 오른쪽 클릭
3. 중지 선택
4. Docker MySQL을 3306 포트로 실행

```bash
docker run -d \
  -p 3306:3306 \
  -e MYSQL_ROOT_PASSWORD=password123 \
  mysql
```

---

## 7. Volume 없이 MySQL 데이터 유지 여부 확인

이번에는 Volume을 사용하지 않았을 때 어떤 문제가 발생하는지 실습해 보자.

### 7-1. MySQL 컨테이너 실행

```bash
docker run -d \
  --name mysql-test \
  -p 3307:3306 \
  -e MYSQL_ROOT_PASSWORD=pass123 \
  mysql
```

### 7-2. 데이터베이스 생성

```bash
docker exec -it mysql-test bash
```

MySQL 접속:

```bash
mysql -u root -p
```

```sql
CREATE DATABASE mydb;

SHOW DATABASES;

EXIT;
```

### 7-3. 컨테이너 삭제

```bash
docker rm -f mysql-test
```

`docker rm -f`는 실행 중인 컨테이너를 강제로 중지하고 삭제한다.

| 명령어 | 의미 |
|---|---|
| `docker rm` | 컨테이너 삭제 |
| `-f` | 실행 중인 컨테이너 강제 중지 후 삭제 |
| `mysql-test` | 삭제할 컨테이너 이름 |

주의할 점은 컨테이너만 삭제한다는 것이다. MySQL 이미지까지 삭제되는 것은 아니다.

### 7-4. 새로운 MySQL 컨테이너 실행

```bash
docker run -d \
  --name mysql-test \
  -p 3307:3306 \
  -e MYSQL_ROOT_PASSWORD=pass123 \
  mysql
```

다시 MySQL에 접속한다.

```bash
docker exec -it mysql-test bash

mysql -u root -p
```

```sql
SHOW DATABASES;
```

이전에 생성했던 `mydb`가 사라진 것을 확인할 수 있다.

**이것이 Volume을 사용해야 하는 이유다.**

---

## 8. Bind Mount를 이용한 MySQL 데이터 유지

이번에는 Windows 호스트 폴더를 MySQL 데이터 저장 경로에 연결해 보자.

### 8-1. 호스트 디렉터리 생성

Windows에서 다음 폴더를 생성한다.

```text
C:\Temp\docker-mysql\mysql_data
```

### 8-2. MySQL 컨테이너 실행

```bash
docker run -d \
  -p 3307:3306 \
  -e MYSQL_ROOT_PASSWORD=pass12 \
  -v "C:\Temp\docker-mysql\mysql_data:/var/lib/mysql" \
  --name my-mysql \
  mysql:8.0
```

### 8-3. 실행 옵션 설명

| 옵션 | 의미 |
|---|---|
| `-d` | 백그라운드 실행 |
| `-p 3307:3306` | 호스트 3307 → 컨테이너 3306 |
| `-e MYSQL_ROOT_PASSWORD=pass12` | MySQL root 비밀번호 설정 |
| `-v` | 호스트 폴더와 컨테이너 경로 연결 |
| `--name my-mysql` | 컨테이너 이름 지정 |
| `mysql:8.0` | MySQL 8.0 이미지 사용 |

가장 중요한 부분은 다음과 같다.

```bash
-v "C:\Temp\docker-mysql\mysql_data:/var/lib/mysql"
```

MySQL은 기본적으로 `/var/lib/mysql`에 데이터 파일을 저장한다.

이 경로를 Windows 호스트 폴더와 연결했기 때문에 컨테이너 내부에서 발생하는 데이터 변경 사항이 호스트 폴더에 저장된다.

### 8-4. 데이터베이스 생성

```bash
docker exec -it my-mysql bash

mysql -u root -p
```

```sql
CREATE DATABASE mydb;

SHOW DATABASES;

EXIT;
```

### 8-5. 컨테이너 삭제

```bash
docker stop my-mysql

docker rm my-mysql
```

### 8-6. 동일한 호스트 경로로 컨테이너 재생성

```bash
docker run -d \
  -p 3307:3306 \
  -e MYSQL_ROOT_PASSWORD=pass12 \
  -v "C:\Temp\docker-mysql\mysql_data:/var/lib/mysql" \
  --name my-mysql \
  mysql:8.0
```

다시 접속한다.

```bash
docker exec -it my-mysql bash

mysql -u root -p
```

```sql
SHOW DATABASES;
```

이전에 생성했던 `mydb`가 그대로 존재하는 것을 확인할 수 있다.

**컨테이너는 삭제했지만 호스트 폴더에 저장된 데이터는 유지되었기 때문이다.**

### 8-7. 컨테이너를 다시 만들 때 비밀번호를 변경하면?

다음과 같이 기존 데이터 폴더를 그대로 연결하면서 root 비밀번호를 변경한다고 가정하자.

```bash
docker run -d \
  -p 3307:3306 \
  -e MYSQL_ROOT_PASSWORD=newpass123 \
  -v "C:\Temp\docker-mysql\mysql_data:/var/lib/mysql" \
  --name my-mysql \
  mysql:8.0
```

기존 데이터가 이미 초기화되어 있다면 `MYSQL_ROOT_PASSWORD` 환경변수는 새로운 비밀번호로 자동 변경되지 않는다.

MySQL 공식 이미지의 초기화 환경변수는 데이터 디렉터리가 비어 있을 때 초기 설정에 사용되기 때문이다.

비밀번호를 변경하려면 기존 비밀번호로 접속한 뒤 SQL 명령어를 사용해야 한다.

```sql
ALTER USER 'root'@'localhost'
IDENTIFIED BY 'newpass123';
```

---

## 9. Named Volume을 이용한 MySQL 데이터 유지

운영 환경이나 일반적인 데이터베이스 실습에서는 Docker가 직접 관리하는 Named Volume을 사용하는 방법도 많이 활용한다.

### 9-1. Named Volume 생성

```bash
docker volume create mysql_data
```

### 9-2. 생성된 Volume 확인

```bash
docker volume ls
```

출력 예시:

```text
DRIVER    VOLUME NAME
local     mysql_data
```

### 9-3. MySQL 컨테이너 실행

Windows CMD에서 실행할 때는 다음과 같이 작성할 수 있다.

```cmd
docker run -d ^
  --name my-mysql ^
  -p 3307:3306 ^
  -e MYSQL_ROOT_PASSWORD=pass12 ^
  -v mysql_data:/var/lib/mysql ^
  mysql:8.0
```

PowerShell이나 Linux에서는 줄바꿈 문법이 다르므로 다음처럼 실행하면 된다.

```bash
docker run -d \
  --name my-mysql \
  -p 3307:3306 \
  -e MYSQL_ROOT_PASSWORD=pass12 \
  -v mysql_data:/var/lib/mysql \
  mysql:8.0
```

여기서 핵심은 다음 부분이다.

```bash
-v mysql_data:/var/lib/mysql
```

- `mysql_data`: Docker Volume 이름
- `/var/lib/mysql`: 컨테이너 내부의 MySQL 데이터 저장 경로

### 9-4. Volume 상세 정보 확인

```bash
docker volume inspect mysql_data
```

출력 예시:

```json
[
  {
    "Driver": "local",
    "Mountpoint": "/var/lib/docker/volumes/mysql_data/_data",
    "Name": "mysql_data",
    "Scope": "local"
  }
]
```

`Mountpoint`는 Docker가 관리하는 실제 저장 위치다.

Linux에서는 다음과 같은 경로를 확인할 수 있다.

```text
/var/lib/docker/volumes/mysql_data/_data
```

Windows의 Docker Desktop에서는 이 경로가 Docker 내부 Linux 환경에 존재할 수 있으므로 Windows 파일 탐색기에서 동일한 경로로 직접 접근하는 것은 일반적인 방식이 아니다.

### 9-5. 데이터 유지 확인

MySQL 접속:

```bash
docker exec -it my-mysql bash

mysql -u root -p
```

```sql
CREATE DATABASE mydb;

SHOW DATABASES;

EXIT;
```

컨테이너 삭제:

```bash
docker rm -f my-mysql
```

같은 Volume을 연결하여 새로운 컨테이너 생성:

```bash
docker run -d \
  --name my-mysql \
  -p 3307:3306 \
  -e MYSQL_ROOT_PASSWORD=pass12 \
  -v mysql_data:/var/lib/mysql \
  mysql:8.0
```

다시 접속하여 확인한다.

```bash
docker exec -it my-mysql bash

mysql -u root -p
```

```sql
SHOW DATABASES;
```

기존에 생성한 `mydb`가 그대로 유지되는 것을 확인할 수 있다.

**컨테이너를 삭제해도 Volume은 별도로 존재하기 때문에 데이터를 다시 사용할 수 있다.**

---

## 10. Docker 컨테이너와 Volume 삭제 명령어

| 명령어 | 설명 |
|---|---|
| `docker ps` | 실행 중인 컨테이너 확인 |
| `docker ps -a` | 전체 컨테이너 확인 |
| `docker stop [이름]` | 컨테이너 중지 |
| `docker rm [이름]` | 컨테이너 삭제 |
| `docker rm -f [이름]` | 실행 중인 컨테이너 강제 삭제 |
| `docker volume ls` | Volume 목록 확인 |
| `docker volume inspect [이름]` | Volume 상세 정보 확인 |
| `docker volume rm [이름]` | Volume 삭제 |
| `docker volume prune` | 사용하지 않는 Volume 삭제 |

여러 컨테이너를 한 번에 삭제할 수도 있다.

```bash
docker rm -f container1 container2 container3
```

주의할 점은 일반적인 `docker rm` 명령어는 Named Volume을 자동으로 삭제하지 않는다는 것이다.

반면 다음과 같이 `-v` 옵션을 함께 사용하면 해당 컨테이너에 연결된 익명 Volume도 삭제 대상이 된다.

```bash
docker rm -v [컨테이너 이름]
```

Named Volume은 별도로 삭제해야 한다.

```bash
docker volume rm mysql_data
```

**Volume을 삭제하면 그 안에 저장된 데이터도 함께 삭제되므로 주의해야 한다.**

---

## 11. 전체 개념 정리

| 구분 | 설명 |
|---|---|
| Container | 프로그램을 실행하는 독립적인 환경 |
| Image | 컨테이너를 생성하기 위한 실행 이미지 |
| Volume | 컨테이너와 독립적으로 데이터를 저장하는 공간 |
| Bind Mount | 호스트의 지정된 폴더를 컨테이너에 연결 |
| Named Volume | Docker가 직접 관리하는 저장 공간 |
| `-v` | Volume 또는 호스트 디렉터리 연결 옵션 |
| `-p` | 호스트와 컨테이너의 포트 연결 |
| `-e` | 컨테이너 환경변수 설정 |
| `-d` | 백그라운드 실행 |

### 핵심 흐름

```text
Docker Image
     │
     ▼
Docker Container
     │
     ├── 프로그램 실행
     │
     └── 데이터 읽기 / 쓰기
              │
              ▼
        Docker Volume
              │
              ▼
        데이터 영속성 유지
```

### 학습하면서 기억할 점

1. 컨테이너와 데이터 저장 공간은 분리할 수 있다.
2. 컨테이너를 삭제해도 Named Volume과 Bind Mount의 데이터는 유지된다.
3. Bind Mount는 호스트에서 직접 파일을 확인하거나 수정할 때 유용하다.
4. Named Volume은 Docker가 저장 공간을 관리하기 때문에 DB 데이터 보관에 적합하다.
5. MySQL의 `/var/lib/mysql`을 Volume에 연결하면 컨테이너를 교체해도 기존 데이터베이스를 유지할 수 있다.
6. Volume을 삭제하면 데이터도 삭제되므로 백업과 삭제 명령에 주의해야 한다.

**결론:** Docker Volume은 컨테이너의 생명주기와 데이터의 생명주기를 분리하기 위한 기능이다. 컨테이너는 언제든 교체할 수 있지만 데이터는 계속 유지해야 하는 MySQL, Redis 등의 서비스에서 중요한 역할을 한다.