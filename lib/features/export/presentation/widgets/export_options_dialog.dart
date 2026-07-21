import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:printing/printing.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../report_form/domain/entities/report_entity.dart';
import '../controllers/export_controller.dart';

class ExportOptionsDialog extends ConsumerWidget {
  final ReportEntity report;

  const ExportOptionsDialog({
    super.key,
    required this.report,
  });

  static void show(BuildContext context, ReportEntity report) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => ExportOptionsDialog(report: report),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final exportState = ref.watch(exportControllerProvider);
    final controller = ref.read(exportControllerProvider.notifier);

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.picture_as_pdf, color: AppTheme.primaryBlue, size: 24),
                  SizedBox(width: 8),
                  Text(
                    'Exportar Relatório',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryBlue,
                    ),
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.close, color: AppTheme.textMuted),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 6),
          const Text(
            'Escolha a forma como deseja emitir e compartilhar o relatório:',
            style: TextStyle(fontSize: 13, color: AppTheme.textMuted),
          ),
          const SizedBox(height: 16),

          if (exportState.isGenerating)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 24.0),
              child: Center(
                child: Column(
                  children: [
                    CircularProgressIndicator(color: AppTheme.primaryBlue),
                    SizedBox(height: 12),
                    Text(
                      'Gerando documento PDF CMOC...',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppTheme.primaryBlue),
                    ),
                  ],
                ),
              ),
            )
          else ...[
            // OPÇÃO 1: VISUALIZAR / BAIXAR PDF
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryBlue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              icon: const Icon(Icons.picture_as_pdf_outlined),
              label: const Text('Visualizar e Baixar PDF'),
              onPressed: () async {
                final pdfBytes = await controller.generatePdf(report);
                if (pdfBytes != null && context.mounted) {
                  Navigator.pop(context);
                  await Printing.layoutPdf(
                    onLayout: (format) async => pdfBytes,
                    name: 'Relatorio_CMOC_${report.date.toString().split(' ')[0]}',
                  );
                }
              },
            ),
            const SizedBox(height: 10),

            // OPÇÃO 2: COMPARTILHAR WHATSAPP
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.cmocGreen,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              icon: const Icon(Icons.share_rounded),
              label: const Text('Compartilhar WhatsApp (Texto + PDF)'),
              onPressed: () async {
                Navigator.pop(context);
                await controller.shareWhatsApp(report);
              },
            ),
            const SizedBox(height: 10),

            // OPÇÃO 3: IMPRIMIR DIRETO
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                foregroundColor: AppTheme.primaryBlue,
                side: const BorderSide(color: AppTheme.borderLight, width: 1.5),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              icon: const Icon(Icons.print_rounded),
              label: const Text('Imprimir Documento'),
              onPressed: () async {
                Navigator.pop(context);
                await controller.printPdf(report);
              },
            ),
          ],
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
