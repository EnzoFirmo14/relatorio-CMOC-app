import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../report_form/domain/entities/report_entity.dart';
import 'pdf_export_service.dart';

class WhatsAppExportService {
  final PdfExportService _pdfService;

  WhatsAppExportService({PdfExportService? pdfService})
      : _pdfService = pdfService ?? PdfExportService();

  String formatWhatsAppText(ReportEntity report) {
    final buffer = StringBuffer();
    buffer.writeln('📋 *RELATÓRIO DIÁRIO DE INFRAESTRUTURA - CMOC*');
    buffer.writeln('📅 Data: ${report.date.toString().split(' ')[0]}');
    buffer.writeln('⛏️ Mina/Local: ${report.globalLocation}');
    buffer.writeln('🔄 Turno: ${report.shift} — Turma: ${report.team}');
    buffer.writeln('🚜 Equipamento: ${report.globalEquipment}');
    buffer.writeln('');

    buffer.writeln('👥 *EXECUTANTES:*');
    for (final op in report.operators) {
      buffer.writeln('• ${op.name} (${op.registration})');
    }
    buffer.writeln('');

    buffer.writeln('📝 *ORDENS DE SERVIÇO:*');
    for (final os in report.workOrders) {
      buffer.writeln('📌 *OS ${os.number}* — ${os.location} (${os.startTime} às ${os.endTime})');
      buffer.writeln('Descrição: ${os.activities}');
      if (os.materialsUsed.isNotEmpty) {
        buffer.writeln('Materiais: ${os.materialsUsed.join(", ")}');
      }
      buffer.writeln('');
    }

    buffer.writeln('⚙️ *Gerado via App CMOC Infraestrutura*');
    return buffer.toString();
  }

  Future<void> shareReportViaWhatsApp(ReportEntity report) async {
    final text = formatWhatsAppText(report);
    final pdfBytes = await _pdfService.generateReportPdf(report);

    final tempDir = await getTemporaryDirectory();
    final fileName = 'Relatorio_CMOC_${report.date.toString().split(' ')[0]}_${report.shift}.pdf';
    final filePath = '${tempDir.path}/$fileName';
    final file = File(filePath);
    await file.writeAsBytes(pdfBytes);

    await Share.shareXFiles(
      [XFile(filePath)],
      text: text,
      subject: 'Relatório Diário de Infraestrutura CMOC',
    );
  }
}
