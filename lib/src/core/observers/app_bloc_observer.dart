import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppBlocObserver extends BlocObserver {
  const AppBlocObserver();

  @override
  void onEvent(Bloc<dynamic, dynamic> bloc, Object? event) {
    super.onEvent(bloc, event);
    debugPrint('[EVENTO] ${bloc.runtimeType} -> $event');
  }

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    debugPrint('[CAMBIO] ${bloc.runtimeType}: ${change.nextStateSummary}');
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    debugPrint('[ERROR] ${bloc.runtimeType}: $error');
    super.onError(bloc, error, stackTrace);
  }
}

extension _ChangeSummary on Change<dynamic> {
  String get nextStateSummary =>
      'actual=${currentState.runtimeType} -> nuevo=$nextState';
}
