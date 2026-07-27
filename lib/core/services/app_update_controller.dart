import 'dart:async';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app_update_service.dart';

enum AppUpdateStatus {
  idle,
  checking,
  updateAvailable,
  downloading,
  validating,
  readyToInstall,
  installing,
  error,
}

class AppUpdateState {
  final AppUpdateStatus status;
  final UpdateInfo? updateInfo;
  final double downloadProgress;
  final String? errorMessage;
  final File? downloadedFile;
  final bool hasInstallPermission;

  AppUpdateState({
    required this.status,
    this.updateInfo,
    this.downloadProgress = 0.0,
    this.errorMessage,
    this.downloadedFile,
    this.hasInstallPermission = false,
  });

  AppUpdateState copyWith({
    AppUpdateStatus? status,
    UpdateInfo? updateInfo,
    double? downloadProgress,
    String? errorMessage,
    File? downloadedFile,
    bool? hasInstallPermission,
  }) {
    return AppUpdateState(
      status: status ?? this.status,
      updateInfo: updateInfo ?? this.updateInfo,
      downloadProgress: downloadProgress ?? this.downloadProgress,
      errorMessage: errorMessage ?? this.errorMessage,
      downloadedFile: downloadedFile ?? this.downloadedFile,
      hasInstallPermission: hasInstallPermission ?? this.hasInstallPermission,
    );
  }
}

class AppUpdateNotifier extends StateNotifier<AppUpdateState> {
  final AppUpdateService _service;

  AppUpdateNotifier(this._service) : super(AppUpdateState(status: AppUpdateStatus.idle));

  /// Inicia a busca por nova versão.
  Future<void> checkForUpdate() async {
    // Evita múltiplas requisições simultâneas
    if (state.status == AppUpdateStatus.checking || 
        state.status == AppUpdateStatus.downloading ||
        state.status == AppUpdateStatus.validating) {
      return;
    }

    state = state.copyWith(status: AppUpdateStatus.checking);
    try {
      final updateInfo = await _service.checkForUpdate();
      if (updateInfo != null) {
        final hasPerm = await _service.checkInstallPermission();
        state = AppUpdateState(
          status: AppUpdateStatus.updateAvailable,
          updateInfo: updateInfo,
          hasInstallPermission: hasPerm,
        );
      } else {
        state = AppUpdateState(status: AppUpdateStatus.idle);
      }
    } catch (e) {
      state = AppUpdateState(
        status: AppUpdateStatus.error,
        errorMessage: 'Falha ao verificar atualizações: $e',
      );
    }
  }

  /// Inicia o download e a validação do novo APK.
  Future<void> startDownload() async {
    final info = state.updateInfo;
    if (info == null) return;

    state = state.copyWith(
      status: AppUpdateStatus.downloading,
      downloadProgress: 0.0,
    );

    try {
      final file = await _service.downloadApk(
        info.apkUrl,
        onProgress: (progress) {
          state = state.copyWith(downloadProgress: progress);
        },
      );

      state = state.copyWith(status: AppUpdateStatus.validating);

      final isValid = await _service.validateIntegrity(file, info.sha256);
      if (!isValid) {
        state = state.copyWith(
          status: AppUpdateStatus.error,
          errorMessage: 'Falha na validação de integridade. O arquivo pode ter sido corrompido durante o download.',
        );
        return;
      }

      final hasPerm = await _service.checkInstallPermission();
      state = state.copyWith(
        status: AppUpdateStatus.readyToInstall,
        downloadedFile: file,
        hasInstallPermission: hasPerm,
      );
    } catch (e) {
      state = state.copyWith(
        status: AppUpdateStatus.error,
        errorMessage: 'Erro ao baixar atualização: $e',
      );
    }
  }

  /// Redireciona o usuário para conceder a permissão do Android de fontes desconhecidas
  Future<void> requestPermission() async {
    await _service.requestInstallPermission();
    // Polling rápido para verificar se a permissão foi concedida após o retorno do usuário
    for (int i = 0; i < 5; i++) {
      await Future.delayed(const Duration(milliseconds: 500));
      final hasPerm = await _service.checkInstallPermission();
      if (hasPerm) {
        state = state.copyWith(hasInstallPermission: true);
        break;
      }
    }
  }

  /// Dispara o instalador nativo do APK
  Future<void> install() async {
    final file = state.downloadedFile;
    if (file == null) return;

    final hasPerm = await _service.checkInstallPermission();
    if (!hasPerm) {
      state = state.copyWith(hasInstallPermission: false);
      return;
    }

    state = state.copyWith(status: AppUpdateStatus.installing);
    final success = await _service.installApk(file.path);
    if (!success) {
      state = state.copyWith(
        status: AppUpdateStatus.error,
        errorMessage: 'Falha ao iniciar o instalador nativo do Android.',
      );
    }
  }

  /// Reseta o estado para o modo inativo
  void reset() {
    state = AppUpdateState(status: AppUpdateStatus.idle);
  }
}

final appUpdateServiceProvider = Provider<AppUpdateService>((ref) {
  return AppUpdateService();
});

final appUpdateControllerProvider = StateNotifierProvider<AppUpdateNotifier, AppUpdateState>((ref) {
  final service = ref.watch(appUpdateServiceProvider);
  return AppUpdateNotifier(service);
});
