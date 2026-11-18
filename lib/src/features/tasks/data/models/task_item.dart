import 'package:equatable/equatable.dart';

enum TaskCategory {
  arquitectura,
  widgets,
  testing;

  static TaskCategory fromString(String value) {
    return TaskCategory.values.firstWhere(
      (e) => e.name.toLowerCase() == value.toLowerCase(),
      orElse: () => TaskCategory.arquitectura,
    );
  }
}

class TaskItem extends Equatable {
  final String id;
  final String title;
  final TaskCategory category;
  final bool isCompleted;

  const TaskItem({
    required this.id,
    required this.title,
    required this.category,
    this.isCompleted = false,
  });

  /// Convierte una fila JSON devuelta por PostgreSQL (Supabase) en una entidad `TaskItem`.
  factory TaskItem.fromJson(Map<String, dynamic> json) {
    return TaskItem(
      id: json['id'].toString(),
      title: (json['title'] as String?) ?? '',
      category: TaskCategory.fromString(
        (json['category'] as String?) ?? 'arquitectura',
      ),
      isCompleted: (json['is_completed'] as bool?) ?? false,
    );
  }

  /// Convierte la entidad a un mapa JSON para insertar/actualizar en la tabla `tasks`.
  Map<String, dynamic> toInsertJson() {
    return {
      'title': title,
      'category': category.name,
      'is_completed': isCompleted,
    };
  }

  TaskItem copyWith({
    String? id,
    String? title,
    TaskCategory? category,
    bool? isCompleted,
  }) {
    return TaskItem(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  @override
  List<Object?> get props => [id, title, category, isCompleted];
}
