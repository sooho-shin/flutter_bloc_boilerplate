import 'package:get_it/get_it.dart';
import '../services/api_service.dart';
import '../../data/repositories/example_repository.dart';
import '../../data/repositories/todo_repository.dart';

final getIt = GetIt.instance;

void setup() {
  getIt.registerLazySingleton(() => ApiService());
  getIt.registerLazySingleton(() => ExampleRepository(getIt<ApiService>()));
  getIt.registerLazySingleton(() => TodoRepository(getIt<ApiService>()));
}