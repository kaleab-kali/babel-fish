import 'package:babelfish_core/babelfish_core.dart';

abstract final class FixtureLanguages {
  static const english = BabelLanguage(code: 'en', name: 'English');

  static const french = BabelLanguage(
    code: 'fr',
    name: 'French',
    nativeName: 'Francais',
  );

  static const amharic = BabelLanguage(
    code: 'am',
    name: 'Amharic',
    nativeName: 'አማርኛ',
  );

  static const all = [english, french, amharic];
}
