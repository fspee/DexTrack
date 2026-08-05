import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/widgets/dex_card.dart';
import '../collection/collection_provider.dart';


class HomePage extends ConsumerWidget {
  const HomePage({
    required this.onNavigate,
    super.key,
  });

  final ValueChanged<int> onNavigate;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final totalCards = ref.watch(totalCardCountProvider);
    final uniqueCards = ref.watch(uniqueCardCountProvider);

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'DexTrack',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
            ),
            const SizedBox(height: 6),
            Text(
              'Deine Kartensammlung auf einen Blick',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: const Color(0xFF6B7280),
                  ),
            ),
            const SizedBox(height: 24),

            // Suche
            TextField(
              readOnly: true,
              onTap: () => onNavigate(2),
              decoration: InputDecoration(
                hintText: 'Karten, Sets oder Decks suchen',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: const Icon(Icons.chevron_right),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Scanner
            _ScanCard(
              onTap: () => onNavigate(2),
            ),

            const SizedBox(height: 28),

            Row(
              children: [
                Expanded(
                  child: Text(
                    'Meine Sammlung',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                ),
                TextButton(
                  onPressed: () => onNavigate(1),
                  child: const Text('Alle anzeigen'),
                ),
              ],
            ),

            const SizedBox(height: 10),

            Row(
              children: [
                Expanded(
                  child: _StatisticCard(
                    label: 'Karten gesamt',
                    value: '$totalCards',
                    icon: Icons.style_outlined,
                    onTap: () => onNavigate(1),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatisticCard(
                    label: 'Verschiedene',
                    value: '$uniqueCards',
                    icon: Icons.collections_bookmark_outlined,
                    onTap: () => onNavigate(1),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 28),

            _SectionHeader(
              title: 'Set-Fortschritt',
              actionLabel: 'Alle anzeigen',
              onPressed: () => onNavigate(3),
            ),

            const SizedBox(height: 12),

            const _EmptySection(
              icon: Icons.grid_view_outlined,
              title: 'Noch kein Set begonnen',
              description:
                  'Füge deine erste Karte hinzu, um deinen Fortschritt zu sehen.',
            ),

            const SizedBox(height: 28),

            _SectionHeader(
              title: 'Zuletzt hinzugefügt',
              actionLabel: 'Sammlung öffnen',
              onPressed: () => onNavigate(1),
            ),

            const SizedBox(height: 12),

            _EmptySection(
              icon: Icons.history,
              title: totalCards == 0
                  ? 'Noch keine Karten vorhanden'
                  : '$totalCards Karten in deiner Sammlung',
              description: totalCards == 0
                  ? 'Deine zuletzt hinzugefügten Karten erscheinen hier.'
                  : 'Eine Vorschau der zuletzt hinzugefügten Karten ergänzen wir später.',
            ),

            const SizedBox(height: 28),

            _SectionHeader(
              title: 'Meine Decks',
              actionLabel: 'Alle anzeigen',
              onPressed: () => onNavigate(4),
            ),

            const SizedBox(height: 12),

            const _EmptySection(
              icon: Icons.layers_outlined,
              title: 'Noch kein Deck erstellt',
              description:
                  'Stelle später dein erstes eigenes Deck zusammen.',
            ),
          ],
        ),
      ),
    );
  }
}

class _ScanCard extends StatelessWidget {
  const _ScanCard({
    required this.onTap,
  });

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Material(
      color: colors.primary,
      borderRadius: BorderRadius.circular(22),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Padding(
          padding: const EdgeInsets.all(22),
          child: Row(
            children: [
              Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Icon(
                  Icons.document_scanner_outlined,
                  color: Colors.white,
                  size: 30,
                ),
              ),
              const SizedBox(width: 18),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Karte scannen',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Karte erkennen und zur Sammlung hinzufügen',
                      style: TextStyle(
                        color: Colors.white70,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatisticCard extends StatelessWidget {
  const _StatisticCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final String value;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: const Color(0xFFE5E7EB),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                icon,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 18),
              Text(
                value,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: const Color(0xFF6B7280),
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    required this.actionLabel,
    required this.onPressed,
  });

  final String title;
  final String actionLabel;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
        ),
        TextButton(
          onPressed: onPressed,
          child: Text(actionLabel),
        ),
      ],
    );
  }
}

class _EmptySection extends StatelessWidget {
  const _EmptySection({
    required this.icon,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return DexCard(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(
              icon,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  description,
                  style: const TextStyle(
                    color: Color(0xFF6B7280),
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}