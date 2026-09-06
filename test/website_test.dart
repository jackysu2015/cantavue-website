import 'package:cantavue_website/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Future<void> show(WidgetTester tester, Size size, {double scale = 1}) async {
    final original = FlutterError.onError;
    FlutterError.onError = (details) {
      FlutterError.dumpErrorToConsole(details, forceReport: true);
      original?.call(details);
    };
    addTearDown(() => FlutterError.onError = original);
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
    tester.platformDispatcher.textScaleFactorTestValue = scale;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    await tester.pumpWidget(const CantaVueWebsite());
    await tester.pumpAndSettle();
  }

  testWidgets('desktop navigation reaches release and returns to top', (
    tester,
  ) async {
    await show(tester, const Size(1440, 960));
    expect(tester.takeException(), isNull);
    await tester.tap(find.text('发布进展'));
    await tester.pumpAndSettle();
    final controller = tester
        .widget<SingleChildScrollView>(find.byType(SingleChildScrollView).first)
        .controller!;
    expect(controller.offset, greaterThan(1000));
    await tester.ensureVisible(find.text('回到顶部'));
    await tester.tap(find.text('回到顶部'));
    await tester.pumpAndSettle();
    expect(controller.offset, 0);
    expect(tester.takeException(), isNull);
  });

  testWidgets('language switch changes body and FAQ remains interactive', (
    tester,
  ) async {
    await show(tester, const Size(1440, 960));
    await tester.tap(find.byKey(const ValueKey('language')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('English').last);
    await tester.pumpAndSettle();
    expect(find.text('Less paper.\nMore music.'), findsOneWidget);
    await tester.tap(find.text('FAQs'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Can I download CantaVue now?'));
    await tester.pumpAndSettle();
    expect(find.textContaining('There is no public download'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  for (final language in ['简体中文', '繁體中文', 'English']) {
    testWidgets('320 px and 200% text: $language', (tester) async {
      await show(tester, const Size(320, 800), scale: 2);
      await tester.tap(find.byKey(const ValueKey('language')));
      await tester.pumpAndSettle();
      await tester.tap(find.text(language).last);
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      final controller = tester
          .widget<SingleChildScrollView>(
            find.byType(SingleChildScrollView).first,
          )
          .controller!;
      controller.jumpTo(controller.position.maxScrollExtent);
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      await tester.tap(find.byType(PopupMenuButton<int>));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });
  }
}
