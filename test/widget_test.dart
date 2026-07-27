import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_teste_1/features/auth/presentation/pages/login_page.dart';
import 'package:flutter_teste_1/core/services/isar_service.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';

class FakePathProviderPlatform extends PathProviderPlatform {
  @override
  Future<String?> getApplicationDocumentsPath() async {
    return '.';
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    PathProviderPlatform.instance = FakePathProviderPlatform();
    await IsarService.instance.init();
  });

  tearDownAll(() async {
    await IsarService.instance.close();
  });

  testWidgets('App smoke test - verifies login page loads', (WidgetTester tester) async {
    // Build our app using standard fonts under ProviderScope and trigger a frame.
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: LoginPage(),
        ),
      ),
    );

    // Verify that the login page title or text is present.
    expect(find.text('Login CMOC'), findsOneWidget);
    expect(find.text('Autenticação'), findsOneWidget);
    expect(find.text('Entrar como Operador'), findsOneWidget);
  });
}
