# TechStore Flutter

[techstore-nextjs](https://github.com/YOUR_USER/techstore-nextjs)와 동일한 UI·기능을 제공하는 **멀티 플랫폼** Flutter 앱입니다.

## 생성 위치

로컬 워크스페이스 기준:

```
/Users/bluejunha/Documents/git/techstore-flutter
```

`techstore-nextjs`와 같은 상위 폴더(`Documents/git/`)에 두었습니다.

- **웹**: PC 브라우저에서 실행 (`flutter run -d chrome`)
- **모바일**: iOS / Android 네이티브 앱

## 기능

| 화면 | 경로 | 설명 |
|------|------|------|
| 홈 | `/` | 히어로, 인기 상품, 카테고리별 탐색 |
| 전체 상품 | `/products` | 전체/특가 필터 |
| 검색 | `/search?q=` | 상품명·설명·카테고리 검색 |
| 카테고리 | `/category/:slug` | 정렬·특가 필터 |
| 상품 상세 | `/product/:id` | 찜/장바구니/주문 |
| 장바구니 | `/cart` | 수량 조절, 주문 요약 |
| 찜 목록 | `/wishlist` | 찜 상품 관리 |
| 로그인 | `/login` | 데모 로그인 |
| 마이페이지 | `/mypage` | 프로필, 주문, 설정 |

## 사전 요구 사항

- [Flutter SDK](https://docs.flutter.dev/get-started/install) 3.16 이상
- 웹: `flutter config --enable-web`
- iOS: Xcode (macOS)
- Android: Android Studio / SDK

## 설치 및 실행

```bash
cd techstore-flutter

# 플랫폼 폴더가 없다면 (최초 1회)
flutter create . --platforms=web,ios,android

flutter pub get

# 웹 (PC 브라우저)
flutter run -d chrome

# iOS 시뮬레이터
flutter run -d ios

# Android 에뮬레이터
flutter run -d android
```

## 프로덕션 빌드

```bash
# 웹
flutter build web

# Android APK
flutter build apk

# iOS (macOS + Xcode 필요)
flutter build ios
```

## 프로젝트 구조

```
techstore-flutter/
├── lib/
│   ├── main.dart              # 앱 진입점
│   ├── router/                # go_router 라우팅
│   ├── providers/             # 장바구니·찜·로그인 상태 (Provider)
│   ├── models/                # Product, CartItem 등
│   ├── data/                  # 상품 데이터 (Next.js와 동일)
│   ├── theme/                 # indigo/violet 테마
│   ├── widgets/               # GNB, Footer, ProductCard, Toast
│   └── screens/               # 각 페이지
├── web/                       # 웹 진입점 (index.html, manifest.json)
├── pubspec.yaml               # 의존성 및 프로젝트 메타
├── analysis_options.yaml
└── README.md
```

## Next.js 대비

| 항목 | Next.js | Flutter |
|------|---------|---------|
| 상태 관리 | StoreContext | Provider (`StoreProvider`) |
| 라우팅 | App Router | go_router |
| 스타일 | Tailwind CSS | Material + 커스텀 테마 |
| 분석 | Amplitude / Braze | 미포함 (필요 시 SDK 추가) |

상품 데이터·UI 레이아웃·색상은 `techstore-nextjs`와 동일하게 맞춰 두었습니다.
