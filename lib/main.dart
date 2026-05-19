import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:smart_chef_ai_assistant/src/core/database/app_database.dart';
import 'package:smart_chef_ai_assistant/src/core/navigation/app_router.dart';
import 'package:smart_chef_ai_assistant/src/core/providers/view_mode_provider.dart';
import 'package:smart_chef_ai_assistant/src/core/providers/theme_provider.dart';
import 'package:smart_chef_ai_assistant/src/core/services/ai_classification_service.dart';
import 'package:smart_chef_ai_assistant/src/core/services/on_device_classification_service.dart';
import 'package:smart_chef_ai_assistant/src/core/services/smart_classification_service.dart';
import 'package:smart_chef_ai_assistant/src/core/services/voice_service.dart';
import 'package:smart_chef_ai_assistant/src/core/services/tts_service.dart';
import 'package:smart_chef_ai_assistant/src/features/recipe_generator/data/services/ai_recipe_generator_service.dart';
import 'package:smart_chef_ai_assistant/src/core/theme/app_theme.dart';
import 'package:smart_chef_ai_assistant/src/core/theme/data/theme_data_source.dart';
import 'package:smart_chef_ai_assistant/src/features/recipes/data/data_sources/drift_recipe_data_source.dart';
import 'package:smart_chef_ai_assistant/src/features/recipes/data/data_sources/mock_recipe_data_source.dart';
import 'package:smart_chef_ai_assistant/src/features/recipes/data/repositories/recipe_repository.dart';
import 'package:smart_chef_ai_assistant/src/features/recipes/presentation/bloc/recipe_bloc.dart';
import 'package:smart_chef_ai_assistant/src/features/voice_control/presentation/bloc/voice_control_bloc.dart';
import 'package:smart_chef_ai_assistant/src/features/recipes/domain/repositories/recipe_repository_interface.dart';

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
  final database = AppDatabase();
  final driftDataSource = DriftRecipeDataSource(database);

  // Инициализация репозитория
  final recipeRepository = RecipeRepository(
    mockDataSource: mockDataSource,
    driftDataSource: driftDataSource,
  );

  // Инициализация сервисов для голоса
  final voiceService = VoiceService();
  final llmService = AiClassificationService();
  final onDeviceService = OnDeviceClassificationService();
  final aiService = SmartClassificationService(
    llmService: llmService,
    onDeviceService: onDeviceService,
  );
  final ttsService = TtsService();
  // Обеспечиваем пред-инициализацию микрофона
  await voiceService.isReady;
  
  final aiRecipeGeneratorService = AiRecipeGeneratorService();

  runApp(
    MyApp(
      voiceService: voiceService,
      aiService: aiService,
      ttsService: ttsService,
      recipeRepository: recipeRepository,
      database: database,
      generatorService: aiRecipeGeneratorService,
    ),
  );
}

class MyApp extends StatefulWidget {
  final VoiceService voiceService;
  final SmartClassificationService aiService;
  final TtsService ttsService;
  final RecipeRepository recipeRepository;
  final AppDatabase database;
  final AiRecipeGeneratorService generatorService;

  const MyApp({
    super.key,
    required this.voiceService,
    required this.aiService,
    required this.ttsService,
    required this.recipeRepository,
    required this.database,
    required this.generatorService,
  });

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final AppRouter _appRouter;

  @override
  void initState() {
    super.initState();
    _appRouter = AppRouter();
  }

  @override
  Widget build(BuildContext context) {
    final themeDataSource = ThemeDataSource();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(themeDataSource: themeDataSource),
        ),
        ChangeNotifierProvider(
          create: (_) => ViewModeProvider(),
        ),
        ChangeNotifierProvider<SmartClassificationService>.value(
          value: widget.aiService,
        ),
        Provider<AppDatabase>.value(value: widget.database),
      ],
      child: MultiRepositoryProvider(
        providers: [
          RepositoryProvider<RecipeRepositoryInterface>.value(
            value: widget.recipeRepository,
          ),
          RepositoryProvider<RecipeRepository>(
            create: (_) => widget.recipeRepository,
          ),
          RepositoryProvider<AiRecipeGeneratorService>.value(
            value: widget.generatorService,
          ),
          RepositoryProvider<TtsService>.value(value: widget.ttsService),
        ],
        child: MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) =>
                  RecipeBloc(repository: widget.recipeRepository)
                    ..add(const FetchRecipesEvent()),
            ),
            BlocProvider(
              create: (context) => VoiceControlBloc(
                voiceService: widget.voiceService,
                aiService: widget.aiService,
                ttsService: widget.ttsService,
                recipeRepository: context.read<RecipeRepository>(),
                appRouter: _appRouter,
              ),
            ),
          ],
          child: Consumer<ThemeProvider>(
            builder: (context, themeProvider, child) {
              return MaterialApp.router(
                debugShowCheckedModeBanner: false,
                title: 'Smart Chef AI',
                theme: AppTheme.lightTheme,
                darkTheme: AppTheme.darkTheme,
                themeMode: themeProvider.themeMode,
                routerConfig: _appRouter.config(),
              );
            },
          ),
        ),
      ),
    );
  }
}
