import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/auth_request.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/input_field.dart';
import '../../widgets/primary_button.dart';
import '../nutrition/nutrition_form_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _firstnameController = TextEditingController();
  final _lastnameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _firstnameController.dispose();
    _lastnameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    final authProvider = context.read<AuthProvider>();
    final firstname = _firstnameController.text.trim();
    final lastname = _lastnameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if ([firstname, lastname, email, password].any((e) => e.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Заполните все поля')),
      );
      return;
    }

    try {
      await authProvider.register(
        RegisterRequest(
          firstname: firstname,
          lastname: lastname,
          email: email,
          password: password,
        ),
      );
      if (mounted) {
        // Navigate to the AI form after successful registration.
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const NutritionFormScreen()),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<AuthProvider>().isLoading;

    return Scaffold(
      appBar: AppBar(title: const Text('Регистрация в NutriFit AI')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 24),
            InputField(label: 'Имя', controller: _firstnameController),
            const SizedBox(height: 16),
            InputField(label: 'Фамилия', controller: _lastnameController),
            const SizedBox(height: 16),
            InputField(label: 'Email', controller: _emailController, keyboardType: TextInputType.emailAddress),
            const SizedBox(height: 16),
            InputField(label: 'Пароль', controller: _passwordController, obscureText: true),
            const SizedBox(height: 24),
            PrimaryButton(
              text: 'Зарегистрироваться',
              isLoading: isLoading,
              onPressed: _register,
            ),
          ],
        ),
      ),
    );
  }
}
