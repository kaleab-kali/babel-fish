import 'package:babelfish_providers/babelfish_providers.dart';
import 'package:test/test.dart';

void main() {
  group('ProviderAdapterInfo', () {
    test('defaults to no declared capabilities', () {
      const provider = ProviderAdapterInfo(
        id: 'empty',
        name: 'Empty',
        requiresNetwork: false,
        requiresCredentials: false,
      );

      expect(provider.capabilities, isEmpty);
      expect(provider.supports(ProviderCapability.audioCapture), isFalse);
    });

    test('reports declared capabilities', () {
      const provider = ProviderAdapterInfo(
        id: 'speech-provider',
        name: 'Speech Provider',
        requiresNetwork: true,
        requiresCredentials: true,
        capabilities: <ProviderCapability>{
          ProviderCapability.audioCapture,
          ProviderCapability.transcription,
        },
      );

      expect(provider.supports(ProviderCapability.audioCapture), isTrue);
      expect(provider.supports(ProviderCapability.transcription), isTrue);
      expect(provider.supports(ProviderCapability.translation), isFalse);
    });
  });
}
