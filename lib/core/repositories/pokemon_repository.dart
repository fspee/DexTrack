import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../database/app_database.dart';
import '../../database/database_provider.dart';
import '../models/pokemon_card.dart';
import '../models/pokemon_set.dart';
import '../services/tcgdex_provider.dart';
import '../services/tcgdex_service.dart';

class PokemonRepository {
  const PokemonRepository({
    required this.database,
    required this.service,
  });

  final AppDatabase database;
  final TcgdexService service;

  Future<List<PokemonSet>> getSets() {
    return service.getSets();
  }

  Future<List<PokemonCard>> getSetCards(String setId) async {
    if (kIsWeb) {
      final cards = await service.getCardsForSet(setId);
      cards.sort(_compareCardNumbers);
      return cards;
    }

    final cacheComplete = await database.isSetCacheComplete(setId);

    if (cacheComplete) {
      final cachedCards =
          await database.loadCachedCardsForSet(setId);

      cachedCards.sort(_compareCardNumbers);
      return cachedCards;
    }

    final downloadedCards =
        await service.getCardsForSet(setId);

    downloadedCards.sort(_compareCardNumbers);

    await database.saveCardsToCache(downloadedCards);
    await database.markSetCacheComplete(setId);

    return downloadedCards;
  }

  Future<List<PokemonCard>> searchCards(String query) {
    return service.searchCards(query);
  }

  Future<PokemonCard> getCard(String id) {
    return service.getCard(id);
  }

  static int _compareCardNumbers(
    PokemonCard first,
    PokemonCard second,
  ) {
    return _numberValue(first.number).compareTo(
      _numberValue(second.number),
    );
  }

  static int _numberValue(String number) {
    final firstPart = number.split('/').first;
    final digits =
        RegExp(r'\d+').firstMatch(firstPart)?.group(0);

    return int.tryParse(digits ?? '') ?? 999999;
  }
}

final pokemonRepositoryProvider = Provider<PokemonRepository>((ref) {
  return PokemonRepository(
    database: ref.watch(databaseProvider),
    service: ref.watch(tcgdexServiceProvider),
  );
});