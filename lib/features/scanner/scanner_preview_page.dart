import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

import '../../core/models/pokemon_card.dart';
import '../../core/models/pokemon_set.dart';
import '../../core/repositories/pokemon_repository.dart';
import '../../shared/widgets/dex_network_image.dart';
import '../cards/card_detail_page.dart';
import '../cards/card_search_page.dart';
import '../collection/collection_provider.dart';
import 'scanner_session.dart';

class ScannerPreviewPage extends ConsumerStatefulWidget {
  const ScannerPreviewPage({
    required this.imagePath,
    super.key,
  });

  final String imagePath;

  @override
  ConsumerState<ScannerPreviewPage> createState() =>
      _ScannerPreviewPageState();
}

class _ScannerPreviewPageState
    extends ConsumerState<ScannerPreviewPage> {
  late final TextRecognizer _textRecognizer;

  bool _isRecognizing = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();

    _textRecognizer = TextRecognizer(
      script: TextRecognitionScript.latin,
    );
  }

  Future<void> _recognizeCard() async {
    if (_isRecognizing) {
      return;
    }

    setState(() {
      _isRecognizing = true;
      _errorMessage = null;
    });

    try {
      final inputImage = InputImage.fromFilePath(
        widget.imagePath,
      );

      final recognizedText = await _textRecognizer.processImage(
        inputImage,
      );

      final scanData = _extractCardData(
        recognizedText.text,
      );

      if (scanData.name == null) {
        if (!mounted) {
          return;
        }

        setState(() {
          _errorMessage =
              'Der Kartenname konnte nicht zuverlässig erkannt werden.';
        });

        return;
      }

      final repository = ref.read(
        pokemonRepositoryProvider,
      );

      final searchResults = await repository.searchCards(
        scanData.name!,
      );

      final sets = await repository.getSets();

      final matchingCards = _filterMatches(
        searchResults: searchResults,
        sets: sets,
        detectedNumber: scanData.number,
        detectedTotal: scanData.total,
      );

      if (!mounted) {
        return;
      }

      if (matchingCards.length == 1) {
  final card = matchingCards.first;

  final wasAdded = await Navigator.of(context).push<bool>(
    MaterialPageRoute<bool>(
      builder: (_) => CardDetailPage(
        card: card,
        returnToScannerAfterAdd: true,
      ),
    ),
  );

  if (!mounted) {
    return;
  }

  if (wasAdded == true) {
  Navigator.of(context).pop(true);
}

  return;
}

      await _showRecognitionResult(
        detectedName: scanData.name!,
        detectedNumber: scanData.number,
        cards: matchingCards,
      );
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _errorMessage =
            'Die Karte konnte nicht erkannt werden: $error';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isRecognizing = false;
        });
      }
    }
  }

  _DetectedCardData _extractCardData(String rawText) {
    final lines = rawText
        .split(RegExp(r'\r?\n'))
        .map((line) => line.trim())
        .where((line) => line.isNotEmpty)
        .toList();

    String? detectedName;
    String? detectedNumber;
    String? detectedTotal;

    bool isStageLine(String value) {
      final normalized = value
          .toLowerCase()
          .replaceAll(
            RegExp(r'[^a-zäöüß0-9 ]'),
            '',
          )
          .trim();

      return normalized == 'basis' ||
          normalized == 'basic' ||
          normalized == 'phase 1' ||
          normalized == 'phase1' ||
          normalized == 'phase 2' ||
          normalized == 'phase2';
    }

    // Der Kartenname steht üblicherweise direkt vor oder nach
    // BASIS, PHASE 1 beziehungsweise PHASE 2.
    for (var index = 0; index < lines.length; index++) {
      if (!isStageLine(lines[index])) {
        continue;
      }

      final candidateIndexes = [
        index + 1,
        index - 1,
        index + 2,
        index - 2,
      ];

      for (final candidateIndex in candidateIndexes) {
        if (candidateIndex < 0 ||
            candidateIndex >= lines.length) {
          continue;
        }

        final candidate = lines[candidateIndex];

        if (_isPlausibleCardName(candidate)) {
          detectedName = candidate;
          break;
        }
      }

      if (detectedName != null) {
        break;
      }
    }

    // Fallback, falls keine Entwicklungsstufe erkannt wurde.
    if (detectedName == null) {
      for (final line in lines) {
        if (_isPlausibleCardName(line)) {
          detectedName = line;
          break;
        }
      }
    }

    final numberPattern = RegExp(
      r'(\d{1,3})\s*[/|]\s*(\d{2,4})',
    );

    for (final line in lines) {
      final match = numberPattern.firstMatch(line);

      if (match == null) {
        continue;
      }

      detectedNumber = match.group(1)?.padLeft(3, '0');
      detectedTotal = match.group(2);

      // OCR erkennt beispielsweise 198 gelegentlich als 1980.
      if (detectedTotal != null &&
          detectedTotal!.length > 3) {
        detectedTotal = detectedTotal!.substring(0, 3);
      }

      break;
    }

    return _DetectedCardData(
      name: detectedName,
      number: detectedNumber,
      total: detectedTotal,
    );
  }

  bool _isPlausibleCardName(String value) {
    final cleaned = value.trim();
    final lower = cleaned.toLowerCase();

    if (cleaned.length < 2 || cleaned.length > 35) {
      return false;
    }

    if (!RegExp(r'[A-Za-zÄÖÜäöüß]').hasMatch(cleaned)) {
      return false;
    }

    const exactExcludedValues = {
      'basis',
      'basic',
      'phase 1',
      'phase1',
      'phase 2',
      'phase2',
      'fähigkeit',
      'attacke',
      'trainer',
      'energie',
    };

    if (exactExcludedValues.contains(lower)) {
      return false;
    }

    const excludedStarts = [
      'nr.',
      'größe',
      'gewicht',
      'schwäche',
      'resistenz',
      'rückzug',
      'illustr.',
      'pokémon',
      'pokemon',
      'fähigkeit',
      'entwicklung',
    ];

    if (excludedStarts.any(lower.startsWith)) {
      return false;
    }

    // Längere Sätze sind wahrscheinlich Attacken- oder Beschreibungstext.
    if (cleaned.split(RegExp(r'\s+')).length > 4) {
      return false;
    }

    if (RegExp(r'\d{2,3}\s*/\s*\d{2,4}').hasMatch(cleaned)) {
      return false;
    }

    return true;
  }

  List<PokemonCard> _filterMatches({
    required List<PokemonCard> searchResults,
    required List<PokemonSet> sets,
    required String? detectedNumber,
    required String? detectedTotal,
  }) {
    if (searchResults.isEmpty) {
      return [];
    }

    final normalizedNumber = detectedNumber == null
        ? null
        : _normalizeNumber(detectedNumber);

    final normalizedTotal = detectedTotal == null
        ? null
        : int.tryParse(
            _normalizeNumber(detectedTotal),
          );

    var matches = [...searchResults];

    // Zuerst nach der lokalen Kartennummer filtern.
    if (normalizedNumber != null &&
        normalizedNumber.isNotEmpty) {
      final numberMatches = matches.where((card) {
        return _normalizeNumber(card.number) ==
            normalizedNumber;
      }).toList();

      if (numberMatches.isNotEmpty) {
        matches = numberMatches;
      }
    }

    // Danach die Gesamtzahl des Sets berücksichtigen,
    // beispielsweise 165 aus 010/165.
    if (normalizedTotal != null) {
      final setsById = {
        for (final set in sets) set.id: set,
      };

      final totalMatches = matches.where((card) {
        final set = setsById[card.setId];

        if (set == null) {
          return false;
        }

        return set.officialCardCount == normalizedTotal ||
            set.totalCardCount == normalizedTotal;
      }).toList();

      if (totalMatches.isNotEmpty) {
        matches = totalMatches;
      }
    }

    return matches.take(5).toList();
  }

  String _normalizeNumber(String value) {
    final digits = RegExp(r'\d+')
        .firstMatch(value)
        ?.group(0);

    if (digits == null) {
      return '';
    }

    return int.tryParse(digits)?.toString() ?? digits;
  }

  Future<void> _showRecognitionResult({
    required String detectedName,
    required String? detectedNumber,
    required List<PokemonCard> cards,
  }) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (sheetContext) {
        return SafeArea(
          child: FractionallySizedBox(
            heightFactor: 0.82,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                20,
                4,
                20,
                24,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cards.isEmpty
                        ? 'Keine eindeutige Karte gefunden'
                        : 'Karte erkannt',
                    style: Theme.of(sheetContext)
                        .textTheme
                        .titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    detectedNumber == null
                        ? detectedName
                        : '$detectedName · $detectedNumber',
                    style: Theme.of(sheetContext)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(
                          color: Theme.of(sheetContext)
                              .colorScheme
                              .onSurfaceVariant,
                        ),
                  ),
                  const SizedBox(height: 20),
                  if (cards.isEmpty)
                    Expanded(
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.search_off,
                              size: 56,
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Bitte suche die Karte manuell.',
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 20),
                            FilledButton.icon(
                              onPressed: () {
                                Navigator.of(sheetContext).pop();

                                Navigator.of(context).push(
                                  MaterialPageRoute<void>(
                                    builder: (_) =>
                                        CardSearchPage(
  countForBooster:
      ref.read(scannerSessionProvider).isBoosterMode,
)
                                  ),
                                );
                              },
                              icon: const Icon(Icons.search),
                              label: const Text(
                                'Manuelle Suche öffnen',
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    Expanded(
                      child: ListView.separated(
                        itemCount: cards.length,
                        separatorBuilder: (_, _) =>
                            const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final card = cards[index];

                          return _RecognizedCardTile(
                            card: card,
                            
onOpen: () async {
  Navigator.of(sheetContext).pop();

  final wasAdded =
      await Navigator.of(this.context).push<bool>(
    MaterialPageRoute<bool>(
      builder: (_) => CardDetailPage(
        card: card,
        returnToScannerAfterAdd: true,
      ),
    ),
  );

  if (!mounted) {
    return;
  }

  if (wasAdded == true) {
    Navigator.of(this.context).pop(true);
  }
},

         onAdd: () {
  final collection = ref.read(collectionProvider);

  final alreadyOwned = collection.any(
    (entry) => entry.card.id == card.id,
  );

  ref
      .read(collectionProvider.notifier)
      .addCard(card);

  final scannerSession = ref.read(scannerSessionProvider);

  if (scannerSession.isBoosterMode) {
    ref
        .read(scannerSessionProvider.notifier)
        .addCard(
          alreadyOwned: alreadyOwned,
        );
  }

  Navigator.of(sheetContext).pop();

  if (mounted) {
    Navigator.of(this.context).pop(true);
  }
},                 
                          );
                        },
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _textRecognizer.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Foto prüfen'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: Image.file(
                      File(widget.imagePath),
                      fit: BoxFit.contain,
                      errorBuilder: (_, _, _) {
                        return const Center(
                          child: Text(
                            'Das Foto konnte nicht angezeigt werden.',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
            if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: Text(
                  _errorMessage!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: colors.error,
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                20,
                12,
                20,
                24,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _isRecognizing
                          ? null
                          : () {
                              Navigator.of(context).pop();
                            },
                      icon: const Icon(Icons.refresh),
                      label: const Text(
                        'Erneut aufnehmen',
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: const BorderSide(
                          color: Colors.white,
                        ),
                        minimumSize: const Size(0, 56),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: _isRecognizing
                          ? null
                          : _recognizeCard,
                      icon: _isRecognizing
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            )
                          : const Icon(Icons.search),
                      label: Text(
                        _isRecognizing
                            ? 'Erkennung …'
                            : 'Karte erkennen',
                      ),
                      style: FilledButton.styleFrom(
                        minimumSize: const Size(0, 56),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RecognizedCardTile extends StatelessWidget {
  const _RecognizedCardTile({
    required this.card,
    required this.onOpen,
    required this.onAdd,
  });

  final PokemonCard card;
  final VoidCallback onOpen;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context)
          .colorScheme
          .surfaceContainerLow,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onOpen,
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              DexNetworkImage(
                imageUrl: card.imageUrl,
                width: 64,
                height: 90,
                fit: BoxFit.cover,
                borderRadius: 10,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      card.name,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      card.setName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${card.number} · ${card.rarity}',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall,
                    ),
                  ],
                ),
              ),
              IconButton.filled(
                tooltip: 'Zur Sammlung hinzufügen',
                onPressed: onAdd,
                icon: const Icon(Icons.add),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DetectedCardData {
  const _DetectedCardData({
    required this.name,
    required this.number,
    required this.total,
  });

  final String? name;
  final String? number;
  final String? total;
}