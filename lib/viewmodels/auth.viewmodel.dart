import 'package:lumohub/models/profile.model.dart';
import 'package:lumohub/services/auth.service.dart';
import 'package:lumohub/services/firestore.service.dart';
import 'package:lumohub/viewmodels/base.viewmodel.dart';

class AuthViewModel extends BaseViewModel {
  final AuthService _authService;
  final FirestoreService _firestoreService;

  AuthViewModel(this._authService, this._firestoreService);

  String? _error;

  bool get isAuthenticated => _authService.isAuthenticated;
  String? get error => _error;

  // Método para iniciar sesión
  Future<void> login(String email, String password) async {
    setState(ViewState.busy);
    try {
      final result = await _authService.login(email, password);
      if (result.success) {
        _error = null;
        setState(ViewState.success);
      } else {
        handleError(result.errorMessage!);
      }
    } catch (e) {
      handleError('Error al iniciar sesión');
    }
  }

  // Método para cerrar sesión
  Future<void> logout() async {
    setState(ViewState.busy);
    try {
      await _authService.logout();
      _error = null;
      setState(ViewState.success);
    } catch (e) {
      handleError('Error al cerrar sesión');
    }
  }

  // al momento del register en el viewmodel, se consumen los dos servicios, el de auth y el de firestore
  // porque debo registrar el usuario en ambos servicios, uno como Auth y el otro en mi base de datos
  Future<void> register(name, email, password) async {
    final profile = Profile(name: name, email: email);
    setState(ViewState.busy);
    try {
      final result = await _authService.register(name, email, password);
      if (result.success) {
        await _firestoreService.registerProfile(_authService.uid!, profile);
        _error = null;
        setState(ViewState.success);
      } else {
        handleError(result.errorMessage!);
      }
    } catch (e) {
      handleError('Error al registrar');
    }
  }
}
