import 'dart:async';

import 'site_typography.dart';
import 'site_languages.dart';
export 'site_languages.dart' show initialLanguage;
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/generated/site_localizations.dart';
import 'scenario_gallery.dart';
import 'browser_stub.dart'
    if (dart.library.js_interop) 'browser_web.dart'
    as browser;

void main() => runApp(const CantaVueWebsite());

const iris = Color(0xFF5552DB);
const ink = Color(0xFF10203A);
const midnight = Color(0xFF111127);
const feather = Color(0xFFF7F5FD);
const appStoreUrl = 'https://apps.apple.com/app/cantavue/id6809090213';

const siteFontFallback = [
  'CantaSansSC',
  'CantaMultilingual',
  'CantaArabic',
  'CantaHebrew',
  'CantaDevanagari',
  'CantaThai',
  'CantaCJK',
];

class CantaVueWebsite extends StatefulWidget {
  const CantaVueWebsite({this.initialUri, super.key});
  final Uri? initialUri;
  @override
  State<CantaVueWebsite> createState() => _CantaVueWebsiteState();
}

class _CantaVueWebsiteState extends State<CantaVueWebsite> {
  late String language = initialLanguage(
    widget.initialUri ?? browser.currentUri(),
  );

  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'CantaVue · 谱翎',
    locale: !language.startsWith('zh-')
        ? Locale(language)
        : Locale.fromSubtags(
            languageCode: 'zh',
            scriptCode: language == 'zh-Hant' ? 'Hant' : 'Hans',
          ),
    supportedLocales: SiteLocalizations.supportedLocales,
    localizationsDelegates: const [
      SiteLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    theme: ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: Colors.white,
      colorScheme: ColorScheme.fromSeed(
        seedColor: iris,
        primary: iris,
        surface: Colors.white,
        onSurface: ink,
      ),
      fontFamily: language == 'zh-Hant' ? 'CantaSansTC' : 'CantaSansSC',
      fontFamilyFallback: const [
        'CantaSansSC',
        'CantaMultilingual',
        'CantaArabic',
        'CantaHebrew',
        'CantaDevanagari',
        'CantaThai',
        'CantaCJK',
        'PingFang SC',
        'Microsoft YaHei',
        'Noto Sans CJK SC',
        'Arial',
      ],
      textTheme: const TextTheme(
        bodyMedium: TextStyle(fontSize: 16, height: 1.7, color: ink),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: iris,
          foregroundColor: Colors.white,
          minimumSize: const Size(0, 52),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          textStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            fontFamily: language == 'zh-Hant' ? 'CantaSansTC' : 'CantaSansSC',
            fontFamilyFallback: siteFontFallback,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: ink,
          minimumSize: const Size(44, 48),
          textStyle: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            fontFamily: language == 'zh-Hant' ? 'CantaSansTC' : 'CantaSansSC',
            fontFamilyFallback: siteFontFallback,
          ),
        ),
      ),
      dividerColor: const Color(0xFFE6E6EF),
    ),
    home: HomePage(
      language: language,
      onLanguage: (value) => setState(() => language = value),
    ),
  );
}

class HomePage extends StatefulWidget {
  const HomePage({required this.language, required this.onLanguage, super.key});
  final String language;
  final ValueChanged<String> onLanguage;
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final sections = List.generate(5, (_) => GlobalKey());
  final scroll = ScrollController();
  @override
  void dispose() {
    scroll.dispose();
    super.dispose();
  }

  void jump(int section) {
    final target = sections[section].currentContext;
    if (target != null) {
      Scrollable.ensureVisible(
        target,
        duration: MediaQuery.disableAnimationsOf(context)
            ? Duration.zero
            : const Duration(milliseconds: 450),
        curve: Curves.easeOutCubic,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = SiteLocalizations.of(context);
    browser.updateDocument(
      widget.language,
      '${s.brandCaption} · ${s.heroTitle.replaceAll('\n', ' ')}',
      s.heroBody,
    );
    final width = MediaQuery.sizeOf(context).width;
    final wide =
        width >= 1240 && MediaQuery.textScalerOf(context).scale(1) < 1.5;
    double labelWidth(String text, double size) {
      final painter = TextPainter(
        text: TextSpan(
          text: text,
          style: Theme.of(context).textTheme.labelLarge!.copyWith(
            fontSize: size,
            fontWeight: FontWeight.w600,
          ),
        ),
        textDirection: Directionality.of(context),
        textScaler: MediaQuery.textScalerOf(context),
      )..layout();
      final result = painter.width;
      painter.dispose();
      return result;
    }

    final navigationWidth =
        500 +
        labelWidth(s.navFeatures, 14) +
        labelWidth(s.navWorkflow, 14) +
        labelWidth(s.navFaq, 14) +
        labelWidth(s.navStatus, 14) +
        labelWidth(s.downloadCta, 16) +
        labelWidth(siteLanguages[widget.language]!, 14);
    final expandedNavigation =
        wide && navigationWidth <= (width.clamp(0, 1328) - 96);
    return Scaffold(
      body: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(bottom: BorderSide(color: Color(0xFFE6E6EF))),
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1328),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: wide ? 48 : 16,
                    vertical: 12,
                  ),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () => jump(0),
                        borderRadius: BorderRadius.circular(10),
                        child: Padding(
                          padding: const EdgeInsets.all(4),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(9),
                                child: Image.asset(
                                  'assets/brand.png',
                                  width: 36,
                                  height: 36,
                                  excludeFromSemantics: true,
                                ),
                              ),
                              const SizedBox(width: 10),
                              if (width > 360 ||
                                  MediaQuery.textScalerOf(context).scale(1) <
                                      1.5)
                                const Text(
                                  'CantaVue',
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: -.8,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                      const Spacer(),
                      if (expandedNavigation) ...[
                        TextButton(
                          onPressed: () => jump(1),
                          child: Text(s.navFeatures),
                        ),
                        TextButton(
                          onPressed: () => jump(2),
                          child: Text(s.navWorkflow),
                        ),
                        TextButton(
                          onPressed: () => jump(3),
                          child: Text(s.navFaq),
                        ),
                        TextButton(
                          onPressed: () => jump(4),
                          child: Text(s.navStatus),
                        ),
                        const SizedBox(width: 20),
                      ],
                      PopupMenuButton<String>(
                        key: const ValueKey('language'),
                        tooltip: s.language,
                        initialValue: widget.language,
                        onSelected: widget.onLanguage,
                        itemBuilder: (_) => [
                          for (final entry in siteLanguages.entries)
                            PopupMenuItem(
                              value: entry.key,
                              child: Text(entry.value),
                            ),
                        ],
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.language_rounded, size: 20),
                              if (width >= 700) ...[
                                const SizedBox(width: 8),
                                Text(
                                  siteLanguages[widget.language]!,
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                      if (expandedNavigation) ...[
                        const SizedBox(width: 24),
                        FilledButton(
                          onPressed: () => browser.navigate(appStoreUrl),
                          child: Text(s.downloadCta),
                        ),
                      ] else
                        PopupMenuButton<int>(
                          tooltip: s.menu,
                          icon: const Icon(Icons.menu_rounded),
                          onSelected: (section) {
                            if (section == 5) {
                              browser.navigate(appStoreUrl);
                            } else {
                              jump(section);
                            }
                          },
                          itemBuilder: (_) => [
                            PopupMenuItem(value: 1, child: Text(s.navFeatures)),
                            PopupMenuItem(value: 2, child: Text(s.navWorkflow)),
                            PopupMenuItem(value: 3, child: Text(s.navFaq)),
                            PopupMenuItem(value: 4, child: Text(s.navStatus)),
                            PopupMenuItem(value: 5, child: Text(s.downloadCta)),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              controller: scroll,
              child: SelectionArea(
                child: Column(
                  children: [
                    Container(
                      key: sections[0],
                      color: midnight,
                      child: _Section(
                        padding: wide ? 76 : 48,
                        child: Column(
                          children: [
                            _Columns(
                              wide: wide,
                              gap: 56,
                              leftFlex: 10,
                              rightFlex: 11,
                              left: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _Eyebrow(
                                    s.eyebrow,
                                    color: const Color(0xFFB6AEFF),
                                  ),
                                  const SizedBox(height: 24),
                                  _Headline(
                                    s.heroTitle,
                                    size: wide ? 66 : 43,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(height: 26),
                                  Text(
                                    s.heroBody,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      height: 1.85,
                                      color: Color(0xFFC7C7DA),
                                    ),
                                  ),
                                  const SizedBox(height: 32),
                                  Wrap(
                                    spacing: 12,
                                    runSpacing: 12,
                                    crossAxisAlignment:
                                        WrapCrossAlignment.center,
                                    children: [
                                      FilledButton.icon(
                                        onPressed: () =>
                                            browser.navigate(appStoreUrl),
                                        icon: const Icon(
                                          Icons.download_rounded,
                                          size: 19,
                                        ),
                                        label: Text(s.downloadCta),
                                      ),
                                      TextButton(
                                        onPressed: () => jump(1),
                                        style: TextButton.styleFrom(
                                          foregroundColor: Colors.white,
                                        ),
                                        child: Text(s.explore),
                                      ),
                                      TextButton(
                                        onPressed: () => jump(4),
                                        style: TextButton.styleFrom(
                                          foregroundColor: Colors.white,
                                        ),
                                        child: Text(s.releaseCta),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 28),
                                  Text(
                                    s.heroNote,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Color(0xFFAFAEC6),
                                    ),
                                  ),
                                ],
                              ),
                              right: Column(
                                children: [
                                  _ProductScreenshotCarousel(
                                    wide: wide,
                                    semanticLabel: s.imageCaption,
                                  ),
                                  const SizedBox(height: 14),
                                  Text(
                                    s.imageCaption,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFFAFAEC6),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      key: sections[1],
                      child: _Section(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _Eyebrow(s.featureEyebrow),
                            const SizedBox(height: 20),
                            _Columns(
                              wide: wide,
                              gap: 64,
                              left: _Headline(
                                s.featureTitle,
                                size: wide ? 48 : 36,
                              ),
                              right: Text(
                                s.featureBody,
                                style: const TextStyle(
                                  fontSize: 18,
                                  height: 1.8,
                                  color: Color(0xFF667084),
                                ),
                              ),
                            ),
                            const SizedBox(height: 44),
                            LayoutBuilder(
                              builder: (context, constraints) {
                                final count = wide ? 2 : 1;
                                final cardWidth =
                                    (constraints.maxWidth - (count - 1) * 24) /
                                    count;
                                return Wrap(
                                  spacing: 24,
                                  runSpacing: 24,
                                  children: [
                                    _FeatureCard(
                                      width: cardWidth,
                                      number: '01',
                                      icon: Icons.chrome_reader_mode_outlined,
                                      tag: s.readTag,
                                      title: s.readTitle,
                                      body: s.readBody,
                                      color: const Color(0xFFF1F0FF),
                                    ),
                                    _FeatureCard(
                                      width: cardWidth,
                                      number: '02',
                                      icon: Icons.draw_outlined,
                                      tag: s.inkTag,
                                      title: s.inkTitle,
                                      body: s.inkBody,
                                      color: const Color(0xFFF8F6F0),
                                    ),
                                    _FeatureCard(
                                      width: cardWidth,
                                      number: '03',
                                      icon: Icons.library_music_outlined,
                                      tag: s.libraryTag,
                                      title: s.libraryTitle,
                                      body: s.libraryBody,
                                      color: const Color(0xFFF1F5F8),
                                    ),
                                    _FeatureCard(
                                      width: cardWidth,
                                      number: '04',
                                      icon: Icons.graphic_eq_rounded,
                                      tag: s.practiceTag,
                                      title: s.practiceTitle,
                                      body: s.practiceBody,
                                      color: const Color(0xFFF5F3F9),
                                    ),
                                  ],
                                );
                              },
                            ),
                            const SizedBox(height: 24),
                            Text(
                              s.featureNote,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color(0xFF667084),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      key: sections[2],
                      color: feather,
                      child: _Section(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _Eyebrow(s.workflowEyebrow),
                            const SizedBox(height: 20),
                            _Columns(
                              wide: wide,
                              gap: 64,
                              left: _Headline(
                                s.workflowTitle,
                                size: wide ? 48 : 36,
                              ),
                              right: Text(
                                s.workflowBody,
                                style: const TextStyle(
                                  fontSize: 18,
                                  height: 1.8,
                                  color: Color(0xFF667084),
                                ),
                              ),
                            ),
                            const SizedBox(height: 44),
                            ScenarioGallery(wide: wide),
                            const SizedBox(height: 52),
                            if (wide)
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: _Step(
                                      number: '01',
                                      title: s.step1Title,
                                      body: s.step1Body,
                                    ),
                                  ),
                                  const SizedBox(width: 32),
                                  Expanded(
                                    child: _Step(
                                      number: '02',
                                      title: s.step2Title,
                                      body: s.step2Body,
                                    ),
                                  ),
                                  const SizedBox(width: 32),
                                  Expanded(
                                    child: _Step(
                                      number: '03',
                                      title: s.step3Title,
                                      body: s.step3Body,
                                    ),
                                  ),
                                ],
                              )
                            else ...[
                              _Step(
                                number: '01',
                                title: s.step1Title,
                                body: s.step1Body,
                              ),
                              const Divider(height: 40),
                              _Step(
                                number: '02',
                                title: s.step2Title,
                                body: s.step2Body,
                              ),
                              const Divider(height: 40),
                              _Step(
                                number: '03',
                                title: s.step3Title,
                                body: s.step3Body,
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                    _Section(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.shield_outlined,
                            size: 38,
                            color: iris,
                          ),
                          const SizedBox(height: 24),
                          _Eyebrow(s.privacyEyebrow),
                          const SizedBox(height: 20),
                          _Headline(
                            s.privacyTitle,
                            size: wide ? 46 : 34,
                            align: TextAlign.center,
                          ),
                          const SizedBox(height: 24),
                          ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 760),
                            child: Text(
                              s.privacyBody,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 18,
                                height: 1.9,
                                color: Color(0xFF667084),
                              ),
                            ),
                          ),
                          const SizedBox(height: 32),
                          Wrap(
                            spacing: 24,
                            runSpacing: 16,
                            alignment: WrapAlignment.center,
                            children:
                                [s.privacyTag1, s.privacyTag2, s.privacyTag3]
                                    .map(
                                      (text) => Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(
                                            Icons.check_circle_outline_rounded,
                                            size: 20,
                                            color: iris,
                                          ),
                                          const SizedBox(width: 8),
                                          Flexible(
                                            child: Text(
                                              text,
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                    .toList(),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      key: sections[3],
                      decoration: const BoxDecoration(
                        border: Border(
                          top: BorderSide(color: Color(0xFFE6E6EF)),
                        ),
                      ),
                      child: _Section(
                        child: _Columns(
                          wide: wide,
                          gap: 72,
                          leftFlex: 7,
                          rightFlex: 11,
                          left: _Headline(s.faqTitle, size: wide ? 40 : 34),
                          right: Column(
                            children: [
                              _Faq(question: s.faq1q, answer: s.faq1a),
                              _Faq(question: s.faq2q, answer: s.faq2a),
                              _Faq(question: s.faq3q, answer: s.faq3a),
                              _Faq(question: s.faq4q, answer: s.faq4a),
                              _Faq(question: s.faq5q, answer: s.faq5a),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      key: sections[4],
                      color: const Color(0xFF2D216D),
                      child: _Section(
                        child: Column(
                          children: [
                            _Eyebrow(
                              s.releaseEyebrow,
                              color: const Color(0xFFC5BDFF),
                            ),
                            const SizedBox(height: 24),
                            _Headline(
                              s.releaseTitle,
                              size: wide ? 48 : 36,
                              color: Colors.white,
                              align: TextAlign.center,
                            ),
                            const SizedBox(height: 24),
                            ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 660),
                              child: Text(
                                s.releaseBody,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 18,
                                  height: 1.85,
                                  color: Color(0xFFD6D1EA),
                                ),
                              ),
                            ),
                            const SizedBox(height: 32),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 14,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFF443883),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                s.releaseBadge,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                            FilledButton.icon(
                              onPressed: () => browser.navigate(appStoreUrl),
                              icon: const Icon(Icons.open_in_new_rounded),
                              label: Text(s.releaseLinkLabel),
                            ),
                          ],
                        ),
                      ),
                    ),
                    _Section(
                      padding: 36,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Wrap(
                            alignment: WrapAlignment.spaceBetween,
                            spacing: 40,
                            runSpacing: 12,
                            children: [
                              Text(
                                s.footerCopyright,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                s.footerLine,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF667084),
                                ),
                              ),
                              TextButton.icon(
                                onPressed: () => jump(0),
                                icon: const Icon(
                                  Icons.arrow_upward_rounded,
                                  size: 18,
                                ),
                                label: Text(s.backTop),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 12,
                            runSpacing: 8,
                            children: [
                              for (final page in [
                                ('privacy', s.policyPrivacy),
                                ('terms', s.policyTerms),
                                ('support', s.policySupport),
                              ])
                                TextButton(
                                  onPressed: () => browser.navigate(
                                    '/${page.$1}${widget.language == 'zh-Hans' ? '' : '-${widget.language}'}.html',
                                  ),
                                  child: Text(page.$2),
                                ),
                              TextButton.icon(
                                onPressed: () => browser.navigate(
                                  'mailto:${s.feedbackEmail}',
                                ),
                                icon: const Icon(Icons.mail_outline, size: 18),
                                label: Text(s.feedbackEmail),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            s.footerPrivacy,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF667084),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProductScreenshotCarousel extends StatefulWidget {
  const _ProductScreenshotCarousel({
    required this.wide,
    required this.semanticLabel,
  });

  final bool wide;
  final String semanticLabel;

  @override
  State<_ProductScreenshotCarousel> createState() =>
      _ProductScreenshotCarouselState();
}

class _ProductScreenshotCarouselState
    extends State<_ProductScreenshotCarousel> {
  final controller = PageController(viewportFraction: .82);
  Timer? timer;
  int current = 0;
  String? screenshotLocale;
  List<String> shots = const [];

  static const screenshotLocales = {
    'ar',
    'ca',
    'cs',
    'da',
    'de',
    'el',
    'en',
    'es',
    'fi',
    'fr',
    'he',
    'hi',
    'hr',
    'hu',
    'id',
    'it',
    'ja',
    'ko',
    'ms',
    'nb',
    'nl',
    'pl',
    'pt',
    'ro',
    'ru',
    'sk',
    'sv',
    'th',
    'tr',
    'uk',
    'vi',
    'zh',
    'zh_Hans',
    'zh_Hant',
  };

  static const shotNames = [
    'appstore_01-library.png',
    'appstore_02-scan.png',
    'appstore_03-annotation.png',
    'appstore_04-symbols.png',
    'appstore_05-pages.png',
    'appstore_06-setlists.png',
    'appstore_07-metronome.png',
    'appstore_08-practice.png',
    'appstore_09-teaching.png',
    'appstore_10-templates.png',
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final locale = _screenshotLocale(Localizations.localeOf(context));
    if (locale != screenshotLocale) {
      screenshotLocale = locale;
      shots = [
        for (final name in shotNames) 'assets/screenshots/$locale/$name',
      ];
      current = 0;
      if (controller.hasClients) {
        controller.jumpToPage(0);
      }
    }
    for (final shot in shots) {
      precacheImage(AssetImage(shot), context);
    }
    timer?.cancel();
    if (!MediaQuery.disableAnimationsOf(context)) {
      timer = Timer.periodic(const Duration(seconds: 5), (_) => go(1));
    }
  }

  static String _screenshotLocale(Locale locale) {
    if (locale.languageCode == 'zh') {
      return switch (locale.scriptCode) {
        'Hant' => 'zh_Hant',
        'Hans' => 'zh_Hans',
        _ => 'zh',
      };
    }
    return screenshotLocales.contains(locale.languageCode)
        ? locale.languageCode
        : 'en';
  }

  @override
  void dispose() {
    timer?.cancel();
    controller.dispose();
    super.dispose();
  }

  void go(int delta) {
    if (!controller.hasClients) return;
    final next = (current + delta) % shots.length;
    controller.animateToPage(
      next,
      duration: MediaQuery.disableAnimationsOf(context)
          ? Duration.zero
          : const Duration(milliseconds: 420),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) => Semantics(
    image: true,
    label: widget.semanticLabel,
    child: ExcludeSemantics(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFF3A3655)),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF191738), Color(0xFF31205F)],
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x66000000),
              blurRadius: 28,
              offset: Offset(0, 18),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(19),
          child: AspectRatio(
            aspectRatio: widget.wide ? 1.16 : .9,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final w = constraints.maxWidth;
                final h = constraints.maxHeight;
                return Stack(
                  clipBehavior: Clip.hardEdge,
                  children: [
                    Positioned.fill(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: RadialGradient(
                            center: const Alignment(.55, -.55),
                            radius: 1.05,
                            colors: [
                              const Color(0xFF7771FF).withValues(alpha: .42),
                              const Color(0xFF231A4A).withValues(alpha: .18),
                              const Color(0xFF111127),
                            ],
                            stops: const [.0, .5, 1],
                          ),
                        ),
                      ),
                    ),
                    Positioned.fill(
                      child: PageView.builder(
                        controller: controller,
                        itemCount: shots.length,
                        onPageChanged: (value) =>
                            setState(() => current = value),
                        itemBuilder: (context, index) => AnimatedBuilder(
                          animation: controller,
                          builder: (context, child) {
                            var distance = 0.0;
                            if (controller.hasClients &&
                                controller.position.haveDimensions) {
                              distance = ((controller.page ?? current) - index)
                                  .abs()
                                  .clamp(0.0, 1.0)
                                  .toDouble();
                            } else {
                              distance = current == index ? 0 : 1;
                            }
                            final scale = 1 - distance * .08;
                            final opacity = 1 - distance * .28;
                            return Center(
                              child: Opacity(
                                opacity: opacity,
                                child: Transform.scale(
                                  scale: scale,
                                  child: child,
                                ),
                              ),
                            );
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: w * .025,
                              vertical: h * .08,
                            ),
                            child: _ScreenshotFrame(asset: shots[index]),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 16,
                      top: h * .45,
                      child: _CarouselButton(
                        icon: Icons.chevron_left_rounded,
                        onPressed: () => go(-1),
                      ),
                    ),
                    Positioned(
                      right: 16,
                      top: h * .45,
                      child: _CarouselButton(
                        icon: Icons.chevron_right_rounded,
                        onPressed: () => go(1),
                      ),
                    ),
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: h * .065,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          for (var i = 0; i < shots.length; i++)
                            AnimatedContainer(
                              duration: MediaQuery.disableAnimationsOf(context)
                                  ? Duration.zero
                                  : const Duration(milliseconds: 220),
                              width: i == current ? 28 : 8,
                              height: 8,
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              decoration: BoxDecoration(
                                color: i == current
                                    ? const Color(0xFFC5BDFF)
                                    : const Color(0x66C5BDFF),
                                borderRadius: BorderRadius.circular(999),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    ),
  );
}

class _CarouselButton extends StatelessWidget {
  const _CarouselButton({required this.icon, required this.onPressed});

  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => IconButton.filledTonal(
    onPressed: onPressed,
    icon: Icon(icon),
    color: Colors.white,
    style: IconButton.styleFrom(
      backgroundColor: const Color(0xAA2D216D),
      fixedSize: const Size(44, 44),
    ),
  );
}

class _ScreenshotFrame extends StatelessWidget {
  const _ScreenshotFrame({required this.asset});

  final String asset;

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(
      color: const Color(0xFFF8F7FF),
      borderRadius: BorderRadius.circular(18),
      border: Border.all(color: const Color(0xFFE5E0F4), width: 2),
      boxShadow: const [
        BoxShadow(
          color: Color(0x66000000),
          blurRadius: 24,
          offset: Offset(0, 14),
        ),
      ],
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Image.asset(
        asset,
        fit: BoxFit.contain,
        alignment: Alignment.topCenter,
        excludeFromSemantics: true,
        errorBuilder: (_, _, _) => Center(
          child: Image.asset(
            'assets/brand.png',
            width: 88,
            height: 88,
            excludeFromSemantics: true,
          ),
        ),
      ),
    ),
  );
}

class _Section extends StatelessWidget {
  const _Section({required this.child, this.padding = 88});
  final Widget child;
  final double padding;
  @override
  Widget build(BuildContext context) => SizedBox(
    width: double.infinity,
    child: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1328),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.sizeOf(context).width >= 700 ? 48 : 24,
            vertical: MediaQuery.sizeOf(context).width >= 700
                ? padding
                : padding * .68,
          ),
          child: child,
        ),
      ),
    ),
  );
}

class _Columns extends StatelessWidget {
  const _Columns({
    required this.wide,
    required this.left,
    required this.right,
    this.gap = 48,
    this.leftFlex = 1,
    this.rightFlex = 1,
  });
  final bool wide;
  final Widget left, right;
  final double gap;
  final int leftFlex, rightFlex;
  @override
  Widget build(BuildContext context) => wide
      ? Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(flex: leftFlex, child: left),
            SizedBox(width: gap),
            Expanded(flex: rightFlex, child: right),
          ],
        )
      : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            left,
            SizedBox(height: gap * .75),
            right,
          ],
        );
}

class _Headline extends StatelessWidget {
  const _Headline(
    this.text, {
    required this.size,
    this.color = ink,
    this.align = TextAlign.start,
  });
  final String text;
  final double size;
  final Color color;
  final TextAlign align;
  @override
  Widget build(BuildContext context) => Semantics(
    header: true,
    child: Text(
      text,
      textAlign: align,
      style: TextStyle(
        fontSize: size,
        height: 1.24,
        letterSpacing: siteTracking(context, -1.5),
        fontWeight: FontWeight.w700,
        color: color,
      ),
    ),
  );
}

class _Eyebrow extends StatelessWidget {
  const _Eyebrow(this.text, {this.color = iris});
  final String text;
  final Color color;
  @override
  Widget build(BuildContext context) => Text(
    text,
    style: TextStyle(
      fontSize: 13,
      letterSpacing: siteTracking(context, 1.2),
      height: 1.6,
      fontWeight: FontWeight.w600,
      color: color,
    ),
  );
}

class _FeatureCard extends StatelessWidget {
  const _FeatureCard({
    required this.width,
    required this.number,
    required this.icon,
    required this.tag,
    required this.title,
    required this.body,
    required this.color,
  });
  final double width;
  final String number, tag, title, body;
  final IconData icon;
  final Color color;
  @override
  Widget build(BuildContext context) => SizedBox(
    width: width,
    child: Container(
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 30, color: iris),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  tag,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: iris,
                  ),
                ),
              ),
              Text(
                number,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w300,
                  color: Color(0xFF9D9DAF),
                ),
              ),
            ],
          ),
          const SizedBox(height: 36),
          Text(
            title,
            style: TextStyle(
              fontSize: 26,
              height: 1.4,
              fontWeight: FontWeight.w600,
              letterSpacing: siteTracking(context, -.6),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            body,
            style: const TextStyle(
              fontSize: 16,
              height: 1.85,
              color: Color(0xFF556075),
            ),
          ),
        ],
      ),
    ),
  );
}

class _Step extends StatelessWidget {
  const _Step({required this.number, required this.title, required this.body});
  final String number, title, body;
  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        number,
        style: const TextStyle(
          fontSize: 16,
          color: iris,
          fontWeight: FontWeight.w600,
        ),
      ),
      const SizedBox(width: 24),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 23,
                height: 1.4,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              body,
              style: const TextStyle(
                fontSize: 16,
                height: 1.8,
                color: Color(0xFF667084),
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

class _Faq extends StatelessWidget {
  const _Faq({required this.question, required this.answer});
  final String question, answer;
  @override
  Widget build(BuildContext context) => Container(
    decoration: const BoxDecoration(
      border: Border(bottom: BorderSide(color: Color(0xFFE6E6EF))),
    ),
    child: ExpansionTile(
      tilePadding: const EdgeInsets.symmetric(vertical: 10),
      childrenPadding: const EdgeInsetsDirectional.only(bottom: 24, end: 24),
      shape: const Border(),
      collapsedShape: const Border(),
      title: Text(
        question,
        style: const TextStyle(
          fontSize: 18,
          height: 1.6,
          fontWeight: FontWeight.w500,
        ),
      ),
      children: [
        Text(
          answer,
          style: const TextStyle(
            fontSize: 16,
            height: 1.85,
            color: Color(0xFF667084),
          ),
        ),
      ],
    ),
  );
}
