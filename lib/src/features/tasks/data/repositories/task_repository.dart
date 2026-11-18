import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/task_item.dart';

/// Repositorio conectado a la tabla `public.tasks` en Supabase.
/// Encapsula todas las consultas PostgREST.
class TaskRepository {
  final SupabaseClient _supabase;
  static const String _tableName = 'tasks';

  const TaskRepository({required SupabaseClient supabaseClient})
    : _supabase = supabaseClient;

  /// Obtiene todas las tareas ordenadas por fecha de creación (`SELECT * FROM tasks`).
  Future<List<TaskItem>> fetchTasks() async {
    final List<Map<String, dynamic>> data = await _supabase
        .from(_tableName)
        .select()
        .order('created_at', ascending: true);

    return data.map(TaskItem.fromJson).toList();
  }

  /// Inserta una nueva tarea en Supabase y devuelve la fila creada con su `uuid` real.
  Future<TaskItem> createTask({
    required String title,
    required TaskCategory category,
  }) async {
    final Map<String, dynamic> insertedRow = await _supabase
        .from(_tableName)
        .insert({
          'title': title,
          'category': category.name,
          'is_completed': false,
        })
        .select()
        .single();

    return TaskItem.fromJson(insertedRow);
  }

  /// Actualiza la columna `is_completed` en Supabase (`UPDATE tasks SET is_completed = ...`).
  Future<TaskItem> updateTaskCompletion({
    required String taskId,
    required bool isCompleted,
  }) async {
    final Map<String, dynamic> updatedRow = await _supabase
        .from(_tableName)
        .update({'is_completed': isCompleted})
        .eq('id', taskId)
        .select()
        .single();

    return TaskItem.fromJson(updatedRow);
  }

  /// Elimina la fila en Supabase (`DELETE FROM tasks WHERE id = ...`).
  Future<void> deleteTask(String taskId) async {
    await _supabase.from(_tableName).delete().eq('id', taskId);
  }
}
