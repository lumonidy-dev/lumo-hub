import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lumohub/models/profile.model.dart';

class FirestoreResult<T> {
  final bool success;
  final T? result; // Para operaciones de lectura
  final String? errorMessage;

  FirestoreResult.success([this.result])
      : success = true,
        errorMessage = null;

  FirestoreResult.failure(this.errorMessage)
      : success = false,
        result = null;
}

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Verifica si existe un documento con el uid como id del documento, en la colección `users`
  Future<bool> existsProfile(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    return doc.exists;
  }

  // Registra un nuevo perfil en Firestore
  Future<FirestoreResult<void>> registerProfile(
      String uid, Profile profile) async {
    // Verifica si el perfil ya existe
    if (await existsProfile(uid)) {
      return FirestoreResult.failure('El perfil ya existe');
    }

    try {
      await _firestore.collection('users').doc(uid).set(profile.toFirestore());
      return FirestoreResult.success();
    } catch (e) {
      return FirestoreResult.failure(
          'Error al registrar el perfil: ${e.toString()}');
    }
  }

  // Actualiza un perfil existente en Firestore
  Future<FirestoreResult<void>> updateProfile(
      String uid, Profile profile) async {
    try {
      await _firestore
          .collection('users')
          .doc(uid)
          .update(profile.toFirestore());
      return FirestoreResult.success();
    } catch (e) {
      return FirestoreResult.failure(
          'Error al actualizar el perfil: ${e.toString()}');
    }
  }

  // Obtiene un perfil de Firestore
  Future<FirestoreResult<Profile>> fetchProfile(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists && doc.data() != null) {
        Profile profile = Profile.fromFirestore(doc.data()!);
        return FirestoreResult.success(profile);
      } else {
        return FirestoreResult.failure('El perfil no existe');
      }
    } catch (e) {
      return FirestoreResult.failure(
          'Error al obtener el perfil: ${e.toString()}');
    }
  }

  // Borra un perfil de Firestore
  Future<FirestoreResult<void>> deleteProfile(String uid) async {
    try {
      if (await existsProfile(uid)) {
        await _firestore.collection('users').doc(uid).delete();
        return FirestoreResult.success();
      } else {
        return FirestoreResult.failure('El perfil no existe');
      }
    } catch (e) {
      return FirestoreResult.failure(
          'Error al borrar el perfil: ${e.toString()}');
    }
  }
}
