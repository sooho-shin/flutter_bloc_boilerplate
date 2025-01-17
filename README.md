# flutter_bloc_boilerplate

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

lib/
├── bloc/ # BLoC 관련 파일
│ ├── app_bloc.dart # App의 공용 BLoC
│ ├── app_event.dart # 이벤트 정의
│ ├── app_state.dart # 상태 정의
├── core/ # 공통 유틸리티 및 상수
│ ├── constants.dart
│ ├── services/ # 서비스 (API 등)
├── data/ # 데이터 레이어
│ ├── models/ # 모델
│ ├── repositories/ # 레포지토리
├── presentation/ # UI 레이어
│ ├── screens/ # 화면 구성
│ ├── widgets/ # 공용 위젯
├── main.dart # 엔트리포인트
