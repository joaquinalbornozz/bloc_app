import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/task_bloc.dart';
import '../../bloc/task_event.dart';
import '../../data/models/task_item.dart';

class TaskCard extends StatelessWidget {
  final TaskItem task;

  const TaskCard({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: Checkbox(
          value: task.isCompleted,
          onChanged: (_) {
            context.read<TaskBloc>().add(ToggleTask(task));
          },
        ),
        title: Text(
          task.title,
          style: TextStyle(
            decoration: task.isCompleted ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Text('Módulo: ${task.category.name.toUpperCase()}'),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline),
          tooltip: 'Eliminar de Supabase',
          onPressed: () {
            context.read<TaskBloc>().add(DeleteTask(task.id));
          },
        ),
      ),
    );
  }
}
