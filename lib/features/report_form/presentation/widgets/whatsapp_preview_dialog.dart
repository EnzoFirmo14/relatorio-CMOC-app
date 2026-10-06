import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/theme/app_theme.dart';

class WhatsappPreviewDialog extends StatefulWidget {
  final String formattedText;

  const WhatsappPreviewDialog({
    super.key,
    required this.formattedText,
  });

  @override
  State<WhatsappPreviewDialog> createState() => _WhatsappPreviewDialogState();
}

class _WhatsappPreviewDialogState extends State<WhatsappPreviewDialog> {
  bool _copied = false;
  bool _sent = false;

  @override
  void initState() {
    super.initState();
    // Auto-copia o texto ao abrir o dialog
    Clipboard.setData(ClipboardData(text: widget.formattedText));
  }

  void _copyToClipboard() {
    Clipboard.setData(ClipboardData(text: widget.formattedText));
    setState(() => _copied = true);
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _copied = false);
    });
  }

  Future<void> _shareViaWhatsApp() async {
    final encoded = Uri.encodeComponent(widget.formattedText);

    // Garante que o texto esteja na área de transferência antes de abrir
    await Clipboard.setData(ClipboardData(text: widget.formattedText));

    bool launched = false;

    // 1. Tenta abrir o app nativo no Android/iOS diretamente via deep link
    if (!kIsWeb) {
      try {
        final nativeUri = Uri.parse('whatsapp://send?text=$encoded');
        launched = await launchUrl(nativeUri, mode: LaunchMode.externalApplication);
      } catch (e) {
        debugPrint('[WhatsappPreviewDialog] Falha ao abrir deep link nativo: $e');
      }
    }

    // 2. Se falhar ou for Web, usa wa.me / api.whatsapp.com
    if (!launched) {
      try {
        final webUri = Uri.parse('https://wa.me/?text=$encoded');
        launched = await launchUrl(webUri, mode: LaunchMode.externalApplication);
      } catch (e) {
        debugPrint('[WhatsappPreviewDialog] Falha ao abrir link web: $e');
      }
    }

    if (!launched) {
      try {
        final fallbackUri = Uri.parse('https://api.whatsapp.com/send?text=$encoded');
        launched = await launchUrl(fallbackUri, mode: LaunchMode.externalApplication);
      } catch (_) {}
    }

    if (!mounted) return;

    // Independente do launcher, o texto já está copiado e o relatório foi salvo.
    // Atualiza para o card de confirmação pós-envio
    setState(() => _sent = true);

    if (!launched) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            '⚠️ Se o WhatsApp não abriu automaticamente, o texto já foi copiado. Abra o WhatsApp e cole.',
          ),
          duration: Duration(seconds: 5),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppTheme.cardColorLight,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
        side: const BorderSide(color: AppTheme.borderLight),
      ),
      child: _sent ? _buildSentConfirmation() : _buildPreview(context),
    );
  }

  // ─── Tela de confirmação pós-envio ──────────────────────────────────────────
  Widget _buildSentConfirmation() {
    return Padding(
      padding: const EdgeInsets.all(28.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.check_circle_rounded, color: Color(0xFF25D366), size: 72),
          const SizedBox(height: 16),
          const Text(
            'Relatório Enviado!',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppTheme.textDark,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'O WhatsApp foi aberto com o relatório pronto.\n'
            'O texto também está na área de transferência caso precise colar novamente.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: AppTheme.textMuted),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => setState(() => _sent = false),
                  child: const Text('Ver Texto'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF23005B),
                  ),
                  child: const Text('Fechar'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ─── Preview do texto do relatório ─────────────────────────────────────────
  Widget _buildPreview(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Cabeçalho
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Relatório Pronto ✅',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textDark,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, color: AppTheme.textMuted),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 4),
          // Banner de auto-cópia
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF25D366).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Row(
              children: [
                Icon(Icons.copy_all, size: 14, color: Color(0xFF25D366)),
                SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'Texto copiado automaticamente. Toque em "Abrir WhatsApp" e cole na conversa.',
                    style: TextStyle(fontSize: 12, color: Color(0xFF1a8a45)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // Preview do texto com altura limitada e scroll
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.38,
              minHeight: 80,
            ),
            child: Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: AppTheme.borderLight),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: SingleChildScrollView(
                child: Text(
                  widget.formattedText,
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 12.0,
                    color: AppTheme.textDark,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),
          // Botões de ação
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _copyToClipboard,
                  icon: Icon(
                    _copied ? Icons.check : Icons.copy,
                    size: 16,
                    color: _copied ? const Color(0xFF25D366) : null,
                  ),
                  label: Text(
                    _copied ? 'Copiado!' : 'Copiar',
                    style: TextStyle(
                      color: _copied ? const Color(0xFF25D366) : null,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 2,
                child: ElevatedButton.icon(
                  onPressed: _shareViaWhatsApp,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF25D366),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  icon: const Icon(Icons.send, size: 18),
                  label: const Text(
                    'Abrir WhatsApp',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

