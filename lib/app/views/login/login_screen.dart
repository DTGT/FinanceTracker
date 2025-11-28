import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:financial_tracker/app/viewmodels/authenticaton.dart';
import 'package:financial_tracker/app/services/auth_service.dart';
import '../main_navigation.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LoginViewModel(AuthService()),
      child: _LoginScreenBody(),
    );
  }
}

class _LoginScreenBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<LoginViewModel>(context);

    return Scaffold(
      body: Center(
        child: vm.isLoading
            ? const CircularProgressIndicator()
            : ElevatedButton.icon(
                icon: const Icon(Icons.login),
                label: const Text('Sign in with Google'),
                onPressed: () async {
                  final user = await vm.signIn();
                  if (user != null && context.mounted) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const MainNavigation()),
                    );
                  }
                },
              ),
      ),
    );
  }
}
