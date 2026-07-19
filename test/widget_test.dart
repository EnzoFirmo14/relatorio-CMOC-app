import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_teste_1/main.dart';

void main() {
  testWidgets('App smoke test - verifies login page loads', (WidgetTester tester) async {
    // Build our app under ProviderScope and trigger a frame.
    await tester.pumpWidget(
      const ProviderScope(
        child: MyApp(),
      ),
    );

    // Verify that the login page title or text is present.
    expect(find.text('Login CMOC'), findsOneWidget);
    expect(find.text('Autenticação'), findsOneWidget);
    expect(find.text('Entrar como Operador'), findsOneWidget);
  });
}
