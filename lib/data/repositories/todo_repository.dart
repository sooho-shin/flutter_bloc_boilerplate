import '../../core/services/api_service.dart';
import '../models/todo_model.dart';

class TodoRepository {
  final ApiService apiService;

  TodoRepository(this.apiService);

  Future<TodoModel> fetchTodo() async {
    // JSONPlaceholder API
    final data = await apiService.fetchData('https://jsonplaceholder.typicode.com/todos/1');
    return TodoModel.fromJson(data);
  }
}