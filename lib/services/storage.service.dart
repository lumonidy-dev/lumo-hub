import 'package:firebase_storage/firebase_storage.dart';
import 'dart:typed_data';
import 'package:mime/mime.dart';

class StorageResult {
  final bool success;
  final String? url;
  final String? errorMessage;

  StorageResult.success(this.url)
      : success = true,
        errorMessage = null;

  StorageResult.failure(this.errorMessage)
      : success = false,
        url = null;
}

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Función para eliminar todos los archivos de un directorio
  Future<StorageResult> deleteAllFiles(String directory) async {
    try {
      ListResult listResult = await _storage.ref(directory).listAll();
      for (var item in listResult.items) {
        await item.delete();
      }
      return StorageResult.success(null);
    } catch (e) {
      return StorageResult.failure('Error eliminando archivos: $e');
    }
  }

  // Descarga la URL de la imagen de un usuario específico.
  Future<StorageResult> downloadImageUrl(String uid, String path) async {
    try {
      String downloadUrl = await _storage.ref('$path/$uid').getDownloadURL();
      return StorageResult.success(downloadUrl);
    } catch (e) {
      return StorageResult.failure('Error descargando URL de la imagen: $e');
    }
  }

  // Subir una imagen a Firebase Storage
  Future<StorageResult> uploadImage(
      String uid, Uint8List image, String path) async {
    // Determina el tipo MIME de la imagen y su extensión
    final mimeType = lookupMimeType('', headerBytes: image);
    final extension = mimeType != null ? mimeType.split('/').last : 'jpg';

    // Definir la ruta del archivo
    String filePath = '$path/$uid/profile_image.$extension';

    try {
      // Subir la imagen a Firebase Storage
      await _storage
          .ref(filePath)
          .putData(image, SettableMetadata(contentType: mimeType));

      // Obtener la URL de descarga de la imagen
      String downloadUrl = await _storage.ref(filePath).getDownloadURL();
      return StorageResult.success(downloadUrl);
    } catch (e) {
      return StorageResult.failure('Error subiendo imagen: $e');
    }
  }
}
