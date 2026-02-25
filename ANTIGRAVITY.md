# Voice Chef (Smart Chef AI Assistant) - Project Context & Rules

## 📱 О проекте
Voice Chef — это мобильное приложение на Flutter для кулинаров, главной фичей которого является голосовое управление. Пользователь может переключать шаги рецепта, добавлять в избранное, менять тему и осуществлять навигацию с помощью естественных голосовых команд.

## 🛠 Технологический стек
* **Фреймворк:** Flutter (Dart 3+)
* **Архитектура:** Layered Clean Architecture (Presentation, Domain, Data)
* **Управление состоянием:**
    * `flutter_bloc` (BLoC) — для сложной бизнес-логики (Рецепты, Голосовое управление). Используется `bloc_concurrency` (sequential) для избежания гонок.
    * `provider` (ChangeNotifier) — для простых глобальных настроек (ThemeProvider).
* **Роутинг:** `auto_route` (^10.2.0)
* **Локальное хранилище:**
    * `drift` (SQLite) — для кэширования избранных рецептов и данных.
    * `shared_preferences` — для простых настроек (тема приложения).
* **Voice & AI:**
    * `speech_to_text` — преобразование голоса в текст (VoiceService).
    * **GigaChat API** (Sber) — классификация намерений (Intent Classification) (AiService). Используется SDK `gigachat_dart`.
    * **SSL Fix:** В `main.dart` используется `HttpOverrides` для обхода проверки сертификатов Минцифры при запросах к GigaChat.

## 🏗 Текущая архитектура и компоненты

### 1. Навигация и UI (Shell)
* Реализована через `AutoTabsRouter` (MainNavigationPage).
* **Механика FAB:** Активация записи по `LongPressStart`, остановка по `LongPressEnd`.
* **Визуальный фидбек:** Иконка микрофона краснеет при записи, SnackBar показывает транскрипцию в процессе обработки.

### 2. Рецепты (Recipe Feature)
* **Domain:** `Recipe`, `RecipeStep`, `RecipeRepository`.
* **Data:**
    * `MockRecipeDataSource` — генерация начальных данных.
    * `DriftRecipeDataSource` — работа с SQLite через `drift`.
* **Presentation:** `RecipeBloc` управляет списком рецептов и их состоянием.

### 3. Голосовое управление (Voice Control Flow)
* **VoiceControlBloc:** Оркестратор процесса.
    * **Синхронизация:** При остановке записи (`StopListeningEvent`) BLoC входит в цикл ожидания флага `isFinal` от STT. Для предотвращения блокировки очереди событий, переменная `_currentTranscription` обновляется напрямую в callback-функции `onResult`.
* **AiService:** Отправляет текст в GigaChat с системным промптом, требующим JSON. Содержит robust-парсер JSON для очистки ответа от Markdown-тегов или вводных слов модели.
* **Исполнение:** Глобальные слушатели в `MainNavigationPage` и локальные в `RecipeStepView` реагируют на `VoiceCommandRecognized`.

## 📜 Правила разработки (AI Guidelines)
1.  **SSL Overrides:** Никогда не удаляйте `HttpOverrides.global` из `main.dart`, иначе GigaChat перестанет работать на Android.
2.  **STT Sync:** Помните, что `_currentTranscription` в BLoC обновляется напрямую через callback для корректной работы цикла ожидания финального результата.
3.  **JSON Handling:** GigaChat может иногда ошибаться в формате (добавлять текст вокруг JSON). Используйте `cleanedJson` логику в `AiService`.
4.  **Кодогенерация:** При изменении роутов (`AppRouter`) или базы данных (`Drift`), запускайте `fvm flutter pub run build_runner build --delete-conflicting-outputs`.

## 🚀 Ближайшие задачи (Next Steps)
1. [x] Перевод на бесплатную модель GigaChat.
2. [x] Исправление SSL Handshake для российских API.
3. [x] Решение проблемы "обрезанных" команд через `isFinal` и callback-синхронизацию.
4. [ ] Доработка управления шагами рецепта (навигация внутри `RecipeStepView` по командам "следующий", "предыдущий").
5. [ ] Добавление визуального индикатора громкости голоса на кнопке FAB.