import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import '../../features/report_form/data/models/collaborator_model.dart';
import '../../features/report_form/data/models/report_model.dart';

/// Serviço singleton para gerenciar o ciclo de vida da conexão com o Isar.
///
/// Deve ser inicializado uma única vez no [main()] antes de construir a UI.
/// Após a inicialização, a instância é acessível via [IsarService.instance].
class IsarService {
  IsarService._internal();

  static final IsarService _instance = IsarService._internal();

  static IsarService get instance => _instance;

  Isar? _isar;

  /// Retorna a instância do banco. Lança [StateError] se não inicializado.
  Isar get isar {
    if (_isar == null || !_isar!.isOpen) {
      throw StateError(
        'IsarService não foi inicializado. '
        'Chame IsarService.instance.init() antes de usar.',
      );
    }
    return _isar!;
  }

  bool get isInitialized => _isar != null && _isar!.isOpen;

  /// Inicializa o banco de dados Isar no diretório de documentos do app.
  /// Deve ser chamado no [main()] antes de [runApp].
  ///
  /// Se o banco existente tiver schema incompatível (ex: após troca de pacote
  /// ou alteração de modelo), deleta o arquivo antigo e recria do zero.
  Future<void> init() async {
    if (kIsWeb) return;
    if (isInitialized) return;

    String? dirPath;
    if (!kIsWeb) {
      final dir = await getApplicationDocumentsDirectory();
      dirPath = dir.path;
    }
    const dbName = 'cmoc_db';

    try {
      _isar = await Isar.open(
        [
          ReportModelSchema,
          CollaboratorModelSchema,
        ],
        directory: dirPath ?? '',
        name: dbName,
      );
    } catch (e) {
      // Schema incompatível ou arquivo corrompido — apaga e recria do zero.
      // Dados locais não sincronizados serão perdidos, mas o app não crasha.
      debugPrint('[IsarService] Falha ao abrir DB ($e) — recriando do zero.');
      if (!kIsWeb && dirPath != null) {
        await _deleteIsarFiles(dirPath, dbName);
      }
      _isar = await Isar.open(
        [
          ReportModelSchema,
          CollaboratorModelSchema,
        ],
        directory: dirPath ?? '',
        name: dbName,
      );
    }
  }

  /// Deleta os arquivos físicos do banco Isar com o nome dado.
  Future<void> _deleteIsarFiles(String dirPath, String dbName) async {
    if (kIsWeb) return;
    for (final fileName in ['$dbName.isar', '$dbName.isar.lock']) {
      final file = File('$dirPath/$fileName');
      try {
        if (await file.exists()) await file.delete();
      } catch (_) {
        // Silently ignore — arquivo pode não existir.
      }
    }
  }

  /// Fecha a conexão com o banco. Útil em testes.
  Future<void> close() async {
    await _isar?.close();
    _isar = null;
  }
}
