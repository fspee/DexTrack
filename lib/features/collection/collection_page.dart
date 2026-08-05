import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models/collection_entry.dart';
import '../cards/card_detail_page.dart';
import 'collection_provider.dart';

class CollectionPage extends ConsumerWidget {
  const CollectionPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final collection = ref.watch(collectionProvider);
    final totalCards = ref.watch(totalCardCountProvider);
    final uniqueCards = ref.watch(uniqueCardCountProvider);

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
                  'Meine Sammlung',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                ),
                const SizedBox(height: 6),
                Text(
                  '$totalCards Karten · $uniqueCards verschiedene',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: const Color(0xFF6B7280),
                      ),
                ),
              ],
            ),
          ),
          Expanded(
            child: collection.isEmpty
                ? const _EmptyCollection()
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                    itemCount: collection.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      return _CollectionCard(
                        entry: collection[index],
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _CollectionCard extends ConsumerWidget {
  const _CollectionCard({
    required this.entry,
  });

  final CollectionEntry entry;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final card = entry.card;

    void openDetails() {
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (context) => CardDetailPage(
            card: card,
          ),
        ),
      );
    }

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: openDetails,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: const Color(0xFFE5E7EB),
            ),
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(9),
                child: card.imageUrl.isEmpty
                    ? const _CardImagePlaceholder()
                    : Image.network(
                        card.imageUrl,
                        width: 58,
                        height: 81,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) {
                          return const _CardImagePlaceholder();
                        },
                      ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      card.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      card.setName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xFF6B7280),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      card.number,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: const Color(0xFF6B7280),
                          ),
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
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
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
                onSelected: (value) {
                  if (value == 'details') {
                    openDetails();
                  }

                  if (value == 'delete') {
                    ref
                        .read(collectionProvider.notifier)
                        .removeCardCompletely(card);
                  }
                },
                itemBuilder: (context) => const [
                  PopupMenuItem<String>(
                    value: 'details',
                    child: Row(
                      children: [
                        Icon(Icons.open_in_new),
                        SizedBox(width: 10),
                        Text('Details öffnen'),
                      ],
                    ),
                  ),
                  PopupMenuItem<String>(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete_outline),
                        SizedBox(width: 10),
                        Text('Vollständig entfernen'),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CardImagePlaceholder extends StatelessWidget {
  const _CardImagePlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 58,
      height: 81,
      color: Theme.of(context).colorScheme.primaryContainer,
      alignment: Alignment.center,
      child: Icon(
        Icons.style_outlined,
        color: Theme.of(context).colorScheme.primary,
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
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 76,
              height: 76,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Icon(
                Icons.collections_bookmark_outlined,
                size: 38,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Deine Sammlung ist leer',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Suche eine Karte und füge sie anschließend deiner Sammlung hinzu.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF6B7280),
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}