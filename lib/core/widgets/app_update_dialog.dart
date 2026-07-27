import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/app_update_controller.dart';
import '../theme/app_theme.dart';

class AppUpdateDialog extends ConsumerWidget {
  const AppUpdateDialog({super.key});

  /// Apresenta o diálogo de atualização na tela.
  static Future<void> show(BuildContext context, {required bool isMandatory}) async {
    return showDialog(
      context: context,
      barrierDismissible: !isMandatory,
      builder: (context) => PopScope(
        canPop: !isMandatory,
        child: const AppUpdateDialog(),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(appUpdateControllerProvider);
    final controller = ref.read(appUpdateControllerProvider.notifier);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final cardBgColor = isDark ? AppTheme.cardColorDark : AppTheme.cardColorLight;
    final primaryTextColor = isDark ? AppTheme.textLight : AppTheme.textDark;
    final mutedTextColor = isDark ? AppTheme.textMutedDark : AppTheme.textMuted;
    final borderColor = isDark ? AppTheme.borderDark : AppTheme.borderLight;

    // Se por algum motivo o estado resetar para idle após a abertura, fecha o dialog
    if (state.status == AppUpdateStatus.idle) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pop();
      });
      return const SizedBox.shrink();
    }

    return Dialog(
      backgroundColor: cardBgColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: borderColor, width: 1.5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeader(context, state, isDark),
            const SizedBox(height: 20),
            _buildBody(context, state, primaryTextColor, mutedTextColor),
            const SizedBox(height: 24),
            _buildActions(context, state, controller),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, AppUpdateState state, bool isDark) {
    IconData icon;
    Color iconColor;
    String title;

    switch (state.status) {
      case AppUpdateStatus.checking:
        icon = Icons.sync_rounded;
        iconColor = AppTheme.primaryBlue;
        title = 'Verificando atualizações';
        break;
      case AppUpdateStatus.updateAvailable:
        icon = Icons.system_update_rounded;
        iconColor = AppTheme.accentBlue;
        title = 'Nova versão disponível!';
        break;
      case AppUpdateStatus.downloading:
        icon = Icons.downloading_rounded;
        iconColor = AppTheme.accentBlue;
        title = 'Baixando atualização';
        break;
      case AppUpdateStatus.validating:
        icon = Icons.verified_user_rounded;
        iconColor = AppTheme.cmocGreen;
        title = 'Validando integridade';
        break;
      case AppUpdateStatus.readyToInstall:
        if (!state.hasInstallPermission) {
          icon = Icons.security_rounded;
          iconColor = Colors.orange;
          title = 'Permissão necessária';
        } else {
          icon = Icons.check_circle_outline_rounded;
          iconColor = AppTheme.cmocGreen;
          title = 'Pronto para instalar';
        }
        break;
      case AppUpdateStatus.installing:
        icon = Icons.install_mobile_rounded;
        iconColor = AppTheme.primaryBlue;
        title = 'Instalando aplicativo';
        break;
      case AppUpdateStatus.error:
        icon = Icons.error_outline_rounded;
        iconColor = AppTheme.redAlert;
        title = 'Falha na atualização';
        break;
      default:
        icon = Icons.info_outline_rounded;
        iconColor = AppTheme.primaryBlue;
        title = 'Atualização';
    }

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            size: 40,
            color: iconColor,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          title,
          textAlign: TextAlign.center,
          style: GoogleFonts.outfit(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: isDark ? AppTheme.textLight : AppTheme.textDark,
          ),
        ),
      ],
    );
  }

  Widget _buildBody(BuildContext context, AppUpdateState state, Color primaryTextColor, Color mutedTextColor) {
    switch (state.status) {
      case AppUpdateStatus.checking:
        return const Center(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: CircularProgressIndicator(strokeWidth: 3),
          ),
        );

      case AppUpdateStatus.updateAvailable:
        final info = state.updateInfo!;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Versão disponível:',
                  style: GoogleFonts.inter(fontWeight: FontWeight.w600, color: mutedTextColor),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryBlue.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    '${info.version}+${info.buildNumber}',
                    style: GoogleFonts.firaCode(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryBlue,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (info.changelog.isNotEmpty) ...[
              Text(
                'Novidades nesta versão:',
                style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: primaryTextColor),
              ),
              const SizedBox(height: 6),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                constraints: const BoxConstraints(maxHeight: 100),
                decoration: BoxDecoration(
                  color: primaryTextColor.withValues(alpha: 0.03),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppTheme.borderLight.withValues(alpha: 0.5)),
                ),
                child: SingleChildScrollView(
                  child: Text(
                    info.changelog,
                    style: GoogleFonts.inter(fontSize: 13, color: mutedTextColor),
                  ),
                ),
              ),
            ],
            if (info.isMandatory) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(Icons.warning_amber_rounded, color: AppTheme.redAlert, size: 16),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      'Esta atualização é obrigatória para continuar utilizando o aplicativo.',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: AppTheme.redAlert,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        );

      case AppUpdateStatus.downloading:
        final percentage = (state.downloadProgress * 100).toInt();
        return Column(
          children: [
            LinearProgressIndicator(
              value: state.downloadProgress,
              backgroundColor: AppTheme.primaryBlue.withValues(alpha: 0.08),
              valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.cmocGreen),
              borderRadius: BorderRadius.circular(4),
              minHeight: 8,
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Fazendo download do arquivo...',
                  style: GoogleFonts.inter(fontSize: 13, color: mutedTextColor),
                ),
                Text(
                  '$percentage%',
                  style: GoogleFonts.firaCode(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryBlue,
                  ),
                ),
              ],
            ),
          ],
        );

      case AppUpdateStatus.validating:
        return Column(
          children: [
            const Center(
              child: CircularProgressIndicator(
                strokeWidth: 3,
                valueColor: AlwaysStoppedAnimation<Color>(AppTheme.cmocGreen),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Confirmando assinatura e hash SHA-256...',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(fontSize: 13, color: mutedTextColor),
            ),
          ],
        );

      case AppUpdateStatus.readyToInstall:
        if (!state.hasInstallPermission) {
          return Text(
            'Para continuar com a instalação, é necessário conceder permissão nativa do Android para que este aplicativo possa atualizar a si mesmo.',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(fontSize: 14, color: mutedTextColor),
          );
        } else {
          return Text(
            'Arquivo baixado e verificado com sucesso. Toque em "Instalar" para iniciar a instalação.',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(fontSize: 14, color: mutedTextColor),
          );
        }

      case AppUpdateStatus.installing:
        return Column(
          children: [
            const Center(child: CircularProgressIndicator(strokeWidth: 3)),
            const SizedBox(height: 16),
            Text(
              'Abrindo instalador nativo do sistema...',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(fontSize: 13, color: mutedTextColor),
            ),
          ],
        );

      case AppUpdateStatus.error:
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppTheme.redAlert.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppTheme.redAlert.withValues(alpha: 0.2)),
          ),
          child: Text(
            state.errorMessage ?? 'Ocorreu um erro desconhecido durante a atualização.',
            style: GoogleFonts.inter(fontSize: 13, color: AppTheme.redAlert),
          ),
        );

      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildActions(BuildContext context, AppUpdateState state, AppUpdateNotifier controller) {
    final info = state.updateInfo;
    final isMandatory = info?.isMandatory ?? false;

    if (state.status == AppUpdateStatus.checking ||
        state.status == AppUpdateStatus.downloading ||
        state.status == AppUpdateStatus.validating ||
        state.status == AppUpdateStatus.installing) {
      return const SizedBox.shrink();
    }

    if (state.status == AppUpdateStatus.error) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (!isMandatory)
            TextButton(
              onPressed: () {
                controller.reset();
                Navigator.of(context).pop();
              },
              child: const Text('Fechar'),
            ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: () {
              if (info != null) {
                controller.startDownload();
              } else {
                controller.checkForUpdate();
              }
            },
            child: const Text('Tentar novamente'),
          ),
        ],
      );
    }

    if (state.status == AppUpdateStatus.updateAvailable) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (!isMandatory)
            TextButton(
              onPressed: () {
                controller.reset();
                Navigator.of(context).pop();
              },
              child: const Text('Mais Tarde'),
            ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: () => controller.startDownload(),
            child: const Text('Atualizar Agora'),
          ),
        ],
      );
    }

    if (state.status == AppUpdateStatus.readyToInstall) {
      if (!state.hasInstallPermission) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (!isMandatory)
              TextButton(
                onPressed: () {
                  controller.reset();
                  Navigator.of(context).pop();
                },
                child: const Text('Cancelar'),
              ),
            const SizedBox(width: 8),
            ElevatedButton.icon(
              onPressed: () => controller.requestPermission(),
              icon: const Icon(Icons.settings_suggest_rounded, size: 18),
              label: const Text('Dar Permissão'),
            ),
          ],
        );
      } else {
        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (!isMandatory)
              TextButton(
                onPressed: () {
                  controller.reset();
                  Navigator.of(context).pop();
                },
                child: const Text('Cancelar'),
              ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: () => controller.install(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.cmocGreen,
              ),
              child: const Text('Instalar'),
            ),
          ],
        );
      }
    }

    return const SizedBox.shrink();
  }
}
