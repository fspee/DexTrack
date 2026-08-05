import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/pokemon_card.dart';
import '../services/tcgdex_provider.dart';
import '../services/tcgdex_service.dart';

class PokemonRepository {
  PokemonRepository({
    required this.service,
  });

  final TcgdexService service;

  Future<List<PokemonCard>> searchCards(String query) {
    return service.searchCards(query);
  }

  Future<PokemonCard> getCard(String id) {
    return service.getCard(id);
  }
}

final pokemonRepositoryProvider = Provider<PokemonRepository>((ref) {
  return PokemonRepository(
    service: ref.watch(tcgdexServiceProvider),
  );
});