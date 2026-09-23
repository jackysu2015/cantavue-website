# Website languages · 2026-09-17

The website follows the application's 33 product languages: Simplified and Traditional Chinese, English, and the 30 languages in `tool/locales.json`. The `zh` ARB remains a Flutter compatibility resource, not a separate selectable language.

Every language has the same 134 messages. The home page and complete privacy, terms and support documents use those ARB files, with dedicated HTML and clean URLs. The shared `lib/site_languages.dart` registry controls the menu, route mapping, static generation and language alternates. URL selection is explicit and remains on refresh; no language cookies or automatic geographic redirects are added. Arabic and Hebrew have RTL text and navigation; image assets are not mirrored.

## Translation source and limits

Policy and support messages are reused only where the English source exactly matches the current app resource; translations then come from that same app key. This preserves the September 14 policy scope, including local teaching, notifications, manual transfers and credential deletion. Website-only copy is translated separately. Source generation uses the existing local Qwen model, with direct editorial translations for selected languages and explicit corrections in `tool/translation_corrections.json`.

Text review checks music terminology and preserves the current limits: App Store availability, platform validation, no editable notation recognition from photos, no automatic uploads or cloud sync, and no current in-app purchases. This is not independent native-speaker review of every language. No app requirement completion status is changed by a website translation.

## Fonts and dependencies

Six existing application Noto font sources are subset for the website's published characters. They cover Latin, Greek, Cyrillic, Arabic, Hebrew, Devanagari, Thai, Japanese and Korean; existing SC/TC fonts remain. All files are served locally with their SIL OFL 1.1 license. `docs/MULTILINGUAL_FONTS.json` records source/output hashes and sizes. Fonttools is a development-only dependency and is not shipped. No new Flutter runtime package or permission is introduced.

## Maintenance

1. Update the source ARB and translations, retaining all keys and source semantics.
2. Apply reviewed wording with `python3 tool/apply_translation_corrections.py`.
3. With the sibling application font sources and fonttools available, run `python3 tool/prepare_multilingual_fonts.py`.
4. Generate localizations, build static documents and run website analysis/tests.
5. `python3 tool/check_documents.py` checks all 132 documents, language links, canonical URLs, direction and sitemap entries.
6. Build the Flutter release with `dart run tool/build.dart`. The normal hosting workflow publishes its `dist/` output.

Exact results and remaining validation limits are recorded in the main project `docs/STATUS.md`.
