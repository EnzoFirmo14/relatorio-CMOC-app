import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class CloudinaryService {
  final String cloudName = 'qoxf3ibm';
  final String uploadPreset = 'cmoc_preset';

  /// Realiza o upload de uma imagem (caminho físico ou blob URL) para o Cloudinary
  /// e retorna a URL segura (secure_url).
  Future<String> uploadImage(String absolutePath) async {
    final url = Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/image/upload');
    final request = http.MultipartRequest('POST', url);
    request.fields['upload_preset'] = uploadPreset;

    try {
      if (kIsWeb || absolutePath.startsWith('blob:') || absolutePath.startsWith('http')) {
        // Na Web ou se for uma URL/blob, fazemos o download dos bytes primeiro
        final response = await http.get(Uri.parse(absolutePath));
        if (response.statusCode != 200) {
          throw Exception('Falha ao baixar bytes da imagem local: ${response.statusCode}');
        }
        final fileBytes = response.bodyBytes;
        request.files.add(http.MultipartFile.fromBytes(
          'file',
          fileBytes,
          filename: 'upload.jpg',
        ));
      } else {
        // Em plataformas móveis/desktop físicas, lê do caminho local
        final file = File(absolutePath);
        if (!await file.exists()) {
          throw Exception('Arquivo físico de imagem não encontrado: $absolutePath');
        }
        request.files.add(await http.MultipartFile.fromPath(
          'file',
          file.path,
        ));
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);
        final secureUrl = data['secure_url'] as String?;
        if (secureUrl != null) {
          return secureUrl;
        }
        throw Exception('URL segura (secure_url) não encontrada no retorno do Cloudinary.');
      } else {
        throw Exception('Resposta de erro do Cloudinary (${response.statusCode}): ${response.body}');
      }
    } catch (e) {
      throw Exception('Erro ao enviar imagem ao Cloudinary: $e');
    }
  }
}
