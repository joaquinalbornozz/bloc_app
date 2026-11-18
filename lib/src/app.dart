import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'features/tasks/presentation/pages/task_board_page.dart';
import 'features/theme/cubit/theme_cubit.dart';

class BlocApp extends StatelessWidget {
  const BlocApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, themeMode) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Demo Clase Flutter BLoC + Supabase',
          themeMode: themeMode,
          theme: ThemeData(
            useMaterial3: true,
            colorSchemeSeed: const Color(0xFF0284C7),
            brightness: Brightness.light,
          ),
          darkTheme: ThemeData(
            useMaterial3: true,
            colorSchemeSeed: const Color(0xFF38BDF8),
            brightness: Brightness.dark,
          ),
          home: const TaskBoardPage(),
        );
      },
    );
  }
}
