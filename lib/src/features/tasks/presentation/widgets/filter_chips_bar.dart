import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/task_bloc.dart';
import '../../bloc/task_event.dart';

class FilterChipsBar extends StatelessWidget {
  final TaskFilter activeFilter;

  const FilterChipsBar({super.key, required this.activeFilter});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: SingleChildScrollView(
        scrollDirection: .horizontal,
        child: Row(
          children: [
            const Text('Filtro: '),
            const SizedBox(width: 8),
            Wrap(
              spacing: 8,
              children: [
                ChoiceChip(
                  label: const Text('Todas'),
                  selected: activeFilter == TaskFilter.all,
                  onSelected: (_) => context.read<TaskBloc>().add(
                    const ChangeFilter(TaskFilter.all),
                  ),
                ),
                ChoiceChip(
                  label: const Text('Pendientes'),
                  selected: activeFilter == TaskFilter.pending,
                  onSelected: (_) => context.read<TaskBloc>().add(
                    const ChangeFilter(TaskFilter.pending),
                  ),
                ),
                ChoiceChip(
                  label: const Text('Completadas'),
                  selected: activeFilter == TaskFilter.completed,
                  onSelected: (_) => context.read<TaskBloc>().add(
                    const ChangeFilter(TaskFilter.completed),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
