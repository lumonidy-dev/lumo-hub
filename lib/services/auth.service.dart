import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class AuthResult {
  final bool success;
  final UserCredential? userCredential;
  final String? errorMessage;

  AuthResult.success([this.userCredential])
      : success = true,
        errorMessage = null;

  AuthResult.failure(this.errorMessage)
      : success = false,
        userCredential = null;
}

class AuthService {
  // Iniciar sesión por correo y contraseña, retorna un objeto AuthResult
  Future<AuthResult> login(String email, String password) async {
    try {
      final userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return AuthResult.success(userCredential);
    } catch (e) {
      return AuthResult.failure(e.toString());
    }
  }

  // Iniciar sesión con Github, retorna un objeto AuthResult
  Future<AuthResult> loginWithGithub() async {
    try {
      UserCredential userCredential;
      final provider = GithubAuthProvider();

      if (kIsWeb) {
        userCredential = await FirebaseAuth.instance.signInWithPopup(provider);
      } else {
        userCredential =
            await FirebaseAuth.instance.signInWithProvider(provider);
      }

      return AuthResult.success(userCredential);
    } catch (e) {
      return AuthResult.failure(e.toString());
    }
  }

  // Cerrar sesión, retorna un objeto AuthResult
  Future<AuthResult> logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      return AuthResult.success();
    } catch (e) {
      return AuthResult.failure(e.toString());
    }
  }

  // Registrar un usuario por payload(nombre, correo, contraseña), retorna un objeto AuthResult
  Future<AuthResult> register(
      String name, String email, String password) async {
    try {
      final userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      await userCredential.user!.updateDisplayName(name);
      return AuthResult.success(userCredential);
    } catch (e) {
      return AuthResult.failure(e.toString());
    }
  }

  // Resetear la contraseña de un usuario por correo, retorna un objeto AuthResult
  Future<AuthResult> resetPassword(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      return AuthResult.success();
    } catch (e) {
      return AuthResult.failure(e.toString());
    }
  }

  // Actualizar el perfil de un usuario displayName?, photoURL?, retorna un objeto AuthResult
  Future<AuthResult> updateProfile(
      {String? displayName, String? photoURL}) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await user.updateDisplayName(displayName);
        await user.updatePhotoURL(photoURL);
        return AuthResult.success();
      } else {
        return AuthResult.failure("No hay un usuario autenticado");
      }
    } catch (e) {
      return AuthResult.failure(e.toString());
    }
  }

  // Borra el perfil de un usuario, retorna un objeto AuthResult
  Future<AuthResult> deleteProfile() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await user.delete();
        return AuthResult.success();
      } else {
        return AuthResult.failure("No hay un usuario autenticado");
      }
    } catch (e) {
      return AuthResult.failure(e.toString());
    }
  }

  // Observador de cambios en la autenticación
  Stream<User?> get authStateChanges =>
      FirebaseAuth.instance.authStateChanges();

  // isAuthenticaded
  bool get isAuthenticated => FirebaseAuth.instance.currentUser != null;

  // uid
  String? get uid => FirebaseAuth.instance.currentUser?.uid;
}
