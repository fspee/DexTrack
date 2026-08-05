import 'pokemon_card.dart';

class CollectionEntry {
  const CollectionEntry({
    required this.card,
    this.quantity = 1,
  });

  final PokemonCard card;
  final int quantity;

  CollectionEntry copyWith({
    PokemonCard? card,
    int? quantity,
  }) {
    return CollectionEntry(
      card: card ?? this.card,
      quantity: quantity ?? this.quantity,
    );
  }
}