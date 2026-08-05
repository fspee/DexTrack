import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models/pokemon_card.dart';
import '../../shared/widgets/dex_network_image.dart';
import '../collection/collection_provider.dart';
import '../scanner/scanner_session.dart';

class CardDetailPage extends ConsumerWidget {
  const CardDetailPage({
    required this.card,
    this.returnToScannerAfterAdd = false,
    super.key,
  });

  final PokemonCard card;

  /// Ist dieser Wert true, wird nach dem Hinzufügen `true`
  /// an die vorherige Scannerseite zurückgegeben.
  final bool returnToScannerAfterAdd;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final collection = ref.watch(collectionProvider);

    final matchingEntry = collection
        .where((entry) => entry.card.id == card.id)
        .firstOrNull;

    final quantity = matchingEntry?.quantity ?? 0;
    final isFavorite = matchingEntry?.isFavorite ?? false;

    return Scaffold(
      appBar: AppBar(
        title: Text(card.name),
        actions: [
          IconButton(
            tooltip: isFavorite
                ? 'Aus Favoriten entfernen'
                : 'Als Favorit markieren',
            onPressed: () {
              ref
                  .read(collectionProvider.notifier)
                  .toggleFavorite(card);
            },
            icon: Icon(
              isFavorite ? Icons.star : Icons.star_border,
              color: isFavorite ? Colors.amber : null,
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: DexNetworkImage(
                  imageUrl: card.imageUrl,
                  width: 300,
                  height: 420,
                  fit: BoxFit.contain,
                  borderRadius: 18,
                  placeholder: Container(
                    width: 300,
                    height: 420,
                    color:
                        Theme.of(context).colorScheme.primaryContainer,
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.style_outlined,
                      size: 80,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                card.name,
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium
                    ?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                card.setName,
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurfaceVariant,
                    ),
              ),
              const SizedBox(height: 24),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _InfoRow(
                        label: 'Kartennummer',
                        value: card.number,
                      ),
                      _InfoRow(
                        label: 'Seltenheit',
                        value: card.rarity,
                      ),
                      _InfoRow(
                        label: 'Kategorie',
                        value: card.supertype,
                      ),
                      if (card.hp != null)
                        _InfoRow(
                          label: 'KP',
                          value: card.hp.toString(),
                        ),
                      if (card.types.isNotEmpty)
                        _InfoRow(
                          label: 'Typ',
                          value: card.types.join(', '),
                        ),
                    ],
                  ),
                ),
              ),
              if (quantity > 0) ...[
                const SizedBox(height: 16),
                Card(
                  child: ListTile(
                    leading: Icon(
                      Icons.check_circle,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    title: const Text('Bereits in deiner Sammlung'),
                    subtitle: Text(
                      quantity == 1
                          ? 'Du besitzt diese Karte 1×.'
                          : 'Du besitzt diese Karte bereits $quantity×.',
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: FilledButton.icon(
                  icon: const Icon(Icons.add),
                  label: Text(
                    quantity == 0
                        ? 'Zur Sammlung hinzufügen'
                        : 'Weiteres Exemplar hinzufügen',
                  ),
                  onPressed: () {
  final alreadyOwned = quantity > 0;

  ref
      .read(collectionProvider.notifier)
      .addCard(card);

  final scannerSession = ref.read(scannerSessionProvider);

  if (returnToScannerAfterAdd &&
      scannerSession.isBoosterMode) {
    ref
        .read(scannerSessionProvider.notifier)
        .addCard(
          alreadyOwned: alreadyOwned,
        );
  }

  if (returnToScannerAfterAdd) {
    Navigator.of(context).pop(true);
    return;
  }

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        '${card.name} wurde hinzugefügt.',
      ),
    ),
  );
},
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color:
                    Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}