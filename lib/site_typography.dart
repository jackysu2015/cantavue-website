import 'package:flutter/widgets.dart';

// Tracking intended for Latin headings must not disturb connected scripts.
double siteTracking(BuildContext context, double latinTracking) =>
    const {
      'ar',
      'he',
      'hi',
      'th',
    }.contains(Localizations.localeOf(context).languageCode)
    ? 0
    : latinTracking;
