import 'package:flutter_bloc/flutter_bloc.dart';
import 'todo_event.dart';
import 'todo_state.dart';
import '../../data/repositories/todo_repository.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final TodoRepository todoRepository;

  TodoBloc(this.todoRepository) : super(const TodoState.initial()) {
    on<FetchTodo>((event, emit) async {
      emit(const TodoState.loading());
      try {
        final todo = await todoRepository.fetchTodo();
        emit(TodoState.loaded(todo));
      } catch (e) {
        emit(TodoState.error(e.toString()));
      }
    });
  }
}