import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models/pokemon_card.dart';
import '../../core/models/pokemon_set.dart';
import '../../core/repositories/pokemon_repository.dart';

final setsProvider = FutureProvider<List<PokemonSet>>((ref) {
  final repository = ref.watch(pokemonRepositoryProvider);
  return repository.getSets();
});

final setCardsProvider =
    FutureProvider.family<List<PokemonCard>, String>((ref, setId) {
  final repository = ref.watch(pokemonRepositoryProvider);
  return repository.getSetCards(setId);
});