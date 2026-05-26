final class BabelLanguage {
  const BabelLanguage({
    required this.code,
    required this.name,
    this.nativeName,
  });

  final String code;
  final String name;
  final String? nativeName;

  String get displayName {
    final localName = nativeName;
    if (localName == null || localName == name) {
      return name;
    }

    return '$name ($localName)';
  }

  @override
  bool operator ==(Object other) {
    return other is BabelLanguage &&
        other.code == code &&
        other.name == name &&
        other.nativeName == nativeName;
  }

  @override
  int get hashCode => Object.hash(code, name, nativeName);

  @override
  String toString() => 'BabelLanguage(code: $code, name: $name)';
}
