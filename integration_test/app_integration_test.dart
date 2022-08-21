import 'package:crud_flutter_bloc/main.dart' as app;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Note List Page E2E test', () {
    testWidgets('Should open NoteEditPage', (widgetTester) async {
      app.main();
      await widgetTester.pumpAndSettle();
      await widgetTester.tap(find.byIcon(Icons.add));
      await Future.delayed(const Duration(seconds: 1));
      await widgetTester.pumpAndSettle();
      expect(find.byKey(const Key('NoteEditPage')), findsOneWidget);
    });

    testWidgets('Should open showDialog', (widgetTester) async {
      app.main();
      await widgetTester.pumpAndSettle();
      await widgetTester.tap(find.byIcon(Icons.clear_all));
      await Future.delayed(const Duration(seconds: 1));
      await widgetTester.pumpAndSettle();
      expect(find.byKey(const Key('deleteAllNotes')), findsOneWidget);
    });
  });
}
