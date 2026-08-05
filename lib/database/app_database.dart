import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import '../core/models/collection_entry.dart';
import '../core/models/pokemon_card.dart';

part 'app_database.g.dart';

class StoredCards extends Table {
  TextColumn get cardId => text()();

  TextColumn get name => text()();

  TextColumn get setId => text()();

  TextColumn get setName => text()();

  TextColumn get number => text()();

  TextColumn get rarity =>
      text().withDefault(const Constant('Unbekannt'))();

  TextColumn get imageUrl =>
      text().withDefault(const Constant(''))();

  TextColumn get cardmarketUrl =>
      text().withDefault(const Constant(''))();

  TextColumn get language =>
      text().withDefault(const Constant('de'))();

  TextColumn get supertype =>
      text().withDefault(const Constant('Unbekannt'))();

  TextColumn get subtypesJson =>
      text().withDefault(const Constant('[]'))();

  IntColumn get hp => integer().nullable()();

  TextColumn get typesJson =>
      text().withDefault(const Constant('[]'))();

  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {cardId};
}

class CollectionItems extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get cardId =>
      text().references(StoredCards, #cardId)();

  IntColumn get quantity =>
      integer().withDefault(const Constant(1))();

  TextColumn get variant =>
      text().withDefault(const Constant('normal'))();

  TextColumn get condition =>
      text().withDefault(const Constant('unbekannt'))();

  DateTimeColumn get addedAt => dateTime()();

  BoolColumn get isFavorite =>
      boolean().withDefault(const Constant(false))();

  @override
  List<Set<Column<Object>>> get uniqueKeys => [
        {cardId, variant, condition},
      ];
}

class WishlistItems extends Table {
  TextColumn get cardId =>
      text().references(StoredCards, #cardId)();

  DateTimeColumn get addedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {cardId};
}


class AppSettings extends Table {
  TextColumn get settingKey => text()();

  TextColumn get settingValue => text()();

  @override
  Set<Column<Object>> get primaryKey => {settingKey};
}

@DriftDatabase(
  tables: [
    StoredCards,
    CollectionItems,
    WishlistItems,
    AppSettings,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(driftDatabase(name: 'dextrack'));

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (migrator) async {
        await migrator.createAll();
      },
      onUpgrade: (migrator, from, to) async {
        if (from < 2) {
          await customStatement(
            'ALTER TABLE collection_items '
            'ADD COLUMN is_favorite INTEGER NOT NULL DEFAULT 0',
          );
        }

        if (from < 3) {
          await customStatement(
            'CREATE TABLE IF NOT EXISTS wishlist_items ('
            'card_id TEXT NOT NULL PRIMARY KEY '
            'REFERENCES stored_cards(card_id), '
            'added_at INTEGER NOT NULL'
            ')',
          );
        }
      },
    );
  }

  // ---------------------------------------------------------------------------
  // Onboarding
  // ---------------------------------------------------------------------------

  Future<bool> isOnboardingComplete() async {
    final row = await (select(appSettings)
          ..where(
            (table) =>
                table.settingKey.equals('onboarding_complete'),
          ))
        .getSingleOrNull();

    return row?.settingValue == 'true';
  }

  Future<void> setOnboardingComplete() async {
    await into(appSettings).insertOnConflictUpdate(
      AppSettingsCompanion.insert(
        settingKey: 'onboarding_complete',
        settingValue: 'true',
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Sammlung
  // ---------------------------------------------------------------------------

  Future<List<CollectionEntry>> loadCollectionEntries() async {
    final query = select(collectionItems).join([
      innerJoin(
        storedCards,
        storedCards.cardId.equalsExp(collectionItems.cardId),
      ),
    ]);

    final rows = await query.get();

    return rows.map((row) {
      final storedCard = row.readTable(storedCards);
      final collectionItem = row.readTable(collectionItems);

      return CollectionEntry(
        card: _storedCardToPokemonCard(storedCard),
        quantity: collectionItem.quantity,
        isFavorite: collectionItem.isFavorite,
      );
    }).toList();
  }

  Future<void> saveCollectionEntry({
    required PokemonCard card,
    required int quantity,
    required bool isFavorite,
  }) async {
    await transaction(() async {
      await _saveStoredCard(card);

      final existingItem = await (select(collectionItems)
            ..where(
              (table) =>
                  table.cardId.equals(card.id) &
                  table.variant.equals('normal') &
                  table.condition.equals('unbekannt'),
            ))
          .getSingleOrNull();

      if (existingItem == null) {
        await into(collectionItems).insert(
          CollectionItemsCompanion.insert(
            cardId: card.id,
            quantity: Value(quantity),
            variant: const Value('normal'),
            condition: const Value('unbekannt'),
            addedAt: DateTime.now(),
            isFavorite: Value(isFavorite),
          ),
        );
      } else {
        await (update(collectionItems)
              ..where(
                (table) => table.id.equals(existingItem.id),
              ))
            .write(
          CollectionItemsCompanion(
            quantity: Value(quantity),
            isFavorite: Value(isFavorite),
          ),
        );
      }
    });
  }

  Future<void> deleteCollectionEntry(String cardId) async {
    await (delete(collectionItems)
          ..where(
            (table) => table.cardId.equals(cardId),
          ))
        .go();
  }

  Future<void> clearStoredCollection() async {
    await delete(collectionItems).go();
  }

  // ---------------------------------------------------------------------------
  // Set-Karten-Cache
  // ---------------------------------------------------------------------------

  Future<void> saveCardsToCache(List<PokemonCard> cards) async {
    if (cards.isEmpty) {
      return;
    }

    await transaction(() async {
      for (final card in cards) {
        await _saveStoredCard(card);
      }
    });
  }

  Future<List<PokemonCard>> loadCachedCardsForSet(
    String setId,
  ) async {
    final rows = await (select(storedCards)
          ..where(
            (table) => table.setId.equals(setId),
          ))
        .get();

    return rows
        .map(_storedCardToPokemonCard)
        .toList();
  }

  Future<bool> isSetCacheComplete(String setId) async {
    final row = await (select(appSettings)
          ..where(
            (table) =>
                table.settingKey.equals('set_cache_$setId'),
          ))
        .getSingleOrNull();

    return row?.settingValue == 'complete';
  }

  Future<void> markSetCacheComplete(String setId) async {
    await into(appSettings).insertOnConflictUpdate(
      AppSettingsCompanion.insert(
        settingKey: 'set_cache_$setId',
        settingValue: 'complete',
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Wunschliste
  // ---------------------------------------------------------------------------

  Future<List<PokemonCard>> loadWishlistCards() async {
    final query = select(wishlistItems).join([
      innerJoin(
        storedCards,
        storedCards.cardId.equalsExp(wishlistItems.cardId),
      ),
    ]);

    final rows = await query.get();

    return rows.map((row) {
      final storedCard = row.readTable(storedCards);
      return _storedCardToPokemonCard(storedCard);
    }).toList();
  }

  Future<bool> isCardOnWishlist(String cardId) async {
    final row = await (select(wishlistItems)
          ..where(
            (table) => table.cardId.equals(cardId),
          ))
        .getSingleOrNull();

    return row != null;
  }

  Future<void> addCardToWishlist(PokemonCard card) async {
    await transaction(() async {
      await _saveStoredCard(card);

      await into(wishlistItems).insertOnConflictUpdate(
        WishlistItemsCompanion.insert(
          cardId: card.id,
          addedAt: DateTime.now(),
        ),
      );
    });
  }

  Future<void> removeCardFromWishlist(String cardId) async {
    await (delete(wishlistItems)
          ..where(
            (table) => table.cardId.equals(cardId),
          ))
        .go();
  }

  Future<void> clearWishlist() async {
    await delete(wishlistItems).go();
  }

  // ---------------------------------------------------------------------------
  // Gemeinsame Hilfsmethoden
  // ---------------------------------------------------------------------------

  Future<void> _saveStoredCard(PokemonCard card) async {
    await into(storedCards).insertOnConflictUpdate(
      StoredCardsCompanion.insert(
        cardId: card.id,
        name: card.name,
        setId: card.setId,
        setName: card.setName,
        number: card.number,
        rarity: Value(card.rarity),
        imageUrl: Value(card.imageUrl),
        cardmarketUrl: Value(card.cardmarketUrl),
        language: Value(card.language),
        supertype: Value(card.supertype),
        subtypesJson: Value(jsonEncode(card.subtypes)),
        hp: Value(card.hp),
        typesJson: Value(jsonEncode(card.types)),
        updatedAt: DateTime.now(),
      ),
    );
  }

  PokemonCard _storedCardToPokemonCard(StoredCard storedCard) {
    return PokemonCard(
      id: storedCard.cardId,
      name: storedCard.name,
      setId: storedCard.setId,
      setName: storedCard.setName,
      number: storedCard.number,
      rarity: storedCard.rarity,
      imageUrl: storedCard.imageUrl,
      cardmarketUrl: storedCard.cardmarketUrl,
      language: storedCard.language,
      supertype: storedCard.supertype,
      subtypes: _decodeStringList(storedCard.subtypesJson),
      hp: storedCard.hp,
      types: _decodeStringList(storedCard.typesJson),
    );
  }

  static List<String> _decodeStringList(String jsonText) {
    try {
      final decoded = jsonDecode(jsonText);

      if (decoded is List<dynamic>) {
        return decoded.whereType<String>().toList();
      }
    } catch (_) {
      // Bei beschädigten Daten wird eine leere Liste verwendet.
    }

    return const [];
  }
}