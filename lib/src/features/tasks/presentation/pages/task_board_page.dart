import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../theme/cubit/theme_cubit.dart';
import '../../bloc/task_bloc.dart';
import '../../bloc/task_event.dart';
import '../../bloc/task_state.dart';
import '../../data/models/task_item.dart';
import '../widgets/filter_chips_bar.dart';
import '../widgets/metrics_header.dart';
import '../widgets/task_card.dart';

class TaskBoardPage extends StatelessWidget {
  const TaskBoardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tareas BLoC'),
        actions: [
          IconButton(
            tooltip: 'Simular error RLS (probar BlocListener)',
            icon: const Icon(Icons.bug_report_outlined),
            onPressed: () {
              context.read<TaskBloc>().add(const SimulateError());
            },
          ),
          IconButton(
            tooltip: 'Sincronizar con Supabase',
            icon: const Icon(Icons.cloud_sync_outlined),
            onPressed: () {
              context.read<TaskBloc>().add(const LoadTasks());
            },
          ),
          IconButton(
            tooltip: 'Alternar tema (ThemeCubit)',
            icon: const Icon(Icons.brightness_6_outlined),
            onPressed: () {
              context.read<ThemeCubit>().toggleTheme();
            },
          ),
        ],
      ),
      body: BlocConsumer<TaskBloc, TaskState>(
        listenWhen: (previous, current) =>
            previous.feedbackMessage != current.feedbackMessage ||
            previous.errorMessage != current.errorMessage,
        listener: (context, state) {
          final messenger = ScaffoldMessenger.of(context);
          if (state.errorMessage != null) {
            messenger
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage!),
                  backgroundColor: Colors.redAccent,
                  behavior: SnackBarBehavior.floating,
                ),
              );
          } else if (state.feedbackMessage != null) {
            messenger
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(state.feedbackMessage!),
                  behavior: SnackBarBehavior.floating,
                  duration: const Duration(seconds: 2),
                ),
              );
          }
        },
        builder: (context, state) {
          if (state.status == TaskStatus.loading && state.tasks.isEmpty) {
            return const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Consultando tabla public.tasks en Supabase...'),
                ],
              ),
            );
          }

          return Column(
            children: [
              MetricsHeader(
                total: state.tasks.length,
                pending: state.pendingCount,
                completed: state.completedCount,
              ),
              FilterChipsBar(activeFilter: state.filter),
              const Divider(height: 1),
              Expanded(
                child: state.filteredTasks.isEmpty
                    ? const Center(
                        child: Text(
                          'No hay tareas para el filtro seleccionado.',
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        itemCount: state.filteredTasks.length,
                        itemBuilder: (context, index) {
                          final task = state.filteredTasks[index];
                          return TaskCard(task: task);
                        },
                      ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddTaskDialog(context),
        icon: const Icon(Icons.add),
        label: const Text('Nueva Tarea'),
      ),
    );
  }

  void _showAddTaskDialog(BuildContext parentContext) {
    final controller = TextEditingController();
    TaskCategory selectedCategory = TaskCategory.arquitectura;

    showDialog<void>(
      context: parentContext,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Insertar Tarea en Supabase'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: controller,
                    autofocus: true,
                    decoration: const InputDecoration(
                      labelText: 'Descripción de la tarea',
                      hintText: 'Ej. Configurar políticas RLS en Supabase',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<TaskCategory>(
                    initialValue: selectedCategory,
                    decoration: const InputDecoration(
                      labelText: 'Categoría del módulo',
                      border: OutlineInputBorder(),
                    ),
                    items: TaskCategory.values.map((cat) {
                      return DropdownMenuItem(
                        value: cat,
                        child: Text(cat.name.toUpperCase()),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setDialogState(() => selectedCategory = value);
                      }
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: const Text('Cancelar'),
                ),
                FilledButton(
                  onPressed: () {
                    parentContext.read<TaskBloc>().add(
                      AddTask(
                        title: controller.text,
                        category: selectedCategory,
                      ),
                    );
                    Navigator.of(dialogContext).pop();
                  },
                  child: const Text('Guardar en Supabase'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
