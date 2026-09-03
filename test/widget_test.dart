import 'package:flutter_test/flutter_test.dart';

import 'package:pdf_watermarker/main.dart';

void main() {
  testWidgets('app shows splash branding on launch', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text("Ken's Banga Changa"), findsOneWidget);
    expect(find.text('Banga Chunga PDF'), findsOneWidget);
    expect(find.text('Built by Ken for Lovish'), findsOneWidget);
  });
}
