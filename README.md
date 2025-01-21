# Flutter BLoC Boilerplate

**Flutter + BLoC** 아키텍처로 구성된 간단한 보일러플레이트 프로젝트임.  
아키텍처 구조 예시, 의존성 주입(Dependency Injection), REST API 연동 예시(Todo API) 등이 포함되어 있음
새로운 프로젝트 시작 시 기본 골격으로 활용할 수 있음.

---

## 개요

- **프로젝트명**: `flutter_bloc_boilerplate`
- **주요 패턴**: [BLoC](https://bloclibrary.dev/#/), [GetIt](https://pub.dev/packages/get_it),  
  [Freezed](https://pub.dev/packages/freezed), [Json Serializable](https://pub.dev/packages/json_serializable) 등
- **구조**: Presentation (UI) / BLoC (비즈니스 로직) / Data (Repository, Model) / Core (DI, Service) 로 레이어 분리

---

## 프로젝트 구조

```markdown
flutter_bloc_boilerplate/
┣ .dart_tool/
┣ android/
┣ build/
┣ ios/
┣ lib/
┃ ┣ bloc/
┃ ┃ ┣ app_bloc.dart
┃ ┃ ┣ app_event.dart
┃ ┃ ┣ app_event.freezed.dart
┃ ┃ ┣ app_state.dart
┃ ┃ ┣ app_state.freezed.dart
┃ ┃ ┣ todo_bloc.dart <– Todo API 기능 담당
┃ ┃ ┣ todo_event.dart
┃ ┃ ┗ todo_state.dart
┃ ┣ core/
┃ ┃ ┣ di/
┃ ┃ ┃ ┗ injection.dart <– GetIt 의존성 주입
┃ ┃ ┣ services/
┃ ┃ ┃ ┗ api_service.dart <– Dio HTTP 통신
┃ ┃ ┗ constants.dart
┃ ┣ data/
┃ ┃ ┣ models/
┃ ┃ ┃ ┣ example_model.dart
┃ ┃ ┃ ┣ example_model.g.dart
┃ ┃ ┃ ┣ todo_model.dart
┃ ┃ ┃ ┗ todo_model.g.dart
┃ ┃ ┗ repositories/
┃ ┃ ┃ ┣ example_repository.dart
┃ ┃ ┃ ┗ todo_repository.dart <– Todo API 로직
┃ ┣ presentation/
┃ ┃ ┣ screens/
┃ ┃ ┃ ┗ home.dart <– AppBloc + TodoBloc 함께 사용
┃ ┃ ┗ widgets/
┃ ┗ main.dart <– MultiBlocProvider 등록
┣ test/
┣ pubspec.yaml
┗ README.md
```

---

### 주요 폴더/파일 설명

1. **bloc 폴더**

   - `AppBloc`, `AppEvent`, `AppState`: 전체 앱 전역에서 사용될 BLoC
   - `TodoBloc`, `TodoEvent`, `TodoState`: `todos/1` API와 관련된 BLoC 로직

2. **core 폴더**

   - `di/injection.dart`: [GetIt](https://pub.dev/packages/get_it)을 이용한 의존성 주입 설정
   - `services/api_service.dart`: [Dio](https://pub.dev/packages/dio)로 API 통신을 담당

3. **data 폴더**

   - `models`: JSON 직렬화/역직렬화를 위해 `json_serializable`을 사용하는 모델 클래스들
     - `example_model.dart`, `todo_model.dart` 등
   - `repositories`: 실제 데이터 소스 호출(서비스) + 모델 변환을 캡슐화해 BLoC에서 사용하기 쉽게 제공

4. **presentation 폴더**

   - `screens/home.dart`: BLoC의 상태를 구독해 UI로 보여주는 예시 (AppBloc + TodoBloc)
   - `widgets/`: 재사용 위젯 모음

5. **main.dart**
   - 앱의 진입점(Entry Point)
   - `MultiBlocProvider`로 `AppBloc`, `TodoBloc` 등을 등록하고 `HomeScreen`을 띄움

---

## 설치 및 실행 방법

1. **의존성 설치**

   ```bash
   flutter pub get
   ```

2. **build_runner(json_serializable 등) 코드 생성**

   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

3. **앱 실행**

   ```bash
   flutter run
   ```

4. **앱 실행 했는데 안되면 clean 하고 해보셈**
   ```bash
   flutter clean
   flutter pub get
   flutter run
   ```

---

## BLoC 구조와 사용 예시

### TodoBloc 예시

- TodoBloc에서 `FetchTodo` 이벤트를 감지 → `todoRepository.fetchTodo()` 호출 → `TodoModel` 반환 → `TodoState.loaded`로 UI에 전달

```dart
// todo_bloc.dart (핵심부분)
on<FetchTodo>((event, emit) async {
  emit(const TodoState.loading());
  try {
    final todo = await todoRepository.fetchTodo();
    emit(TodoState.loaded(todo));
  } catch (e) {
    emit(TodoState.error(e.toString()));
  }
});
```

### HomeScreen에서 상태 구독

```dart
// home.dart (일부 발췌)
context.read<TodoBloc>().add(const TodoEvent.fetchTodo());

BlocBuilder<TodoBloc, TodoState>(
  builder: (context, state) {
    return state.when(
      initial: () => const CircularProgressIndicator(),
      loading: () => const CircularProgressIndicator(),
      loaded: (todo) => Text('Title: ${todo.title}'),
      error: (msg) => Text('에러: $msg'),
    );
  },
);
```

### DI (injection.dart)

- ApiService, ExampleRepository, TodoRepository를 lazySingleton으로 등록
- main.dart의 MultiBlocProvider에서 getIt<>()를 통해 의존성 주입

```dart
final getIt = GetIt.instance;

void setup() {
  getIt.registerLazySingleton(() => ApiService());
  getIt.registerLazySingleton(() => ExampleRepository(getIt<ApiService>()));
  getIt.registerLazySingleton(() => TodoRepository(getIt<ApiService>()));
}
```

---

#### 업데이트 / 개선 사항 (지피티가 말한 개선사항임)

    •	BLoC 분할: 프로젝트 규모가 커지면 기능별로 여러 BLoC을 만들어 관리
    •	UI 위젯 분리: 공용 위젯은 presentation/widgets/에 배치
    •	테스트 코드: test/ 폴더에 BLoC, Repository 테스트 추가
    •	의존성 자동화: injectable을 사용하면 DI 코드를 자동 생성 가능
    •	lint 규칙 강화: analysis_options.yaml에 프로젝트 컨벤션에 맞는 규칙 적용
