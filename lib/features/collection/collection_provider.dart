import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models/collection_entry.dart';
import '../../core/models/pokemon_card.dart';
import '../../database/database_provider.dart';

final collectionProvider =
    NotifierProvider<CollectionNotifier, List<CollectionEntry>>(
  CollectionNotifier.new,
);

class CollectionNotifier extends Notifier<List<CollectionEntry>> {
  bool _collectionLoaded = false;

  @override
  List<CollectionEntry> build() {
    if (!kIsWeb) {
      Future.microtask(_loadCollection);
    }

    return [];
  }

  Future<void> _loadCollection() async {
    if (_collectionLoaded) {
      return;
    }

    _collectionLoaded = true;

    try {
      final database = ref.read(databaseProvider);
      final storedCollection = await database.loadCollectionEntries();

      state = storedCollection;
    } catch (error, stackTrace) {
      debugPrint('Sammlung konnte nicht geladen werden: $error');
      debugPrintStack(stackTrace: stackTrace);
    }
  }

  void addCard(PokemonCard card) {
    final existingIndex = state.indexWhere(
      (entry) => entry.card.id == card.id,
    );

    if (existingIndex == -1) {
      final newEntry = CollectionEntry(
        card: card,
        quantity: 1,
      );

      state = [
        ...state,
        newEntry,
      ];

      _saveEntry(newEntry);
      return;
    }

    final updatedEntry = state[existingIndex].copyWith(
      quantity: state[existingIndex].quantity + 1,
    );

    state = [
      for (var index = 0; index < state.length; index++)
        if (index == existingIndex)
          updatedEntry
        else
          state[index],
    ];

    _saveEntry(updatedEntry);
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

      _deleteEntry(card.id);
      return;
    }

    final updatedEntry = existingEntry.copyWith(
      quantity: existingEntry.quantity - 1,
    );

    state = [
      for (var index = 0; index < state.length; index++)
        if (index == existingIndex)
          updatedEntry
        else
          state[index],
    ];

    _saveEntry(updatedEntry);
  }

  void removeCardCompletely(PokemonCard card) {
    state = [
      for (final entry in state)
        if (entry.card.id != card.id) entry,
    ];

    _deleteEntry(card.id);
  }

void toggleFavorite(PokemonCard card) {
  final existingIndex = state.indexWhere(
    (entry) => entry.card.id == card.id,
  );

  if (existingIndex == -1) {
    final newEntry = CollectionEntry(
      card: card,
      quantity: 1,
      isFavorite: true,
    );

    state = [
      ...state,
      newEntry,
    ];

    _saveEntry(newEntry);
    return;
  }

  final updatedEntry = state[existingIndex].copyWith(
    isFavorite: !state[existingIndex].isFavorite,
  );

  state = [
    for (var index = 0; index < state.length; index++)
      if (index == existingIndex)
        updatedEntry
      else
        state[index],
  ];

  _saveEntry(updatedEntry);
}

  void clearCollection() {
    state = [];

    if (!kIsWeb) {
      final database = ref.read(databaseProvider);
      unawaited(database.clearStoredCollection());
    }
  }

  void _saveEntry(CollectionEntry entry) {
    if (kIsWeb) {
      return;
    }

    final database = ref.read(databaseProvider);

    unawaited(
      database.saveCollectionEntry(
        card: entry.card,
        quantity: entry.quantity,
        isFavorite: entry.isFavorite,
      ),
    );
  }

  void _deleteEntry(String cardId) {
    if (kIsWeb) {
      return;
    }

    final database = ref.read(databaseProvider);

    unawaited(
      database.deleteCollectionEntry(cardId),
    );
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