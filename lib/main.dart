import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'views/login/login_screen.dart';
import 'views/home/home_screen.dart';
import 'views/register/register_screen.dart';
import 'viewmodels/login_viewmodel.dart';
import 'viewmodels/register_viewmodel.dart';
import 'viewmodels/profile_viewmodel.dart';
import 'viewmodels/github_viewmodel.dart';
import 'services/auth_service.dart';
import 'services/firestore_service.dart';
import 'services/storage_service.dart';
import 'package:provider/provider.dart';
import 'package:firebase_app_check/firebase_app_check.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase App Check
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize Firebase App Check
  await FirebaseAppCheck.instance.activate(
    webProvider:
        ReCaptchaV3Provider('6Le4dropAAAAAOugQMowaCuD_w0CICq-JLECBS0y'),
    androidProvider: AndroidProvider.playIntegrity,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthService authService = AuthService();
    final FirestoreService firestoreService = FirestoreService();
    final StorageService storageService = StorageService();

    return MultiProvider(
      providers: [
        Provider<AuthService>(create: (_) => authService),
        Provider<FirestoreService>(create: (_) => firestoreService),
        ChangeNotifierProvider(
            create: (_) => LoginViewModel(authService, firestoreService)),
        ChangeNotifierProvider(
            create: (_) =>
                RegistrationViewModel(authService, firestoreService)),
        ChangeNotifierProvider(
            create: (_) => ProfileViewModel(
                firestoreService, authService, storageService)),
        ChangeNotifierProvider(
            create: (context) => GithubViewModel(authService)),
      ],
      child: MaterialApp(
        title: 'Lumo Hub',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          appBarTheme: AppBarTheme(color: Colors.blue[800]),
          buttonTheme: ButtonThemeData(buttonColor: Colors.blue[700]),
          textTheme: const TextTheme(
            headlineMedium: TextStyle(fontSize: 20.0, color: Colors.black),
            bodyMedium: TextStyle(fontSize: 16.0, color: Colors.black),
          ),
        ),
        initialRoute: '/login',
        routes: {
          '/login': (context) => const LoginScreen(),
          '/home': (context) => const HomeScreen(),
          '/register': (context) => const RegisterScreen(),
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
