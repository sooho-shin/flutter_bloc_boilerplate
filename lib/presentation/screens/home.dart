import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// 기존 BLoC
import '../../bloc/app/app_bloc.dart';
import '../../bloc/app/app_event.dart';
import '../../bloc/app/app_state.dart';

// 새로 추가된 TodoBLoC
import '../../bloc/todo/todo_bloc.dart';
import '../../bloc/todo/todo_event.dart';
import '../../bloc/todo/todo_state.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 기존 AppBloc 이벤트 디스패치
    context.read<AppBloc>().add(const AppEvent.started());
    // 새 TodoBloc 이벤트 디스패치 (데이터 가져오기)
    context.read<TodoBloc>().add(const TodoEvent.fetchTodo());

    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Column(
        children: [
          // [1] 기존 AppBloc 상태 표시
          BlocBuilder<AppBloc, AppState>(
            builder: (context, state) {
              return state.maybeWhen(
                initial: () => const Center(child: CircularProgressIndicator()),
                load: () => const Center(child: Text('Welcome to BLoC!')),
                orElse: () => const SizedBox.shrink(),
              );
            },
          ),

          const Divider(),

          // [2] 새 TodoBloc 상태 표시
          BlocBuilder<TodoBloc, TodoState>(
            builder: (context, state) {
              return state.when(
                initial: () => const Center(child: CircularProgressIndicator()),
                loading: () => const Center(child: CircularProgressIndicator()),
                loaded: (todo) => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Title: ${todo.title}'),
                      Text('Completed: ${todo.completed ? "Yes" : "No"}'),
                    ],
                  ),
                ),
                error: (msg) => Center(child: Text('에러 발생: $msg')),
              );
            },
          ),
        ],
      ),
    );
  }
}