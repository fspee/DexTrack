import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models/pokemon_card.dart';
import '../collection/collection_provider.dart';

class CardDetailPage extends ConsumerWidget {
  const CardDetailPage({
    required this.card,
    super.key,
  });

  final PokemonCard card;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(card.name),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: card.imageUrl.isNotEmpty
                      ? Image.network(
                          card.imageUrl,
                          height: 420,
                          fit: BoxFit.contain,
                        )
                      : Container(
                          height: 420,
                          width: 300,
                          color: Colors.grey.shade200,
                          child: const Icon(
                            Icons.style,
                            size: 80,
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 24),

              Text(
                card.name,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),

              const SizedBox(height: 8),

              Text(
                card.setName,
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.grey,
                ),
              ),

              const SizedBox(height: 24),

              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _InfoRow(
                        label: "Kartennummer",
                        value: card.number,
                      ),
                      _InfoRow(
                        label: "Seltenheit",
                        value: card.rarity,
                      ),
                      _InfoRow(
                        label: "Kategorie",
                        value: card.supertype,
                      ),
                      if (card.hp != null)
                        _InfoRow(
                          label: "KP",
                          value: card.hp.toString(),
                        ),
                      if (card.types.isNotEmpty)
                        _InfoRow(
                          label: "Typ",
                          value: card.types.join(", "),
                        ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                height: 55,
                child: FilledButton.icon(
                  icon: const Icon(Icons.add),
                  label: const Text("Zur Sammlung hinzufügen"),
                  onPressed: () {
                    ref.read(collectionProvider.notifier).addCard(card);

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          "${card.name} wurde hinzugefügt.",
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
              style: const TextStyle(
                color: Colors.grey,
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