import 'dart:io';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../../report_form/domain/entities/report_entity.dart';

class PdfExportService {
  Future<Uint8List> generateReportPdf(ReportEntity report) async {
    final pdf = pw.Document();

    // Carregar logo do arquivo se disponível
    pw.MemoryImage? logoImage;
    try {
      final logoBytes = await rootBundle.load('assets/images/cmoc_icon.png');
      logoImage = pw.MemoryImage(logoBytes.buffer.asUint8List());
    } catch (_) {}

    // Carregar fotos locais anexadas
    final List<pw.MemoryImage> photoImages = [];
    for (final os in report.workOrders) {
      for (final path in os.photoPaths) {
        try {
          final file = File(path);
          if (file.existsSync()) {
            final bytes = await file.readAsBytes();
            photoImages.add(pw.MemoryImage(bytes));
          }
        } catch (_) {}
      }
    }

    // Definir cores oficiais CMOC para o PDF
    const primaryBlue = PdfColor.fromInt(0xFF0F4C81);
    const cmocGreen = PdfColor.fromInt(0xFF00A859);
    const darkText = PdfColor.fromInt(0xFF0D253A);
    const lightBg = PdfColor.fromInt(0xFFF4F7FA);
    const borderGrey = PdfColor.fromInt(0xFFD0DCE5);

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        header: (context) => pw.Column(
          children: [
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.center,
                  children: [
                    if (logoImage != null)
                      pw.Container(
                        width: 42,
                        height: 42,
                        child: pw.Image(logoImage),
                      ),
                    if (logoImage != null) pw.SizedBox(width: 10),
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          'CMOC BRASIL',
                          style: pw.TextStyle(
                            fontSize: 16,
                            fontWeight: pw.FontWeight.bold,
                            color: primaryBlue,
                          ),
                        ),
                        pw.Text(
                          'MINERAÇÃO & INFRAESTRUTURA',
                          style: const pw.TextStyle(
                            fontSize: 9,
                            color: cmocGreen,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    pw.Text(
                      'RELATÓRIO DIÁRIO DE CAMPO',
                      style: pw.TextStyle(
                        fontSize: 12,
                        fontWeight: pw.FontWeight.bold,
                        color: primaryBlue,
                      ),
                    ),
                    pw.Text(
                      'Data: ${report.date.toString().split(' ')[0]}',
                      style: const pw.TextStyle(fontSize: 10, color: darkText),
                    ),
                  ],
                ),
              ],
            ),
            pw.SizedBox(height: 8),
            pw.Divider(color: primaryBlue, thickness: 1.5),
            pw.SizedBox(height: 12),
          ],
        ),
        footer: (context) => pw.Column(
          children: [
            pw.Divider(color: borderGrey, thickness: 0.5),
            pw.SizedBox(height: 4),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text(
                  'CMOC Infraestrutura Subterrânea - Documento Oficial',
                  style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey700),
                ),
                pw.Text(
                  'Página ${context.pageNumber} de ${context.pagesCount}',
                  style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold, color: primaryBlue),
                ),
              ],
            ),
          ],
        ),
        build: (context) => [
          // ─── 1. RESUMO OPERACIONAL DE CABEÇALHO ─────────────────────────────
          pw.Container(
            padding: const pw.EdgeInsets.all(10),
            decoration: pw.BoxDecoration(
              color: lightBg,
              border: pw.Border.all(color: borderGrey, width: 0.8),
              borderRadius: const pw.BorderRadius.all(pw.Radius.circular(6)),
            ),
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                _pdfInfoBox('Mina / Local', report.globalLocation.isNotEmpty ? report.globalLocation : 'N/A'),
                _pdfInfoBox('Turno', report.shift.isNotEmpty ? report.shift : 'N/A'),
                _pdfInfoBox('Turma', report.team.isNotEmpty ? report.team : 'N/A'),
                _pdfInfoBox('Equipamento', report.globalEquipment.isNotEmpty ? report.globalEquipment : 'N/A'),
              ],
            ),
          ),
          pw.SizedBox(height: 16),

          // ─── 2. EXECUTANTES DA EQUIPE ─────────────────────────────────────
          pw.Text(
            'EXECUTANTES DA EQUIPE',
            style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold, color: primaryBlue),
          ),
          pw.SizedBox(height: 6),
          pw.TableHelper.fromTextArray(
            headers: ['#', 'Nome do Colaborador', 'Matrícula'],
            data: List.generate(
              report.operators.length,
              (index) {
                final op = report.operators[index];
                return ['${index + 1}', op.name, op.registration];
              },
            ),
            headerStyle: pw.TextStyle(color: PdfColors.white, fontWeight: pw.FontWeight.bold, fontSize: 9),
            headerDecoration: const pw.BoxDecoration(color: primaryBlue),
            cellHeight: 20,
            cellStyle: const pw.TextStyle(fontSize: 9),
          ),
          pw.SizedBox(height: 16),

          // ─── 3. ORDENS DE SERVIÇO (OS) ────────────────────────────────────
          pw.Text(
            'ORDENS DE SERVIÇO REALIZADAS',
            style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold, color: primaryBlue),
          ),
          pw.SizedBox(height: 6),
          ...report.workOrders.map((os) {
            return pw.Container(
              margin: const pw.EdgeInsets.only(bottom: 12),
              padding: const pw.EdgeInsets.all(10),
              decoration: pw.BoxDecoration(
                border: pw.Border.all(color: borderGrey, width: 0.8),
                borderRadius: const pw.BorderRadius.all(pw.Radius.circular(6)),
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text(
                        'OS Nº: ${os.number.isNotEmpty ? os.number : "S/N"} - Local: ${os.location.isNotEmpty ? os.location : "N/A"}',
                        style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold, color: primaryBlue),
                      ),
                      pw.Text(
                        'Horário: ${os.startTime} às ${os.endTime}',
                        style: const pw.TextStyle(fontSize: 9, color: darkText),
                      ),
                    ],
                  ),
                  pw.SizedBox(height: 4),
                  pw.Text(
                    'Atividades Realizadas:',
                    style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold, color: cmocGreen),
                  ),
                  pw.Text(
                    os.activities.isNotEmpty ? os.activities : 'Nenhuma descrição fornecida.',
                    style: const pw.TextStyle(fontSize: 9),
                  ),
                  if (os.materialsUsed.isNotEmpty) ...[
                    pw.SizedBox(height: 6),
                    pw.Text(
                      'Materiais Utilizados: ${os.materialsUsed.join(", ")}',
                      style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold, color: darkText),
                    ),
                  ],
                ],
              ),
            );
          }),

          // ─── 4. ANEXO FOTOGRÁFICO ─────────────────────────────────────────
          if (photoImages.isNotEmpty) ...[
            pw.SizedBox(height: 12),
            pw.Text(
              'ANEXO FOTOGRÁFICO DE CAMPO',
              style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold, color: primaryBlue),
            ),
            pw.SizedBox(height: 8),
            pw.Wrap(
              spacing: 12,
              runSpacing: 12,
              children: photoImages.map((img) {
                return pw.Container(
                  width: 230,
                  height: 160,
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(color: borderGrey, width: 1),
                    borderRadius: const pw.BorderRadius.all(pw.Radius.circular(4)),
                  ),
                  child: pw.Image(img, fit: pw.BoxFit.cover),
                );
              }).toList(),
            ),
          ],

          // ─── 5. CAMPO DE ASSINATURA ──────────────────────────────────────
          pw.SizedBox(height: 24),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
            children: [
              pw.Column(
                children: [
                  pw.Container(width: 180, height: 1, color: darkText),
                  pw.SizedBox(height: 4),
                  pw.Text('Assinatura do Executante', style: const pw.TextStyle(fontSize: 8)),
                ],
              ),
              pw.Column(
                children: [
                  pw.Container(width: 180, height: 1, color: darkText),
                  pw.SizedBox(height: 4),
                  pw.Text('Assinatura do Supervisor CMOC', style: const pw.TextStyle(fontSize: 8)),
                ],
              ),
            ],
          ),
        ],
      ),
    );

    return pdf.save();
  }

  pw.Widget _pdfInfoBox(String label, String value) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(label, style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey700)),
        pw.Text(value, style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold)),
      ],
    );
  }
}
