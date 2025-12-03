import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../models/nutrition_request.dart';
import '../models/nutrition_response.dart';
import '../services/ai_service.dart';
import 'auth_provider.dart';

/// Provider responsible for calling the AI endpoint and holding the last result.
class NutritionProvider extends ChangeNotifier {
  final AiService _aiService;
  final AuthProvider _authProvider;

  NutritionResponse? _latestResponse;
  bool _isLoading = false;

  NutritionProvider(this._aiService, this._authProvider);

  NutritionResponse? get latestResponse => _latestResponse;
  bool get isLoading => _isLoading;

  Future<void> fetchNutrition(NutritionRequest request) async {
    _isLoading = true;
    notifyListeners();
    try {
      _latestResponse = await _aiService.getNutritionAdvice(request);
    } on DioException catch (e) {
      final statusCode = e.response?.statusCode ?? 0;
      if (statusCode == 401 || statusCode == 403) {
        await _authProvider.logout();
        throw 'Сессия истекла, войдите снова';
      }
      throw e.response?.data?['message'] ?? 'Не удалось получить рекомендации';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
