// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:smart_sense/main.dart';

void main() {
  testWidgets('SmartSense app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const SmartSenseApp());

    // Wait for the app to settle
    await tester.pumpAndSettle();

    // Verify that the default page (设备管理) is displayed.
    expect(find.text('设备管理'), findsOneWidget);

    // Verify that the bottom navigation bar is present
    expect(find.text('设备'), findsOneWidget);
    expect(find.text('监控'), findsOneWidget);
    expect(find.text('记录'), findsOneWidget);
  });
}
