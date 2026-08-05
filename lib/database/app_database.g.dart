// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $StoredCardsTable extends StoredCards
    with TableInfo<$StoredCardsTable, StoredCard> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StoredCardsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _cardIdMeta = const VerificationMeta('cardId');
  @override
  late final GeneratedColumn<String> cardId = GeneratedColumn<String>(
    'card_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _setIdMeta = const VerificationMeta('setId');
  @override
  late final GeneratedColumn<String> setId = GeneratedColumn<String>(
    'set_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _setNameMeta = const VerificationMeta(
    'setName',
  );
  @override
  late final GeneratedColumn<String> setName = GeneratedColumn<String>(
    'set_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _numberMeta = const VerificationMeta('number');
  @override
  late final GeneratedColumn<String> number = GeneratedColumn<String>(
    'number',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rarityMeta = const VerificationMeta('rarity');
  @override
  late final GeneratedColumn<String> rarity = GeneratedColumn<String>(
    'rarity',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('Unbekannt'),
  );
  static const VerificationMeta _imageUrlMeta = const VerificationMeta(
    'imageUrl',
  );
  @override
  late final GeneratedColumn<String> imageUrl = GeneratedColumn<String>(
    'image_url',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _cardmarketUrlMeta = const VerificationMeta(
    'cardmarketUrl',
  );
  @override
  late final GeneratedColumn<String> cardmarketUrl = GeneratedColumn<String>(
    'cardmarket_url',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _languageMeta = const VerificationMeta(
    'language',
  );
  @override
  late final GeneratedColumn<String> language = GeneratedColumn<String>(
    'language',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('de'),
  );
  static const VerificationMeta _supertypeMeta = const VerificationMeta(
    'supertype',
  );
  @override
  late final GeneratedColumn<String> supertype = GeneratedColumn<String>(
    'supertype',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('Unbekannt'),
  );
  static const VerificationMeta _subtypesJsonMeta = const VerificationMeta(
    'subtypesJson',
  );
  @override
  late final GeneratedColumn<String> subtypesJson = GeneratedColumn<String>(
    'subtypes_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _hpMeta = const VerificationMeta('hp');
  @override
  late final GeneratedColumn<int> hp = GeneratedColumn<int>(
    'hp',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _typesJsonMeta = const VerificationMeta(
    'typesJson',
  );
  @override
  late final GeneratedColumn<String> typesJson = GeneratedColumn<String>(
    'types_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    cardId,
    name,
    setId,
    setName,
    number,
    rarity,
    imageUrl,
    cardmarketUrl,
    language,
    supertype,
    subtypesJson,
    hp,
    typesJson,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'stored_cards';
  @override
  VerificationContext validateIntegrity(
    Insertable<StoredCard> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('card_id')) {
      context.handle(
        _cardIdMeta,
        cardId.isAcceptableOrUnknown(data['card_id']!, _cardIdMeta),
      );
    } else if (isInserting) {
      context.missing(_cardIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('set_id')) {
      context.handle(
        _setIdMeta,
        setId.isAcceptableOrUnknown(data['set_id']!, _setIdMeta),
      );
    } else if (isInserting) {
      context.missing(_setIdMeta);
    }
    if (data.containsKey('set_name')) {
      context.handle(
        _setNameMeta,
        setName.isAcceptableOrUnknown(data['set_name']!, _setNameMeta),
      );
    } else if (isInserting) {
      context.missing(_setNameMeta);
    }
    if (data.containsKey('number')) {
      context.handle(
        _numberMeta,
        number.isAcceptableOrUnknown(data['number']!, _numberMeta),
      );
    } else if (isInserting) {
      context.missing(_numberMeta);
    }
    if (data.containsKey('rarity')) {
      context.handle(
        _rarityMeta,
        rarity.isAcceptableOrUnknown(data['rarity']!, _rarityMeta),
      );
    }
    if (data.containsKey('image_url')) {
      context.handle(
        _imageUrlMeta,
        imageUrl.isAcceptableOrUnknown(data['image_url']!, _imageUrlMeta),
      );
    }
    if (data.containsKey('cardmarket_url')) {
      context.handle(
        _cardmarketUrlMeta,
        cardmarketUrl.isAcceptableOrUnknown(
          data['cardmarket_url']!,
          _cardmarketUrlMeta,
        ),
      );
    }
    if (data.containsKey('language')) {
      context.handle(
        _languageMeta,
        language.isAcceptableOrUnknown(data['language']!, _languageMeta),
      );
    }
    if (data.containsKey('supertype')) {
      context.handle(
        _supertypeMeta,
        supertype.isAcceptableOrUnknown(data['supertype']!, _supertypeMeta),
      );
    }
    if (data.containsKey('subtypes_json')) {
      context.handle(
        _subtypesJsonMeta,
        subtypesJson.isAcceptableOrUnknown(
          data['subtypes_json']!,
          _subtypesJsonMeta,
        ),
      );
    }
    if (data.containsKey('hp')) {
      context.handle(_hpMeta, hp.isAcceptableOrUnknown(data['hp']!, _hpMeta));
    }
    if (data.containsKey('types_json')) {
      context.handle(
        _typesJsonMeta,
        typesJson.isAcceptableOrUnknown(data['types_json']!, _typesJsonMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {cardId};
  @override
  StoredCard map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StoredCard(
      cardId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}card_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      setId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}set_id'],
      )!,
      setName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}set_name'],
      )!,
      number: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}number'],
      )!,
      rarity: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}rarity'],
      )!,
      imageUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_url'],
      )!,
      cardmarketUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cardmarket_url'],
      )!,
      language: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}language'],
      )!,
      supertype: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}supertype'],
      )!,
      subtypesJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}subtypes_json'],
      )!,
      hp: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}hp'],
      ),
      typesJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}types_json'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $StoredCardsTable createAlias(String alias) {
    return $StoredCardsTable(attachedDatabase, alias);
  }
}

class StoredCard extends DataClass implements Insertable<StoredCard> {
  final String cardId;
  final String name;
  final String setId;
  final String setName;
  final String number;
  final String rarity;
  final String imageUrl;
  final String cardmarketUrl;
  final String language;
  final String supertype;
  final String subtypesJson;
  final int? hp;
  final String typesJson;
  final DateTime updatedAt;
  const StoredCard({
    required this.cardId,
    required this.name,
    required this.setId,
    required this.setName,
    required this.number,
    required this.rarity,
    required this.imageUrl,
    required this.cardmarketUrl,
    required this.language,
    required this.supertype,
    required this.subtypesJson,
    this.hp,
    required this.typesJson,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['card_id'] = Variable<String>(cardId);
    map['name'] = Variable<String>(name);
    map['set_id'] = Variable<String>(setId);
    map['set_name'] = Variable<String>(setName);
    map['number'] = Variable<String>(number);
    map['rarity'] = Variable<String>(rarity);
    map['image_url'] = Variable<String>(imageUrl);
    map['cardmarket_url'] = Variable<String>(cardmarketUrl);
    map['language'] = Variable<String>(language);
    map['supertype'] = Variable<String>(supertype);
    map['subtypes_json'] = Variable<String>(subtypesJson);
    if (!nullToAbsent || hp != null) {
      map['hp'] = Variable<int>(hp);
    }
    map['types_json'] = Variable<String>(typesJson);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  StoredCardsCompanion toCompanion(bool nullToAbsent) {
    return StoredCardsCompanion(
      cardId: Value(cardId),
      name: Value(name),
      setId: Value(setId),
      setName: Value(setName),
      number: Value(number),
      rarity: Value(rarity),
      imageUrl: Value(imageUrl),
      cardmarketUrl: Value(cardmarketUrl),
      language: Value(language),
      supertype: Value(supertype),
      subtypesJson: Value(subtypesJson),
      hp: hp == null && nullToAbsent ? const Value.absent() : Value(hp),
      typesJson: Value(typesJson),
      updatedAt: Value(updatedAt),
    );
  }

  factory StoredCard.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StoredCard(
      cardId: serializer.fromJson<String>(json['cardId']),
      name: serializer.fromJson<String>(json['name']),
      setId: serializer.fromJson<String>(json['setId']),
      setName: serializer.fromJson<String>(json['setName']),
      number: serializer.fromJson<String>(json['number']),
      rarity: serializer.fromJson<String>(json['rarity']),
      imageUrl: serializer.fromJson<String>(json['imageUrl']),
      cardmarketUrl: serializer.fromJson<String>(json['cardmarketUrl']),
      language: serializer.fromJson<String>(json['language']),
      supertype: serializer.fromJson<String>(json['supertype']),
      subtypesJson: serializer.fromJson<String>(json['subtypesJson']),
      hp: serializer.fromJson<int?>(json['hp']),
      typesJson: serializer.fromJson<String>(json['typesJson']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'cardId': serializer.toJson<String>(cardId),
      'name': serializer.toJson<String>(name),
      'setId': serializer.toJson<String>(setId),
      'setName': serializer.toJson<String>(setName),
      'number': serializer.toJson<String>(number),
      'rarity': serializer.toJson<String>(rarity),
      'imageUrl': serializer.toJson<String>(imageUrl),
      'cardmarketUrl': serializer.toJson<String>(cardmarketUrl),
      'language': serializer.toJson<String>(language),
      'supertype': serializer.toJson<String>(supertype),
      'subtypesJson': serializer.toJson<String>(subtypesJson),
      'hp': serializer.toJson<int?>(hp),
      'typesJson': serializer.toJson<String>(typesJson),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  StoredCard copyWith({
    String? cardId,
    String? name,
    String? setId,
    String? setName,
    String? number,
    String? rarity,
    String? imageUrl,
    String? cardmarketUrl,
    String? language,
    String? supertype,
    String? subtypesJson,
    Value<int?> hp = const Value.absent(),
    String? typesJson,
    DateTime? updatedAt,
  }) => StoredCard(
    cardId: cardId ?? this.cardId,
    name: name ?? this.name,
    setId: setId ?? this.setId,
    setName: setName ?? this.setName,
    number: number ?? this.number,
    rarity: rarity ?? this.rarity,
    imageUrl: imageUrl ?? this.imageUrl,
    cardmarketUrl: cardmarketUrl ?? this.cardmarketUrl,
    language: language ?? this.language,
    supertype: supertype ?? this.supertype,
    subtypesJson: subtypesJson ?? this.subtypesJson,
    hp: hp.present ? hp.value : this.hp,
    typesJson: typesJson ?? this.typesJson,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  StoredCard copyWithCompanion(StoredCardsCompanion data) {
    return StoredCard(
      cardId: data.cardId.present ? data.cardId.value : this.cardId,
      name: data.name.present ? data.name.value : this.name,
      setId: data.setId.present ? data.setId.value : this.setId,
      setName: data.setName.present ? data.setName.value : this.setName,
      number: data.number.present ? data.number.value : this.number,
      rarity: data.rarity.present ? data.rarity.value : this.rarity,
      imageUrl: data.imageUrl.present ? data.imageUrl.value : this.imageUrl,
      cardmarketUrl: data.cardmarketUrl.present
          ? data.cardmarketUrl.value
          : this.cardmarketUrl,
      language: data.language.present ? data.language.value : this.language,
      supertype: data.supertype.present ? data.supertype.value : this.supertype,
      subtypesJson: data.subtypesJson.present
          ? data.subtypesJson.value
          : this.subtypesJson,
      hp: data.hp.present ? data.hp.value : this.hp,
      typesJson: data.typesJson.present ? data.typesJson.value : this.typesJson,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StoredCard(')
          ..write('cardId: $cardId, ')
          ..write('name: $name, ')
          ..write('setId: $setId, ')
          ..write('setName: $setName, ')
          ..write('number: $number, ')
          ..write('rarity: $rarity, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('cardmarketUrl: $cardmarketUrl, ')
          ..write('language: $language, ')
          ..write('supertype: $supertype, ')
          ..write('subtypesJson: $subtypesJson, ')
          ..write('hp: $hp, ')
          ..write('typesJson: $typesJson, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    cardId,
    name,
    setId,
    setName,
    number,
    rarity,
    imageUrl,
    cardmarketUrl,
    language,
    supertype,
    subtypesJson,
    hp,
    typesJson,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StoredCard &&
          other.cardId == this.cardId &&
          other.name == this.name &&
          other.setId == this.setId &&
          other.setName == this.setName &&
          other.number == this.number &&
          other.rarity == this.rarity &&
          other.imageUrl == this.imageUrl &&
          other.cardmarketUrl == this.cardmarketUrl &&
          other.language == this.language &&
          other.supertype == this.supertype &&
          other.subtypesJson == this.subtypesJson &&
          other.hp == this.hp &&
          other.typesJson == this.typesJson &&
          other.updatedAt == this.updatedAt);
}

class StoredCardsCompanion extends UpdateCompanion<StoredCard> {
  final Value<String> cardId;
  final Value<String> name;
  final Value<String> setId;
  final Value<String> setName;
  final Value<String> number;
  final Value<String> rarity;
  final Value<String> imageUrl;
  final Value<String> cardmarketUrl;
  final Value<String> language;
  final Value<String> supertype;
  final Value<String> subtypesJson;
  final Value<int?> hp;
  final Value<String> typesJson;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const StoredCardsCompanion({
    this.cardId = const Value.absent(),
    this.name = const Value.absent(),
    this.setId = const Value.absent(),
    this.setName = const Value.absent(),
    this.number = const Value.absent(),
    this.rarity = const Value.absent(),
    this.imageUrl = const Value.absent(),
    this.cardmarketUrl = const Value.absent(),
    this.language = const Value.absent(),
    this.supertype = const Value.absent(),
    this.subtypesJson = const Value.absent(),
    this.hp = const Value.absent(),
    this.typesJson = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  StoredCardsCompanion.insert({
    required String cardId,
    required String name,
    required String setId,
    required String setName,
    required String number,
    this.rarity = const Value.absent(),
    this.imageUrl = const Value.absent(),
    this.cardmarketUrl = const Value.absent(),
    this.language = const Value.absent(),
    this.supertype = const Value.absent(),
    this.subtypesJson = const Value.absent(),
    this.hp = const Value.absent(),
    this.typesJson = const Value.absent(),
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : cardId = Value(cardId),
       name = Value(name),
       setId = Value(setId),
       setName = Value(setName),
       number = Value(number),
       updatedAt = Value(updatedAt);
  static Insertable<StoredCard> custom({
    Expression<String>? cardId,
    Expression<String>? name,
    Expression<String>? setId,
    Expression<String>? setName,
    Expression<String>? number,
    Expression<String>? rarity,
    Expression<String>? imageUrl,
    Expression<String>? cardmarketUrl,
    Expression<String>? language,
    Expression<String>? supertype,
    Expression<String>? subtypesJson,
    Expression<int>? hp,
    Expression<String>? typesJson,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (cardId != null) 'card_id': cardId,
      if (name != null) 'name': name,
      if (setId != null) 'set_id': setId,
      if (setName != null) 'set_name': setName,
      if (number != null) 'number': number,
      if (rarity != null) 'rarity': rarity,
      if (imageUrl != null) 'image_url': imageUrl,
      if (cardmarketUrl != null) 'cardmarket_url': cardmarketUrl,
      if (language != null) 'language': language,
      if (supertype != null) 'supertype': supertype,
      if (subtypesJson != null) 'subtypes_json': subtypesJson,
      if (hp != null) 'hp': hp,
      if (typesJson != null) 'types_json': typesJson,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  StoredCardsCompanion copyWith({
    Value<String>? cardId,
    Value<String>? name,
    Value<String>? setId,
    Value<String>? setName,
    Value<String>? number,
    Value<String>? rarity,
    Value<String>? imageUrl,
    Value<String>? cardmarketUrl,
    Value<String>? language,
    Value<String>? supertype,
    Value<String>? subtypesJson,
    Value<int?>? hp,
    Value<String>? typesJson,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return StoredCardsCompanion(
      cardId: cardId ?? this.cardId,
      name: name ?? this.name,
      setId: setId ?? this.setId,
      setName: setName ?? this.setName,
      number: number ?? this.number,
      rarity: rarity ?? this.rarity,
      imageUrl: imageUrl ?? this.imageUrl,
      cardmarketUrl: cardmarketUrl ?? this.cardmarketUrl,
      language: language ?? this.language,
      supertype: supertype ?? this.supertype,
      subtypesJson: subtypesJson ?? this.subtypesJson,
      hp: hp ?? this.hp,
      typesJson: typesJson ?? this.typesJson,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (cardId.present) {
      map['card_id'] = Variable<String>(cardId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (setId.present) {
      map['set_id'] = Variable<String>(setId.value);
    }
    if (setName.present) {
      map['set_name'] = Variable<String>(setName.value);
    }
    if (number.present) {
      map['number'] = Variable<String>(number.value);
    }
    if (rarity.present) {
      map['rarity'] = Variable<String>(rarity.value);
    }
    if (imageUrl.present) {
      map['image_url'] = Variable<String>(imageUrl.value);
    }
    if (cardmarketUrl.present) {
      map['cardmarket_url'] = Variable<String>(cardmarketUrl.value);
    }
    if (language.present) {
      map['language'] = Variable<String>(language.value);
    }
    if (supertype.present) {
      map['supertype'] = Variable<String>(supertype.value);
    }
    if (subtypesJson.present) {
      map['subtypes_json'] = Variable<String>(subtypesJson.value);
    }
    if (hp.present) {
      map['hp'] = Variable<int>(hp.value);
    }
    if (typesJson.present) {
      map['types_json'] = Variable<String>(typesJson.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StoredCardsCompanion(')
          ..write('cardId: $cardId, ')
          ..write('name: $name, ')
          ..write('setId: $setId, ')
          ..write('setName: $setName, ')
          ..write('number: $number, ')
          ..write('rarity: $rarity, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('cardmarketUrl: $cardmarketUrl, ')
          ..write('language: $language, ')
          ..write('supertype: $supertype, ')
          ..write('subtypesJson: $subtypesJson, ')
          ..write('hp: $hp, ')
          ..write('typesJson: $typesJson, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CollectionItemsTable extends CollectionItems
    with TableInfo<$CollectionItemsTable, CollectionItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CollectionItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _cardIdMeta = const VerificationMeta('cardId');
  @override
  late final GeneratedColumn<String> cardId = GeneratedColumn<String>(
    'card_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES stored_cards (card_id)',
    ),
  );
  static const VerificationMeta _quantityMeta = const VerificationMeta(
    'quantity',
  );
  @override
  late final GeneratedColumn<int> quantity = GeneratedColumn<int>(
    'quantity',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _variantMeta = const VerificationMeta(
    'variant',
  );
  @override
  late final GeneratedColumn<String> variant = GeneratedColumn<String>(
    'variant',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('normal'),
  );
  static const VerificationMeta _conditionMeta = const VerificationMeta(
    'condition',
  );
  @override
  late final GeneratedColumn<String> condition = GeneratedColumn<String>(
    'condition',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('unbekannt'),
  );
  static const VerificationMeta _addedAtMeta = const VerificationMeta(
    'addedAt',
  );
  @override
  late final GeneratedColumn<DateTime> addedAt = GeneratedColumn<DateTime>(
    'added_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    cardId,
    quantity,
    variant,
    condition,
    addedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'collection_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<CollectionItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('card_id')) {
      context.handle(
        _cardIdMeta,
        cardId.isAcceptableOrUnknown(data['card_id']!, _cardIdMeta),
      );
    } else if (isInserting) {
      context.missing(_cardIdMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(
        _quantityMeta,
        quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta),
      );
    }
    if (data.containsKey('variant')) {
      context.handle(
        _variantMeta,
        variant.isAcceptableOrUnknown(data['variant']!, _variantMeta),
      );
    }
    if (data.containsKey('condition')) {
      context.handle(
        _conditionMeta,
        condition.isAcceptableOrUnknown(data['condition']!, _conditionMeta),
      );
    }
    if (data.containsKey('added_at')) {
      context.handle(
        _addedAtMeta,
        addedAt.isAcceptableOrUnknown(data['added_at']!, _addedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_addedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {cardId, variant, condition},
  ];
  @override
  CollectionItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CollectionItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      cardId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}card_id'],
      )!,
      quantity: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}quantity'],
      )!,
      variant: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}variant'],
      )!,
      condition: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}condition'],
      )!,
      addedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}added_at'],
      )!,
    );
  }

  @override
  $CollectionItemsTable createAlias(String alias) {
    return $CollectionItemsTable(attachedDatabase, alias);
  }
}

class CollectionItem extends DataClass implements Insertable<CollectionItem> {
  final int id;
  final String cardId;
  final int quantity;
  final String variant;
  final String condition;
  final DateTime addedAt;
  const CollectionItem({
    required this.id,
    required this.cardId,
    required this.quantity,
    required this.variant,
    required this.condition,
    required this.addedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['card_id'] = Variable<String>(cardId);
    map['quantity'] = Variable<int>(quantity);
    map['variant'] = Variable<String>(variant);
    map['condition'] = Variable<String>(condition);
    map['added_at'] = Variable<DateTime>(addedAt);
    return map;
  }

  CollectionItemsCompanion toCompanion(bool nullToAbsent) {
    return CollectionItemsCompanion(
      id: Value(id),
      cardId: Value(cardId),
      quantity: Value(quantity),
      variant: Value(variant),
      condition: Value(condition),
      addedAt: Value(addedAt),
    );
  }

  factory CollectionItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CollectionItem(
      id: serializer.fromJson<int>(json['id']),
      cardId: serializer.fromJson<String>(json['cardId']),
      quantity: serializer.fromJson<int>(json['quantity']),
      variant: serializer.fromJson<String>(json['variant']),
      condition: serializer.fromJson<String>(json['condition']),
      addedAt: serializer.fromJson<DateTime>(json['addedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'cardId': serializer.toJson<String>(cardId),
      'quantity': serializer.toJson<int>(quantity),
      'variant': serializer.toJson<String>(variant),
      'condition': serializer.toJson<String>(condition),
      'addedAt': serializer.toJson<DateTime>(addedAt),
    };
  }

  CollectionItem copyWith({
    int? id,
    String? cardId,
    int? quantity,
    String? variant,
    String? condition,
    DateTime? addedAt,
  }) => CollectionItem(
    id: id ?? this.id,
    cardId: cardId ?? this.cardId,
    quantity: quantity ?? this.quantity,
    variant: variant ?? this.variant,
    condition: condition ?? this.condition,
    addedAt: addedAt ?? this.addedAt,
  );
  CollectionItem copyWithCompanion(CollectionItemsCompanion data) {
    return CollectionItem(
      id: data.id.present ? data.id.value : this.id,
      cardId: data.cardId.present ? data.cardId.value : this.cardId,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      variant: data.variant.present ? data.variant.value : this.variant,
      condition: data.condition.present ? data.condition.value : this.condition,
      addedAt: data.addedAt.present ? data.addedAt.value : this.addedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CollectionItem(')
          ..write('id: $id, ')
          ..write('cardId: $cardId, ')
          ..write('quantity: $quantity, ')
          ..write('variant: $variant, ')
          ..write('condition: $condition, ')
          ..write('addedAt: $addedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, cardId, quantity, variant, condition, addedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CollectionItem &&
          other.id == this.id &&
          other.cardId == this.cardId &&
          other.quantity == this.quantity &&
          other.variant == this.variant &&
          other.condition == this.condition &&
          other.addedAt == this.addedAt);
}

class CollectionItemsCompanion extends UpdateCompanion<CollectionItem> {
  final Value<int> id;
  final Value<String> cardId;
  final Value<int> quantity;
  final Value<String> variant;
  final Value<String> condition;
  final Value<DateTime> addedAt;
  const CollectionItemsCompanion({
    this.id = const Value.absent(),
    this.cardId = const Value.absent(),
    this.quantity = const Value.absent(),
    this.variant = const Value.absent(),
    this.condition = const Value.absent(),
    this.addedAt = const Value.absent(),
  });
  CollectionItemsCompanion.insert({
    this.id = const Value.absent(),
    required String cardId,
    this.quantity = const Value.absent(),
    this.variant = const Value.absent(),
    this.condition = const Value.absent(),
    required DateTime addedAt,
  }) : cardId = Value(cardId),
       addedAt = Value(addedAt);
  static Insertable<CollectionItem> custom({
    Expression<int>? id,
    Expression<String>? cardId,
    Expression<int>? quantity,
    Expression<String>? variant,
    Expression<String>? condition,
    Expression<DateTime>? addedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (cardId != null) 'card_id': cardId,
      if (quantity != null) 'quantity': quantity,
      if (variant != null) 'variant': variant,
      if (condition != null) 'condition': condition,
      if (addedAt != null) 'added_at': addedAt,
    });
  }

  CollectionItemsCompanion copyWith({
    Value<int>? id,
    Value<String>? cardId,
    Value<int>? quantity,
    Value<String>? variant,
    Value<String>? condition,
    Value<DateTime>? addedAt,
  }) {
    return CollectionItemsCompanion(
      id: id ?? this.id,
      cardId: cardId ?? this.cardId,
      quantity: quantity ?? this.quantity,
      variant: variant ?? this.variant,
      condition: condition ?? this.condition,
      addedAt: addedAt ?? this.addedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (cardId.present) {
      map['card_id'] = Variable<String>(cardId.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<int>(quantity.value);
    }
    if (variant.present) {
      map['variant'] = Variable<String>(variant.value);
    }
    if (condition.present) {
      map['condition'] = Variable<String>(condition.value);
    }
    if (addedAt.present) {
      map['added_at'] = Variable<DateTime>(addedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CollectionItemsCompanion(')
          ..write('id: $id, ')
          ..write('cardId: $cardId, ')
          ..write('quantity: $quantity, ')
          ..write('variant: $variant, ')
          ..write('condition: $condition, ')
          ..write('addedAt: $addedAt')
          ..write(')'))
        .toString();
  }
}

class $AppSettingsTable extends AppSettings
    with TableInfo<$AppSettingsTable, AppSetting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _settingKeyMeta = const VerificationMeta(
    'settingKey',
  );
  @override
  late final GeneratedColumn<String> settingKey = GeneratedColumn<String>(
    'setting_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _settingValueMeta = const VerificationMeta(
    'settingValue',
  );
  @override
  late final GeneratedColumn<String> settingValue = GeneratedColumn<String>(
    'setting_value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [settingKey, settingValue];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<AppSetting> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('setting_key')) {
      context.handle(
        _settingKeyMeta,
        settingKey.isAcceptableOrUnknown(data['setting_key']!, _settingKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_settingKeyMeta);
    }
    if (data.containsKey('setting_value')) {
      context.handle(
        _settingValueMeta,
        settingValue.isAcceptableOrUnknown(
          data['setting_value']!,
          _settingValueMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_settingValueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {settingKey};
  @override
  AppSetting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppSetting(
      settingKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}setting_key'],
      )!,
      settingValue: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}setting_value'],
      )!,
    );
  }

  @override
  $AppSettingsTable createAlias(String alias) {
    return $AppSettingsTable(attachedDatabase, alias);
  }
}

class AppSetting extends DataClass implements Insertable<AppSetting> {
  final String settingKey;
  final String settingValue;
  const AppSetting({required this.settingKey, required this.settingValue});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['setting_key'] = Variable<String>(settingKey);
    map['setting_value'] = Variable<String>(settingValue);
    return map;
  }

  AppSettingsCompanion toCompanion(bool nullToAbsent) {
    return AppSettingsCompanion(
      settingKey: Value(settingKey),
      settingValue: Value(settingValue),
    );
  }

  factory AppSetting.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppSetting(
      settingKey: serializer.fromJson<String>(json['settingKey']),
      settingValue: serializer.fromJson<String>(json['settingValue']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'settingKey': serializer.toJson<String>(settingKey),
      'settingValue': serializer.toJson<String>(settingValue),
    };
  }

  AppSetting copyWith({String? settingKey, String? settingValue}) => AppSetting(
    settingKey: settingKey ?? this.settingKey,
    settingValue: settingValue ?? this.settingValue,
  );
  AppSetting copyWithCompanion(AppSettingsCompanion data) {
    return AppSetting(
      settingKey: data.settingKey.present
          ? data.settingKey.value
          : this.settingKey,
      settingValue: data.settingValue.present
          ? data.settingValue.value
          : this.settingValue,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppSetting(')
          ..write('settingKey: $settingKey, ')
          ..write('settingValue: $settingValue')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(settingKey, settingValue);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppSetting &&
          other.settingKey == this.settingKey &&
          other.settingValue == this.settingValue);
}

class AppSettingsCompanion extends UpdateCompanion<AppSetting> {
  final Value<String> settingKey;
  final Value<String> settingValue;
  final Value<int> rowid;
  const AppSettingsCompanion({
    this.settingKey = const Value.absent(),
    this.settingValue = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AppSettingsCompanion.insert({
    required String settingKey,
    required String settingValue,
    this.rowid = const Value.absent(),
  }) : settingKey = Value(settingKey),
       settingValue = Value(settingValue);
  static Insertable<AppSetting> custom({
    Expression<String>? settingKey,
    Expression<String>? settingValue,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (settingKey != null) 'setting_key': settingKey,
      if (settingValue != null) 'setting_value': settingValue,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AppSettingsCompanion copyWith({
    Value<String>? settingKey,
    Value<String>? settingValue,
    Value<int>? rowid,
  }) {
    return AppSettingsCompanion(
      settingKey: settingKey ?? this.settingKey,
      settingValue: settingValue ?? this.settingValue,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (settingKey.present) {
      map['setting_key'] = Variable<String>(settingKey.value);
    }
    if (settingValue.present) {
      map['setting_value'] = Variable<String>(settingValue.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingsCompanion(')
          ..write('settingKey: $settingKey, ')
          ..write('settingValue: $settingValue, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $StoredCardsTable storedCards = $StoredCardsTable(this);
  late final $CollectionItemsTable collectionItems = $CollectionItemsTable(
    this,
  );
  late final $AppSettingsTable appSettings = $AppSettingsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    storedCards,
    collectionItems,
    appSettings,
  ];
}

typedef $$StoredCardsTableCreateCompanionBuilder =
    StoredCardsCompanion Function({
      required String cardId,
      required String name,
      required String setId,
      required String setName,
      required String number,
      Value<String> rarity,
      Value<String> imageUrl,
      Value<String> cardmarketUrl,
      Value<String> language,
      Value<String> supertype,
      Value<String> subtypesJson,
      Value<int?> hp,
      Value<String> typesJson,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$StoredCardsTableUpdateCompanionBuilder =
    StoredCardsCompanion Function({
      Value<String> cardId,
      Value<String> name,
      Value<String> setId,
      Value<String> setName,
      Value<String> number,
      Value<String> rarity,
      Value<String> imageUrl,
      Value<String> cardmarketUrl,
      Value<String> language,
      Value<String> supertype,
      Value<String> subtypesJson,
      Value<int?> hp,
      Value<String> typesJson,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$StoredCardsTableReferences
    extends BaseReferences<_$AppDatabase, $StoredCardsTable, StoredCard> {
  $$StoredCardsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$CollectionItemsTable, List<CollectionItem>>
  _collectionItemsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.collectionItems,
    aliasName: 'stored_cards__card_id__collection_items__card_id',
  );

  $$CollectionItemsTableProcessedTableManager get collectionItemsRefs {
    final manager =
        $$CollectionItemsTableTableManager($_db, $_db.collectionItems).filter(
          (f) => f.cardId.cardId.sqlEquals($_itemColumn<String>('card_id')!),
        );

    final cache = $_typedResult.readTableOrNull(
      _collectionItemsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$StoredCardsTableFilterComposer
    extends Composer<_$AppDatabase, $StoredCardsTable> {
  $$StoredCardsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get cardId => $composableBuilder(
    column: $table.cardId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get setId => $composableBuilder(
    column: $table.setId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get setName => $composableBuilder(
    column: $table.setName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get number => $composableBuilder(
    column: $table.number,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rarity => $composableBuilder(
    column: $table.rarity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imageUrl => $composableBuilder(
    column: $table.imageUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get cardmarketUrl => $composableBuilder(
    column: $table.cardmarketUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get language => $composableBuilder(
    column: $table.language,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get supertype => $composableBuilder(
    column: $table.supertype,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get subtypesJson => $composableBuilder(
    column: $table.subtypesJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get hp => $composableBuilder(
    column: $table.hp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get typesJson => $composableBuilder(
    column: $table.typesJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> collectionItemsRefs(
    Expression<bool> Function($$CollectionItemsTableFilterComposer f) f,
  ) {
    final $$CollectionItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cardId,
      referencedTable: $db.collectionItems,
      getReferencedColumn: (t) => t.cardId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CollectionItemsTableFilterComposer(
            $db: $db,
            $table: $db.collectionItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$StoredCardsTableOrderingComposer
    extends Composer<_$AppDatabase, $StoredCardsTable> {
  $$StoredCardsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get cardId => $composableBuilder(
    column: $table.cardId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get setId => $composableBuilder(
    column: $table.setId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get setName => $composableBuilder(
    column: $table.setName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get number => $composableBuilder(
    column: $table.number,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rarity => $composableBuilder(
    column: $table.rarity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imageUrl => $composableBuilder(
    column: $table.imageUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cardmarketUrl => $composableBuilder(
    column: $table.cardmarketUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get language => $composableBuilder(
    column: $table.language,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get supertype => $composableBuilder(
    column: $table.supertype,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get subtypesJson => $composableBuilder(
    column: $table.subtypesJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get hp => $composableBuilder(
    column: $table.hp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get typesJson => $composableBuilder(
    column: $table.typesJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$StoredCardsTableAnnotationComposer
    extends Composer<_$AppDatabase, $StoredCardsTable> {
  $$StoredCardsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get cardId =>
      $composableBuilder(column: $table.cardId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get setId =>
      $composableBuilder(column: $table.setId, builder: (column) => column);

  GeneratedColumn<String> get setName =>
      $composableBuilder(column: $table.setName, builder: (column) => column);

  GeneratedColumn<String> get number =>
      $composableBuilder(column: $table.number, builder: (column) => column);

  GeneratedColumn<String> get rarity =>
      $composableBuilder(column: $table.rarity, builder: (column) => column);

  GeneratedColumn<String> get imageUrl =>
      $composableBuilder(column: $table.imageUrl, builder: (column) => column);

  GeneratedColumn<String> get cardmarketUrl => $composableBuilder(
    column: $table.cardmarketUrl,
    builder: (column) => column,
  );

  GeneratedColumn<String> get language =>
      $composableBuilder(column: $table.language, builder: (column) => column);

  GeneratedColumn<String> get supertype =>
      $composableBuilder(column: $table.supertype, builder: (column) => column);

  GeneratedColumn<String> get subtypesJson => $composableBuilder(
    column: $table.subtypesJson,
    builder: (column) => column,
  );

  GeneratedColumn<int> get hp =>
      $composableBuilder(column: $table.hp, builder: (column) => column);

  GeneratedColumn<String> get typesJson =>
      $composableBuilder(column: $table.typesJson, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> collectionItemsRefs<T extends Object>(
    Expression<T> Function($$CollectionItemsTableAnnotationComposer a) f,
  ) {
    final $$CollectionItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cardId,
      referencedTable: $db.collectionItems,
      getReferencedColumn: (t) => t.cardId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CollectionItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.collectionItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$StoredCardsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $StoredCardsTable,
          StoredCard,
          $$StoredCardsTableFilterComposer,
          $$StoredCardsTableOrderingComposer,
          $$StoredCardsTableAnnotationComposer,
          $$StoredCardsTableCreateCompanionBuilder,
          $$StoredCardsTableUpdateCompanionBuilder,
          (StoredCard, $$StoredCardsTableReferences),
          StoredCard,
          PrefetchHooks Function({bool collectionItemsRefs})
        > {
  $$StoredCardsTableTableManager(_$AppDatabase db, $StoredCardsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StoredCardsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StoredCardsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StoredCardsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> cardId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> setId = const Value.absent(),
                Value<String> setName = const Value.absent(),
                Value<String> number = const Value.absent(),
                Value<String> rarity = const Value.absent(),
                Value<String> imageUrl = const Value.absent(),
                Value<String> cardmarketUrl = const Value.absent(),
                Value<String> language = const Value.absent(),
                Value<String> supertype = const Value.absent(),
                Value<String> subtypesJson = const Value.absent(),
                Value<int?> hp = const Value.absent(),
                Value<String> typesJson = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => StoredCardsCompanion(
                cardId: cardId,
                name: name,
                setId: setId,
                setName: setName,
                number: number,
                rarity: rarity,
                imageUrl: imageUrl,
                cardmarketUrl: cardmarketUrl,
                language: language,
                supertype: supertype,
                subtypesJson: subtypesJson,
                hp: hp,
                typesJson: typesJson,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String cardId,
                required String name,
                required String setId,
                required String setName,
                required String number,
                Value<String> rarity = const Value.absent(),
                Value<String> imageUrl = const Value.absent(),
                Value<String> cardmarketUrl = const Value.absent(),
                Value<String> language = const Value.absent(),
                Value<String> supertype = const Value.absent(),
                Value<String> subtypesJson = const Value.absent(),
                Value<int?> hp = const Value.absent(),
                Value<String> typesJson = const Value.absent(),
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => StoredCardsCompanion.insert(
                cardId: cardId,
                name: name,
                setId: setId,
                setName: setName,
                number: number,
                rarity: rarity,
                imageUrl: imageUrl,
                cardmarketUrl: cardmarketUrl,
                language: language,
                supertype: supertype,
                subtypesJson: subtypesJson,
                hp: hp,
                typesJson: typesJson,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$StoredCardsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({collectionItemsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (collectionItemsRefs) db.collectionItems,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (collectionItemsRefs)
                    await $_getPrefetchedData<
                      StoredCard,
                      $StoredCardsTable,
                      CollectionItem
                    >(
                      currentTable: table,
                      referencedTable: $$StoredCardsTableReferences
                          ._collectionItemsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$StoredCardsTableReferences(
                            db,
                            table,
                            p0,
                          ).collectionItemsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.cardId == item.cardId),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$StoredCardsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $StoredCardsTable,
      StoredCard,
      $$StoredCardsTableFilterComposer,
      $$StoredCardsTableOrderingComposer,
      $$StoredCardsTableAnnotationComposer,
      $$StoredCardsTableCreateCompanionBuilder,
      $$StoredCardsTableUpdateCompanionBuilder,
      (StoredCard, $$StoredCardsTableReferences),
      StoredCard,
      PrefetchHooks Function({bool collectionItemsRefs})
    >;
typedef $$CollectionItemsTableCreateCompanionBuilder =
    CollectionItemsCompanion Function({
      Value<int> id,
      required String cardId,
      Value<int> quantity,
      Value<String> variant,
      Value<String> condition,
      required DateTime addedAt,
    });
typedef $$CollectionItemsTableUpdateCompanionBuilder =
    CollectionItemsCompanion Function({
      Value<int> id,
      Value<String> cardId,
      Value<int> quantity,
      Value<String> variant,
      Value<String> condition,
      Value<DateTime> addedAt,
    });

final class $$CollectionItemsTableReferences
    extends
        BaseReferences<_$AppDatabase, $CollectionItemsTable, CollectionItem> {
  $$CollectionItemsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $StoredCardsTable _cardIdTable(_$AppDatabase db) => db.storedCards
      .createAlias('collection_items__card_id__stored_cards__card_id');

  $$StoredCardsTableProcessedTableManager get cardId {
    final $_column = $_itemColumn<String>('card_id')!;

    final manager = $$StoredCardsTableTableManager(
      $_db,
      $_db.storedCards,
    ).filter((f) => f.cardId.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_cardIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$CollectionItemsTableFilterComposer
    extends Composer<_$AppDatabase, $CollectionItemsTable> {
  $$CollectionItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get variant => $composableBuilder(
    column: $table.variant,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get condition => $composableBuilder(
    column: $table.condition,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get addedAt => $composableBuilder(
    column: $table.addedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$StoredCardsTableFilterComposer get cardId {
    final $$StoredCardsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cardId,
      referencedTable: $db.storedCards,
      getReferencedColumn: (t) => t.cardId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StoredCardsTableFilterComposer(
            $db: $db,
            $table: $db.storedCards,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CollectionItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $CollectionItemsTable> {
  $$CollectionItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get variant => $composableBuilder(
    column: $table.variant,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get condition => $composableBuilder(
    column: $table.condition,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get addedAt => $composableBuilder(
    column: $table.addedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$StoredCardsTableOrderingComposer get cardId {
    final $$StoredCardsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cardId,
      referencedTable: $db.storedCards,
      getReferencedColumn: (t) => t.cardId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StoredCardsTableOrderingComposer(
            $db: $db,
            $table: $db.storedCards,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CollectionItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CollectionItemsTable> {
  $$CollectionItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<String> get variant =>
      $composableBuilder(column: $table.variant, builder: (column) => column);

  GeneratedColumn<String> get condition =>
      $composableBuilder(column: $table.condition, builder: (column) => column);

  GeneratedColumn<DateTime> get addedAt =>
      $composableBuilder(column: $table.addedAt, builder: (column) => column);

  $$StoredCardsTableAnnotationComposer get cardId {
    final $$StoredCardsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cardId,
      referencedTable: $db.storedCards,
      getReferencedColumn: (t) => t.cardId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StoredCardsTableAnnotationComposer(
            $db: $db,
            $table: $db.storedCards,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CollectionItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CollectionItemsTable,
          CollectionItem,
          $$CollectionItemsTableFilterComposer,
          $$CollectionItemsTableOrderingComposer,
          $$CollectionItemsTableAnnotationComposer,
          $$CollectionItemsTableCreateCompanionBuilder,
          $$CollectionItemsTableUpdateCompanionBuilder,
          (CollectionItem, $$CollectionItemsTableReferences),
          CollectionItem,
          PrefetchHooks Function({bool cardId})
        > {
  $$CollectionItemsTableTableManager(
    _$AppDatabase db,
    $CollectionItemsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CollectionItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CollectionItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CollectionItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> cardId = const Value.absent(),
                Value<int> quantity = const Value.absent(),
                Value<String> variant = const Value.absent(),
                Value<String> condition = const Value.absent(),
                Value<DateTime> addedAt = const Value.absent(),
              }) => CollectionItemsCompanion(
                id: id,
                cardId: cardId,
                quantity: quantity,
                variant: variant,
                condition: condition,
                addedAt: addedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String cardId,
                Value<int> quantity = const Value.absent(),
                Value<String> variant = const Value.absent(),
                Value<String> condition = const Value.absent(),
                required DateTime addedAt,
              }) => CollectionItemsCompanion.insert(
                id: id,
                cardId: cardId,
                quantity: quantity,
                variant: variant,
                condition: condition,
                addedAt: addedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CollectionItemsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({cardId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (cardId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.cardId,
                                referencedTable:
                                    $$CollectionItemsTableReferences
                                        ._cardIdTable(db),
                                referencedColumn:
                                    $$CollectionItemsTableReferences
                                        ._cardIdTable(db)
                                        .cardId,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$CollectionItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CollectionItemsTable,
      CollectionItem,
      $$CollectionItemsTableFilterComposer,
      $$CollectionItemsTableOrderingComposer,
      $$CollectionItemsTableAnnotationComposer,
      $$CollectionItemsTableCreateCompanionBuilder,
      $$CollectionItemsTableUpdateCompanionBuilder,
      (CollectionItem, $$CollectionItemsTableReferences),
      CollectionItem,
      PrefetchHooks Function({bool cardId})
    >;
typedef $$AppSettingsTableCreateCompanionBuilder =
    AppSettingsCompanion Function({
      required String settingKey,
      required String settingValue,
      Value<int> rowid,
    });
typedef $$AppSettingsTableUpdateCompanionBuilder =
    AppSettingsCompanion Function({
      Value<String> settingKey,
      Value<String> settingValue,
      Value<int> rowid,
    });

class $$AppSettingsTableFilterComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get settingKey => $composableBuilder(
    column: $table.settingKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get settingValue => $composableBuilder(
    column: $table.settingValue,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AppSettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get settingKey => $composableBuilder(
    column: $table.settingKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get settingValue => $composableBuilder(
    column: $table.settingValue,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AppSettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get settingKey => $composableBuilder(
    column: $table.settingKey,
    builder: (column) => column,
  );

  GeneratedColumn<String> get settingValue => $composableBuilder(
    column: $table.settingValue,
    builder: (column) => column,
  );
}

class $$AppSettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AppSettingsTable,
          AppSetting,
          $$AppSettingsTableFilterComposer,
          $$AppSettingsTableOrderingComposer,
          $$AppSettingsTableAnnotationComposer,
          $$AppSettingsTableCreateCompanionBuilder,
          $$AppSettingsTableUpdateCompanionBuilder,
          (
            AppSetting,
            BaseReferences<_$AppDatabase, $AppSettingsTable, AppSetting>,
          ),
          AppSetting,
          PrefetchHooks Function()
        > {
  $$AppSettingsTableTableManager(_$AppDatabase db, $AppSettingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppSettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppSettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppSettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> settingKey = const Value.absent(),
                Value<String> settingValue = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AppSettingsCompanion(
                settingKey: settingKey,
                settingValue: settingValue,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String settingKey,
                required String settingValue,
                Value<int> rowid = const Value.absent(),
              }) => AppSettingsCompanion.insert(
                settingKey: settingKey,
                settingValue: settingValue,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AppSettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AppSettingsTable,
      AppSetting,
      $$AppSettingsTableFilterComposer,
      $$AppSettingsTableOrderingComposer,
      $$AppSettingsTableAnnotationComposer,
      $$AppSettingsTableCreateCompanionBuilder,
      $$AppSettingsTableUpdateCompanionBuilder,
      (
        AppSetting,
        BaseReferences<_$AppDatabase, $AppSettingsTable, AppSetting>,
      ),
      AppSetting,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$StoredCardsTableTableManager get storedCards =>
      $$StoredCardsTableTableManager(_db, _db.storedCards);
  $$CollectionItemsTableTableManager get collectionItems =>
      $$CollectionItemsTableTableManager(_db, _db.collectionItems);
  $$AppSettingsTableTableManager get appSettings =>
      $$AppSettingsTableTableManager(_db, _db.appSettings);
}
