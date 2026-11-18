import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../data/repositories/task_repository.dart';
import 'task_event.dart';
import 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final TaskRepository _repository;

  TaskBloc({required this._repository}) : super(const TaskState()) {
    on<LoadTasks>(_onLoadTasks);
    on<AddTask>(_onAddTask);
    on<ToggleTask>(_onToggleTask);
    on<DeleteTask>(_onDeleteTask);
    on<ChangeFilter>(_onChangeFilter);
    on<SimulateError>(_onSimulateError);
  }

  Future<void> _onLoadTasks(LoadTasks event, Emitter<TaskState> emit) async {
    emit(
      state.copyWith(
        status: TaskStatus.loading,
        clearError: true,
        clearFeedback: true,
      ),
    );

    try {
      final loadedTasks = await _repository.fetchTasks();
      emit(
        state.copyWith(
          status: TaskStatus.success,
          tasks: loadedTasks,
          feedbackMessage: 'Tareas sincronizadas con Supabase PostgreSQL',
        ),
      );
    } on PostgrestException catch (e) {
      emit(
        state.copyWith(
          status: TaskStatus.failure,
          errorMessage: 'Error de Supabase (${e.code}): ${e.message}',
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: TaskStatus.failure,
          errorMessage: 'No se pudo conectar a Supabase: $e',
        ),
      );
    }
  }

  Future<void> _onAddTask(AddTask event, Emitter<TaskState> emit) async {
    final cleanTitle = event.title.trim();
    if (cleanTitle.isEmpty) {
      emit(
        state.copyWith(
          status: TaskStatus.failure,
          errorMessage: 'El título de la tarea no puede estar vacío.',
        ),
      );
      return;
    }

    try {
      // Insertamos en Supabase y recibimos el registro con su UUID generado
      final createdTask = await _repository.createTask(
        title: cleanTitle,
        category: event.category,
      );

      final updatedList = [...state.tasks, createdTask];

      emit(
        state.copyWith(
          status: TaskStatus.success,
          tasks: updatedList,
          feedbackMessage: 'Guardada en Supabase: "${createdTask.title}"',
          clearError: true,
        ),
      );
    } on PostgrestException catch (e) {
      emit(
        state.copyWith(
          status: TaskStatus.failure,
          errorMessage: 'No se pudo insertar en Supabase: ${e.message}',
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: TaskStatus.failure,
          errorMessage: 'Error inesperado al crear la tarea: $e',
        ),
      );
    }
  }

  Future<void> _onToggleTask(ToggleTask event, Emitter<TaskState> emit) async {
    try {
      final updatedTask = await _repository.updateTaskCompletion(
        taskId: event.task.id,
        isCompleted: !event.task.isCompleted,
      );

      final updatedList = state.tasks.map((task) {
        return task.id == updatedTask.id ? updatedTask : task;
      }).toList();

      emit(
        state.copyWith(
          status: TaskStatus.success,
          tasks: updatedList,
          clearFeedback: true,
          clearError: true,
        ),
      );
    } on PostgrestException catch (e) {
      emit(
        state.copyWith(
          status: TaskStatus.failure,
          errorMessage: 'Error al actualizar tarea en Supabase: ${e.message}',
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: TaskStatus.failure,
          errorMessage: 'No se pudo actualizar la tarea: $e',
        ),
      );
    }
  }

  Future<void> _onDeleteTask(DeleteTask event, Emitter<TaskState> emit) async {
    try {
      await _repository.deleteTask(event.taskId);

      final updatedList = state.tasks
          .where((task) => task.id != event.taskId)
          .toList();

      emit(
        state.copyWith(
          status: TaskStatus.success,
          tasks: updatedList,
          feedbackMessage: 'Tarea eliminada de Supabase correctamente',
          clearError: true,
        ),
      );
    } on PostgrestException catch (e) {
      emit(
        state.copyWith(
          status: TaskStatus.failure,
          errorMessage: 'Error al eliminar en Supabase: ${e.message}',
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: TaskStatus.failure,
          errorMessage: 'No se pudo eliminar la tarea: $e',
        ),
      );
    }
  }

  void _onChangeFilter(ChangeFilter event, Emitter<TaskState> emit) {
    emit(
      state.copyWith(
        filter: event.filter,
        clearFeedback: true,
        clearError: true,
      ),
    );
  }

  void _onSimulateError(SimulateError event, Emitter<TaskState> emit) {
    emit(
      state.copyWith(
        status: TaskStatus.failure,
        errorMessage:
            'Error simulado: Fallo de permisos RLS en la tabla public.tasks.',
        clearFeedback: true,
      ),
    );
  }
}
