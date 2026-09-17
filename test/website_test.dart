import 'package:cantavue_website/main.dart';
import 'package:cantavue_website/site_languages.dart';
import 'package:cantavue_website/l10n/generated/site_localizations.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUpAll(() async {
    for (final entry in {
      'CantaSansSC': 'NotoSansSC-400.ttf',
      'CantaSansTC': 'NotoSansTC-400.ttf',
      'CantaMultilingual': 'NotoSans-Regular.ttf',
      'CantaArabic': 'NotoSansArabic-Variable.ttf',
      'CantaHebrew': 'NotoSansHebrew-Variable.ttf',
      'CantaDevanagari': 'NotoSansDevanagari-Variable.ttf',
      'CantaThai': 'NotoSansThai-Variable.ttf',
      'CantaCJK': 'NotoSansCJKsc-Regular.otf',
    }.entries) {
      await (FontLoader(
        entry.key,
      )..addFont(rootBundle.load('assets/fonts/${entry.value}'))).load();
    }
  });
  test('every language has reloadable clean and HTML URLs', () {
    for (final language in siteLanguages.keys) {
      for (final path in [
        siteHomePath(language),
        '/$language',
        '/?lang=$language',
      ]) {
        expect(
          initialLanguage(Uri.parse('https://www.cantavue.com$path')),
          language,
        );
      }
    }
    expect(
      initialLanguage(Uri.parse('https://www.cantavue.com/unknown')),
      'zh-Hans',
    );
  });
  test('Sites clean URL redirects preserve the selected language', () {
    for (final path in ['/en', '/en.html']) {
      expect(initialLanguage(Uri.parse('https://www.cantavue.com$path')), 'en');
    }
    for (final path in ['/zh-Hant', '/zh-Hant.html']) {
      expect(
        initialLanguage(Uri.parse('https://www.cantavue.com$path')),
        'zh-Hant',
      );
    }
    expect(initialLanguage(Uri.parse('https://www.cantavue.com/')), 'zh-Hans');
  });

  Future<void> show(
    WidgetTester tester,
    Size size, {
    double scale = 1,
    String language = 'zh-Hans',
  }) async {
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
    await tester.pumpWidget(
      CantaVueWebsite(
        initialUri: Uri.parse(
          'https://www.cantavue.com${siteHomePath(language)}',
        ),
      ),
    );
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
    final betaAnswer = find.textContaining('join the iOS TestFlight beta');
    expect(betaAnswer, findsOneWidget);
    await tester.tap(find.text('Can I download CantaVue now?'));
    await tester.pumpAndSettle();
    expect(betaAnswer, findsNothing);
    expect(tester.takeException(), isNull);
  });

  for (final language in siteLanguages.keys) {
    testWidgets('desktop navigation and full page: $language', (tester) async {
      await show(tester, const Size(1280, 960), language: language);
      expect(tester.takeException(), isNull);
      final controller = tester
          .widget<SingleChildScrollView>(
            find.byType(SingleChildScrollView).first,
          )
          .controller!;
      controller.jumpTo(controller.position.maxScrollExtent);
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });
    testWidgets('320 px and 200% text: $language', (tester) async {
      await show(tester, const Size(320, 800), scale: 2, language: language);
      final context = tester.element(find.byType(HomePage));
      expect(
        SiteLocalizations.of(context).localeName.replaceAll('_', '-'),
        language,
      );
      expect(
        Directionality.of(context),
        siteIsRtl(language) ? TextDirection.rtl : TextDirection.ltr,
      );
      await tester.tap(find.byKey(const ValueKey('language')));
      await tester.pumpAndSettle();
      expect(find.byType(PopupMenuItem<String>), findsNWidgets(33));
      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
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
