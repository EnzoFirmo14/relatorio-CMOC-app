import 'dart:io';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class ImageService {
  ImageService._();

  static final ImagePicker _picker = ImagePicker();

  /// Abre a câmera ou galeria, comprime a imagem e a salva na pasta local do app.
  /// Retorna o caminho relativo da imagem salva (ex: 'photos/img_123.jpg') ou null se cancelado.
  static Future<String?> pickAndCompressImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 1920,
        maxHeight: 1080,
      );

      if (pickedFile == null) return null;

      // Cria a pasta /photos na pasta de documentos do app
      final docDir = await getApplicationDocumentsDirectory();
      final photosDir = Directory(p.join(docDir.path, 'photos'));
      if (!await photosDir.exists()) {
        await photosDir.create(recursive: true);
      }

      // Nome único para o arquivo
      final String fileName = 'img_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final String targetPath = p.join(photosDir.path, fileName);

      // Comprime a imagem e salva direto no caminho final
      final XFile? compressedFile = await FlutterImageCompress.compressAndGetFile(
        pickedFile.path,
        targetPath,
        quality: 80,
        format: CompressFormat.jpeg,
      );

      if (compressedFile == null) {
        // Se a compressão falhar por algum motivo, salvamos o original
        final File originalFile = File(pickedFile.path);
        await originalFile.copy(targetPath);
      }

      // Retorna o caminho relativo (para evitar quebras caso o path absoluto do app mude)
      return p.join('photos', fileName);
    } catch (_) {
      return null;
    }
  }

  /// Converte o caminho relativo armazenado no Isar em um caminho absoluto para a UI.
  static Future<String> getAbsolutePath(String relativePath) async {
    final docDir = await getApplicationDocumentsDirectory();
    return p.join(docDir.path, relativePath);
  }

  /// Exclui o arquivo físico de imagem do disco.
  static Future<void> deleteImageFile(String relativePath) async {
    try {
      final docDir = await getApplicationDocumentsDirectory();
      final fullPath = p.join(docDir.path, relativePath);
      final file = File(fullPath);
      if (await file.exists()) {
        await file.delete();
      }
    } catch (_) {
      // Ignora falhas de exclusão física para não quebrar o app
    }
  }
}
