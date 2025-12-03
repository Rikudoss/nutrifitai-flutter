/// Request body for the AI nutrition endpoint.
class NutritionRequest {
  final int age;
  final double weight;
  final double height;
  final String gender; // "male" or "female"
  final String goal; // "gain" / "lose" / "maintain"
  final String activity; // "low" / "medium" / "high"

  NutritionRequest({
    required this.age,
    required this.weight,
    required this.height,
    required this.gender,
    required this.goal,
    required this.activity,
  });

  Map<String, dynamic> toJson() {
    // Build the JSON body sent to the backend.
    return {
      'age': age,
      'weight': weight,
      'height': height,
      'gender': gender,
      'goal': goal,
      'activity': activity,
    };
  }
}
