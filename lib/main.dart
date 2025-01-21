import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/app/app_bloc.dart';
import 'core/di/injection.dart';
import 'presentation/screens/home.dart';

import 'bloc/todo/todo_bloc.dart';
import 'data/repositories/todo_repository.dart';





void main() {
  setup();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AppBloc()),   // AppBloc 등록
        BlocProvider(create: (_) => TodoBloc(getIt<TodoRepository>())),
      ],
      child: MaterialApp(
        title: 'Flutter BLoC App',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: HomeScreen(),
      ),
    );
  }
}
