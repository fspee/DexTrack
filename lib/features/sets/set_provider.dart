import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models/pokemon_card.dart';
import '../../core/models/pokemon_set.dart';
import '../../core/services/tcgdex_provider.dart';

final setsProvider = FutureProvider<List<PokemonSet>>((ref) {
  final service = ref.watch(tcgdexServiceProvider);
  return service.getSets();
});

final setCardsProvider =
    FutureProvider.family<List<PokemonCard>, String>((ref, setId) async {
  final service = ref.watch(tcgdexServiceProvider);
  final cards = await service.getCardsForSet(setId);

  cards.sort((first, second) {
    final firstNumber = _numberValue(first.number);
    final secondNumber = _numberValue(second.number);

    return firstNumber.compareTo(secondNumber);
  });

  return cards;
});

int _numberValue(String number) {
  final firstPart = number.split('/').first;
  final digits = RegExp(r'\d+').firstMatch(firstPart)?.group(0);

  return int.tryParse(digits ?? '') ?? 999999;
}