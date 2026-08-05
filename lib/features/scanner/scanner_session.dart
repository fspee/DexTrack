import 'package:flutter_riverpod/flutter_riverpod.dart';

class ScannerSession {
  const ScannerSession({
    this.isBoosterMode = false,
    this.scannedCards = 0,
    this.newCards = 0,
    this.duplicates = 0,
  });

  final bool isBoosterMode;
  final int scannedCards;
  final int newCards;
  final int duplicates;

  ScannerSession copyWith({
    bool? isBoosterMode,
    int? scannedCards,
    int? newCards,
    int? duplicates,
  }) {
    return ScannerSession(
      isBoosterMode: isBoosterMode ?? this.isBoosterMode,
      scannedCards: scannedCards ?? this.scannedCards,
      newCards: newCards ?? this.newCards,
      duplicates: duplicates ?? this.duplicates,
    );
  }
}

class ScannerSessionNotifier extends Notifier<ScannerSession> {
  @override
  ScannerSession build() {
    return const ScannerSession();
  }

  void startBooster() {
    state = const ScannerSession(
      isBoosterMode: true,
    );
  }

  void stopBooster() {
    state = const ScannerSession();
  }

  void addCard({
    required bool alreadyOwned,
  }) {
    state = state.copyWith(
      scannedCards: state.scannedCards + 1,
      newCards: state.newCards + (alreadyOwned ? 0 : 1),
      duplicates: state.duplicates + (alreadyOwned ? 1 : 0),
    );
  }
}

final scannerSessionProvider =
    NotifierProvider<ScannerSessionNotifier, ScannerSession>(
  ScannerSessionNotifier.new,
);