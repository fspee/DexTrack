import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/pokemon_card.dart';
import '../models/pokemon_set.dart';

class TcgdexService {
  TcgdexService({
    http.Client? client,
  }) : _client = client ?? http.Client();

  static const String _baseUrl = 'https://api.tcgdex.net/v2/de';

  final http.Client _client;

  Future<List<PokemonCard>> searchCards(String query) async {
    final cleanedQuery = query.trim();

    if (cleanedQuery.isEmpty) {
      return [];
    }

    final briefCards = await _searchBriefCards(cleanedQuery);

    final cards = await Future.wait(
      briefCards.map((briefCard) async {
        final id = briefCard['id'] as String?;

        if (id == null || id.isEmpty) {
          return null;
        }

        try {
          return await getCard(id);
        } catch (_) {
          return null;
        }
      }),
    );

    return cards.whereType<PokemonCard>().toList();
  }

  Future<List<Map<String, dynamic>>> _searchBriefCards(
    String query,
  ) async {
    final uri = Uri.parse('$_baseUrl/cards').replace(
      queryParameters: {
        'name': query,
        'pagination:page': '1',
        'pagination:itemsPerPage': '100',
      },
    );

    final response = await _client.get(uri);

    if (response.statusCode != 200) {
      throw TcgdexException(
        'Kartensuche fehlgeschlagen',
        response.statusCode,
      );
    }

    final decoded = jsonDecode(response.body);

    if (decoded is! List<dynamic>) {
      throw const TcgdexException(
        'Die API hat ein unerwartetes Format zurückgegeben.',
      );
    }

    return decoded.whereType<Map<String, dynamic>>().toList();
  }

  Future<PokemonCard> getCard(String id) async {
    final uri = Uri.parse('$_baseUrl/cards/$id');
    final response = await _client.get(uri);

    if (response.statusCode != 200) {
      throw TcgdexException(
        'Kartendetails konnten nicht geladen werden.',
        response.statusCode,
      );
    }

    final decoded = jsonDecode(response.body);

    if (decoded is! Map<String, dynamic>) {
      throw const TcgdexException(
        'Die API hat ein unerwartetes Format zurückgegeben.',
      );
    }

    return PokemonCard.fromTcgdexDetail(decoded);
  }

  Future<List<PokemonSet>> getSets() async {
    final uri = Uri.parse('$_baseUrl/sets');
    final response = await _client.get(uri);

    if (response.statusCode != 200) {
      throw TcgdexException(
        'Sets konnten nicht geladen werden.',
        response.statusCode,
      );
    }

    final decoded = jsonDecode(response.body);

    if (decoded is! List<dynamic>) {
      throw const TcgdexException(
        'Die Set-API hat ein unerwartetes Format zurückgegeben.',
      );
    }

    final sets = decoded
        .whereType<Map<String, dynamic>>()
        .map(PokemonSet.fromTcgdex)
        .where((set) => set.id.isNotEmpty)
        .toList();

    sets.sort(
      (first, second) =>
          second.id.toLowerCase().compareTo(first.id.toLowerCase()),
    );

    return sets;
  }
Future<List<PokemonCard>> getCardsForSet(String setId) async {
  final uri = Uri.parse('$_baseUrl/sets/$setId');
  final response = await _client.get(uri);

  if (response.statusCode != 200) {
    throw TcgdexException(
      'Setkarten konnten nicht geladen werden.',
      response.statusCode,
    );
  }

  final decoded = jsonDecode(response.body);

  if (decoded is! Map<String, dynamic>) {
    throw const TcgdexException(
      'Die Set-API hat ein unerwartetes Format zurückgegeben.',
    );
  }

  final briefCards = decoded['cards'];

  if (briefCards is! List<dynamic>) {
    return [];
  }

  final cards = await Future.wait(
    briefCards.whereType<Map<String, dynamic>>().map((briefCard) async {
      final id = briefCard['id'] as String?;

      if (id == null || id.isEmpty) {
        return null;
      }

      try {
        return await getCard(id);
      } catch (_) {
        return null;
      }
    }),
  );

  return cards.whereType<PokemonCard>().toList();
}
  void dispose() {
    _client.close();
  }
}

class TcgdexException implements Exception {
  const TcgdexException(
    this.message, [
    this.statusCode,
  ]);

  final String message;
  final int? statusCode;

  @override
  String toString() {
    if (statusCode == null) {
      return message;
    }

    return '$message Fehlercode: $statusCode';
  }
}