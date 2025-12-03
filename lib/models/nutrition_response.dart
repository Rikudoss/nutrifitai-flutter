/// Macro nutrients returned from the AI endpoint.
class Macros {
  final int protein;
  final int fats;
  final int carbs;

  Macros({required this.protein, required this.fats, required this.carbs});

  factory Macros.fromJson(Map<String, dynamic> json) {
    return Macros(
      protein: json['protein'] as int,
      fats: json['fats'] as int,
      carbs: json['carbs'] as int,
    );
  }
}

/// Full nutrition response.
class NutritionResponse {
  final int calories;
  final Macros macros;
  final List<String> dietTips;
  final List<String> workoutPlan;
  final List<String> addFoods;
  final List<String> reduceFoods;
  final List<String> commonMistakes;

  NutritionResponse({
    required this.calories,
    required this.macros,
    required this.dietTips,
    required this.workoutPlan,
    required this.addFoods,
    required this.reduceFoods,
    required this.commonMistakes,
  });

  factory NutritionResponse.fromJson(Map<String, dynamic> json) {
    // Parse nested macros and various recommendation lists.
    return NutritionResponse(
      calories: (json['calories'] as num).toInt(),
      macros: Macros.fromJson(json['macros'] as Map<String, dynamic>),
      dietTips: List<String>.from(json['dietTips'] ?? []),
      workoutPlan: List<String>.from(json['workoutPlan'] ?? []),
      addFoods: List<String>.from(json['addFoods'] ?? []),
      reduceFoods: List<String>.from(json['reduceFoods'] ?? []),
      commonMistakes: List<String>.from(json['commonMistakes'] ?? []),
    );
  }
}
