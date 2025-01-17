import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/app_bloc.dart';
import '../../core/di/injection.dart';
import '../../bloc/app_event.dart';
import '../../bloc/app_state.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // AppStarted 이벤트 디스패치
    context.read<AppBloc>().add(const AppEvent.started());

    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: BlocBuilder<AppBloc, AppState>(
        builder: (context, state) {
          // maybeWhen을 사용하여 상태를 처리
          return state.maybeWhen(
            initial: () => const Center(child: CircularProgressIndicator()),
            load: () => const Center(child: Text('Welcome to BLoC!')),
            orElse: () => const SizedBox.shrink(),
          );
        },
      ),
    );
  }
}