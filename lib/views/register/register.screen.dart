import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:lumohub/viewmodels/auth.viewmodel.dart';
import 'package:lumohub/viewmodels/base.viewmodel.dart';

import 'package:lumohub/widgets/elevated_button.widget.dart';
import 'package:lumohub/widgets/loading.widget.dart';
import 'package:lumohub/widgets/text_field.widget.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  RegistrationScreenState createState() => RegistrationScreenState();
}

class RegistrationScreenState extends State<RegistrationScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    // Limpia los controladores de texto al eliminar el widget
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);

    // Redirigir al usuario si ya está autenticado
    _redirectIfAuthenticated(authViewModel);

    // Mostrar Snackbar para errores después de la construcción del widget
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (authViewModel.errorMessage != null) {
        _showErrorSnackbar(authViewModel.errorMessage!);
      }
    });

    // Mostrar indicador de carga si el estado está ocupado
    if (authViewModel.state == ViewState.busy) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Registro'),
        ),
        body: const Center(
          child: LoadingWidget(), // Usar un widget de carga
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildTextFields(),
            const Spacer(),
            _buildRegisterButton(authViewModel),
          ],
        ),
      ),
    );
  }

  // Función para verificar y redirigir al usuario si ya está autenticado
  void _redirectIfAuthenticated(AuthViewModel authViewModel) {
    if (authViewModel.isAuthenticated) {
      Future.microtask(() => Navigator.pushReplacementNamed(context, '/home'));
    }
  }

  // Función para construir los campos de texto
  Widget _buildTextFields() {
    return Column(
      children: [
        CustomTextField(
          controller: _usernameController,
          labelText: 'Nombre de usuario',
        ),
        const SizedBox(height: 16),
        CustomTextField(
          controller: _emailController,
          labelText: 'Correo electrónico',
        ),
        CustomTextField(
          controller: _passwordController,
          labelText: 'Contraseña',
          obscureText: true,
        ),
      ],
    );
  }

  // Función para construir el botón de registro
  Widget _buildRegisterButton(AuthViewModel authViewModel) {
    return CustomElevatedButton(
      text: 'Registrarse',
      onPressed: () => _onRegisterButtonPressed(authViewModel),
    );
  }

  // Función para manejar la acción del botón de registro
  void _onRegisterButtonPressed(AuthViewModel authViewModel) {
    final username = _usernameController.text;
    final email = _emailController.text;
    final password = _passwordController.text;

    authViewModel.register(username, email, password);
  }

  // Función para mostrar el Snackbar en caso de error
  void _showErrorSnackbar(String errorMessage) {
    final snackBar = SnackBar(
      content: Text(errorMessage),
      backgroundColor: Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
