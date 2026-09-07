import 'dart:convert';
import 'dart:io';

const policyPages = {
  'privacy': ('policyPrivacy', 10),
  'terms': ('policyTerms', 6),
  'support': ('policySupport', 4),
};
const policyLanguages = {
  'zh-Hans': ('zh_Hans', '简体中文', '/'),
  'zh-Hant': ('zh_Hant', '繁體中文', '/zh-Hant.html'),
  'en': ('en', 'English', '/en.html'),
};

String policyPath(String page, String language) =>
    '$page${language == 'zh-Hans' ? '' : '-$language'}.html';
String escape(String text) => const HtmlEscape().convert(text);

String policyNavigation(String language, Map<String, String> text) =>
    '<nav class="policy-links">${policyPages.entries.map((page) => '<a href="/${policyPath(page.key, language)}">${escape(text[page.value.$1]!)}</a>').join(' · ')} · <a href="mailto:info@cantavue.com">${escape(text['feedbackEmail']!)}</a></nav>';

// Legal and support pages are complete HTML documents, independent of Flutter
// bootstrapping, so review teams and assistive technology can read them directly.
List<String> buildPolicies(String origin) {
  final outputs = <String>[];
  for (final language in policyLanguages.entries) {
    final text =
        (jsonDecode(
                  File(
                    'lib/l10n/site_${language.value.$1}.arb',
                  ).readAsStringSync(),
                )
                as Map<String, dynamic>)
            .cast<String, String>();
    String t(String key) => escape(text[key]!);
    for (final page in policyPages.entries) {
      final kind = page.key;
      final path = policyPath(kind, language.key);
      final title = t(page.value.$1);
      final body = StringBuffer();
      for (var section = 1; section <= page.value.$2; section++) {
        body.write(
          '<section id="section-$section"><h2>${t('$kind${section}Title')}</h2>',
        );
        for (final paragraph in text['$kind${section}Body']!.split('\n\n')) {
          body.write('<p>${escape(paragraph)}</p>');
        }
        body.write('</section>');
      }
      if (kind == 'privacy') {
        body.write('<section><h2>${t('privacySources')}</h2><ul>');
        for (final source in [
          ('providerOpenAI', 'https://openai.com/policies/privacy-policy/'),
          (
            'providerApple',
            'https://www.apple.com/legal/privacy/data/en/test-flight/',
          ),
          ('providerImslp', 'https://imslp.org/wiki/IMSLP:Privacy_policy'),
        ]) {
          body.write(
            '<li><a href="${source.$2}" rel="noreferrer">${t(source.$1)}</a></li>',
          );
        }
        body.write('</ul></section>');
      }
      File('web/$path').writeAsStringSync('''<!DOCTYPE html>
<html lang="${language.key}">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <meta name="theme-color" content="#5552DB">
  <meta name="description" content="${t('${kind}Intro')}">
  <meta name="robots" content="index, follow">
  <title>$title · CantaVue</title>
  <link rel="canonical" href="$origin/$path">
  ${policyLanguages.keys.map((locale) => '<link rel="alternate" hreflang="$locale" href="$origin/${policyPath(kind, locale)}">').join('\n')}
  <link rel="icon" type="image/png" href="/assets/assets/brand.png">
  <link rel="stylesheet" href="/policies.css">
</head>
<body>
<header class="site-header"><a class="brand" href="${language.value.$3}"><img src="/assets/assets/brand.png" width="42" height="42" alt=""><span>CantaVue</span></a><nav aria-label="${t('policyHome')}">${policyLanguages.entries.map((locale) => '<a href="/${policyPath(kind, locale.key)}" lang="${locale.key}"${locale.key == language.key ? ' aria-current="page"' : ''}>${locale.value.$2}</a>').join(' ')}</nav></header>
<main>
  <a class="back" href="${language.value.$3}">← ${t('policyHome')}</a>
  <div class="intro"><p class="eyebrow">CantaVue · ${t('brandCaption')}</p><h1>$title</h1><p class="date">${t('policyUpdated')}</p><p>${t('${kind}Intro')}</p>${kind == 'support' ? '<a class="email-button" href="mailto:info@cantavue.com">${t('supportEmailAction')} ↗</a>' : ''}</div>
  <div class="document-layout"><aside><nav aria-label="${t('policyContents')}"><strong>${t('policyContents')}</strong><ol>${List.generate(page.value.$2, (i) => '<li><a href="#section-${i + 1}">${t('$kind${i + 1}Title')}</a></li>').join()}</ol></nav></aside><article>$body</article></div>
</main>
<footer><p>${t('footerCopyright')}</p>${policyNavigation(language.key, text)}</footer>
</body></html>
''');
      outputs.add(path);
    }
  }
  return outputs;
}
