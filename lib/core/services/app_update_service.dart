import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';

class UpdateInfo {
  final String version;
  final int buildNumber;
  final String apkUrl;
  final String sha256;
  final String changelog;
  final bool isMandatory;

  UpdateInfo({
    required this.version,
    required this.buildNumber,
    required this.apkUrl,
    required this.sha256,
    required this.changelog,
    required this.isMandatory,
  });

  factory UpdateInfo.fromMap(Map<String, dynamic> map) {
    return UpdateInfo(
      version: map['version'] as String? ?? '1.0.0',
      buildNumber: map['build_number'] as int? ?? 0,
      apkUrl: map['apk_url'] as String? ?? '',
      sha256: map['sha256'] as String? ?? '',
      changelog: map['changelog'] as String? ?? '',
      isMandatory: map['is_mandatory'] as bool? ?? false,
    );
  }
}

class AppUpdateService {
  static const MethodChannel _channel = MethodChannel('com.cmoc.relatorio/app_update');
  final FirebaseFirestore? _firestoreInstance;

  AppUpdateService({FirebaseFirestore? firestore})
      : _firestoreInstance = firestore;

  FirebaseFirestore get _firestore => _firestoreInstance ?? FirebaseFirestore.instance;

  /// Verifica se há atualizações disponíveis comparando os metadados locais com os remotos.
  Future<UpdateInfo?> checkForUpdate() async {
    // Apenas Android necessita do fluxo de atualização manual de APK
    if (kIsWeb || !Platform.isAndroid) return null;

    try {
      final docSnap = await _firestore.collection('version_control').doc('latest').get();
      if (!docSnap.exists || docSnap.data() == null) {
        debugPrint('[AppUpdateService] Documento version_control/latest não encontrado no Firestore.');
        return null;
      }

      final updateInfo = UpdateInfo.fromMap(docSnap.data()!);
      if (updateInfo.apkUrl.isEmpty) {
        debugPrint('[AppUpdateService] URL do APK vazia nas configurações.');
        return null;
      }

      final packageInfo = await PackageInfo.fromPlatform();
      final currentVersion = packageInfo.version;
      final currentBuild = int.tryParse(packageInfo.buildNumber) ?? 0;

      final shouldUpdateApp = shouldUpdate(
        current: currentVersion,
        latest: updateInfo.version,
        currentBuild: currentBuild,
        latestBuild: updateInfo.buildNumber,
      );

      if (shouldUpdateApp) {
        debugPrint('[AppUpdateService] Nova versão encontrada: ${updateInfo.version}+${updateInfo.buildNumber}');
        return updateInfo;
      }
      
      debugPrint('[AppUpdateService] O app está atualizado (Local: $currentVersion+$currentBuild)');
      return null;
    } catch (e) {
      debugPrint('[AppUpdateService] Erro ao verificar versão: $e');
      return null;
    }
  }

  /// Lógica de comparação semântica de versões (SemVer)
  bool shouldUpdate({
    required String current,
    required String latest,
    required int currentBuild,
    required int latestBuild,
  }) {
    try {
      final currentParts = current.split('.').map(int.parse).toList();
      final latestParts = latest.split('.').map(int.parse).toList();

      for (int i = 0; i < 3; i++) {
        final curr = i < currentParts.length ? currentParts[i] : 0;
        final lat = i < latestParts.length ? latestParts[i] : 0;
        if (lat > curr) return true;
        if (curr > lat) return false;
      }

      // Se as versões forem idênticas (ex: 1.0.0 e 1.0.0), compara pelo número de compilação
      return latestBuild > currentBuild;
    } catch (e) {
      // Fallback em caso de falha de parsing
      return latest != current || latestBuild > currentBuild;
    }
  }

  /// Realiza o download seguro do APK reportando o progresso da operação
  Future<File> downloadApk(String url, {required Function(double progress) onProgress}) async {
    final client = http.Client();
    final request = http.Request('GET', Uri.parse(url));
    final response = await client.send(request);

    if (response.statusCode != 200) {
      client.close();
      throw Exception('Falha ao baixar arquivo: HTTP ${response.statusCode}');
    }

    final contentLength = response.contentLength ?? 0;
    int downloadedBytes = 0;

    final tempDir = await getTemporaryDirectory();
    final apkFile = File('${tempDir.path}/app-update.apk');
    
    // Se o arquivo antigo existir, deleta para evitar lixo
    if (await apkFile.exists()) {
      await apkFile.delete();
    }

    final fileSink = apkFile.openWrite();

    try {
      await response.stream.listen(
        (chunk) {
          fileSink.add(chunk);
          downloadedBytes += chunk.length;
          if (contentLength > 0) {
            final progress = downloadedBytes / contentLength;
            onProgress(progress);
          }
        },
        cancelOnError: true,
      ).asFuture();
      
      await fileSink.flush();
      await fileSink.close();
      client.close();
      return apkFile;
    } catch (e) {
      await fileSink.close();
      client.close();
      if (await apkFile.exists()) {
        await apkFile.delete();
      }
      throw Exception('Erro durante download do APK: $e');
    }
  }

  /// Calcula o hash SHA-256 do arquivo baixado e compara com o valor do servidor
  Future<bool> validateIntegrity(File file, String expectedSha256) async {
    try {
      if (!await file.exists()) return false;

      final stream = file.openRead();
      final hash = await sha256.bind(stream).first;
      final calculatedSha = hash.toString();

      debugPrint('[AppUpdateService] Hash esperado: $expectedSha256');
      debugPrint('[AppUpdateService] Hash calculado: $calculatedSha');

      // Compara ignorando caixa alta/baixa
      return calculatedSha.trim().toLowerCase() == expectedSha256.trim().toLowerCase();
    } catch (e) {
      debugPrint('[AppUpdateService] Falha ao calcular integridade do APK: $e');
      return false;
    }
  }

  /// Verifica se o dispositivo possui a permissão de instalar aplicativos desconhecidos
  Future<bool> checkInstallPermission() async {
    try {
      final bool hasPermission = await _channel.invokeMethod('checkInstallPermission');
      return hasPermission;
    } on PlatformException catch (e) {
      debugPrint('[AppUpdateService] Erro ao verificar permissão nativa: $e');
      return false;
    }
  }

  /// Redireciona o usuário para as configurações nativas do Android para autorizar instalações
  Future<void> requestInstallPermission() async {
    try {
      await _channel.invokeMethod('requestInstallPermission');
    } on PlatformException catch (e) {
      debugPrint('[AppUpdateService] Erro ao abrir configurações nativas: $e');
    }
  }

  /// Aciona a Intent de instalação oficial no Android passando o arquivo APK
  Future<bool> installApk(String filePath) async {
    try {
      final bool success = await _channel.invokeMethod('installApk', {'filePath': filePath});
      return success;
    } on PlatformException catch (e) {
      debugPrint('[AppUpdateService] Erro ao instalar APK via MethodChannel: $e');
      return false;
    }
  }
}
