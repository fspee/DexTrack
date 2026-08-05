import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models/collection_entry.dart';
import '../../core/models/pokemon_card.dart';

final collectionProvider =
    NotifierProvider<CollectionNotifier, List<CollectionEntry>>(
  CollectionNotifier.new,
);

class CollectionNotifier extends Notifier<List<CollectionEntry>> {
  @override
  List<CollectionEntry> build() {
    return [];
  }

  void addCard(PokemonCard card) {
    final existingIndex = state.indexWhere(
      (entry) => entry.card.id == card.id,
    );

    if (existingIndex == -1) {
      state = [
        ...state,
        CollectionEntry(card: card),
      ];
      return;
    }

    state = [
      for (var index = 0; index < state.length; index++)
        if (index == existingIndex)
          state[index].copyWith(
            quantity: state[index].quantity + 1,
          )
        else
          state[index],
    ];
  }

  void removeOneCard(PokemonCard card) {
    final existingIndex = state.indexWhere(
      (entry) => entry.card.id == card.id,
    );

    if (existingIndex == -1) {
      return;
    }

    final existingEntry = state[existingIndex];

    if (existingEntry.quantity <= 1) {
      state = [
        for (final entry in state)
          if (entry.card.id != card.id) entry,
      ];
      return;
    }

    state = [
      for (var index = 0; index < state.length; index++)
        if (index == existingIndex)
          state[index].copyWith(
            quantity: state[index].quantity - 1,
          )
        else
          state[index],
    ];
  }

  void removeCardCompletely(PokemonCard card) {
    state = [
      for (final entry in state)
        if (entry.card.id != card.id) entry,
    ];
  }

  void clearCollection() {
    state = [];
  }
}

final totalCardCountProvider = Provider<int>((ref) {
  final collection = ref.watch(collectionProvider);

  return collection.fold(
    0,
    (total, entry) => total + entry.quantity,
  );
});

final uniqueCardCountProvider = Provider<int>((ref) {
  return ref.watch(collectionProvider).length;
});