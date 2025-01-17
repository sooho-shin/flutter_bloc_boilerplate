import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_state.freezed.dart';

@freezed
class AppState with _$AppState {
  const factory AppState.initial() = AppInitial;
  const factory AppState.load() = AppLoaded;
}


// https://velog.io/@leeeeeoy/Flutter-Bloc-%EC%82%AC%EC%9A%A9%ED%95%B4%EB%B3%B4%EA%B8%B0-1