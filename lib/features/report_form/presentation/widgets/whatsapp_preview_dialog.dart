import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
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

  void _copyToClipboard() {
    Clipboard.setData(ClipboardData(text: widget.formattedText));
    setState(() {
      _copied = true;
    });
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _copied = false;
        });
      }
    });
  }

  void _shareViaWhatsApp() {
    // Compartilha o texto nativamente
    // share_plus aciona a sheet nativa do Android, o operador seleciona o WhatsApp/outro app de comunicacao
    Share.share(widget.formattedText);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppTheme.cardColorLight,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
        side: const BorderSide(color: AppTheme.borderLight),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Relatório Pronto',
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
            const SizedBox(height: 8),
            const Text(
              'O texto já foi copiado automaticamente. Toque em "Enviar pelo WhatsApp" e cole na conversa do WhatsApp.',
              style: TextStyle(
                fontSize: 13.0,
                color: AppTheme.textMuted,
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
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
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _copyToClipboard,
                    child: Text(_copied ? 'Copiado!' : 'Copiar Texto'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: _shareViaWhatsApp,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF25D366), // WhatsApp Green
                    ),
                    child: const Text('Enviar WhatsApp'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
