import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models/pokemon_card.dart';
import '../../core/models/pokemon_set.dart';
import '../../core/services/tcgdex_provider.dart';
import '../../database/database_provider.dart';

final setsProvider = FutureProvider<List<PokemonSet>>((ref) {
  final service = ref.watch(tcgdexServiceProvider);
  return service.getSets();
});

final setCardsProvider =
    FutureProvider.family<List<PokemonCard>, String>((ref, setId) async {
  final service = ref.watch(tcgdexServiceProvider);

  if (!kIsWeb) {
    final database = ref.watch(databaseProvider);

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

  final downloadedCards =
      await service.getCardsForSet(setId);

  downloadedCards.sort(_compareCardNumbers);

  return downloadedCards;
});

int _compareCardNumbers(
  PokemonCard first,
  PokemonCard second,
) {
  return _numberValue(first.number).compareTo(
    _numberValue(second.number),
  );
}

int _numberValue(String number) {
  final firstPart = number.split('/').first;
  final digits =
      RegExp(r'\d+').firstMatch(firstPart)?.group(0);

  return int.tryParse(digits ?? '') ?? 999999;
}