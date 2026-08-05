import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'tcgdex_service.dart';

final tcgdexServiceProvider = Provider<TcgdexService>((ref) {
  final service = TcgdexService();

  ref.onDispose(service.dispose);

  return service;
});