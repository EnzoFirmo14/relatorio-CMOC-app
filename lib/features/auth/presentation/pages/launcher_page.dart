import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../../../core/services/app_update_controller.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/cmoc_logo.dart';
import '../../../sync/presentation/controllers/sync_controller.dart';

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
    // Tenta sincronizar relatórios pendentes silenciosamente em segundo plano
    ref.read(syncControllerProvider.notifier).triggerSync();

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
        progressWidget = _buildPermissionTutorial(context, controller, mutedTextColor, isDark, isMandatory);
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

  Widget _buildPermissionTutorial(BuildContext context, dynamic controller, Color mutedTextColor, bool isDark, bool isMandatory) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Instrução Passo a Passo:',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                const SizedBox(height: 12),
                _buildTutorialStep(
                  '1',
                  'Toque no botão verde "Dar Permissão nas Configurações" abaixo.',
                  isDark,
                ),
                const SizedBox(height: 8),
                _buildTutorialStep(
                  '2',
                  'Ative a opção "Permitir desta fonte" (ou marque a chave ao lado do logotipo da CMOC).',
                  isDark,
                ),
                const SizedBox(height: 8),
                _buildTutorialStep(
                  '3',
                  'Clique no botão de voltar do seu celular para retornar a esta tela e concluir.',
                  isDark,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => controller.requestPermission(),
            icon: const Icon(Icons.security, size: 18),
            label: const Text('Dar Permissão nas Configurações'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.cmocGreen,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
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
  }

  Widget _buildTutorialStep(String number, String text, bool isDark) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 22,
          height: 22,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            color: AppTheme.primaryBlue,
            shape: BoxShape.circle,
          ),
          child: Text(
            number,
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.inter(
              fontSize: 13,
              height: 1.3,
              color: isDark ? AppTheme.textLight : AppTheme.textDark,
            ),
          ),
        ),
      ],
    );
  }
}
