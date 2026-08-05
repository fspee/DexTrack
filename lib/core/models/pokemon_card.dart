class PokemonCard {
  const PokemonCard({
    required this.id,
    required this.name,
    required this.setId,
    required this.setName,
    required this.number,
    required this.rarity,
    required this.imageUrl,
    required this.cardmarketUrl,
    required this.language,
    required this.supertype,
    required this.subtypes,
    required this.hp,
    required this.types,
  });

  final String id;
  final String name;
  final String setId;
  final String setName;
  final String number;
  final String rarity;
  final String imageUrl;
  final String cardmarketUrl;
  final String language;
  final String supertype;
  final List<String> subtypes;
  final int? hp;
  final List<String> types;

  factory PokemonCard.fromTcgdexDetail(Map<String, dynamic> json) {
    final set = json['set'] as Map<String, dynamic>? ?? {};
    final imageBase = json['image'] as String?;

    return PokemonCard(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? 'Unbekannte Karte',
      setId: set['id'] as String? ?? '',
      setName: set['name'] as String? ?? 'Unbekanntes Set',
      number: json['localId'] as String? ?? '',
      rarity: json['rarity'] as String? ?? 'Unbekannt',
      imageUrl: imageBase == null ? '' : '$imageBase/high.webp',
      cardmarketUrl: '',
      language: 'de',
      supertype: json['category'] as String? ?? 'Unbekannt',
      subtypes: [
        if (json['stage'] is String) json['stage'] as String,
        if (json['suffix'] is String) json['suffix'] as String,
        if (json['trainerType'] is String) json['trainerType'] as String,
        if (json['energyType'] is String) json['energyType'] as String,
      ],
      hp: _parseHp(json['hp']),
      types: (json['types'] as List<dynamic>?)
              ?.whereType<String>()
              .toList() ??
          const [],
    );
  }

  static int? _parseHp(dynamic value) {
    if (value is int) {
      return value;
    }

    if (value is String) {
      return int.tryParse(value);
    }

    return null;
  }
}