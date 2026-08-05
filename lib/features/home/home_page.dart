import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme/app_spacing.dart';
import '../../shared/widgets/dex_action_card.dart';
import '../../shared/widgets/dex_card.dart';
import '../../shared/widgets/dex_empty_state.dart';
import '../../shared/widgets/dex_section_title.dart';
import '../../shared/widgets/dex_stat_card.dart';
import '../cards/card_detail_page.dart';
import '../collection/collection_provider.dart';

class HomePage extends ConsumerWidget {
  const HomePage({
    required this.onNavigate,
    super.key,
  });

  final ValueChanged<int> onNavigate;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final collection = ref.watch(collectionProvider);
    final totalCards = ref.watch(totalCardCountProvider);
    final uniqueCards = ref.watch(uniqueCardCountProvider);

    final startedSets = collection
        .map((entry) => entry.card.setId)
        .where((setId) => setId.isNotEmpty)
        .toSet()
        .length;

    final recentEntries = collection.reversed.take(5).toList();
    final nextMilestone = _nextMilestone(uniqueCards);
    final cardsUntilMilestone = nextMilestone - uniqueCards;
    final milestoneProgress = uniqueCards / nextMilestone;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.medium,
          AppSpacing.large,
          AppSpacing.medium,
          AppSpacing.xLarge,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _greeting(),
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: AppSpacing.xSmall),
            Text(
              'DexTrack',
              style: Theme.of(context).textTheme.headlineMedium,
            ),

            const SizedBox(height: AppSpacing.large),

            TextField(
              readOnly: true,
              onTap: () => onNavigate(2),
              decoration: const InputDecoration(
                hintText: 'Pokémon-Karte suchen',
                prefixIcon: Icon(Icons.search),
                suffixIcon: Icon(Icons.chevron_right),
              ),
            ),

            const SizedBox(height: AppSpacing.medium),

            DexActionCard(
              title: 'Karte scannen',
              description: 'Karte erkennen und zur Sammlung hinzufügen',
              icon: Icons.document_scanner_outlined,
              onTap: () => onNavigate(2),
            ),

            const SizedBox(height: AppSpacing.xLarge),

            DexSectionTitle(
              title: 'Deine Sammlung',
              actionLabel: 'Öffnen',
              onActionPressed: () => onNavigate(1),
            ),

            const SizedBox(height: AppSpacing.small),

            Row(
              children: [
                Expanded(
                  child: DexStatCard(
                    label: 'Karten gesamt',
                    value: '$totalCards',
                    icon: Icons.style_outlined,
                    onTap: () => onNavigate(1),
                  ),
                ),
                const SizedBox(width: AppSpacing.medium),
                Expanded(
                  child: DexStatCard(
                    label: 'Verschiedene',
                    value: '$uniqueCards',
                    icon: Icons.collections_bookmark_outlined,
                    onTap: () => onNavigate(1),
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppSpacing.medium),

            DexCard(
              onTap: () => onNavigate(3),
              padding: const EdgeInsets.all(AppSpacing.large),
              child: Row(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(
                      Icons.grid_view_outlined,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.medium),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$startedSets Sets begonnen',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: AppSpacing.xSmall),
                        Text(
                          startedSets == 0
                              ? 'Füge Karten hinzu, um deinen Fortschritt zu sehen.'
                              : 'Öffne deine Setübersicht und vervollständige deinen Binder.',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant,
                                  ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.xLarge),

            DexSectionTitle(
              title: 'Nächstes Ziel',
              actionLabel: 'Sammlung',
              onActionPressed: () => onNavigate(1),
            ),

            const SizedBox(height: AppSpacing.small),

            DexCard(
              padding: const EdgeInsets.all(AppSpacing.large),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$nextMilestone verschiedene Karten',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: AppSpacing.xSmall),
                  Text(
                    uniqueCards == 0
                        ? 'Füge deine erste Karte hinzu.'
                        : 'Noch $cardsUntilMilestone Karten bis zum nächsten Meilenstein.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color:
                              Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                  const SizedBox(height: AppSpacing.medium),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: LinearProgressIndicator(
                      value: milestoneProgress.clamp(0.0, 1.0),
                      minHeight: 10,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.small),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      '$uniqueCards / $nextMilestone',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.xLarge),

            DexSectionTitle(
              title: 'Zuletzt hinzugefügt',
              actionLabel: 'Alle anzeigen',
              onActionPressed: () => onNavigate(1),
            ),

            const SizedBox(height: AppSpacing.small),

            if (recentEntries.isEmpty)
              DexEmptyState(
                icon: Icons.history,
                title: 'Noch keine Karten vorhanden',
                description:
                    'Deine zuletzt hinzugefügten Karten erscheinen hier.',
                onTap: () => onNavigate(2),
              )
            else
              SizedBox(
                height: 190,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: recentEntries.length,
                  separatorBuilder: (_, _) =>
                      const SizedBox(width: AppSpacing.medium),
                  itemBuilder: (context, index) {
                    final entry = recentEntries[index];

                    return _RecentCardTile(
                      cardName: entry.card.name,
                      imageUrl: entry.card.imageUrl,
                      quantity: entry.quantity,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => CardDetailPage(
                              card: entry.card,
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),

            const SizedBox(height: AppSpacing.xLarge),

            DexSectionTitle(
              title: 'Schnellzugriff',
            ),

            const SizedBox(height: AppSpacing.small),

            Row(
              children: [
                Expanded(
                  child: _QuickLink(
                    icon: Icons.collections_bookmark_outlined,
                    label: 'Sammlung',
                    onTap: () => onNavigate(1),
                  ),
                ),
                const SizedBox(width: AppSpacing.medium),
                Expanded(
                  child: _QuickLink(
                    icon: Icons.grid_view_outlined,
                    label: 'Sets',
                    onTap: () => onNavigate(3),
                  ),
                ),
                const SizedBox(width: AppSpacing.medium),
                Expanded(
                  child: _QuickLink(
                    icon: Icons.layers_outlined,
                    label: 'Decks',
                    onTap: () => onNavigate(4),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  static String _greeting() {
    final hour = DateTime.now().hour;

    if (hour < 11) {
      return 'Guten Morgen 👋';
    }

    if (hour < 18) {
      return 'Hallo 👋';
    }

    return 'Guten Abend 👋';
  }

  static int _nextMilestone(int currentCount) {
    const milestones = [
      10,
      25,
      50,
      100,
      250,
      500,
      1000,
      2500,
      5000,
      10000,
    ];

    for (final milestone in milestones) {
      if (currentCount < milestone) {
        return milestone;
      }
    }

    return ((currentCount ~/ 5000) + 1) * 5000;
  }
}

class _RecentCardTile extends StatelessWidget {
  const _RecentCardTile({
    required this.cardName,
    required this.imageUrl,
    required this.quantity,
    required this.onTap,
  });

  final String cardName;
  final String imageUrl;
  final int quantity;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 112,
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: imageUrl.isEmpty
                        ? _ImagePlaceholder(cardName: cardName)
                        : Image.network(
                            imageUrl,
                            width: 112,
                            height: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (_, _, _) {
                              return _ImagePlaceholder(
                                cardName: cardName,
                              );
                            },
                          ),
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
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.small),
            Text(
              cardName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ImagePlaceholder extends StatelessWidget {
  const _ImagePlaceholder({
    required this.cardName,
  });

  final String cardName;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 112,
      color: Theme.of(context).colorScheme.primaryContainer,
      alignment: Alignment.center,
      padding: const EdgeInsets.all(AppSpacing.small),
      child: Text(
        cardName,
        textAlign: TextAlign.center,
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }
}

class _QuickLink extends StatelessWidget {
  const _QuickLink({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return DexCard(
      onTap: onTap,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.small,
        vertical: AppSpacing.medium,
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: AppSpacing.small),
          Text(
            label,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }
}