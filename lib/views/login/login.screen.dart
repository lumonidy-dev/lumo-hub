import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../viewmodels/base.viewmodel.dart';
import '../../viewmodels/auth.viewmodel.dart';
import '../../widgets/elevated_button.widget.dart';
import '../../widgets/loading.widget.dart';
import '../../widgets/text_field.widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // Limpia los controladores al eliminar el widget
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Consume el authViewModel
    final authViewModel = Provider.of<AuthViewModel>(context);

    if (authViewModel.isAuthenticated) {
      Future.microtask(() => Navigator.pushReplacementNamed(context, '/home'));
    }
    // Mostrar el LoadingWidget si está cargando
    if (authViewModel.state == ViewState.busy) {
      return const Scaffold(
        body: Center(
          child: LoadingWidget(), // Usar el LoadingWidget aquí
        ),
      );
    }

    // Programar la muestra del SnackBar después de la construcción del widget
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (authViewModel.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(authViewModel.errorMessage!),
            backgroundColor: Colors.red,
          ),
        );
      }
      authViewModel.clearError();
    });

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Iniciar Sesión',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _emailController,
                labelText: 'Correo electrónico',
                keyboardType: TextInputType.emailAddress,
              ),
              CustomTextField(
                controller: _passwordController,
                labelText: 'Contraseña',
                obscureText: true,
              ),
              const SizedBox(height: 16),
              CustomElevatedButton(
                icon: Icons.login,
                text: 'Iniciar sesión',
                onPressed: () {
                  authViewModel.login(
                    _emailController.text,
                    _passwordController.text,
                  );
                },
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/register');
                },
                child: const Text(
                  '¿No tienes cuenta? Regístrate aquí',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
