enum ProviderCapability { audioCapture, transcription, translation }

final class ProviderAdapterInfo {
  const ProviderAdapterInfo({
    required this.id,
    required this.name,
    required this.requiresNetwork,
    required this.requiresCredentials,
    this.capabilities = const <ProviderCapability>{},
  });

  final String id;
  final String name;
  final bool requiresNetwork;
  final bool requiresCredentials;
  final Set<ProviderCapability> capabilities;

  bool supports(ProviderCapability capability) {
    return capabilities.contains(capability);
  }
}
