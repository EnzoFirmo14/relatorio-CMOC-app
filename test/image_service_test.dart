import 'package:flutter_test/flutter_test.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:flutter_teste_1/core/services/image_service.dart';
import 'package:path/path.dart' as p;

class FakePathProviderPlatform extends PathProviderPlatform {
  @override
  Future<String?> getApplicationDocumentsPath() async {
    return 'fake_documents_directory';
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    PathProviderPlatform.instance = FakePathProviderPlatform();
  });

  group('ImageService Tests', () {
    test('Deve resolver caminho absoluto corretamente a partir de caminho relativo', () async {
      final relativePath = p.join('photos', 'img_123.jpg');
      final absolutePath = await ImageService.getAbsolutePath(relativePath);
      
      expect(absolutePath, contains('fake_documents_directory'));
      expect(absolutePath, endsWith(p.join('photos', 'img_123.jpg')));
    });

    test('deleteImageFile deve rodar sem quebrar mesmo que o arquivo nao exista', () async {
      // Nao deve estourar nenhuma excecao
      expect(
        () async => await ImageService.deleteImageFile('photos/non_existent.jpg'),
        returnsNormally,
      );
    });
  });
}
