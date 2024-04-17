import 'dart:typed_data';
import 'package:lumohub/services/auth.service.dart';
import 'package:lumohub/services/firestore.service.dart';
import 'package:lumohub/services/storage.service.dart';
import 'package:lumohub/models/profile.model.dart';
import 'package:lumohub/viewmodels/base.viewmodel.dart';

class ProfileViewModel extends BaseViewModel {
  final StorageService _storageService;
  final AuthService _authService;
  final FirestoreService _profileService;

  Profile? _profile;
  Uint8List? _imageBytes;

  ProfileViewModel(
      this._storageService, this._authService, this._profileService);

  // Getters
  Profile? get profile => _profile;
  Uint8List? get imageBytes => _imageBytes;

  // Método para obtener el perfil del usuario autenticado
  Future<void> getProfile() async {
    // Verificar autenticación
    if (!_authService.isAuthenticated) {
      handleUnauthenticatedError();
      return;
    }

    setState(ViewState.busy);

    try {
      final response = await _profileService.fetchProfile(_authService.uid!);
      if (response.success) {
        _profile = response.result;
        setState(ViewState.success);
      } else {
        handleError(response.errorMessage!);
      }
    } catch (e) {
      handleError('Error al obtener el perfil');
    }
  }

  // Método para subir una foto de perfil
  Future<void> uploadProfilePhoto(Uint8List? newPhotoBytes) async {
    // Verificar autenticación y la presencia de la imagen
    if (!_authService.isAuthenticated || newPhotoBytes == null) {
      handleUnauthenticatedError();
      return;
    }

    setState(ViewState.busy);

    try {
      final result = await _storageService.uploadImage(
          _authService.uid!, newPhotoBytes, 'users_profile');
      if (result.success) {
        _profile?.photoUrl = result.url;
        setState(ViewState.success);
      } else {
        handleError(result.errorMessage!);
      }
    } catch (e) {
      handleError('Error al subir la imagen');
    }
  }

  // Método para enviar los cambios del perfil
  Future<void> submitProfileChanges(Profile updatedProfile) async {
    // Verificar autenticación
    if (!_authService.isAuthenticated) {
      handleUnauthenticatedError();
      return;
    }

    setState(ViewState.busy);

    try {
      await _profileService.updateProfile(_authService.uid!, updatedProfile);
      _profile = updatedProfile;
      setState(ViewState.success);
    } catch (e) {
      handleError('Error al actualizar el perfil');
    }
  }

  // Método para cerrar sesión
  Future<void> logout() async {
    setState(ViewState.busy);

    try {
      await _authService.logout();
      setState(ViewState.success);
    } catch (e) {
      handleError('Error al cerrar sesión');
    }
  }

  // Método para manejar errores de autenticación
  void handleUnauthenticatedError() {
    handleError('Usuario no autenticado');
  }
}
