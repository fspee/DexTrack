import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'app_database.g.dart';

class StoredCards extends Table {
  TextColumn get cardId => text()();

  TextColumn get name => text()();

  TextColumn get setId => text()();

  TextColumn get setName => text()();

  TextColumn get number => text()();

  TextColumn get rarity => text().withDefault(const Constant('Unbekannt'))();

  TextColumn get imageUrl => text().withDefault(const Constant(''))();

  TextColumn get cardmarketUrl => text().withDefault(const Constant(''))();

  TextColumn get language => text().withDefault(const Constant('de'))();

  TextColumn get supertype => text().withDefault(const Constant('Unbekannt'))();

  TextColumn get subtypesJson => text().withDefault(const Constant('[]'))();

  IntColumn get hp => integer().nullable()();

  TextColumn get typesJson => text().withDefault(const Constant('[]'))();

  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {cardId};
}

class CollectionItems extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get cardId => text().references(StoredCards, #cardId)();

  IntColumn get quantity => integer().withDefault(const Constant(1))();

  TextColumn get variant => text().withDefault(const Constant('normal'))();

  TextColumn get condition => text().withDefault(const Constant('unbekannt'))();

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
        ..where((table) => table.settingKey.equals('onboarding_complete')))
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
}