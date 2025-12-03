import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/token_storage.dart';
import 'providers/auth_provider.dart';
import 'providers/nutrition_provider.dart';
import 'screens/auth/login_screen.dart';
import 'screens/nutrition/nutrition_form_screen.dart';
import 'services/ai_service.dart';
import 'services/api_client.dart';
import 'services/auth_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  final tokenStorage = TokenStorage();
  final apiClient = ApiClient(tokenStorage);
  final authService = AuthService(apiClient);
  final aiService = AiService(apiClient);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(authService, tokenStorage)..loadToken(),
        ),
        ChangeNotifierProvider(
          create: (context) => NutritionProvider(aiService, context.read<AuthProvider>()),
        ),
      ],
      child: const NutriFitApp(),
    ),
  );
}

class NutriFitApp extends StatelessWidget {
  const NutriFitApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'NutriFit AI',
      theme: ThemeData(
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: Colors.grey[50],
        appBarTheme: const AppBarTheme(centerTitle: true),
        inputDecorationTheme: const InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
        ),
      ),
      home: const _Bootstrapper(),
      routes: {
        '/login': (_) => const LoginScreen(),
        '/form': (_) => const NutritionFormScreen(),
      },
    );
  }
}

/// Decides whether to show auth screens or the form based on token presence.
class _Bootstrapper extends StatelessWidget {
  const _Bootstrapper();

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, auth, _) {
        if (!auth.isInitialized) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (auth.isAuthenticated) {
          return const NutritionFormScreen();
        }
        return const LoginScreen();
      },
    );
  }
}
