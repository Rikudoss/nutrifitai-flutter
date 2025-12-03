import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/nutrition_request.dart';
import '../../providers/auth_provider.dart';
import '../../providers/nutrition_provider.dart';
import '../../widgets/input_field.dart';
import '../../widgets/primary_button.dart';
import 'nutrition_result_screen.dart';

class NutritionFormScreen extends StatefulWidget {
  const NutritionFormScreen({super.key});

  @override
  State<NutritionFormScreen> createState() => _NutritionFormScreenState();
}

class _NutritionFormScreenState extends State<NutritionFormScreen> {
  final _ageController = TextEditingController();
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  String _gender = 'male';
  String _goal = 'maintain';
  String _activity = 'medium';

  @override
  void dispose() {
    _ageController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final authProvider = context.read<AuthProvider>();
    if (!authProvider.isAuthenticated) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Сессия истекла, войдите снова')),
        );
        Navigator.pushReplacementNamed(context, '/login');
      }
      return;
    }

    final age = int.tryParse(_ageController.text);
    final weight = double.tryParse(_weightController.text);
    final height = double.tryParse(_heightController.text);

    if (age == null || weight == null || height == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Введите корректные числа')),
      );
      return;
    }

    final request = NutritionRequest(
      age: age,
      weight: weight,
      height: height,
      gender: _gender,
      goal: _goal,
      activity: _activity,
    );

    final nutritionProvider = context.read<NutritionProvider>();

    try {
      await nutritionProvider.fetchNutrition(request);
      if (mounted && nutritionProvider.latestResponse != null) {
        // Navigate to the result screen with the latest response.
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => NutritionResultScreen(response: nutritionProvider.latestResponse!),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  Widget _buildDropdown({
    required String label,
    required String value,
    required List<DropdownMenuItem<String>> items,
    required void Function(String?) onChanged,
  }) {
    return InputDecorator(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          items: items,
          onChanged: onChanged,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final nutritionProvider = context.watch<NutritionProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('NutriFit AI'),
        actions: [
          IconButton(
            onPressed: () async {
              await context.read<AuthProvider>().logout();
              if (mounted) {
                Navigator.pushReplacementNamed(context, '/login');
              }
            },
            icon: const Icon(Icons.logout),
            tooltip: 'Выйти',
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(child: InputField(label: 'Возраст', controller: _ageController, keyboardType: TextInputType.number)),
                const SizedBox(width: 16),
                Expanded(child: InputField(label: 'Вес (кг)', controller: _weightController, keyboardType: TextInputType.number)),
              ],
            ),
            const SizedBox(height: 16),
            InputField(label: 'Рост (см)', controller: _heightController, keyboardType: TextInputType.number),
            const SizedBox(height: 16),
            _buildDropdown(
              label: 'Пол',
              value: _gender,
              items: const [
                DropdownMenuItem(value: 'male', child: Text('Мужской')),
                DropdownMenuItem(value: 'female', child: Text('Женский')),
              ],
              onChanged: (val) => setState(() => _gender = val ?? 'male'),
            ),
            const SizedBox(height: 16),
            _buildDropdown(
              label: 'Цель',
              value: _goal,
              items: const [
                DropdownMenuItem(value: 'gain', child: Text('Набор')), // maps to "gain"
                DropdownMenuItem(value: 'lose', child: Text('Похудение')),
                DropdownMenuItem(value: 'maintain', child: Text('Поддержание')),
              ],
              onChanged: (val) => setState(() => _goal = val ?? 'maintain'),
            ),
            const SizedBox(height: 16),
            _buildDropdown(
              label: 'Активность',
              value: _activity,
              items: const [
                DropdownMenuItem(value: 'low', child: Text('Низкая')),
                DropdownMenuItem(value: 'medium', child: Text('Средняя')),
                DropdownMenuItem(value: 'high', child: Text('Высокая')),
              ],
              onChanged: (val) => setState(() => _activity = val ?? 'medium'),
            ),
            const SizedBox(height: 24),
            PrimaryButton(
              text: 'Получить рекомендации',
              isLoading: nutritionProvider.isLoading,
              onPressed: _submit,
            ),
          ],
        ),
      ),
    );
  }
}
