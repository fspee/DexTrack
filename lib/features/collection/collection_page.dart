import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme/app_spacing.dart';
import '../../core/models/collection_entry.dart';
import '../../shared/widgets/dex_card.dart';
import '../cards/card_detail_page.dart';
import 'collection_provider.dart';
import '../../shared/widgets/dex_network_image.dart';

enum CollectionSort {
  recentlyAdded,
  name,
  set,
  number,
}

class CollectionPage extends ConsumerStatefulWidget {
  const CollectionPage({super.key});

  @override
  ConsumerState<CollectionPage> createState() => _CollectionPageState();
}

class _CollectionPageState extends ConsumerState<CollectionPage> {
  final TextEditingController _searchController = TextEditingController();

  String _searchQuery = '';
  CollectionSort _sort = CollectionSort.recentlyAdded;
  bool _favoritesOnly = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<CollectionEntry> _filterAndSort(
    List<CollectionEntry> collection,
  ) {
    final query = _searchQuery.trim().toLowerCase();

    final filtered = collection.where((entry) {
  if (_favoritesOnly && !entry.isFavorite) {
    return false;
  }

  if (query.isEmpty) {
    return true;
  }

  final card = entry.card;

  return card.name.toLowerCase().contains(query) ||
      card.setName.toLowerCase().contains(query) ||
      card.number.toLowerCase().contains(query);
}).toList();

    switch (_sort) {
      case CollectionSort.recentlyAdded:
        return filtered.reversed.toList();

      case CollectionSort.name:
        filtered.sort(
          (first, second) => first.card.name.toLowerCase().compareTo(
                second.card.name.toLowerCase(),
              ),
        );
        return filtered;

      case CollectionSort.set:
        filtered.sort((first, second) {
          final setComparison = first.card.setName.toLowerCase().compareTo(
                second.card.setName.toLowerCase(),
              );

          if (setComparison != 0) {
            return setComparison;
          }

          return _numberValue(first.card.number).compareTo(
            _numberValue(second.card.number),
          );
        });
        return filtered;

      case CollectionSort.number:
        filtered.sort(
          (first, second) => _numberValue(first.card.number).compareTo(
            _numberValue(second.card.number),
          ),
        );
        return filtered;
    }
  }

  int _numberValue(String number) {
    final firstPart = number.split('/').first;
    final match = RegExp(r'\d+').firstMatch(firstPart);

    return int.tryParse(match?.group(0) ?? '') ?? 999999;
  }

  void _openCardDetails(CollectionEntry entry) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => CardDetailPage(
          card: entry.card,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final collection = ref.watch(collectionProvider);
    final totalCards = ref.watch(totalCardCountProvider);
    final uniqueCards = ref.watch(uniqueCardCountProvider);

    final visibleEntries = _filterAndSort(collection);

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.medium,
              AppSpacing.large,
              AppSpacing.medium,
              AppSpacing.medium,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Meine Sammlung',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: AppSpacing.xSmall),
                Text(
                  '$totalCards Karten · $uniqueCards verschiedene',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color:
                            Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
                const SizedBox(height: AppSpacing.large),
                TextField(
                  controller: _searchController,
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Sammlung durchsuchen',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchController.text.isEmpty
                        ? null
                        : IconButton(
                            tooltip: 'Suche löschen',
                            onPressed: () {
                              _searchController.clear();

                              setState(() {
                                _searchQuery = '';
                              });
                            },
                            icon: const Icon(Icons.close),
                          ),
                  ),
                ),
                const SizedBox(height: AppSpacing.medium),
                FilterChip(
  avatar: Icon(
    _favoritesOnly ? Icons.star : Icons.star_border,
    size: 18,
  ),
  label: const Text('Nur Favoriten'),
  selected: _favoritesOnly,
  onSelected: (selected) {
    setState(() {
      _favoritesOnly = selected;
    });
  },
),
                Row(
                  children: [
                    Text(
                      '${visibleEntries.length} Ergebnisse',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurfaceVariant,
                          ),
                    ),
                    const Spacer(),
                    PopupMenuButton<CollectionSort>(
                      initialValue: _sort,
                      tooltip: 'Sortierung',
                      onSelected: (value) {
                        setState(() {
                          _sort = value;
                        });
                      },
                      itemBuilder: (_) => const [
                        PopupMenuItem(
                          value: CollectionSort.recentlyAdded,
                          child: Text('Zuletzt hinzugefügt'),
                        ),
                        PopupMenuItem(
                          value: CollectionSort.name,
                          child: Text('Name'),
                        ),
                        PopupMenuItem(
                          value: CollectionSort.set,
                          child: Text('Set'),
                        ),
                        PopupMenuItem(
                          value: CollectionSort.number,
                          child: Text('Kartennummer'),
                        ),
                      ],
                      child: OutlinedButton.icon(
                        onPressed: null,
                        icon: const Icon(Icons.sort),
                        label: Text(_sortLabel(_sort)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: collection.isEmpty
                ? const _EmptyCollection()
                : visibleEntries.isEmpty
                    ? const _NoSearchResults()
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(
                          AppSpacing.medium,
                          0,
                          AppSpacing.medium,
                          AppSpacing.large,
                        ),
                        itemCount: visibleEntries.length,
                        separatorBuilder: (_, _) =>
                            const SizedBox(height: AppSpacing.small),
                        itemBuilder: (context, index) {
                          final entry = visibleEntries[index];

                          return _CollectionCard(
                            entry: entry,
                            onTap: () => _openCardDetails(entry),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }

  static String _sortLabel(CollectionSort sort) {
    return switch (sort) {
      CollectionSort.recentlyAdded => 'Neueste',
      CollectionSort.name => 'Name',
      CollectionSort.set => 'Set',
      CollectionSort.number => 'Nummer',
    };
  }
}

class _CollectionCard extends ConsumerWidget {
  const _CollectionCard({
    required this.entry,
    required this.onTap,
  });

  final CollectionEntry entry;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final card = entry.card;

    return DexCard(
      onTap: onTap,
      padding: const EdgeInsets.all(AppSpacing.small),
      child: Row(
        children: [
          DexNetworkImage(
  imageUrl: card.imageUrl,
  width: 64,
  height: 90,
  fit: BoxFit.cover,
  placeholder: _CardImagePlaceholder(
    cardName: card.name,
  ),
),
          const SizedBox(width: AppSpacing.medium),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  card.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: AppSpacing.xSmall),
                Text(
                  card.setName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color:
                            Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
                const SizedBox(height: AppSpacing.xSmall),
                Text(
                  card.number,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: 'Ein Exemplar entfernen',
            onPressed: () {
              ref
                  .read(collectionProvider.notifier)
                  .removeOneCard(card);
            },
            icon: const Icon(Icons.remove_circle_outline),
          ),
          SizedBox(
            width: 28,
            child: Text(
              '${entry.quantity}',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          IconButton(
            tooltip: 'Weiteres Exemplar hinzufügen',
            onPressed: () {
              ref.read(collectionProvider.notifier).addCard(card);
            },
            icon: const Icon(Icons.add_circle_outline),
          ),
          PopupMenuButton<String>(
            tooltip: 'Weitere Aktionen',
            onSelected: (value) {
              switch (value) {
                case 'details':
                  onTap();
                case 'delete':
                  ref
                      .read(collectionProvider.notifier)
                      .removeCardCompletely(card);
              }
            },
            itemBuilder: (_) => const [
              PopupMenuItem(
                value: 'details',
                child: Row(
                  children: [
                    Icon(Icons.open_in_new),
                    SizedBox(width: AppSpacing.small),
                    Text('Details öffnen'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete_outline),
                    SizedBox(width: AppSpacing.small),
                    Text('Vollständig entfernen'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CardImagePlaceholder extends StatelessWidget {
  const _CardImagePlaceholder({
    required this.cardName,
  });

  final String cardName;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 64,
      height: 90,
      padding: const EdgeInsets.all(AppSpacing.small),
      color: Theme.of(context).colorScheme.primaryContainer,
      alignment: Alignment.center,
      child: Text(
        cardName,
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }
}

class _EmptyCollection extends StatelessWidget {
  const _EmptyCollection();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xLarge),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.collections_bookmark_outlined,
              size: 60,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: AppSpacing.medium),
            Text(
              'Deine Sammlung ist leer',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: AppSpacing.small),
            Text(
              'Suche oder scanne eine Karte und füge sie anschließend hinzu.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color:
                        Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NoSearchResults extends StatelessWidget {
  const _NoSearchResults();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xLarge),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.search_off,
              size: 56,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: AppSpacing.medium),
            Text(
              'Keine Karte gefunden',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: AppSpacing.small),
            Text(
              'Probiere einen anderen Namen, ein Set oder eine Kartennummer.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color:
                        Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}