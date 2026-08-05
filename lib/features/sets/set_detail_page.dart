import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models/pokemon_card.dart';
import '../../core/models/pokemon_set.dart';
import '../cards/card_detail_page.dart';
import '../collection/collection_provider.dart';
import 'set_provider.dart';

enum SetCardFilter {
  all,
  owned,
  missing,
  duplicates,
}

class SetDetailPage extends ConsumerStatefulWidget {
  const SetDetailPage({
    required this.set,
    super.key,
  });

  final PokemonSet set;

  @override
  ConsumerState<SetDetailPage> createState() => _SetDetailPageState();
}

class _SetDetailPageState extends ConsumerState<SetDetailPage> {
  SetCardFilter _selectedFilter = SetCardFilter.all;

  @override
  Widget build(BuildContext context) {
    final cardsResult = ref.watch(setCardsProvider(widget.set.id));
    final collection = ref.watch(collectionProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.set.name),
      ),
      body: cardsResult.when(
        loading: () => const _LoadingView(),
        error: (error, stackTrace) {
          return _ErrorView(
            message: error.toString(),
            onRetry: () {
              ref.invalidate(setCardsProvider(widget.set.id));
            },
          );
        },
        data: (cards) {
          final quantities = <String, int>{
            for (final entry in collection)
              entry.card.id: entry.quantity,
          };

          final ownedCount = cards.where((card) {
            return (quantities[card.id] ?? 0) > 0;
          }).length;

          final progress =
              cards.isEmpty ? 0.0 : ownedCount / cards.length;

          final filteredCards = cards.where((card) {
            final quantity = quantities[card.id] ?? 0;

            return switch (_selectedFilter) {
              SetCardFilter.all => true,
              SetCardFilter.owned => quantity > 0,
              SetCardFilter.missing => quantity == 0,
              SetCardFilter.duplicates => quantity > 1,
            };
          }).toList();

          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: _SetHeader(
                  set: widget.set,
                  ownedCount: ownedCount,
                  totalCount: cards.length,
                  progress: progress,
                ),
              ),
              SliverToBoxAdapter(
                child: _FilterBar(
                  selectedFilter: _selectedFilter,
                  onSelected: (filter) {
                    setState(() {
                      _selectedFilter = filter;
                    });
                  },
                ),
              ),
              if (filteredCards.isEmpty)
                const SliverFillRemaining(
                  hasScrollBody: false,
                  child: _EmptyFilterResult(),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
                  sliver: SliverGrid(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final card = filteredCards[index];
                        final quantity = quantities[card.id] ?? 0;

                        return _BinderCard(
                          card: card,
                          quantity: quantity,
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute<void>(
                                builder: (context) => CardDetailPage(
                                  card: card,
                                ),
                              ),
                            );
                          },
                        );
                      },
                      childCount: filteredCards.length,
                    ),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 14,
                      childAspectRatio: 0.68,
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _FilterBar extends StatelessWidget {
  const _FilterBar({
    required this.selectedFilter,
    required this.onSelected,
  });

  final SetCardFilter selectedFilter;
  final ValueChanged<SetCardFilter> onSelected;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          _FilterChip(
            label: 'Alle',
            filter: SetCardFilter.all,
            selectedFilter: selectedFilter,
            onSelected: onSelected,
          ),
          const SizedBox(width: 8),
          _FilterChip(
            label: 'Vorhanden',
            filter: SetCardFilter.owned,
            selectedFilter: selectedFilter,
            onSelected: onSelected,
          ),
          const SizedBox(width: 8),
          _FilterChip(
            label: 'Fehlend',
            filter: SetCardFilter.missing,
            selectedFilter: selectedFilter,
            onSelected: onSelected,
          ),
          const SizedBox(width: 8),
          _FilterChip(
            label: 'Doppelt',
            filter: SetCardFilter.duplicates,
            selectedFilter: selectedFilter,
            onSelected: onSelected,
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.filter,
    required this.selectedFilter,
    required this.onSelected,
  });

  final String label;
  final SetCardFilter filter;
  final SetCardFilter selectedFilter;
  final ValueChanged<SetCardFilter> onSelected;

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      selected: selectedFilter == filter,
      onSelected: (_) => onSelected(filter),
    );
  }
}

class _SetHeader extends StatelessWidget {
  const _SetHeader({
    required this.set,
    required this.ownedCount,
    required this.totalCount,
    required this.progress,
  });

  final PokemonSet set;
  final int ownedCount;
  final int totalCount;
  final double progress;

  @override
  Widget build(BuildContext context) {
    final percentage = (progress * 100).round();

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (set.logoUrl.isNotEmpty)
            Center(
              child: SizedBox(
                height: 72,
                child: Image.network(
                  set.logoUrl,
                  fit: BoxFit.contain,
                  errorBuilder: (_, _, _) {
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ),
          if (set.logoUrl.isNotEmpty)
            const SizedBox(height: 20),
          Text(
            set.name,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            '$ownedCount von $totalCount Karten',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: const Color(0xFF6B7280),
                ),
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 10,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                '$percentage % gesammelt',
                style: const TextStyle(
                  color: Color(0xFF6B7280),
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Text(
                '${totalCount - ownedCount} fehlen',
                style: const TextStyle(
                  color: Color(0xFF6B7280),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            'Karten',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Farbig: vorhanden · Schwarz-weiß: fehlt',
            style: TextStyle(
              color: Color(0xFF6B7280),
            ),
          ),
        ],
      ),
    );
  }
}

class _BinderCard extends StatelessWidget {
  const _BinderCard({
    required this.card,
    required this.quantity,
    required this.onTap,
  });

  final PokemonCard card;
  final int quantity;
  final VoidCallback onTap;

  bool get isOwned => quantity > 0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Expanded(
            child: Stack(
              fit: StackFit.expand,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: _buildCardImage(context),
                ),
                if (quantity > 1)
                  Positioned(
                    top: 6,
                    right: 6,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 7,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black87,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '×$quantity',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                if (!isOwned)
                  Positioned(
                    left: 6,
                    bottom: 6,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 7,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.72),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'Fehlt',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          Text(
            card.number,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: const Color(0xFF6B7280),
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardImage(BuildContext context) {
    final image = card.imageUrl.isEmpty
        ? _CardPlaceholder(cardName: card.name)
        : Image.network(
            card.imageUrl,
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) {
              return _CardPlaceholder(cardName: card.name);
            },
          );

    if (isOwned) {
      return image;
    }

    return Opacity(
      opacity: 0.55,
      child: ColorFiltered(
        colorFilter: const ColorFilter.matrix([
          0.2126, 0.7152, 0.0722, 0, 0,
          0.2126, 0.7152, 0.0722, 0, 0,
          0.2126, 0.7152, 0.0722, 0, 0,
          0, 0, 0, 1, 0,
        ]),
        child: image,
      ),
    );
  }
}

class _CardPlaceholder extends StatelessWidget {
  const _CardPlaceholder({
    required this.cardName,
  });

  final String cardName;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.primaryContainer,
      padding: const EdgeInsets.all(8),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.style_outlined,
            color: Theme.of(context).colorScheme.primary,
            size: 32,
          ),
          const SizedBox(height: 8),
          Text(
            cardName,
            textAlign: TextAlign.center,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyFilterResult extends StatelessWidget {
  const _EmptyFilterResult();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.filter_alt_off_outlined,
              size: 52,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              'Keine Karten in diesem Filter',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 18),
          Text('Setkarten werden geladen …'),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({
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
              'Setkarten konnten nicht geladen werden',
              textAlign: TextAlign.center,
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