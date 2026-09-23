import 'package:cantavue_website/site_languages.dart';
import 'dart:convert';
import 'dart:io';
import 'build_policies.dart';

// Search-readable HTML and Flutter use the same localized copy.
void main(List<String> args) {
  final origin = args.isEmpty ? 'https://www.cantavue.com' : args.single;
  final uri = Uri.parse(origin);
  if (uri.scheme != 'https' ||
      uri.host.isEmpty ||
      (uri.path.isNotEmpty && uri.path != '/') ||
      uri.hasQuery ||
      uri.hasFragment) {
    throw ArgumentError('A trusted HTTPS site origin is required.');
  }
  final pages = {
    for (final language in siteLanguages.keys)
      language: (
        siteArbLocale(language),
        language == 'zh-Hans' ? 'index.html' : '$language.html',
      ),
  };
  const appStoreUrl = 'https://apps.apple.com/app/cantavue/id6809090213';
  for (final entry in pages.entries) {
    final locale = entry.key;
    final text =
        (jsonDecode(
                  File(
                    'lib/l10n/site_${entry.value.$1}.arb',
                  ).readAsStringSync(),
                )
                as Map<String, dynamic>)
            .cast<String, String>();
    String t(String key) =>
        const HtmlEscape().convert(text[key]!).replaceAll('\n', '<br>');
    final title =
        "${text['brandCaption']} · ${text['heroTitle']!.replaceAll('\n', ' ')}";
    final canonical =
        '$origin/${entry.value.$2 == 'index.html' ? '' : entry.value.$2.replaceFirst('.html', '')}';
    final content = StringBuffer(
      '<main id="document"><header><img src="assets/assets/brand.png" alt="" width="48" height="48"><strong>${t('brandCaption')}</strong><details><summary>${t('language')}</summary><nav>${siteLanguages.entries.map((language) => '<a href="${siteHomePath(language.key)}" lang="${language.key}">${language.value}</a>').join(' · ')}</nav></details></header>',
    );
    content.write(
      '<section><p>${t('eyebrow')}</p><h1>${t('heroTitle')}</h1><p>${t('heroBody')}</p><p>${t('heroNote')}</p><a href="#release">${t('releaseCta')}</a></section>',
    );
    content.write(
      '<section><h2>${t('featureTitle')}</h2><p>${t('featureBody')}</p>',
    );
    for (final feature in ['read', 'ink', 'library', 'practice']) {
      content.write(
        '<article><h3>${t('${feature}Title')}</h3><p>${t('${feature}Body')}</p></article>',
      );
    }
    content.write(
      '<p>${t('featureNote')}</p></section><section><h2>${t('workflowTitle')}</h2><p>${t('workflowBody')}</p>',
    );
    for (final scene in [
      ('Lesson', 'violin_lesson'),
      ('Ensemble', 'ensemble_stage'),
      ('Pedal', 'pedal_page_turn'),
    ]) {
      content.write(
        '<article><img class="scene" src="assets/assets/scenes/${scene.$2}.webp" alt="${t('scene${scene.$1}Alt')}" width="1536" height="1024" loading="lazy"><p>${t('scene${scene.$1}Tag')}</p><h3>${t('scene${scene.$1}Title')}</h3><p>${t('scene${scene.$1}Body')}</p>',
      );
      if (scene.$1 == 'Pedal') content.write('<p>${t('scenePedalNote')}</p>');
      content.write('</article>');
    }
    content.write('<p>${t('sceneImageNote')}</p>');
    for (var i = 1; i <= 3; i++) {
      content.write(
        '<article><h3>${t('step${i}Title')}</h3><p>${t('step${i}Body')}</p></article>',
      );
    }
    content.write(
      '</section><section><h2>${t('privacyTitle')}</h2><p>${t('privacyBody')}</p></section><section><h2>${t('faqTitle')}</h2>',
    );
    for (var i = 1; i <= 5; i++) {
      content.write(
        '<details><summary>${t('faq${i}q')}</summary><p>${t('faq${i}a')}</p></details>',
      );
    }
    content.write(
      '</section><section id="release"><h2>${t('releaseTitle')}</h2><p>${t('releaseBody')}</p><p>${t('releaseBadge')}</p><p><a href="${Uri.encodeFull(appStoreUrl)}" rel="noopener noreferrer">${t('releaseLinkLabel')}</a></p></section><footer>${t('footerCopyright')}${policyNavigation(locale, text)}<p>${t('footerPrivacy')}</p></footer></main>',
    );
    final alternates = pages.entries
        .map(
          (p) =>
              '<link rel="alternate" hreflang="${p.key}" href="$origin/${p.value.$2 == 'index.html' ? '' : p.value.$2.replaceFirst('.html', '')}">',
        )
        .join('\n');
    File('web/${entry.value.$2}').writeAsStringSync('''<!DOCTYPE html>
<html lang="$locale" dir="${siteIsRtl(locale) ? 'rtl' : 'ltr'}">
<head>
  <base href="/">
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <meta name="theme-color" content="#5552DB">
  <meta name="description" content="${t('heroBody')}">
  <meta property="og:title" content="${const HtmlEscape().convert(title)}">
  <meta property="og:description" content="${t('heroBody')}">
  <meta property="og:type" content="website">
  <meta name="robots" content="index, follow">
  <link rel="canonical" href="$canonical">
  $alternates
  <link rel="icon" type="image/png" href="assets/assets/brand.png">
  <link rel="manifest" href="manifest.json">
  <title>${const HtmlEscape().convert(title)}</title>
  <link rel="stylesheet" href="/policies.css">
  <link rel="stylesheet" href="/multilingual-fonts.css">
  <style>
    html,body{margin:0;background:#111127;color:#fff;font-size:17px;line-height:1.8}*{box-sizing:border-box}
    #document{max-width:1100px;margin:auto;padding:32px 24px}header{display:flex;align-items:center;gap:14px;flex-wrap:wrap}header img{border-radius:12px}nav{font-size:14px}
    .scene{display:block;width:100%;max-width:780px;height:auto;border-radius:16px}section{padding:54px 0;border-bottom:1px solid #38334e}h1{font-size:clamp(38px,6vw,68px);line-height:1.25;letter-spacing:-1.5px}h2{font-size:34px;line-height:1.35}p{max-width:780px;color:#d1cfe1}article{margin:32px 0}a{color:#cbc4ff}summary{cursor:pointer;padding:14px 0}footer{padding:32px 0;font-size:14px}
  </style>
</head>
<body>
$content
<script>
window.cantavueInitialUrl = location.href;
window.cantavueNavigate = function(destination) {
  const paths = ${jsonEncode(policyLanguages.keys.expand((locale) => policyPages.keys.map((page) => '/${policyPath(page, locale)}')).toList())};
  if (paths.includes(destination) || destination === 'mailto:supingjing@me.com' || destination === '$appStoreUrl') {
    location.assign(destination);
  }
};
window.cantavueSetLocale = function(locale, title, description) {
  if (!${jsonEncode(siteLanguages.keys.toList())}.includes(locale)) return;
  document.documentElement.lang = locale;
  document.title = title;
  document.querySelector('meta[name="description"]').content = description;
  document.querySelector('meta[property="og:title"]').content = title;
  document.querySelector('meta[property="og:description"]').content = description;
  const url = new URL(location.href);
  url.pathname = locale === 'zh-Hans' ? '/' : '/' + locale;
  document.documentElement.dir = ['ar', 'he'].includes(locale) ? 'rtl' : 'ltr';
  url.searchParams.delete('lang');
  history.replaceState(null, '', url);
  document.querySelector('link[rel="canonical"]').href = ${jsonEncode(origin)} + url.pathname;
};
</script>
<script src="flutter_bootstrap.js" async></script>
</body>
</html>
''');
  }
  final primary =
      jsonDecode(File('lib/l10n/site_zh_Hans.arb').readAsStringSync())
          as Map<String, dynamic>;
  File('web/manifest.json').writeAsStringSync(
    '${jsonEncode({'name': primary['brandCaption'], 'short_name': 'CantaVue', 'start_url': '.', 'display': 'browser', 'background_color': '#111127', 'theme_color': '#5552DB', 'description': primary['heroBody']})}\n',
  );
  File('web/robots.txt').writeAsStringSync(
    'User-agent: *\nAllow: /\nSitemap: $origin/sitemap.xml\n',
  );
  File('web/sitemap.xml').writeAsStringSync(
    '<?xml version="1.0" encoding="UTF-8"?><urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">${[...pages.values.map((p) => p.$2 == 'index.html' ? '' : p.$2), ...buildPolicies(origin)].map((path) => '<url><loc>$origin/${path.replaceFirst('.html', '')}</loc></url>').join()}</urlset>\n',
  );
}
