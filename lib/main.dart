// ============================================================================
// CLASE PRÁCTICA: MANEJO DE ESTADO EN FLUTTER CON BLOC + SUPABASE
// ============================================================================
//
// PASO 1: SCRIPT SQL PARA PEGAR EN EL "SQL EDITOR" DE SUPABASE
// Ejecutá este bloque en tu proyecto de Supabase (SQL Editor -> New Query):
/*
create table public.tasks (
  id uuid primary key default gen_random_uuid(),
  title text not null,
  category text not null default 'arquitectura',
  is_completed boolean not null default false,
  created_at timestamptz not null default now()
);

-- Habilitar Row Level Security (RLS) y crear política pública de práctica para la clase:
alter table public.tasks enable row level security;

create policy "Acceso publico para demo en clase"
  on public.tasks
  for all
  to anon, authenticated
  using (true)
  with check (true);

-- Datos iniciales de prueba:
insert into public.tasks (title, category, is_completed) values
  ('Comprender la diferencia entre Estado Efímero y de App', 'arquitectura', true),
  ('Modelar Eventos y Estados inmutables con Equatable', 'arquitectura', true),
  ('Conectar TaskRepository con Supabase PostgreSQL', 'arquitectura', false),
  ('Consumir estados con BlocBuilder y BlocListener', 'widgets', false),
  ('Escribir una prueba unitaria para TaskBloc con bloc_test', 'testing', false);
*/

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'src/app.dart';
import 'src/core/observers/app_bloc_observer.dart';
import 'src/features/tasks/bloc/task_bloc.dart';
import 'src/features/tasks/bloc/task_event.dart';
import 'src/features/tasks/data/repositories/task_repository.dart';
import 'src/features/theme/cubit/theme_cubit.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: '.env');

  await Supabase.initialize(
    url: dotenv.get('SUPABASE_URL'),
    publishableKey: dotenv.get('SUPABASE_PUBLISHABLE_KEY'),
  );

  // Registramos el observador global de BLoC para ver cada evento y cambio en consola
  Bloc.observer = const AppBlocObserver();

  // Inyectamos SupabaseClient dentro de nuestro TaskRepository
  final taskRepository = TaskRepository(
    supabaseClient: Supabase.instance.client,
  );

  runApp(
    RepositoryProvider.value(
      value: taskRepository,
      child: MultiBlocProvider(
        providers: [
          BlocProvider<ThemeCubit>(create: (_) => ThemeCubit()),
          BlocProvider<TaskBloc>(
            create: (context) =>
                TaskBloc(repository: context.read<TaskRepository>())..add(
                  const LoadTasks(),
                ), // Carga inicial desde Supabase al arrancar
          ),
        ],
        child: const BlocApp(),
      ),
    ),
  );
}
