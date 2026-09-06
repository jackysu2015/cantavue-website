import 'dart:js_interop';

@JS('cantavueSetLocale')
external void _setLocale(JSString locale, JSString title, JSString description);

void updateDocument(String locale, String title, String description) =>
    _setLocale(locale.toJS, title.toJS, description.toJS);
