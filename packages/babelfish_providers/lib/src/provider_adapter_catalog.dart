import 'provider_adapter_info.dart';

final class ProviderAdapterCatalog {
  ProviderAdapterCatalog(Iterable<ProviderAdapterInfo> providers)
    : _providers = List.unmodifiable(providers) {
    final providerIds = <String>{};
    for (final provider in _providers) {
      if (!providerIds.add(provider.id)) {
        throw ArgumentError.value(
          provider.id,
          'providers',
          'Provider ids must be unique.',
        );
      }
    }
  }

  final List<ProviderAdapterInfo> _providers;

  List<ProviderAdapterInfo> get providers {
    return _providers;
  }

  ProviderAdapterInfo? findById(String id) {
    for (final provider in _providers) {
      if (provider.id == id) {
        return provider;
      }
    }

    return null;
  }

  List<ProviderAdapterInfo> providersSupporting(ProviderCapability capability) {
    return List.unmodifiable(
      _providers.where((provider) => provider.supports(capability)),
    );
  }
}
