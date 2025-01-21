# flutter_bloc_boilerplate

1. bloc 디렉터리
   • app_bloc.dart, app_event.dart, app_state.dart 등으로 Bloc 패턴 구현 파일들이 위치합니다.
   • app_event.freezed.dart, app_state.freezed.dart 파일들은 freezed 패키지를 통해 자동 생성된 코드들이며, 불변 객체(Immutable object)를 만들어주고 패턴 매칭(when, maybeWhen 등)을 손쉽게 사용할 수 있게 해줍니다.
2. core 디렉터리
   • di 폴더(injection.dart)에서 주로 의존성 주입(Dependency Injection)을 담당합니다. 예를 들어, GetIt 또는 injectable 등을 사용해서 서비스나 리포지토리를 싱글톤 형태로 등록할 수 있습니다.
   • services 폴더에는 api_service.dart처럼 네트워크 호출이나 기타 유틸성 로직을 담당하는 서비스 계층이 있고, constants.dart 같은 상수 관리 파일도 포함되어 있습니다.
   • data 폴더는 실제 데이터 모델, 레포지토리를 포함하고 있습니다.
   • models 폴더에서 example_model.dart 및 자동 생성된 example_model.g.dart가 보이는데, 보통 json_serializable 등을 이용해 JSON <-> Dart 모델 변환을 쉽게 처리합니다.
   • repositories 폴더에는 example_repository.dart가 있어, 모델과 상호 작용하며 API 통신이나 DB 연동 등의 로직을 캡슐화합니다.
3. presentation 디렉터리
   • screens 폴더(home.dart)와 widgets 폴더(main.dart)로 UI 관련 파일들이 위치합니다.
   • screens 폴더에는 화면(페이지) 단위의 구현이, widgets 폴더에는 재사용 가능한 위젯들이 들어가는 식으로 구분하는 것이 보통입니다.
4. 그 외 lib 바깥쪽에는
   • analysis_options.yaml을 통해 린트 규칙을 설정하거나,
   • pubspec.yaml을 통해 의존성(패키지)들을 정의할 수 있습니다.
   • test 폴더는 테스트 파일들이 들어가는 표준 디렉터리입니다.

이러한 구조는 BLoC 아키텍처 및 레이어드 아키텍처(presentation, core(service/data), bloc) 형태를 잘 나타내고 있습니다.
• 비즈니스 로직은 BLoC이 담당하고,
• UI는 presentation 폴더에서,
• 데이터 소스(API, 모델 등)는 core/data에서,
• 공통 로직/서비스는 core/services 혹은 injection.dart에서 정리하는 식이죠.

1. app_event.dart
   • @freezed 어노테이션과 함께 AppEvent를 정의하고 있습니다.
   • const factory AppEvent.started() = AppStarted; 와 같이 이벤트를 타입별로 구분하여 표현합니다.
   • 예: 사용자가 앱을 처음 시작했을 때(started), 버튼을 눌렀을 때(buttonPressed) 등 상황마다 다양한 이벤트를 정의할 수 있습니다.
2. app_state.dart
   • 역시 @freezed 어노테이션을 사용한 AppState 정의 파일입니다.
   • const factory AppState.initial() = AppInitial; 처럼 앱의 상태를 여러 가지로 분기할 수 있습니다(예: 초기 상태 initial, 로딩 상태 load, 에러 상태 error, 성공 상태 success 등).
   • Freezed가 copyWith나 when/maybeWhen 같은 여러 유틸 함수를 자동으로 생성해주므로, BLoC 로직을 깔끔하게 짤 수 있습니다.
3. app_bloc.dart
   • Bloc<AppEvent, AppState>를 상속받아 실제 비즈니스 로직을 처리하는 핵심입니다.
   • 생성자에서 super(AppInitial()) 형태로 초기 상태를 설정하고,
   • on<AppEvent>((event, emit) {...}) 혹은 on<AppStarted>((event, emit) {...}) 등으로 이벤트가 들어왔을 때 어떤 상태로 전환할지를 처리합니다.
   • 현재 보여주신 코드에서는 예를 들어 on<AppStarted>((event, emit) => emit(AppLoaded())); 와 같은 식으로 구현할 수 있습니다.

core/di/injection.dart
• GetIt 라이브러리를 사용하여 의존성을 주입하는 설정 파일입니다.
• final getIt = GetIt.instance; 구문으로 GetIt의 전역 인스턴스를 가져옵니다.
• setup() 함수 내부에서

getIt.registerLazySingleton(() => ApiService());
getIt.registerLazySingleton(() => ExampleRepository(getIt<ApiService>()));

와 같이 lazySingleton으로 등록을 해두면, 이후 어디서든 getIt<ApiService>()와 같이 간단히 인스턴스를 요청할 수 있습니다.
• 이를 통해 서비스나 리포지토리와 같은 의존성을 한 곳에서 관리하며, 유지보수가 편리해집니다.

core/services/api_service.dart
• Dio를 사용하여 API 호출을 담당하는 예시 서비스 클래스입니다.
• fetchData(String url) 메서드는 지정된 url에 GET 요청을 날린 뒤, 응답 데이터를 반환합니다.
• 예외 발생 시 throw Exception('Failed to fetch data') 형태로 예외 처리를 하고 있습니다.
• 보일러플레이트 수준에서는 간단한 구조지만, 여기서 인증 토큰, 에러 처리, 로깅 등 다양한 네트워크 로직을 확장할 수 있습니다.

core/services/constants.dart
• 현재는 내용이 비어 있지만, 보통 URL, API key, String 리소스, SharedPreferences Key 등 여러 상수를 정의해서 사용합니다.
• 프로젝트가 커질수록 상수값 관리가 중요해지므로, 관련된 모든 상수를 한 파일에서 관리하면 편리합니다.

data 폴더 안에는 Model과 Repository가 위치하여 실제 데이터(예: API 응답, DB 등)에 접근하고 처리하는 역할을 담당합니다. 1. models/example*model.dart
• json_serializable 패키지를 사용해 @JsonSerializable() 애노테이션이 붙어 있으며,
• part 'example_model.g.dart'; 구문으로부터 자동 생성된 fromJson, toJson 메서드를 제공합니다.
• build_runner를 이용해 example_model.g.dart 파일이 생성되며, 이 파일에 JSON 직렬화/역직렬화 로직이 포함됩니다.
• 예시로 ExampleModel.fromJson(Map<String, dynamic> json) => *$ExampleModelFromJson(json); 같은 형태로 JSON을 ExampleModel 인스턴스로 변환합니다. 2. repositories/example_repository.dart
• **ApiService**를 주입받아(apiService) 실제 데이터 요청 로직을 한 레벨 더 추상화한 클래스입니다.
• fetchExampleData() 메서드에서 apiService.fetchData('https://example.com/data') 호출 -> 응답받은 JSON을 ExampleModel.fromJson()으로 파싱 -> ExampleModel 반환의 과정을 거칩니다.
• 이렇게 Repository 레이어를 두면, BLoC(또는 ViewModel 등)에서는 ExampleRepository의 메서드만 호출하면 되므로 API 통신 로직이 UI 쪽에서 분리되고 재사용이 가능해집니다.
• 나중에 실제 API 호출 경로가 바뀌거나 로컬 DB에서 데이터를 가져오도록 바꿔야 해도, ExampleRepository만 수정하면 되는 이점이 있습니다.

정리하자면 Model과 Repository를 통해 데이터 구조와 데이터 접근 로직을 체계적으로 관리하고, 이들을 BLoC에 주입(의존성 주입)함으로써 UI 로직과 분리된 깔끔한 아키텍처를 구축하는 모습입니다.
