import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:isar_community/isar.dart';
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
    const dbName = 'cmoc_db';

    // 1. Se o banco já estiver aberto no Isar neste isolate, reutiliza a instância.
    final activeInstance = Isar.getInstance(dbName);
    if (activeInstance != null && activeInstance.isOpen) {
      _isar = activeInstance;
      return;
    }

    if (isInitialized) return;

    String? dirPath;
    if (!kIsWeb) {
      final dir = await getApplicationDocumentsDirectory();
      dirPath = dir.path;
    }

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
      debugPrint('[IsarService] Falha na primeira tentativa de abrir DB ($e). Realizando cleanup da instância...');

      // Fecha a instância que falhou para tirá-la do cache interno do Isar
      // e evitar que as próximas chamadas a Isar.open apenas retornem a instância corrompida.
      final currentInstance = Isar.getInstance(dbName);
      if (currentInstance != null) {
        try {
          await currentInstance.close();
        } catch (_) {}
      }

      // Aguarda 500ms para o caso de concorrência com outro isolate (ex: Workmanager)
      await Future.delayed(const Duration(milliseconds: 500));

      // Tenta recuperar se o outro isolate terminou de abrir com sucesso
      final activeInstance = Isar.getInstance(dbName);
      if (activeInstance != null && activeInstance.isOpen) {
        _isar = activeInstance;
        return;
      }

      // Segunda tentativa de abertura (após o delay e limpeza da instância da memória)
      try {
        _isar = await Isar.open(
          [
            ReportModelSchema,
            CollaboratorModelSchema,
          ],
          directory: dirPath ?? '',
          name: dbName,
        );
        return; // Sucesso no retry por concorrência
      } catch (e2) {
        debugPrint('[IsarService] Segunda tentativa falhou ($e2). Assumindo incompatibilidade de esquema e limpando.');

        // Fecha a instância novamente
        final currentInstance2 = Isar.getInstance(dbName);
        if (currentInstance2 != null) {
          try {
            await currentInstance2.close();
          } catch (_) {}
        }

        if (!kIsWeb && dirPath != null) {
          await _deleteIsarFiles(dirPath, dbName);
        }

        // Terceira tentativa (abertura limpa do zero)
        try {
          _isar = await Isar.open(
            [
              ReportModelSchema,
              CollaboratorModelSchema,
            ],
            directory: dirPath ?? '',
            name: dbName,
          );
        } catch (e3) {
          debugPrint('[IsarService] Erro crítico persistente após limpeza: $e3');
          rethrow;
        }
      }
    }
  }

  /// Deleta os arquivos físicos do banco Isar com o nome dado.
  Future<void> _deleteIsarFiles(String dirPath, String dbName) async {
    if (kIsWeb) return;
    for (final fileName in [
      '$dbName.isar',
      '$dbName.isar.lock',
      '$dbName.isar.management',
    ]) {
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
