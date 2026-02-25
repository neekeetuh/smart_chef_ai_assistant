import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:smart_chef_ai_assistant/src/core/database/app_database.dart';
import 'package:smart_chef_ai_assistant/src/core/navigation/app_router.dart';
import 'package:smart_chef_ai_assistant/src/core/providers/theme_provider.dart';
import 'package:smart_chef_ai_assistant/src/core/services/ai_service.dart';
import 'package:smart_chef_ai_assistant/src/core/services/voice_service.dart';
import 'package:smart_chef_ai_assistant/src/core/theme/app_theme.dart';
import 'package:smart_chef_ai_assistant/src/core/theme/data/theme_data_source.dart';
import 'package:smart_chef_ai_assistant/src/features/recipes/data/data_sources/drift_recipe_data_source.dart';
import 'package:smart_chef_ai_assistant/src/features/recipes/data/data_sources/mock_recipe_data_source.dart';
import 'package:smart_chef_ai_assistant/src/features/recipes/data/repositories/recipe_repository.dart';
import 'package:smart_chef_ai_assistant/src/features/recipes/presentation/bloc/recipe_bloc.dart';
import 'package:smart_chef_ai_assistant/src/features/voice_control/presentation/bloc/voice_control_bloc.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() async {
  HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  // Инициализация источников данных
  final mockDataSource = MockRecipeDataSource();

  final appDb = AppDatabase();
  final driftDataSource = DriftRecipeDataSource(appDb);

  // Инициализация сервисов для голоса
  final voiceService = VoiceService();
  final aiService = AiService();

  // Обеспечиваем пред-инициализацию микрофона
  await voiceService.isReady;

  // Создаем экземпляр роутера
  final appRouter = AppRouter();

  runApp(
    MyApp(
      mockDataSource: mockDataSource,
      driftDataSource: driftDataSource,
      voiceService: voiceService,
      aiService: aiService,
      appRouter: appRouter,
    ),
  );
}

class MyApp extends StatelessWidget {
  final MockRecipeDataSource mockDataSource;
  final DriftRecipeDataSource driftDataSource;
  final VoiceService voiceService;
  final AiService aiService;
  final AppRouter appRouter;

  const MyApp({
    super.key,
    required this.mockDataSource,
    required this.driftDataSource,
    required this.voiceService,
    required this.aiService,
    required this.appRouter,
  });

  @override
  Widget build(BuildContext context) {
    final themeDataSource = ThemeDataSource();

    return MultiProvider(
      providers: [
        // Провайдер для темы
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(themeDataSource: themeDataSource),
        ),
      ],
      child: MultiRepositoryProvider(
        providers: [
          // 2. Предоставление Репозитория
          RepositoryProvider<RecipeRepository>(
            create: (context) => RecipeRepository(
              mockDataSource: mockDataSource,
              driftDataSource: driftDataSource,
            ),
          ),
        ],
        child: MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) =>
                  RecipeBloc(
                    // Получаем Репозиторий, используя context.read
                    repository: context.read<RecipeRepository>(),
                  )..add(
                    const FetchRecipesEvent(),
                  ), // Запускаем загрузку данных при создании
            ),
            BlocProvider(
              create: (context) => VoiceControlBloc(
                voiceService: voiceService,
                aiService: aiService,
              ),
            ),
          ],
          child: Consumer<ThemeProvider>(
            builder: (context, themeProvider, child) {
              return MaterialApp.router(
                title: 'Voice Chef',
                theme: AppTheme.lightTheme,
                darkTheme: AppTheme.darkTheme,
                themeMode: themeProvider.themeMode, // Управляется провайдером
                routerConfig: appRouter.config(),
              );
            },
          ),
        ),
      ),
    );
  }
}
