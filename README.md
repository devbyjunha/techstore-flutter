# TechStore Flutter

`techstore-nextjs`와 동일한 UI·기능을 제공하는 **멀티 플랫폼** Flutter 앱입니다.

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

- [Flutter SDK](https://docs.flutter.dev/get-started/install/macos) 3.16 이상 (stable 채널 권장)
- 웹: `flutter config --enable-web`
- iOS: Xcode (macOS)
- Android: Android Studio / SDK

## Flutter SDK 설치 (필수)

이 저장소에는 **앱 소스 코드만** 포함되어 있습니다. `flutter` 명령은 Flutter SDK를 별도로 설치해야 사용할 수 있습니다.

### 설치 확인

```bash
flutter --version
```

정상이면 버전 정보가 출력됩니다. 아래처럼 나오면 SDK가 없거나 PATH에 등록되지 않은 상태입니다.

```text
zsh: command not found: flutter
```

### 설치 방법 (macOS)

**방법 A — Homebrew (간단)**

```bash
brew install --cask flutter
```

**방법 B — 공식 저장소 클론**

```bash
cd ~
git clone https://github.com/flutter/flutter.git -b stable
```

`~/.zshrc`에 PATH를 추가합니다.

```bash
export PATH="$HOME/flutter/bin:$PATH"
```

```bash
source ~/.zshrc
```

### 설치 후 환경 점검

```bash
flutter doctor
```

누락된 항목(Android SDK, Xcode 등)은 `doctor` 안내에 따라 보완합니다. 웹 실행만 할 경우 Chrome이 설치되어 있으면 됩니다.

> **참고**: 터미널을 연 뒤 PATH를 수정했다면, **새 터미널 창**을 열거나 `source ~/.zshrc`를 실행한 다음 `flutter` 명령을 다시 시도하세요.

## 설치 및 실행

> 아래 명령은 **Flutter SDK 설치가 완료된 뒤** 실행하세요.

```bash
cd techstore-flutter

# 플랫폼 폴더가 없다면 (최초 1회)
flutter create . --platforms=web,ios,android

flutter pub get

# 웹 (PC 브라우저) — Chrome 자동 실행 없이, 기존 탭에서 열기
flutter run -d web-server --web-port=8080

# (대안) Chrome 자동 실행
flutter run -d chrome

# 배포와 동일한 스크롤·성능 체감 (release 권장)
flutter run -d web-server --web-port=8080 --release

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

## 문제 해결

### `zsh: command not found: flutter`

| 원인 | 해결 |
|------|------|
| Flutter SDK 미설치 | 위 [Flutter SDK 설치](#flutter-sdk-설치-필수) 절차 진행 |
| PATH 미등록 | `~/.zshrc`에 `export PATH="$HOME/flutter/bin:$PATH"` 추가 후 `source ~/.zshrc` |
| 설치 직후에도 동일 | 터미널 앱을 완전히 종료 후 다시 실행 |

프로젝트 코드 오류가 아니라 **로컬 개발 환경** 문제입니다.

### 상품 이미지가 깨져 보일 때 (엑박)

Flutter Web(CanvasKit)은 외부 이미지를 캔버스에 그릴 때 **CORS** 제한이 있습니다. Next.js는 `next/image`가 서버를 통해 이미지를 불러와 이 문제가 없습니다.

앱은 웹에서 `WebHtmlElementStrategy.prefer`(브라우저 `<img>` 태그)로 이미지를 표시합니다. **앱을 완전히 재시작**한 뒤 다시 확인하세요.

여전히 안 보이면 네트워크에서 `images.unsplash.com` 접근이 막혔을 수 있습니다. 브라우저에서 상품 이미지 URL을 직접 열어 보세요.

### 웹 스크롤이 느리거나 답답할 때

UI 정렬 작업 중 **Stack + RadialGradient 배경**이 추가되면서 스크롤이 느려진 적이 있습니다. 현재는 초기 구조(단순 `Column` + `SingleChildScrollView`)로 되돌려 두었습니다.

1. **debug 모드** (`flutter run` 기본)는 release보다 무겁습니다. 배포 전에는 `--release`로 확인하세요.
2. `flutter run -d web-server --web-port=8080 --release` 로 로컬에서 배포와 동일한 체감을 확인할 수 있습니다.

### `flutter create` / `flutter pub get` 실패

- `flutter doctor`로 경고 항목 확인
- `android/`, `ios/` 폴더가 없을 때만 `flutter create . --platforms=web,ios,android` 실행 (기존 `lib/`는 덮어쓰지 않음)
