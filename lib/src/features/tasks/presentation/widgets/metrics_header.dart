import 'package:flutter/material.dart';

class MetricsHeader extends StatelessWidget {
  final int total;
  final int pending;
  final int completed;

  const MetricsHeader({
    super.key,
    required this.total,
    required this.pending,
    required this.completed,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer.withValues(alpha: .45),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _StatBadge(label: 'Total', count: total),
          _StatBadge(label: 'Pendientes', count: pending),
          _StatBadge(label: 'Completadas', count: completed),
        ],
      ),
    );
  }
}

class _StatBadge extends StatelessWidget {
  final String label;
  final int count;

  const _StatBadge({required this.label, required this.count});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '$count',
          style: Theme.of(context).textTheme.headlineSmall
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}
