import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models/pokemon_card.dart';
import '../collection/collection_provider.dart';
import 'card_search_provider.dart';
import 'card_detail_page.dart';

class CardSearchPage extends ConsumerStatefulWidget {
  const CardSearchPage({super.key});

  @override
  ConsumerState<CardSearchPage> createState() => _CardSearchPageState();
}

class _CardSearchPageState extends ConsumerState<CardSearchPage> {
  final TextEditingController _controller = TextEditingController();

  Timer? _debounce;
  String _query = '';

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    _debounce?.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (!mounted) {
        return;
      }

      setState(() {
        _query = value.trim();
      });
    });

    setState(() {});
  }

  void _clearSearch() {
    _debounce?.cancel();
    _controller.clear();

    setState(() {
      _query = '';
    });
  }

  void _addCard(PokemonCard card) {
    ref.read(collectionProvider.notifier).addCard(card);

    Navigator.of(context).pop();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${card.name} wurde hinzugefügt.'),
        action: SnackBarAction(
          label: 'Rückgängig',
          onPressed: () {
            ref.read(collectionProvider.notifier).removeOneCard(card);
          },
        ),
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    final searchResult = ref.watch(cardSearchProvider(_query));

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Karte hinzufügen',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Suche nach deutschen Pokémon-Karten.',
                  style: TextStyle(
                    color: Color(0xFF6B7280),
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _controller,
                  onChanged: _onSearchChanged,
                  textInputAction: TextInputAction.search,
                  decoration: InputDecoration(
                    hintText: 'Zum Beispiel Gengar oder Glurak',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _controller.text.isEmpty
                        ? null
                        : IconButton(
                            onPressed: _clearSearch,
                            icon: const Icon(Icons.close),
                          ),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: _buildResult(searchResult),
          ),
        ],
      ),
    );
  }

  Widget _buildResult(AsyncValue<List<PokemonCard>> result) {
    if (_query.length < 2) {
      return const _SearchHint();
    }

    return result.when(
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
      error: (error, stackTrace) {
        return _SearchError(
          message: error.toString(),
          onRetry: () {
            ref.invalidate(cardSearchProvider(_query));
          },
        );
      },
      data: (cards) {
        if (cards.isEmpty) {
          return const _NoResults();
        }

        return ListView.separated(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
          itemCount: cards.length,
          separatorBuilder: (_, _) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final card = cards[index];

            return _CardResultTile(
              card: card,
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
        );
      },
    );
  }
}

class _CardResultTile extends StatelessWidget {
  const _CardResultTile({
    required this.card,
    required this.onTap,
  });

  final PokemonCard card;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
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
                    ? const _CardImagePlaceholder(
                        width: 58,
                        height: 81,
                      )
                    : Image.network(
                        card.imageUrl,
                        width: 58,
                        height: 81,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) {
                          return const _CardImagePlaceholder(
                            width: 58,
                            height: 81,
                          );
                        },
                      ),
              ),
              const SizedBox(width: 15),
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
                    const SizedBox(height: 5),
                    Text(
                      card.setName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xFF6B7280),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      '${card.number} · ${card.rarity}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: const Color(0xFF6B7280),
                          ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}

class _CardImagePlaceholder extends StatelessWidget {
  const _CardImagePlaceholder({
    required this.width,
    required this.height,
  });

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      color: Theme.of(context).colorScheme.primaryContainer,
      alignment: Alignment.center,
      child: Icon(
        Icons.style_outlined,
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 13),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                color: Color(0xFF6B7280),
              ),
            ),
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchHint extends StatelessWidget {
  const _SearchHint();

  @override
  Widget build(BuildContext context) {
    return const _CenteredMessage(
      icon: Icons.search,
      title: 'Welche Karte suchst du?',
      message: 'Gib mindestens zwei Buchstaben ein.',
    );
  }
}

class _NoResults extends StatelessWidget {
  const _NoResults();

  @override
  Widget build(BuildContext context) {
    return const _CenteredMessage(
      icon: Icons.search_off,
      title: 'Keine Karte gefunden',
      message: 'Probiere einen anderen Namen.',
    );
  }
}

class _SearchError extends StatelessWidget {
  const _SearchError({
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
              'Kartensuche fehlgeschlagen',
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

class _CenteredMessage extends StatelessWidget {
  const _CenteredMessage({
    required this.icon,
    required this.title,
    required this.message,
  });

  final IconData icon;
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 56,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              title,
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
          ],
        ),
      ),
    );
  }
}