enum ProviderCapability { audioCapture, transcription, translation }

final class ProviderAdapterInfo {
  ProviderAdapterInfo({
    required this.id,
    required this.name,
    required this.requiresNetwork,
    required this.requiresCredentials,
    Set<ProviderCapability> capabilities = const <ProviderCapability>{},
  }) : capabilities = Set.unmodifiable(capabilities) {
    _checkNonBlank(id, 'id');
    _checkNonBlank(name, 'name');
  }

  final String id;
  final String name;
  final bool requiresNetwork;
  final bool requiresCredentials;
  final Set<ProviderCapability> capabilities;

  bool supports(ProviderCapability capability) {
    return capabilities.contains(capability);
  }
}

void _checkNonBlank(String value, String name) {
  if (value.trim().isEmpty) {
    throw ArgumentError.value(value, name, 'Must not be blank.');
  }
}
