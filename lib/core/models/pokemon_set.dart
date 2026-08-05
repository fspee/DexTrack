class PokemonSet {
  const PokemonSet({
    required this.id,
    required this.name,
    required this.logoUrl,
    required this.symbolUrl,
    required this.officialCardCount,
    required this.totalCardCount,
  });

  final String id;
  final String name;
  final String logoUrl;
  final String symbolUrl;
  final int officialCardCount;
  final int totalCardCount;

  factory PokemonSet.fromTcgdex(Map<String, dynamic> json) {
    final cardCount =
        json['cardCount'] as Map<String, dynamic>? ?? const {};

    final logoBase = json['logo'] as String?;
    final symbolBase = json['symbol'] as String?;

    return PokemonSet(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? 'Unbekanntes Set',
      logoUrl: logoBase == null ? '' : '$logoBase.webp',
      symbolUrl: symbolBase == null ? '' : '$symbolBase.webp',
      officialCardCount: _parseInt(cardCount['official']),
      totalCardCount: _parseInt(cardCount['total']),
    );
  }

  static int _parseInt(dynamic value) {
    if (value is int) {
      return value;
    }

    if (value is num) {
      return value.toInt();
    }

    if (value is String) {
      return int.tryParse(value) ?? 0;
    }

    return 0;
  }
}