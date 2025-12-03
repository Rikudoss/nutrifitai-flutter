# NutriFit AI Flutter клиент

Клиент для backend-сервиса NutriFit AI (Spring Boot). Реализованы регистрация, логин, хранение JWT и вызов защищённого AI-эндпоинта для рекомендаций по питанию и тренировкам.

## Требования
- Flutter (SDK см. `pubspec.yaml`)
- Поддерживаемые платформы: Android, Web, Desktop

## Конфигурация
Базовый URL задаётся в `lib/core/config.dart` через константу `BASE_URL`.
- Android-эмулятор: `http://10.0.2.2:8080`
- Web/Desktop: `http://localhost:8080`
- Физическое устройство: укажите IP машины с backend (например, `http://192.168.x.x:8080`).
При необходимости просто поменяйте значение в этом файле. На Android добавлено разрешение `INTERNET` и включён cleartext-трафик, а на iOS — `NSAppTransportSecurity` c `NSAllowsArbitraryLoads`, чтобы локальный backend на http принимал запросы.

## Установка зависимостей
```
flutter pub get
```

## Запуск
Android:
```
flutter run -d emulator-5554
```
Web:
```
flutter run -d chrome
```
Desktop (если разрешено Flutter SDK):
```
flutter run -d windows # или macos/linux
```

## Структура
```
lib/
  core/            # config, работа с JWT хранилищем
  models/          # DTO: auth, nutrition
  services/        # dio-клиент и API слои
  providers/       # состояние авторизации и рекомендаций (Provider)
  screens/         # UI: auth, nutrition
  widgets/         # переиспользуемые UI-компоненты
```

## Основные сценарии
1. Регистрация/логин отправляют запросы `/api/auth/register` и `/api/auth/login`, сохраняют JWT в `SharedPreferences` и открывают форму AI.
2. Форма AI собирает `NutritionRequest` и вызывает `/api/ai/nutrition` с заголовком `Authorization: Bearer <token>`.
3. Ответ `NutritionResponse` отображается на экране результатов с макросами и рекомендациями.
4. При 401/403 токен сбрасывается и пользователь перенаправляется на экран логина.

## Темing
Светлая тема с зелёным акцентом по умолчанию задаётся в `lib/main.dart`.
