import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_teste_1/features/export/domain/services/pdf_export_service.dart';
import 'package:flutter_teste_1/features/report_form/domain/entities/collaborator_entity.dart';
import 'package:flutter_teste_1/features/report_form/domain/entities/report_entity.dart';
import 'package:flutter_teste_1/features/report_form/domain/entities/work_order_entity.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('PdfExportService Tests', () {
    late PdfExportService pdfService;

    setUp(() {
      pdfService = PdfExportService();
    });

    test('Deve gerar bytes de documento PDF valido a partir do ReportEntity', () async {
      final mockReport = ReportEntity(
        uuid: 'test-pdf-uuid',
        date: DateTime(2026, 7, 19),
        globalLocation: 'Mina Subterrânea A',
        shift: 'Turno A',
        team: 'Turma Infra 01',
        globalEquipment: 'Carregadeira CAT R1300G',
        createdAt: DateTime(2026, 7, 19),
        updatedAt: DateTime(2026, 7, 19),
        operators: const [
          CollaboratorEntity(id: 'col-1', name: 'Paulo Tarso', registration: '12345'),
          CollaboratorEntity(id: 'col-2', name: 'Carlos Silva', registration: '67890'),
        ],
        workOrders: const [
          WorkOrderEntity(
            id: 'os-1',
            number: '9988',
            location: 'Galeria 4',
            startTime: '07:00',
            endTime: '12:00',
            activities: 'Troca de encanamento de ventilação na Galeria 4.',
            materialsUsed: ['Tubo de Aço 3 polegadas (4 un)'],
          ),
        ],
      );

      final pdfBytes = await pdfService.generateReportPdf(mockReport);

      expect(pdfBytes, isNotNull);
      expect(pdfBytes.isNotEmpty, isTrue);
      expect(pdfBytes.length, greaterThan(1000));
    });
  });
}
