import 'package:babelfish_core/babelfish_core.dart';
import 'package:test/test.dart';

void main() {
  group('BabelLanguage', () {
    test('uses the English name when no native name is provided', () {
      const language = BabelLanguage(code: 'en', name: 'English');

      expect(language.displayName, 'English');
    });

    test('includes the native name when it differs from the English name', () {
      const language = BabelLanguage(
        code: 'fr',
        name: 'French',
        nativeName: 'Français',
      );

      expect(language.displayName, 'French (Français)');
    });

    test('has value equality', () {
      const first = BabelLanguage(
        code: 'am',
        name: 'Amharic',
        nativeName: 'Amharic',
      );
      const second = BabelLanguage(
        code: 'am',
        name: 'Amharic',
        nativeName: 'Amharic',
      );

      expect(first, second);
      expect(first.hashCode, second.hashCode);
    });
  });
}
