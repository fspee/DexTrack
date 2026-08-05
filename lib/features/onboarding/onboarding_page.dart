import 'package:flutter/material.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({
    required this.onStart,
    super.key,
  });

  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
          child: Column(
            children: [
              const Spacer(),

              Container(
                width: 104,
                height: 104,
                decoration: BoxDecoration(
                  color: colors.primaryContainer,
                  borderRadius: BorderRadius.circular(32),
                ),
                child: Icon(
                  Icons.collections_bookmark_outlined,
                  size: 52,
                  color: colors.primary,
                ),
              ),

              const SizedBox(height: 32),

              Text(
                'Willkommen bei DexTrack',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
              ),

              const SizedBox(height: 12),

              Text(
                'Verwalte deine Pokémon-Karten, behalte Sets im Blick '
                'und stelle später eigene Decks zusammen.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: const Color(0xFF6B7280),
                      height: 1.5,
                    ),
              ),

              const SizedBox(height: 40),

              const _FeatureRow(
                icon: Icons.document_scanner_outlined,
                title: 'Deutsche Karten erkennen',
                description:
                    'Karten später per Kamera oder manueller Suche hinzufügen.',
              ),

              const SizedBox(height: 18),

              const _FeatureRow(
                icon: Icons.cloud_download_outlined,
                title: 'Kartendaten lokal speichern',
                description:
                    'Sets und Karten können für die Offline-Nutzung geladen werden.',
              ),

              const SizedBox(height: 18),

              const _FeatureRow(
                icon: Icons.grid_view_outlined,
                title: 'Set-Fortschritt verfolgen',
                description:
                    'Sieh auf einen Blick, welche Karten dir noch fehlen.',
              ),

              const SizedBox(height: 18),

              const _FeatureRow(
                icon: Icons.layers_outlined,
                title: 'Decks zusammenstellen',
                description:
                    'Prüfe später, welche Karten für ein Deck vorhanden sind.',
              ),

              const Spacer(),

              SizedBox(
                width: double.infinity,
                height: 58,
                child: FilledButton(
                  onPressed: onStart,
                  style: FilledButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  child: const Text(
                    'Einrichtung starten',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              Text(
                'Die Grundfunktionen der App bleiben kostenlos.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
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

class _FeatureRow extends StatelessWidget {
  const _FeatureRow({
    required this.icon,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
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
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: const Color(0xFF6B7280),
                      height: 1.4,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}