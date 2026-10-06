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
  ///
  /// ATENÇÃO: Nunca usa [Isar.getInstance()] pois retorna a instância sem
  /// inicializar os [late] fields de collection (_collections), causando
  /// [LateInitializationError] ao acessar [isar.reportModels], etc.
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
  /// IMPORTANTE: Nunca reutiliza instâncias via Isar.getInstance() pois
  /// as collections (_collections) não são registradas ao recuperar uma
  /// instância existente de outro contexto, causando LateInitializationError.
  Future<void> init() async {
    if (kIsWeb) return;
    const dbName = 'cmoc_db';

    // Se já temos uma instância aberta E funcional neste contexto, não reinicia.
    if (_isar != null && _isar!.isOpen) return;

    // Fecha qualquer instância existente do Isar neste isolate antes de abrir.
    final existingInstance = Isar.getInstance(dbName);
    if (existingInstance != null) {
      try {
        await existingInstance.close();
      } catch (_) {}
    }

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
      debugPrint('[IsarService] Banco Isar aberto com sucesso.');
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
        debugPrint('[IsarService] Banco Isar aberto com sucesso após limpeza.');
      } catch (e2) {
        debugPrint('[IsarService] Erro persistente ao abrir Isar: $e2');
        rethrow;
      }
    }
  }

  /// Garante que o Isar esteja inicializado. Se não estiver, chama [init()].
  /// Use este método sempre que precisar acessar o Isar de forma segura
  /// sem garantia prévia de inicialização.
  Future<Isar> ensureInitialized() async {
    if (_isar == null || !_isar!.isOpen) {
      await init();
    }
    return _isar!;
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
