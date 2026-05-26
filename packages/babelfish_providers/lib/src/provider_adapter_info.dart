final class ProviderAdapterInfo {
  const ProviderAdapterInfo({
    required this.id,
    required this.name,
    required this.requiresNetwork,
    required this.requiresCredentials,
  });

  final String id;
  final String name;
  final bool requiresNetwork;
  final bool requiresCredentials;
}
