enum BabelFishRuntimeMode { fixture }

final class BabelFishRuntimeConfig {
  const BabelFishRuntimeConfig._({required this.mode});

  const BabelFishRuntimeConfig.fixture()
    : this._(mode: BabelFishRuntimeMode.fixture);

  factory BabelFishRuntimeConfig.fromEnvironment({
    String mode = const String.fromEnvironment(
      'BABEL_FISH_MODE',
      defaultValue: 'fixture',
    ),
  }) {
    return switch (mode.trim().toLowerCase()) {
      'fixture' => const BabelFishRuntimeConfig.fixture(),
      _ => throw UnsupportedError(
        'Unsupported BABEL_FISH_MODE "$mode". Supported values: fixture.',
      ),
    };
  }

  final BabelFishRuntimeMode mode;
}
