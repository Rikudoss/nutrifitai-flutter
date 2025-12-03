import 'package:flutter/material.dart';

import '../../models/nutrition_response.dart';
import '../../widgets/result_section.dart';

class NutritionResultScreen extends StatelessWidget {
  final NutritionResponse response;

  const NutritionResultScreen({super.key, required this.response});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ваши рекомендации')), // Navigation from result to form via back button
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Рекомендуемая норма: ${response.calories} ккал',
                        style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 12),
                    Text('Белки: ${response.macros.protein} г'),
                    Text('Жиры: ${response.macros.fats} г'),
                    Text('Углеводы: ${response.macros.carbs} г'),
                  ],
                ),
              ),
            ),
            ResultSection(title: 'Рекомендации по питанию', items: response.dietTips),
            ResultSection(title: 'План тренировок', items: response.workoutPlan),
            ResultSection(title: 'Добавить в рацион', items: response.addFoods),
            ResultSection(title: 'Уменьшить в рационе', items: response.reduceFoods),
            ResultSection(title: 'Типичные ошибки', items: response.commonMistakes),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Назад'),
            ),
          ],
        ),
      ),
    );
  }
}
