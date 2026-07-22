import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';

import '../../../report_form/domain/entities/report_entity.dart';
import '../../domain/services/pdf_export_service.dart';
import '../../domain/services/whatsapp_export_service.dart';

final pdfExportServiceProvider = Provider<PdfExportService>((ref) => PdfExportService());
final whatsappExportServiceProvider = Provider<WhatsAppExportService>((ref) => WhatsAppExportService(pdfService: ref.watch(pdfExportServiceProvider)));

class ExportState {
  final bool isGenerating;
  final String? errorMessage;
  final Uint8List? lastPdfBytes;

  ExportState({
    this.isGenerating = false,
    this.errorMessage,
    this.lastPdfBytes,
  });

  ExportState copyWith({
    bool? isGenerating,
    String? errorMessage,
    Uint8List? lastPdfBytes,
  }) {
    return ExportState(
      isGenerating: isGenerating ?? this.isGenerating,
      errorMessage: errorMessage,
      lastPdfBytes: lastPdfBytes ?? this.lastPdfBytes,
    );
  }
}

class ExportController extends StateNotifier<ExportState> {
  final PdfExportService _pdfService;
  final WhatsAppExportService _whatsappService;

  ExportController(this._pdfService, this._whatsappService) : super(ExportState());

  Future<Uint8List?> generatePdf(ReportEntity report) async {
    state = state.copyWith(isGenerating: true, errorMessage: null);
    try {
      final bytes = await _pdfService.generateReportPdf(report);
      state = state.copyWith(isGenerating: false, lastPdfBytes: bytes);
      return bytes;
    } catch (e) {
      state = state.copyWith(isGenerating: false, errorMessage: 'Erro ao gerar PDF: $e');
      return null;
    }
  }

  Future<void> shareWhatsApp(ReportEntity report) async {
    state = state.copyWith(isGenerating: true, errorMessage: null);
    try {
      await _whatsappService.shareReportViaWhatsApp(report);
      state = state.copyWith(isGenerating: false);
    } catch (e) {
      state = state.copyWith(isGenerating: false, errorMessage: 'Erro ao compartilhar: $e');
    }
  }

  Future<void> printPdf(ReportEntity report) async {
    state = state.copyWith(isGenerating: true, errorMessage: null);
    try {
      final bytes = await generatePdf(report);
      if (bytes != null) {
        await Printing.layoutPdf(
          onLayout: (format) async => bytes,
          name: 'Relatorio_CMOC_${report.date.toString().split(' ')[0]}',
        );
      }
      state = state.copyWith(isGenerating: false);
    } catch (e) {
      state = state.copyWith(isGenerating: false, errorMessage: 'Erro ao imprimir PDF: $e');
    }
  }

  Future<void> savePdfToStorage(ReportEntity report) async {
    state = state.copyWith(isGenerating: true, errorMessage: null);
    try {
      final bytes = await generatePdf(report);
      if (bytes != null) {
        if (kIsWeb) {
          // Na Web, compartilhamos o PDF (o plugin printing cuidará do download/compartilhamento)
          await Printing.sharePdf(
            bytes: bytes,
            filename: 'Relatorio_CMOC_${report.date.toString().split(' ')[0]}_${report.shift}.pdf',
          );
        } else {
          final dir = await getApplicationDocumentsDirectory();
          final fileName = 'Relatorio_CMOC_${report.date.toString().split(' ')[0]}_${report.shift}.pdf';
          final file = File('${dir.path}/$fileName');
          await file.writeAsBytes(bytes);
          
          await Share.shareXFiles(
            [XFile(file.path)],
            subject: 'Relatório PDF CMOC',
          );
        }
      }
      state = state.copyWith(isGenerating: false);
    } catch (e) {
      state = state.copyWith(isGenerating: false, errorMessage: 'Erro ao salvar PDF: $e');
    }
  }
}

final exportControllerProvider = StateNotifierProvider<ExportController, ExportState>((ref) {
  return ExportController(
    ref.watch(pdfExportServiceProvider),
    ref.watch(whatsappExportServiceProvider),
  );
});
