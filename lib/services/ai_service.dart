import '../models/nutrition_request.dart';
import '../models/nutrition_response.dart';
import 'api_client.dart';

/// Wraps calls to the protected AI nutrition endpoint.
class AiService {
  final ApiClient apiClient;

  AiService(this.apiClient);

  Future<NutritionResponse> getNutritionAdvice(NutritionRequest request) async {
    final response = await apiClient.client.post(
      '/api/ai/nutrition',
      data: request.toJson(), // Body sent to the backend
    );
    // Convert JSON map into our Dart model.
    return NutritionResponse.fromJson(response.data as Map<String, dynamic>);
  }
}
