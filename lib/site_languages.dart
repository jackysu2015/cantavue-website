// Shared by Flutter and the static document generators.
const siteLanguages = {
  'zh-Hans': '简体中文',
  'zh-Hant': '繁體中文',
  'en': 'English',
  'es': 'Español',
  'fr': 'Français',
  'de': 'Deutsch',
  'ja': '日本語',
  'ko': '한국어',
  'pt': 'Português',
  'da': 'Dansk',
  'uk': 'Українська',
  'ru': 'Русский',
  'hr': 'Hrvatski',
  'ca': 'Català',
  'hu': 'Magyar',
  'nb': 'Norsk bokmål',
  'hi': 'हिन्दी',
  'id': 'Bahasa Indonesia',
  'tr': 'Türkçe',
  'he': 'עברית',
  'el': 'Ελληνικά',
  'it': 'Italiano',
  'cs': 'Čeština',
  'sk': 'Slovenčina',
  'pl': 'Polski',
  'th': 'ไทย',
  'sv': 'Svenska',
  'ro': 'Română',
  'fi': 'Suomi',
  'nl': 'Nederlands',
  'vi': 'Tiếng Việt',
  'ar': 'العربية',
  'ms': 'Bahasa Melayu',
};

String siteHomePath(String language) =>
    language == 'zh-Hans' ? '/' : '/$language.html';
String siteArbLocale(String language) => language.replaceAll('-', '_');
bool siteIsRtl(String language) => language == 'ar' || language == 'he';

String initialLanguage(Uri uri) {
  final path = uri.path
      .replaceFirst(RegExp(r'\.html$'), '')
      .replaceFirst(RegExp(r'/$'), '');
  final candidate = uri.queryParameters['lang'] ?? path.replaceFirst('/', '');
  return siteLanguages.containsKey(candidate) ? candidate : 'zh-Hans';
}
