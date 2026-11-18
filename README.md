# bloc_app

## Estructura del proyecto
lib/
├── main.dart                                           # Inicializa Supabase, AppBlocObserver y runApp()
└── src/
    ├── app.dart                                        # RepositoryProvider, MultiBlocProvider y MaterialApp
    ├── core/
    │   ├── config/
    │   │   └── supabase_config.dart                    # Constantes SUPABASE_URL y SUPABASE_ANON_KEY
    │   └── observers/
    │       └── app_bloc_observer.dart                  # Logs globales de eventos, estados y errores
    └── features/
        ├── theme/
        │   └── cubit/
        │       └── theme_cubit.dart
        └── tasks/
            ├── data/
            │   ├── models/
            │   │   └── task_item.dart                  # Entidad con Equatable, fromJson y copyWith
            │   └── repositories/
            │       └── task_repository.dart            # Consultas Supabase 
            ├── bloc/
            │   ├── task_bloc.dart                      # Handlers async y captura de PostgrestException
            │   ├── task_event.dart                     # Eventos sealed
            │   └── task_state.dart                     # Estado inmutable y getters 
            └── presentation/
                ├── pages/
                │   └── task_board_page.dart
                └── widgets/
                    ├── filter_chips_bar.dart
                    ├── metrics_header.dart
                    └── task_card.dart
