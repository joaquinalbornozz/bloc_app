import 'package:equatable/equatable.dart';

import '../data/models/task_item.dart';
import 'task_event.dart';

enum TaskStatus { initial, loading, success, failure }

class TaskState extends Equatable {
  final TaskStatus status;
  final List<TaskItem> tasks;
  final TaskFilter filter;
  final String? feedbackMessage;
  final String? errorMessage;

  const TaskState({
    this.status = TaskStatus.initial,
    this.tasks = const [],
    this.filter = TaskFilter.all,
    this.feedbackMessage,
    this.errorMessage,
  });

  List<TaskItem> get filteredTasks {
    switch (filter) {
      case TaskFilter.all:
        return tasks;
      case TaskFilter.pending:
        return tasks.where((t) => !t.isCompleted).toList();
      case TaskFilter.completed:
        return tasks.where((t) => t.isCompleted).toList();
    }
  }

  int get completedCount => tasks.where((t) => t.isCompleted).length;
  int get pendingCount => tasks.where((t) => !t.isCompleted).length;

  TaskState copyWith({
    TaskStatus? status,
    List<TaskItem>? tasks,
    TaskFilter? filter,
    String? feedbackMessage,
    String? errorMessage,
    bool clearFeedback = false,
    bool clearError = false,
  }) {
    return TaskState(
      status: status ?? this.status,
      tasks: tasks ?? this.tasks,
      filter: filter ?? this.filter,
      feedbackMessage: clearFeedback
          ? null
          : (feedbackMessage ?? this.feedbackMessage),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [
    status,
    tasks,
    filter,
    feedbackMessage,
    errorMessage,
  ];
}
