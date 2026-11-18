import 'package:equatable/equatable.dart';

import '../data/models/task_item.dart';

enum TaskFilter { all, pending, completed }

sealed class TaskEvent extends Equatable {
  const TaskEvent();

  @override
  List<Object?> get props => [];
}

final class LoadTasks extends TaskEvent {
  const LoadTasks();
}

final class AddTask extends TaskEvent {
  final String title;
  final TaskCategory category;

  const AddTask({required this.title, required this.category});

  @override
  List<Object?> get props => [title, category];
}

final class ToggleTask extends TaskEvent {
  final TaskItem task;

  const ToggleTask(this.task);

  @override
  List<Object?> get props => [task];
}

final class DeleteTask extends TaskEvent {
  final String taskId;

  const DeleteTask(this.taskId);

  @override
  List<Object?> get props => [taskId];
}

final class ChangeFilter extends TaskEvent {
  final TaskFilter filter;

  const ChangeFilter(this.filter);

  @override
  List<Object?> get props => [filter];
}

final class SimulateError extends TaskEvent {
  const SimulateError();
}
