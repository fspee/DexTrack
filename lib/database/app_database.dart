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

  @override
  List<Set<Column<Object>>> get uniqueKeys => [
        {cardId, variant, condition},
      ];
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
    AppSettings,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(driftDatabase(name: 'dextrack'));

  @override
  int get schemaVersion => 1;

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

      final card = PokemonCard(
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

      return CollectionEntry(
        card: card,
        quantity: collectionItem.quantity,
      );
    }).toList();
  }

  Future<void> saveCollectionEntry({
    required PokemonCard card,
    required int quantity,
  }) async {
    await transaction(() async {
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