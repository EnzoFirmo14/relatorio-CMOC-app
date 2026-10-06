import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';

class AppReleaseInfo {
  final String latestVersion;
  final int latestBuildNumber;
  final String downloadUrl;
  final String releaseNotes;
  final bool forceUpdate;
  final String currentVersion;
  final int currentBuildNumber;
  final bool isUpdateAvailable;

  const AppReleaseInfo({
    required this.latestVersion,
    required this.latestBuildNumber,
    required this.downloadUrl,
    required this.releaseNotes,
    required this.forceUpdate,
    required this.currentVersion,
    required this.currentBuildNumber,
    required this.isUpdateAvailable,
  });
}

class AppUpdateService {
  static final AppUpdateService _instance = AppUpdateService._internal();
  factory AppUpdateService() => _instance;
  AppUpdateService._internal();

  static const MethodChannel _channel = MethodChannel('com.cmoc.relatorio/app_updater');

  // Repositório padrão no GitHub
  static const String githubOwner = 'EnzoFirmo14';
  static const String githubRepo = 'relatorio-CMOC-app';

  /// Obter informações da versão atual do app instalada
  Future<PackageInfo> getPackageInfo() async {
    return await PackageInfo.fromPlatform();
  }

  /// Verifica se há uma nova versão disponível (Firestore -> fallback GitHub Releases)
  Future<AppReleaseInfo?> checkForUpdate() async {
    try {
      final packageInfo = await getPackageInfo();
      final currentVersion = packageInfo.version;
      final currentBuildNumber = int.tryParse(packageInfo.buildNumber) ?? 1;

      // 1. Tentar buscar pelo Firebase Firestore primeiro
      final firestoreInfo = await _checkFirestoreVersion(currentVersion, currentBuildNumber);
      if (firestoreInfo != null) {
        return firestoreInfo;
      }

      // 2. Fallback: Buscar direto pela API do GitHub Releases
      return await _checkGitHubReleases(currentVersion, currentBuildNumber);
    } catch (e) {
      debugPrint('[AppUpdateService] Erro ao checar atualizações: $e');
      return null;
    }
  }

  /// Checagem via Firestore
  Future<AppReleaseInfo?> _checkFirestoreVersion(String currentVersion, int currentBuildNumber) async {
    if (Firebase.apps.isEmpty) return null;

    try {
      final doc = await FirebaseFirestore.instance.collection('cmoc_cadastros').doc('app_version').get();
      if (!doc.exists || doc.data() == null) return null;

      final data = doc.data()!;
      final latestVersion = (data['latest_version'] ?? data['version'] ?? '').toString().trim();
      final latestBuildNumber = (data['build_number'] ?? data['buildNumber'] ?? 0) is int
          ? (data['build_number'] ?? data['buildNumber'] ?? 0) as int
          : int.tryParse(data['build_number']?.toString() ?? '0') ?? 0;
      final downloadUrl = (data['download_url'] ?? data['url'] ?? '').toString().trim();
      final releaseNotes = (data['release_notes'] ?? data['notes'] ?? 'Melhorias gerais e correções de estabilidade.').toString().trim();
      final forceUpdate = data['force_update'] == true;

      if (latestVersion.isEmpty && latestBuildNumber == 0) return null;

      final isAvailable = _isVersionGreater(
        latestVersion: latestVersion,
        latestBuild: latestBuildNumber,
        currentVersion: currentVersion,
        currentBuild: currentBuildNumber,
      );

      return AppReleaseInfo(
        latestVersion: latestVersion.isNotEmpty ? latestVersion : 'v$latestBuildNumber',
        latestBuildNumber: latestBuildNumber,
        downloadUrl: downloadUrl,
        releaseNotes: releaseNotes,
        forceUpdate: forceUpdate,
        currentVersion: currentVersion,
        currentBuildNumber: currentBuildNumber,
        isUpdateAvailable: isAvailable,
      );
    } catch (e) {
      debugPrint('[AppUpdateService] Consulta Firestore app_version falhou: $e');
      return null;
    }
  }

  /// Checagem via GitHub Releases API
  Future<AppReleaseInfo?> _checkGitHubReleases(String currentVersion, int currentBuildNumber) async {
    try {
      final url = Uri.parse('https://api.github.com/repos/$githubOwner/$githubRepo/releases/latest');
      final response = await http.get(url, headers: {
        'Accept': 'application/vnd.github.v3+json',
      }).timeout(const Duration(seconds: 10));

      if (response.statusCode != 200) {
        debugPrint('[AppUpdateService] GitHub Releases API status: ${response.statusCode}');
        return null;
      }

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final rawTag = (data['tag_name'] ?? '').toString().trim();
      final cleanTag = rawTag.startsWith('v') ? rawTag.substring(1) : rawTag;
      final releaseNotes = (data['body'] ?? 'Novas melhorias e correções disponíveis.').toString().trim();

      // Procurar o link do arquivo .apk nos assets da release
      String downloadUrl = '';
      final assets = data['assets'] as List<dynamic>? ?? [];
      for (final asset in assets) {
        final name = (asset['name'] ?? '').toString().toLowerCase();
        if (name.endsWith('.apk')) {
          downloadUrl = (asset['browser_download_url'] ?? '').toString();
          break;
        }
      }

      // Se não encontrou asset .apk específico, usa o link da release
      if (downloadUrl.isEmpty && assets.isNotEmpty) {
        downloadUrl = (assets.first['browser_download_url'] ?? '').toString();
      }

      // Parse versão e build da tag (ex: "1.0.1" ou "1.0.1+2")
      int remoteBuild = 0;
      String remoteVer = cleanTag;
      if (cleanTag.contains('+')) {
        final parts = cleanTag.split('+');
        remoteVer = parts[0];
        remoteBuild = int.tryParse(parts[1]) ?? 0;
      }

      final isAvailable = _isVersionGreater(
        latestVersion: remoteVer,
        latestBuild: remoteBuild,
        currentVersion: currentVersion,
        currentBuild: currentBuildNumber,
      );

      return AppReleaseInfo(
        latestVersion: rawTag.isNotEmpty ? rawTag : 'v$remoteVer',
        latestBuildNumber: remoteBuild,
        downloadUrl: downloadUrl,
        releaseNotes: releaseNotes.isNotEmpty ? releaseNotes : 'Melhorias de desempenho e correções de estabilidade.',
        forceUpdate: false,
        currentVersion: currentVersion,
        currentBuildNumber: currentBuildNumber,
        isUpdateAvailable: isAvailable,
      );
    } catch (e) {
      debugPrint('[AppUpdateService] Consulta GitHub API falhou: $e');
      return null;
    }
  }

  /// Compara duas versões
  bool _isVersionGreater({
    required String latestVersion,
    required int latestBuild,
    required String currentVersion,
    required int currentBuild,
  }) {
    if (latestBuild > 0 && currentBuild > 0) {
      if (latestBuild > currentBuild) return true;
      if (latestBuild < currentBuild) return false;
    }

    // Comparação semântica (ex: "1.0.1" vs "1.0.0")
    try {
      final cleanLatest = latestVersion.replaceAll(RegExp(r'[^0-9.]'), '');
      final cleanCurrent = currentVersion.replaceAll(RegExp(r'[^0-9.]'), '');

      final latestParts = cleanLatest.split('.').map((e) => int.tryParse(e) ?? 0).toList();
      final currentParts = cleanCurrent.split('.').map((e) => int.tryParse(e) ?? 0).toList();

      final maxLength = latestParts.length > currentParts.length ? latestParts.length : currentParts.length;
      while (latestParts.length < maxLength) {
        latestParts.add(0);
      }
      while (currentParts.length < maxLength) {
        currentParts.add(0);
      }

      for (int i = 0; i < maxLength; i++) {
        if (latestParts[i] > currentParts[i]) return true;
        if (latestParts[i] < currentParts[i]) return false;
      }
    } catch (_) {}

    return false;
  }

  /// Baixa o APK com notificação de progresso (0.0 a 1.0)
  Future<File?> downloadApk({
    required String downloadUrl,
    required void Function(double progress, int receivedBytes, int totalBytes) onProgress,
  }) async {
    if (downloadUrl.isEmpty) {
      throw Exception('URL de download do APK não informada.');
    }

    try {
      final client = http.Client();
      final request = http.Request('GET', Uri.parse(downloadUrl));
      final response = await client.send(request);

      if (response.statusCode != 200) {
        throw Exception('Falha ao iniciar download: HTTP ${response.statusCode}');
      }

      final totalBytes = response.contentLength ?? 0;
      int receivedBytes = 0;

      final tempDir = await getTemporaryDirectory();
      final apkFile = File('${tempDir.path}/app-update-cmoc.apk');
      if (await apkFile.exists()) {
        await apkFile.delete();
      }

      final sink = apkFile.openWrite();

      await for (final chunk in response.stream) {
        sink.add(chunk);
        receivedBytes += chunk.length;
        if (totalBytes > 0) {
          final progress = receivedBytes / totalBytes;
          onProgress(progress, receivedBytes, totalBytes);
        } else {
          onProgress(0.5, receivedBytes, 0);
        }
      }

      await sink.flush();
      await sink.close();
      client.close();

      return apkFile;
    } catch (e) {
      debugPrint('[AppUpdateService] Erro durante o download do APK: $e');
      rethrow;
    }
  }

  /// Instala o APK chamando o instalador nativo do Android
  Future<bool> installApk(File apkFile) async {
    if (!Platform.isAndroid) {
      debugPrint('[AppUpdateService] Instalação direta suportada apenas em Android.');
      return false;
    }

    try {
      final canInstall = await _channel.invokeMethod<bool>('canRequestPackageInstalls') ?? false;
      if (!canInstall) {
        // Abre as configurações para o usuário permitir instalar apps dessa fonte
        await _channel.invokeMethod('openInstallPermissionSettings');
      }

      final result = await _channel.invokeMethod<bool>('installApk', {
        'filePath': apkFile.path,
      });

      return result ?? false;
    } catch (e) {
      debugPrint('[AppUpdateService] Erro ao invocar instalador de APK: $e');
      return false;
    }
  }
}
