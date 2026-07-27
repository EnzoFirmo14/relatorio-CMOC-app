import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../../../core/services/app_update_controller.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/cmoc_logo.dart';

class LauncherPage extends ConsumerStatefulWidget {
  const LauncherPage({super.key});

  @override
  ConsumerState<LauncherPage> createState() => _LauncherPageState();
}

class _LauncherPageState extends ConsumerState<LauncherPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startCheck();
    });
  }

  void _startCheck() {
    ref.read(appUpdateControllerProvider.notifier).runAutomaticUpdateFlow(
      onNoUpdate: () {
        // Sem atualizações ou concluído: redireciona para a página de login
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/login');
        }
      },
      onPermissionRequired: () {
        // Permissão de fontes desconhecidas é necessária no Android
        debugPrint('[LauncherPage] Permissão de instalação necessária.');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(appUpdateControllerProvider);
    final controller = ref.read(appUpdateControllerProvider.notifier);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final primaryTextColor = isDark ? AppTheme.textLight : AppTheme.textDark;
    final mutedTextColor = isDark ? AppTheme.textMutedDark : AppTheme.textMuted;
    final isMandatory = state.updateInfo?.isMandatory ?? false;

    // Constrói os estados visuais
    String statusText = 'Carregando...';
    Widget progressWidget = const Center(
      child: CircularProgressIndicator(strokeWidth: 3),
    );

    if (state.status == AppUpdateStatus.checking) {
      statusText = 'Buscando atualizações...';
      progressWidget = const Center(
        child: CircularProgressIndicator(strokeWidth: 3),
      );
    } else if (state.status == AppUpdateStatus.downloading) {
      final pct = (state.downloadProgress * 100).toInt();
      statusText = 'Instalando atualizações... ($pct%)';
      progressWidget = Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40.0),
        child: Column(
          children: [
            LinearProgressIndicator(
              value: state.downloadProgress,
              backgroundColor: AppTheme.primaryBlue.withValues(alpha: 0.08),
              valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.cmocGreen),
              borderRadius: BorderRadius.circular(4),
              minHeight: 8,
            ),
            const SizedBox(height: 8),
            Text(
              'Por favor, não feche o aplicativo.',
              style: GoogleFonts.inter(fontSize: 12, color: mutedTextColor),
            ),
          ],
        ),
      );
    } else if (state.status == AppUpdateStatus.validating) {
      statusText = 'Validando assinatura...';
      progressWidget = const Center(
        child: CircularProgressIndicator(
          strokeWidth: 3,
          valueColor: AlwaysStoppedAnimation<Color>(AppTheme.cmocGreen),
        ),
      );
    } else if (state.status == AppUpdateStatus.readyToInstall) {
      if (!state.hasInstallPermission) {
        statusText = 'Permissão de instalação necessária';
        progressWidget = Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            children: [
              Text(
                'Para concluir a instalação da nova versão, habilite a permissão de fontes desconhecidas para este aplicativo.',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(fontSize: 13, color: mutedTextColor),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () => controller.requestPermission(),
                icon: const Icon(Icons.settings_suggest_rounded, size: 18),
                label: const Text('Dar Permissão nas Configurações'),
              ),
              if (!isMandatory) ...[
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
                  child: const Text('Pular e Entrar no App'),
                ),
              ],
            ],
          ),
        );
      } else {
        statusText = 'Pronto para instalar!';
        progressWidget = Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: ElevatedButton(
            onPressed: () => controller.install(),
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.cmocGreen),
            child: const Text('Iniciar Instalação'),
          ),
        );
      }
    } else if (state.status == AppUpdateStatus.installing) {
      statusText = 'Abrindo instalador nativo...';
      progressWidget = const Center(child: CircularProgressIndicator(strokeWidth: 3));
    } else if (state.status == AppUpdateStatus.error) {
      statusText = 'Ocorreu uma falha na atualização';
      progressWidget = Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Column(
          children: [
            Text(
              state.errorMessage ?? 'Erro de rede ou conexão.',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(fontSize: 13, color: AppTheme.redAlert),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (!isMandatory) ...[
                  OutlinedButton(
                    onPressed: () {
                      controller.reset();
                      Navigator.pushReplacementNamed(context, '/login');
                    },
                    child: const Text('Ignorar e Entrar'),
                  ),
                  const SizedBox(width: 12),
                ],
                ElevatedButton(
                  onPressed: () {
                    controller.reset();
                    _startCheck();
                  },
                  child: const Text('Tentar Novamente'),
                ),
              ],
            ),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logotipo CMOC centralizado
                    const CmocLogo(
                      showSubtitle: true,
                      height: 54.0,
                    ),
                    const SizedBox(height: 48),
                    
                    // Texto do status da operação
                    Text(
                      statusText,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.outfit(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: primaryTextColor,
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    // Widget dinâmico (Carregando, progresso ou botão)
                    progressWidget,
                  ],
                ),
              ),
            ),
            
            // Versão atual no rodapé
            Positioned(
              bottom: 16,
              left: 0,
              right: 0,
              child: FutureBuilder<String>(
                future: _getCurrentVersionString(),
                builder: (context, snapshot) {
                  return Text(
                    snapshot.data ?? '',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.firaCode(
                      fontSize: 10,
                      color: mutedTextColor.withValues(alpha: 0.5),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<String> _getCurrentVersionString() async {
    try {
      final pInfo = await PackageInfo.fromPlatform();
      return 'Versão instalada: ${pInfo.version}+${pInfo.buildNumber}';
    } catch (_) {
      return '';
    }
  }
}
