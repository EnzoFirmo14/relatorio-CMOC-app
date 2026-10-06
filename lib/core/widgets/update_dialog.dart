import 'package:flutter/material.dart';
import '../services/app_update_service.dart';

class UpdateDialog extends StatefulWidget {
  final AppReleaseInfo releaseInfo;

  const UpdateDialog({
    super.key,
    required this.releaseInfo,
  });

  static Future<void> show(BuildContext context, AppReleaseInfo releaseInfo) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: !releaseInfo.forceUpdate,
      builder: (context) => UpdateDialog(releaseInfo: releaseInfo),
    );
  }

  @override
  State<UpdateDialog> createState() => _UpdateDialogState();
}

class _UpdateDialogState extends State<UpdateDialog> {
  final _updateService = AppUpdateService();

  bool _isDownloading = false;
  double _progress = 0.0;
  String _statusMessage = '';
  String? _errorMessage;

  // Cores CMOC
  static const Color cmocPrimary = Color(0xFF23005B);
  static const Color cmocPurple = Color(0xFF5C3FA3);
  static const Color cmocGreen = Color(0xFF74BE45);

  Future<void> _startUpdate() async {
    setState(() {
      _isDownloading = true;
      _errorMessage = null;
      _progress = 0.0;
      _statusMessage = 'Iniciando download do pacote...';
    });

    try {
      final apkFile = await _updateService.downloadApk(
        downloadUrl: widget.releaseInfo.downloadUrl,
        onProgress: (progress, received, total) {
          if (mounted) {
            setState(() {
              _progress = progress;
              if (total > 0) {
                final mbReceived = (received / (1024 * 1024)).toStringAsFixed(1);
                final mbTotal = (total / (1024 * 1024)).toStringAsFixed(1);
                _statusMessage = 'Baixando: $mbReceived MB / $mbTotal MB (${(progress * 100).toInt()}%)';
              } else {
                final mbReceived = (received / (1024 * 1024)).toStringAsFixed(1);
                _statusMessage = 'Baixando: $mbReceived MB...';
              }
            });
          }
        },
      );

      if (apkFile != null && await apkFile.exists()) {
        setState(() {
          _statusMessage = 'Abrindo instalador...';
        });

        final installed = await _updateService.installApk(apkFile);
        if (!installed && mounted) {
          setState(() {
            _errorMessage = 'Abra as configurações e autorize a instalação de fontes desconhecidas.';
            _isDownloading = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isDownloading = false;
          _errorMessage = 'Falha ao baixar atualização: $e';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? const Color(0xFF111827) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF1F2937);
    final secondaryText = isDark ? Colors.white70 : const Color(0xFF6B7280);

    return PopScope(
      canPop: !widget.releaseInfo.forceUpdate && !_isDownloading,
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: cardBg,
        elevation: 16,
        insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 420),
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Cabeçalho com Ícone e Badges
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [cmocPrimary, cmocPurple],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: cmocPurple.withValues(alpha: 0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.system_update_rounded,
                        color: Colors.white,
                        size: 26,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Nova Versão Disponível',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            spacing: 6,
                            runSpacing: 4,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: cmocGreen.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(color: cmocGreen.withValues(alpha: 0.4)),
                                ),
                                child: Text(
                                  widget.releaseInfo.latestVersion,
                                  style: const TextStyle(
                                    color: cmocGreen,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Text(
                                '(Atual: ${widget.releaseInfo.currentVersion})',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: secondaryText,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 18),

                // Informações das Novidades
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF5F7FA),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isDark ? Colors.white10 : const Color(0xFFE5E7EB),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.info_outline_rounded,
                            size: 16,
                            color: isDark ? Colors.white70 : cmocPurple,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Notas da Versão:',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: textColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxHeight: 120),
                        child: SingleChildScrollView(
                          child: Text(
                            widget.releaseInfo.releaseNotes.isNotEmpty
                                ? widget.releaseInfo.releaseNotes
                                : 'Atualização recomendada com melhorias operacionais e correções para os relatórios CMOC.',
                            style: TextStyle(
                              fontSize: 13,
                              color: textColor.withValues(alpha: 0.85),
                              height: 1.4,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                if (_errorMessage != null) ...[
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.error_outline, color: Colors.red, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _errorMessage!,
                            style: const TextStyle(color: Colors.red, fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                const SizedBox(height: 20),

                // Progresso ou Botões
                if (_isDownloading) ...[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(
                          value: _progress > 0 ? _progress : null,
                          backgroundColor: isDark ? Colors.white12 : const Color(0xFFE5E7EB),
                          valueColor: const AlwaysStoppedAnimation<Color>(cmocGreen),
                          minHeight: 10,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _statusMessage,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: secondaryText,
                        ),
                      ),
                    ],
                  ),
                ] else ...[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(
                        height: 48,
                        child: ElevatedButton.icon(
                          onPressed: _startUpdate,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: cmocPrimary,
                            foregroundColor: Colors.white,
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          icon: const Icon(Icons.download_rounded, size: 20),
                          label: const Text(
                            'Atualizar Agora',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ),
                      ),
                      if (!widget.releaseInfo.forceUpdate) ...[
                        const SizedBox(height: 6),
                        SizedBox(
                          height: 40,
                          child: TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            style: TextButton.styleFrom(
                              foregroundColor: secondaryText,
                            ),
                            child: const Text(
                              'Lembrar Mais Tarde',
                              style: TextStyle(fontSize: 13),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
