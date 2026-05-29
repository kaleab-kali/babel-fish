import 'package:babelfish_providers/babelfish_providers.dart';
import 'package:test/test.dart';

void main() {
  group('ProviderAdapterInfo', () {
    test('defaults to no declared capabilities', () {
      final provider = ProviderAdapterInfo(
        id: 'empty',
        name: 'Empty',
        requiresNetwork: false,
        requiresCredentials: false,
      );

      expect(provider.capabilities, isEmpty);
      expect(provider.supports(ProviderCapability.audioCapture), isFalse);
    });

    test('reports declared capabilities', () {
      final provider = ProviderAdapterInfo(
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

    test('defensively copies declared capabilities', () {
      final capabilities = <ProviderCapability>{
        ProviderCapability.audioCapture,
      };
      final provider = ProviderAdapterInfo(
        id: 'capture-provider',
        name: 'Capture Provider',
        requiresNetwork: true,
        requiresCredentials: true,
        capabilities: capabilities,
      );

      capabilities.add(ProviderCapability.translation);

      expect(provider.supports(ProviderCapability.audioCapture), isTrue);
      expect(provider.supports(ProviderCapability.translation), isFalse);
      expect(
        () => provider.capabilities.add(ProviderCapability.transcription),
        throwsUnsupportedError,
      );
    });

    test('rejects blank provider identifiers', () {
      expect(
        () => ProviderAdapterInfo(
          id: ' ',
          name: 'Provider',
          requiresNetwork: false,
          requiresCredentials: false,
        ),
        throwsArgumentError,
      );
    });

    test('rejects blank provider names', () {
      expect(
        () => ProviderAdapterInfo(
          id: 'provider',
          name: '',
          requiresNetwork: false,
          requiresCredentials: false,
        ),
        throwsArgumentError,
      );
    });
  });
}
