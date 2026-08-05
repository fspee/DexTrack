import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models/pokemon_card.dart';
import '../../core/repositories/pokemon_repository.dart';

final cardSearchProvider =
    FutureProvider.autoDispose.family<List<PokemonCard>, String>(
  (ref, query) async {
    final cleanedQuery = query.trim();

    if (cleanedQuery.length < 2) {
      return [];
    }

    final repository = ref.watch(pokemonRepositoryProvider);

    return repository.searchCards(cleanedQuery);
  },
);