final class ProviderUnavailableException implements Exception {
  const ProviderUnavailableException({
    required this.providerId,
    required this.reason,
  });

  final String providerId;
  final String reason;

  @override
  String toString() => 'Provider $providerId is unavailable: $reason';
}
