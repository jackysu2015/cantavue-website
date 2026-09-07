import 'dart:js_interop';

@JS('cantavueSetLocale')
external void _setLocale(JSString locale, JSString title, JSString description);

@JS('cantavueNavigate')
external void _navigate(JSString destination);

void navigate(String destination) => _navigate(destination.toJS);

void updateDocument(String locale, String title, String description) =>
    _setLocale(locale.toJS, title.toJS, description.toJS);
