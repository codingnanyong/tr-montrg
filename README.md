# 🔌 TR Monitoring Solution

[![.NET](https://img.shields.io/badge/.NET-6.0-512BD4?logo=dotnet&logoColor=white)](https://dotnet.microsoft.com/)
[![ASP.NET Core](https://img.shields.io/badge/ASP.NET%20Core-6.0-512BD4?logo=dotnet&logoColor=white)](https://dotnet.microsoft.com/apps/aspnet)
[![Blazor](https://img.shields.io/badge/Blazor-6.0-512BD4?logo=blazor&logoColor=white)](https://dotnet.microsoft.com/apps/aspnet/web-apps/blazor)
[![Entity Framework Core](https://img.shields.io/badge/EF%20Core-6.0-512BD4?logo=dotnet&logoColor=white)](https://docs.microsoft.com/ef/core/)
[![PostgreSQL](https://img.shields.io/badge/PostgreSQL-Supported-336791?logo=postgresql&logoColor=white)](https://www.postgresql.org/)

변압기(TRansformer) 모니터링 및 이상 탐지 솔루션

## 📖 개요

변압기 상태를 실시간으로 모니터링하고, 이상 발생 시 알림을 제공하는 .NET 기반 통합 솔루션입니다.

### ✨ 주요 기능

- 🌡️ **실시간 온도 모니터링**: 변압기 온도 실시간 수집 및 모니터링
- 📧 **스마트 알림 시스템**: 이상 감지 시 이메일/SMS 자동 알림
- 📊 **통합 대시보드**: 기업/위치별 맞춤형 대시보드 제공
- 🔄 **자동 장치 관리**: IoT 디바이스 자동 재부팅 및 상태 관리
- 📷 **열화상 카메라 연동**: 열화상 데이터 통합 분석
- 📈 **데이터 분석**: 히스토리 데이터 기반 트렌드 분석
- ⚠️ **예측 유지보수**: AI 기반 이상 징후 사전 감지

## 🛠️ 기술 스택

### Backend

- **.NET 6.0**: Core framework
- **ASP.NET Core MVC**: Web application
- **Blazor Server**: Interactive dashboard
- **Entity Framework Core**: ORM
- **SignalR**: Real-time communication

### Frontend

- **Blazor Components**: Interactive UI components  
- **Bootstrap 5**: Responsive design
- **Chart.js**: Data visualization
- **Three.js**: 3D monitoring views

### Database

- **PostgreSQL**: Primary database
- **Redis**: Caching & session storage

### Infrastructure

- **Docker**: Containerization
- **nginx**: Reverse proxy & load balancing

## 🖥️ 화면

### TrMontrgSrv.Web

변압기 모니터링 웹 솔루션

![Main](../Image/TrMontgSrv/Main.PNG)

![Plan Example](../Image/TrMontgSrv/Plan_ex.PNG)
![Device Info](../Image/TrMontgSrv/DeviceInfo.PNG)
![Device Detail](../Image/TrMontgSrv/DeviceInfo_detail.PNG)
![Device Chart](../Image/TrMontgSrv/device_chart.PNG)
![Device Issue](../Image/TrMontgSrv/device_issue.PNG)
![Thermal Camera](../Image/TrMontgSrv/temp_camera.PNG)

### TrMontrgSrv.Dashboard

![Dashboard](img/dashboard.png)

## 🚀 빠른 시작

### 📋 사전 요구사항

- **.NET 6.0 SDK** 이상
- **PostgreSQL 12** 이상  
- **Redis** (캐싱용)
- **Visual Studio 2022** 또는 **VS Code**

### 📦 설치 및 실행

1. **저장소 클론**

```bash
git clone https://github.com/your-org/tr-montrg.git
cd tr-montrg
```

2. **데이터베이스 설정**

```bash
# PostgreSQL 연결 문자열 설정
# appsettings.json 파일에서 ConnectionStrings 섹션 수정
```

3. **의존성 설치 및 빌드**

```bash
dotnet restore
dotnet build
```

4. **데이터베이스 마이그레이션**

```bash
dotnet ef database update --project TrMontrgSrv.EF
```

5. **애플리케이션 실행**

```bash
# Web Application 실행
dotnet run --project TrMontrgSrv.Web

# Dashboard 실행 (다른 터미널에서)
dotnet run --project TrMontrgSrv.Dashboard

# WebAPI 실행 (다른 터미널에서)  
dotnet run --project TrMontrgSrv.WebApi
```

### 🔧 환경 설정

#### appsettings.json 예시

```json
{
  "ConnectionStrings": {
    "DefaultConnection": "Host=localhost;Database=tr_montrg;Username=your_user;Password=your_password"
  },
  "Redis": {
    "ConnectionString": "localhost:6379"
  },
  "Email": {
    "SmtpHost": "smtp.gmail.com",
    "SmtpPort": 587,
    "Username": "your_email@gmail.com",
    "Password": "your_app_password"
  },
  "IoT": {
    "MqttBroker": "localhost:1883",
    "DeviceTimeout": 30000
  }
}
```

## 🏗️ 아키텍처

### 프로젝트 구조

```text
tr-montrg/
├── TrMontrgSrv.Web/              # 🌐 ASP.NET Core MVC Web Application
├── TrMontrgSrv.WebApi/           # 🔌 RESTful Web API
├── TrMontrgSrv.Dashboard/        # 📊 Blazor Interactive Dashboard  
├── TrMontrgSrv.BLL/              # 💼 Business Logic Layer
├── TrMontrgSrv.EF/               # 🗄️ Entity Framework Core + Migrations
├── TrMontrgSrv.Model/            # 📋 Data Models & DTOs
├── TrMontrgSrv.SL/               # 🔧 Service Layer
├── TrMontrgSrv.AutoBtg/          # 🤖 Auto Batch Generator Service
├── TrMontrgSrv.Helpers/          # 🛠️ Utility Helpers
├── TrMontrgSrv.LoggerService/    # 📝 Logging Infrastructure
├── TrDataImporterSvc/            # 📥 Data Import Background Service
├── TrMontrgSrv.EF.Test/          # 🧪 Unit Tests
└── TrMontrgSrv.sln               # 📁 Solution File
```

### 시스템 아키텍처

```text
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Web Client    │    │   Dashboard     │    │   Mobile App    │
│   (MVC)         │    │   (Blazor)      │    │   (Future)      │
└─────────┬───────┘    └─────────┬───────┘    └─────────┬───────┘
          │                      │                      │
          └──────────────┬───────────────────────────────┘
                         │
              ┌─────────────────┐
              │   Web API       │
              │   (REST/SignalR)│
              └─────────┬───────┘
                        │
              ┌─────────────────┐
              │  Business Logic │
              │     (BLL)       │
              └─────────┬───────┘
                        │
         ┌──────────────┼──────────────┐
         │              │              │
┌─────────────┐ ┌─────────────┐ ┌─────────────┐
│ PostgreSQL  │ │    Redis    │ │  IoT MQTT   │
│  Database   │ │   Cache     │ │   Broker    │
└─────────────┘ └─────────────┘ └─────────────┘
```

## 📡 API 엔드포인트

### 🌡️ Temperature Monitoring

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/v1/temperatures` | 온도 데이터 조회 |
| POST | `/api/v1/temperatures` | 온도 데이터 등록 |
| GET | `/api/v1/temperatures/{deviceId}` | 특정 디바이스 온도 데이터 |
| GET | `/api/v1/temperatures/alerts` | 온도 알림 목록 |

### 📊 Device Management

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/v1/devices` | 디바이스 목록 조회 |
| POST | `/api/v1/devices` | 새 디바이스 등록 |
| PUT | `/api/v1/devices/{id}` | 디바이스 정보 수정 |
| DELETE | `/api/v1/devices/{id}` | 디바이스 삭제 |
| POST | `/api/v1/devices/{id}/reboot` | 디바이스 재부팅 |

### 📈 Analytics

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/v1/analytics/dashboard` | 대시보드 데이터 |
| GET | `/api/v1/analytics/trends` | 트렌드 분석 데이터 |
| GET | `/api/v1/analytics/reports` | 리포트 생성 |

## 🧪 테스트

### 단위 테스트 실행

```bash
# 모든 테스트 실행
dotnet test

# 특정 프로젝트 테스트
dotnet test TrMontrgSrv.EF.Test

# 커버리지 포함
dotnet test --collect:"XPlat Code Coverage"
```

### 통합 테스트

```bash
# API 테스트
dotnet test TrMontrgSrv.WebApi.Test

# 데이터베이스 테스트
dotnet test TrMontrgSrv.EF.Test
```

## 🐳 Docker 배포

```bash
# Docker 이미지 빌드
docker build -t tr-montrg-web -f TrMontrgSrv.Web/Dockerfile .
docker build -t tr-montrg-api -f TrMontrgSrv.WebApi/Dockerfile .

# Docker Compose로 전체 스택 실행
docker-compose up -d
```

## 📊 모니터링 & 로깅

### 로그 레벨 설정

```json
{
  "Logging": {
    "LogLevel": {
      "Default": "Information",
      "Microsoft.AspNetCore": "Warning",
      "TrMontrgSrv": "Debug"
    }
  }
}
```

### Health Check 엔드포인트

- **Web**: `GET /health`
- **API**: `GET /api/health`  
- **Database**: `GET /api/health/database`
- **Redis**: `GET /api/health/redis`

## 🔒 보안

- ✅ JWT 토큰 기반 인증
- ✅ Role-based 권한 관리
- ✅ HTTPS 강제 적용
- ✅ CORS 정책 적용
- ✅ SQL Injection 방지
- ✅ XSS 보호

## 🚨 문제 해결

### 일반적인 문제들

#### **데이터베이스 연결 오류**

```bash
# PostgreSQL 서비스 확인
sudo systemctl status postgresql

# 연결 문자열 확인
dotnet ef database update --verbose
```

#### **포트 충돌**

```bash
# 사용 중인 포트 확인
netstat -tulpn | grep :5000
```

## 🤝 기여하기

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

### 개발 가이드라인

- **코드 스타일**: EditorConfig 및 StyleCop 규칙 준수
- **커밋 메시지**: [Conventional Commits](https://www.conventionalcommits.org/) 형식 사용
- **테스트**: 새로운 기능에 대한 단위 테스트 필수
- **문서화**: XML 주석 및 README 업데이트

## 📞 지원

- **이슈 리포팅**: [GitHub Issues](https://github.com/codingnanyong/tr-montrg/issues)
- **질문 & 토론**: [GitHub Discussions](https://github.com/codingnanyong/tr-montrg/discussions)

## 📋 로드맵

- [ ] **AI 기반 예측 분석** (Q2 2024)
- [ ] **모바일 앱 개발** (Q3 2024)
- [ ] **클라우드 배포 지원** (Q4 2024)
- [ ] **다국어 지원** (2025)

## 📝 라이선스

Copyright © 2024 Changsin Inc. All rights reserved.

이 소프트웨어는 상업적 용도로 개발되었으며, 저작권법의 보호를 받습니다.
