import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_teste_1/core/services/app_update_service.dart';

void main() {
  late AppUpdateService service;

  setUp(() {
    service = AppUpdateService();
  });

  group('Comparação de Versões Semânticas (SemVer)', () {
    test('Deve retornar true se a versão remota de PATCH for maior', () {
      final result = service.shouldUpdate(
        current: '1.0.0',
        latest: '1.0.1',
        currentBuild: 1,
        latestBuild: 1,
      );
      expect(result, isTrue);
    });

    test('Deve retornar true se a versão remota de MINOR for maior', () {
      final result = service.shouldUpdate(
        current: '1.0.0',
        latest: '1.1.0',
        currentBuild: 1,
        latestBuild: 1,
      );
      expect(result, isTrue);
    });

    test('Deve retornar true se a versão remota de MAJOR for maior', () {
      final result = service.shouldUpdate(
        current: '1.0.0',
        latest: '2.0.0',
        currentBuild: 1,
        latestBuild: 1,
      );
      expect(result, isTrue);
    });

    test('Deve retornar false se a versão remota for menor (patch)', () {
      final result = service.shouldUpdate(
        current: '1.0.5',
        latest: '1.0.4',
        currentBuild: 10,
        latestBuild: 10,
      );
      expect(result, isFalse);
    });

    test('Deve retornar false se a versão remota for menor (minor)', () {
      final result = service.shouldUpdate(
        current: '1.2.0',
        latest: '1.1.9',
        currentBuild: 1,
        latestBuild: 1,
      );
      expect(result, isFalse);
    });

    test('Deve retornar false se a versão remota for menor (major)', () {
      final result = service.shouldUpdate(
        current: '2.0.0',
        latest: '1.9.9',
        currentBuild: 1,
        latestBuild: 10,
      );
      expect(result, isFalse);
    });

    test('Deve retornar true se as versões forem iguais mas o Build Number remoto for maior', () {
      final result = service.shouldUpdate(
        current: '1.0.0',
        latest: '1.0.0',
        currentBuild: 1,
        latestBuild: 2,
      );
      expect(result, isTrue);
    });

    test('Deve retornar false se as versões forem iguais e os Build Numbers forem iguais', () {
      final result = service.shouldUpdate(
        current: '1.0.0',
        latest: '1.0.0',
        currentBuild: 1,
        latestBuild: 1,
      );
      expect(result, isFalse);
    });

    test('Deve retornar false se as versões forem iguais e o Build Number remoto for menor', () {
      final result = service.shouldUpdate(
        current: '1.0.0',
        latest: '1.0.0',
        currentBuild: 3,
        latestBuild: 2,
      );
      expect(result, isFalse);
    });

    test('Deve tolerar versões com formatos inválidos e fazer fallback simples de strings', () {
      // Diferentes e remoto maior
      final resultDiff = service.shouldUpdate(
        current: 'beta-1.0',
        latest: 'beta-2.0',
        currentBuild: 1,
        latestBuild: 2,
      );
      expect(resultDiff, isTrue);

      // Iguais mas build remoto maior
      final resultBuild = service.shouldUpdate(
        current: 'versao-invalida',
        latest: 'versao-invalida',
        currentBuild: 1,
        latestBuild: 2,
      );
      expect(resultBuild, isTrue);
    });
  });
}
