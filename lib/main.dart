import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'viewmodels/auth.viewmodel.dart';
import 'viewmodels/profile.viewmodel.dart';

import 'views/home/home.screen.dart';
import 'views/login/login.screen.dart';
import 'views/register/register.screen.dart';

import 'services/storage.service.dart';
import 'services/firestore.service.dart';
import 'services/auth.service.dart';

import 'package:firebase_core/firebase_core.dart';
import '';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Inicializa los servicios
    final profileService = StorageService();
    final firestoreService = FirestoreService();
    final authService = AuthService();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => AuthViewModel(authService, firestoreService)),
        ChangeNotifierProvider(
            create: (_) => ProfileViewModel(
                profileService, authService, firestoreService)),
      ],
      child: MaterialApp(
        title: 'Login App',
        initialRoute: '/login',
        routes: {
          '/login': (context) => const LoginScreen(),
          '/register': (context) => const RegistrationScreen(),
          '/home': (context) => const HomeScreen(),
        },
      ),
    );
  }
}
