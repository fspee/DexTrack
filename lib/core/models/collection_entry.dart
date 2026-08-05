import 'pokemon_card.dart';

class CollectionEntry {
  const CollectionEntry({
    required this.card,
    this.quantity = 1,
    this.isFavorite = false,
  });

  final PokemonCard card;
  final int quantity;
  final bool isFavorite;

  CollectionEntry copyWith({
    PokemonCard? card,
    int? quantity,
    bool? isFavorite,
  }) {
    return CollectionEntry(
      card: card ?? this.card,
      quantity: quantity ?? this.quantity,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}