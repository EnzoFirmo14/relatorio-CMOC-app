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
      final activeInstance = Isar.getInstance('cmoc_db');
      if (activeInstance != null && activeInstance.isOpen) {
        _isar = activeInstance;
        return _isar!;
      }
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
      debugPrint('[IsarService] Falha na abertura do DB ($e). Realizando limpeza de esquema incompatível...');

      final currentInstance = Isar.getInstance(dbName);
      if (currentInstance != null) {
        try {
          await currentInstance.close();
        } catch (_) {}
      }

      if (!kIsWeb && dirPath != null) {
        await _deleteIsarFiles(dirPath, dbName);
      }

      await Future.delayed(const Duration(milliseconds: 300));

      // Tentativa final de abertura limpa do zero
      try {
        _isar = await Isar.open(
          [
            ReportModelSchema,
            CollaboratorModelSchema,
          ],
          directory: dirPath ?? '',
          name: dbName,
        );
      } catch (e2) {
        debugPrint('[IsarService] Erro persistente ao abrir Isar: $e2');
        rethrow;
      }
    }
  }

  /// Deleta os arquivos físicos do banco Isar com o nome dado se corrompidos.
  Future<void> _deleteIsarFiles(String dirPath, String dbName) async {
    if (kIsWeb) return;
    try {
      final dir = Directory(dirPath);
      if (await dir.exists()) {
        final list = dir.listSync();
        for (final entity in list) {
          if (entity is File) {
            final pathLower = entity.path.toLowerCase();
            final nameLower = entity.uri.pathSegments.last.toLowerCase();
            if (nameLower.contains(dbName.toLowerCase()) ||
                pathLower.endsWith('.isar') ||
                pathLower.endsWith('.isar-lck') ||
                pathLower.endsWith('.isar.lock') ||
                pathLower.endsWith('.isar.management')) {
              try {
                await entity.delete();
                debugPrint('[IsarService] Apagado arquivo corrompido do banco: ${entity.path}');
              } catch (e) {
                debugPrint('[IsarService] Erro ao deletar ${entity.path}: $e');
              }
            }
          }
        }
      }
    } catch (e) {
      debugPrint('[IsarService] Erro na limpeza de arquivos Isar: $e');
    }
  }

  /// Fecha a conexão com o banco. Útil em testes.
  Future<void> close() async {
    await _isar?.close();
    _isar = null;
  }
}
