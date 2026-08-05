import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mlkit_document_scanner/google_mlkit_document_scanner.dart';

import '../cards/card_search_page.dart';
import 'scanner_preview_page.dart';
import 'scanner_session.dart';

class ScannerPage extends ConsumerStatefulWidget {
  const ScannerPage({super.key});

  @override
  ConsumerState<ScannerPage> createState() => _ScannerPageState();
}

class _ScannerPageState extends ConsumerState<ScannerPage> {
  late final DocumentScanner _documentScanner;

  bool _isScanning = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();

    const documentFormats = {
      DocumentFormat.jpeg,
    };

    final options = DocumentScannerOptions(
      documentFormats: documentFormats,
      mode: ScannerMode.filter,
      pageLimit: 1,
      isGalleryImport: true,
    );

    _documentScanner = DocumentScanner(
      options: options,
    );
  }

  Future<void> _scanCard() async {
    if (_isScanning) {
      return;
    }

    setState(() {
      _isScanning = true;
      _errorMessage = null;
    });

    try {
      final result = await _documentScanner.scanDocument();

      if (!mounted) {
        return;
      }

      final images = result.images;

      if (images == null || images.isEmpty) {
        setState(() {
          _errorMessage = 'Es wurde kein Scan übernommen.';
        });
        return;
      }

      final imagePath = images.first;

      if (!File(imagePath).existsSync()) {
        setState(() {
          _errorMessage =
              'Das gescannte Bild konnte nicht gefunden werden.';
        });
        return;
      }

      final scanAgain = await Navigator.of(context).push<bool>(
        MaterialPageRoute<bool>(
          builder: (_) => ScannerPreviewPage(
            imagePath: imagePath,
          ),
        ),
      );

      if (!mounted) {
        return;
      }

      if (scanAgain == true) {
        setState(() {
          _isScanning = false;
        });

        await _scanCard();
        return;
      }
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _errorMessage =
            'Der Scan konnte nicht gestartet werden: $error';
      });
    } finally {
      if (mounted && _isScanning) {
        setState(() {
          _isScanning = false;
        });
      }
    }
  }

  Future<void> _openManualSearch() async {
  final session = ref.read(scannerSessionProvider);

  final scanAgain = await Navigator.of(context).push<bool>(
    MaterialPageRoute<bool>(
      builder: (_) => CardSearchPage(
        countForBooster: session.isBoosterMode,
      ),
    ),
  );

  if (!mounted) {
    return;
  }

  if (scanAgain == true &&
      session.isBoosterMode) {
    await _scanCard();
  }
}

  Future<void> _finishBooster() async {
    final session = ref.read(scannerSessionProvider);

    final shouldFinish = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Booster beenden?'),
          content: Text(
            '${session.scannedCards} Karten wurden hinzugefügt.\n\n'
            '${session.newCards} neu · '
            '${session.duplicates} doppelt',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(false);
              },
              child: const Text('Weiter scannen'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(true);
              },
              child: const Text('Booster beenden'),
            ),
          ],
        );
      },
    );

    if (shouldFinish == true) {
      ref
          .read(scannerSessionProvider.notifier)
          .stopBooster();
    }
  }

  @override
  void dispose() {
    _documentScanner.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final session = ref.watch(scannerSessionProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          session.isBoosterMode
              ? 'Booster scannen'
              : 'Karte scannen',
        ),
        actions: [
          IconButton(
            tooltip: 'Karte manuell suchen',
            onPressed: _openManualSearch,
            icon: const Icon(Icons.search),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            24,
            24,
            24,
            24,
          ),
          child: Column(
            children: [
              if (session.isBoosterMode) ...[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: colors.primaryContainer,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.inventory_2_outlined,
                        color: colors.primary,
                        size: 30,
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${session.scannedCards} Karten hinzugefügt',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium,
                            ),
                            const SizedBox(height: 3),
                            Text(
                              '${session.newCards} neu · '
                              '${session.duplicates} doppelt',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color:
                                        colors.onSurfaceVariant,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: _finishBooster,
                        child: const Text('Beenden'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],

              Expanded(
                child: Center(
                  child: Container(
                    constraints: const BoxConstraints(
                      maxWidth: 320,
                    ),
                    padding: const EdgeInsets.all(28),
                    decoration: BoxDecoration(
                      color: colors.primaryContainer,
                      borderRadius: BorderRadius.circular(28),
                    ),
                    child: AspectRatio(
                      aspectRatio: 63 / 88,
                      child: Container(
                        decoration: BoxDecoration(
                          color: colors.surface,
                          borderRadius:
                              BorderRadius.circular(18),
                          border: Border.all(
                            color: colors.primary,
                            width: 3,
                          ),
                        ),
                        child: Icon(
                          Icons.document_scanner_outlined,
                          size: 88,
                          color: colors.primary,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Text(
                session.isBoosterMode
                    ? 'Nächste Karte scannen'
                    : 'Pokémon-Karte scannen',
                style:
                    Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 8),

              Text(
                session.isBoosterMode
                    ? 'Nach dem Hinzufügen öffnet sich der Scanner automatisch erneut.'
                    : 'Der Scanner erkennt die Kartenränder und schneidet das Foto automatisch zu.',
                style:
                    Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: colors.onSurfaceVariant,
                        ),
                textAlign: TextAlign.center,
              ),

              if (_errorMessage != null) ...[
                const SizedBox(height: 16),
                Text(
                  _errorMessage!,
                  style: TextStyle(
                    color: colors.error,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed:
                      _isScanning ? null : _scanCard,
                  icon: _isScanning
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        )
                      : const Icon(Icons.document_scanner),
                  label: Text(
                    _isScanning
                        ? 'Scanner wird geöffnet …'
                        : 'Scan starten',
                  ),
                ),
              ),

              const SizedBox(height: 10),

              if (!session.isBoosterMode)
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      ref
                          .read(
                            scannerSessionProvider.notifier,
                          )
                          .startBooster();
                    },
                    icon:
                        const Icon(Icons.inventory_2_outlined),
                    label:
                        const Text('Booster-Modus starten'),
                  ),
                ),

              const SizedBox(height: 4),

              TextButton.icon(
                onPressed: _openManualSearch,
                icon: const Icon(Icons.search),
                label: const Text(
                  'Karte stattdessen manuell suchen',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}