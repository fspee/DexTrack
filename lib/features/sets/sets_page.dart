import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models/pokemon_set.dart';
import '../collection/collection_provider.dart';
import 'set_detail_page.dart';
import 'set_provider.dart';

class SetsPage extends ConsumerWidget {
  const SetsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final setsResult = ref.watch(setsProvider);
    final collection = ref.watch(collectionProvider);

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Erweiterungen',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Wähle ein Set und verfolge deinen Fortschritt.',
                  style: TextStyle(
                    color: Color(0xFF6B7280),
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: setsResult.when(
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
              error: (error, stackTrace) {
                return _SetError(
                  message: error.toString(),
                  onRetry: () {
                    ref.invalidate(setsProvider);
                  },
                );
              },
              data: (sets) {
                if (sets.isEmpty) {
                  return const Center(
                    child: Text('Keine Sets gefunden.'),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                  itemCount: sets.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final set = sets[index];

                    // Unterschiedliche Karten dieses Sets in der Sammlung.
                    final ownedCardIds = collection
                        .where((entry) => entry.card.setId == set.id)
                        .map((entry) => entry.card.id)
                        .toSet();

                    final ownedCount = ownedCardIds.length;

                    // Wir verwenden dieselbe Gesamtzahl wie in der Detailseite.
                    final totalCount = set.totalCardCount > 0
                        ? set.totalCardCount
                        : set.officialCardCount;

                    final progress = totalCount == 0
                        ? 0.0
                        : (ownedCount / totalCount).clamp(0.0, 1.0);

                    return _SetTile(
                      set: set,
                      ownedCount: ownedCount,
                      totalCount: totalCount,
                      progress: progress,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => SetDetailPage(
                              set: set,
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _SetTile extends StatelessWidget {
  const _SetTile({
    required this.set,
    required this.ownedCount,
    required this.totalCount,
    required this.progress,
    required this.onTap,
  });

  final PokemonSet set;
  final int ownedCount;
  final int totalCount;
  final double progress;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final percentage = (progress * 100).round();

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: const Color(0xFFE5E7EB),
            ),
          ),
          child: Row(
            children: [
              SizedBox(
                width: 76,
                height: 58,
                child: set.logoUrl.isEmpty
                    ? _SetSymbol(set: set)
                    : Image.network(
                        set.logoUrl,
                        fit: BoxFit.contain,
                        errorBuilder: (_, _, _) {
                          return _SetSymbol(set: set);
                        },
                      ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      set.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      '${set.officialCardCount} reguläre Karten'
                      '${set.totalCardCount > set.officialCardCount ? ' · ${set.totalCardCount} insgesamt' : ''}',
                      style: const TextStyle(
                        color: Color(0xFF6B7280),
                      ),
                    ),
                    const SizedBox(height: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 7,
                      ),
                    ),
                    const SizedBox(height: 7),
                    Row(
                      children: [
                        Text(
                          '$percentage % gesammelt',
                          style: const TextStyle(
                            color: Color(0xFF6B7280),
                            fontSize: 12,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          '$ownedCount / $totalCount',
                          style: const TextStyle(
                            color: Color(0xFF6B7280),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}

class _SetSymbol extends StatelessWidget {
  const _SetSymbol({
    required this.set,
  });

  final PokemonSet set;

  @override
  Widget build(BuildContext context) {
    if (set.symbolUrl.isNotEmpty) {
      return Image.network(
        set.symbolUrl,
        fit: BoxFit.contain,
        errorBuilder: (_, _, _) {
          return _PlaceholderIcon(setName: set.name);
        },
      );
    }

    return _PlaceholderIcon(setName: set.name);
  }
}

class _PlaceholderIcon extends StatelessWidget {
  const _PlaceholderIcon({
    required this.setName,
  });

  final String setName;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      alignment: Alignment.center,
      child: Text(
        setName.isEmpty ? '?' : setName.characters.first.toUpperCase(),
        style: TextStyle(
          color: Theme.of(context).colorScheme.primary,
          fontSize: 24,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _SetError extends StatelessWidget {
  const _SetError({
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.cloud_off_outlined,
              size: 56,
            ),
            const SizedBox(height: 16),
            Text(
              'Sets konnten nicht geladen werden',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFF6B7280),
              ),
            ),
            const SizedBox(height: 20),
            OutlinedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Erneut versuchen'),
            ),
          ],
        ),
      ),
    );
  }
}