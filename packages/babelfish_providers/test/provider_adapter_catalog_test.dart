import 'package:babelfish_providers/babelfish_providers.dart';
import 'package:test/test.dart';

void main() {
  group('ProviderAdapterCatalog', () {
    test('keeps providers immutable and ordered', () {
      final providers = [
        _provider(
          id: 'capture',
          capabilities: {ProviderCapability.audioCapture},
        ),
      ];
      final catalog = ProviderAdapterCatalog(providers);

      providers.add(
        _provider(
          id: 'translation',
          capabilities: {ProviderCapability.translation},
        ),
      );

      expect(catalog.providers.map((provider) => provider.id), ['capture']);
      expect(
        () => catalog.providers.add(
          _provider(
            id: 'late',
            capabilities: {ProviderCapability.transcription},
          ),
        ),
        throwsUnsupportedError,
      );
    });

    test('finds providers by stable id', () {
      final provider = _provider(
        id: 'local-fixture',
        capabilities: {ProviderCapability.transcription},
      );
      final catalog = ProviderAdapterCatalog([provider]);

      expect(catalog.findById('local-fixture'), same(provider));
      expect(catalog.findById('missing'), isNull);
    });

    test('filters providers by declared capability', () {
      final catalog = ProviderAdapterCatalog([
        _provider(
          id: 'capture-only',
          capabilities: {ProviderCapability.audioCapture},
        ),
        _provider(
          id: 'translator',
          capabilities: {ProviderCapability.translation},
        ),
        _provider(
          id: 'speech-suite',
          capabilities: {
            ProviderCapability.audioCapture,
            ProviderCapability.transcription,
            ProviderCapability.translation,
          },
        ),
      ]);

      expect(
        catalog
            .providersSupporting(ProviderCapability.translation)
            .map((provider) => provider.id),
        ['translator', 'speech-suite'],
      );
      expect(
        catalog
            .providersSupporting(ProviderCapability.transcription)
            .map((provider) => provider.id),
        ['speech-suite'],
      );
    });

    test('rejects duplicate provider ids', () {
      expect(
        () => ProviderAdapterCatalog([
          _provider(id: 'duplicate', capabilities: const {}),
          _provider(id: 'duplicate', capabilities: const {}),
        ]),
        throwsArgumentError,
      );
    });
  });
}

ProviderAdapterInfo _provider({
  required String id,
  required Set<ProviderCapability> capabilities,
}) {
  return ProviderAdapterInfo(
    id: id,
    name: id,
    requiresNetwork: true,
    requiresCredentials: true,
    capabilities: capabilities,
  );
}
