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

class CantaVueWebsite extends StatefulWidget {
  const CantaVueWebsite({super.key});
  @override
  State<CantaVueWebsite> createState() => _CantaVueWebsiteState();
}

class _CantaVueWebsiteState extends State<CantaVueWebsite> {
  late String language = switch (Uri.base.queryParameters['lang'] ??
      (Uri.base.path.endsWith('/en.html')
          ? 'en'
          : Uri.base.path.endsWith('/zh-Hant.html')
          ? 'zh-Hant'
          : 'zh-Hans')) {
    'en' => 'en',
    'zh-Hant' => 'zh-Hant',
    _ => 'zh-Hans',
  };

  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'CantaVue · 谱翎',
    locale: language == 'en'
        ? const Locale('en')
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
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: ink,
          minimumSize: const Size(44, 48),
          textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
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
        width >= 980 && MediaQuery.textScalerOf(context).scale(1) < 1.5;
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
                      if (wide) ...[
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
                        const SizedBox(width: 20),
                      ],
                      PopupMenuButton<String>(
                        key: const ValueKey('language'),
                        tooltip: s.language,
                        initialValue: widget.language,
                        onSelected: widget.onLanguage,
                        itemBuilder: (_) => const [
                          PopupMenuItem(value: 'zh-Hans', child: Text('简体中文')),
                          PopupMenuItem(value: 'zh-Hant', child: Text('繁體中文')),
                          PopupMenuItem(value: 'en', child: Text('English')),
                        ],
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.language_rounded, size: 20),
                              if (width >= 700 ||
                                  MediaQuery.textScalerOf(context).scale(1) <
                                      1.5) ...[
                                const SizedBox(width: 8),
                                Text(switch (widget.language) {
                                  'en' => 'English',
                                  'zh-Hant' => '繁體中文',
                                  _ => '简体中文',
                                }, style: const TextStyle(fontSize: 14)),
                              ],
                            ],
                          ),
                        ),
                      ),
                      if (wide) ...[
                        const SizedBox(width: 24),
                        FilledButton(
                          onPressed: () => jump(4),
                          child: Text(s.navStatus),
                        ),
                      ] else
                        PopupMenuButton<int>(
                          tooltip: s.menu,
                          icon: const Icon(Icons.menu_rounded),
                          onSelected: jump,
                          itemBuilder: (_) => [
                            PopupMenuItem(value: 1, child: Text(s.navFeatures)),
                            PopupMenuItem(value: 2, child: Text(s.navWorkflow)),
                            PopupMenuItem(value: 3, child: Text(s.navFaq)),
                            PopupMenuItem(value: 4, child: Text(s.navStatus)),
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
                                        onPressed: () => jump(1),
                                        label: Text(s.explore),
                                        icon: const Icon(
                                          Icons.arrow_forward_rounded,
                                          size: 19,
                                        ),
                                        iconAlignment: IconAlignment.end,
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
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: const Color(0xFF3A3655),
                                      ),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(19),
                                      child: AspectRatio(
                                        aspectRatio: 1.35,
                                        child: Image.asset(
                                          'assets/hero.png',
                                          fit: BoxFit.cover,
                                          semanticLabel: s.imageCaption,
                                          errorBuilder:
                                              (
                                                _,
                                                error,
                                                stackTrace,
                                              ) => Container(
                                                color: const Color(0xFF211E43),
                                                padding: const EdgeInsets.all(
                                                  70,
                                                ),
                                                child: Image.asset(
                                                  'assets/brand.png',
                                                  fit: BoxFit.contain,
                                                  semanticLabel: s.brandCaption,
                                                ),
                                              ),
                                        ),
                                      ),
                                    ),
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
                          Text(
                            s.footerPrivacy,
                            style: const TextStyle(
                              fontSize: 12,
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
        letterSpacing: -1.5,
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
      letterSpacing: 1.2,
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
            style: const TextStyle(
              fontSize: 26,
              height: 1.4,
              fontWeight: FontWeight.w600,
              letterSpacing: -.6,
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
      childrenPadding: const EdgeInsets.only(bottom: 24, right: 24),
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
