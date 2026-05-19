// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $FavoriteRecipesTable extends FavoriteRecipes
    with TableInfo<$FavoriteRecipesTable, FavoriteRecipeEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FavoriteRecipesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _recipeDataMeta = const VerificationMeta(
    'recipeData',
  );
  @override
  late final GeneratedColumn<String> recipeData = GeneratedColumn<String>(
    'recipe_data',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, recipeData];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'favorite_recipes';
  @override
  VerificationContext validateIntegrity(
    Insertable<FavoriteRecipeEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('recipe_data')) {
      context.handle(
        _recipeDataMeta,
        recipeData.isAcceptableOrUnknown(data['recipe_data']!, _recipeDataMeta),
      );
    } else if (isInserting) {
      context.missing(_recipeDataMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FavoriteRecipeEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FavoriteRecipeEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      recipeData: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}recipe_data'],
      )!,
    );
  }

  @override
  $FavoriteRecipesTable createAlias(String alias) {
    return $FavoriteRecipesTable(attachedDatabase, alias);
  }
}

class FavoriteRecipeEntry extends DataClass
    implements Insertable<FavoriteRecipeEntry> {
  final String id;
  final String recipeData;
  const FavoriteRecipeEntry({required this.id, required this.recipeData});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['recipe_data'] = Variable<String>(recipeData);
    return map;
  }

  FavoriteRecipesCompanion toCompanion(bool nullToAbsent) {
    return FavoriteRecipesCompanion(
      id: Value(id),
      recipeData: Value(recipeData),
    );
  }

  factory FavoriteRecipeEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FavoriteRecipeEntry(
      id: serializer.fromJson<String>(json['id']),
      recipeData: serializer.fromJson<String>(json['recipeData']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'recipeData': serializer.toJson<String>(recipeData),
    };
  }

  FavoriteRecipeEntry copyWith({String? id, String? recipeData}) =>
      FavoriteRecipeEntry(
        id: id ?? this.id,
        recipeData: recipeData ?? this.recipeData,
      );
  FavoriteRecipeEntry copyWithCompanion(FavoriteRecipesCompanion data) {
    return FavoriteRecipeEntry(
      id: data.id.present ? data.id.value : this.id,
      recipeData: data.recipeData.present
          ? data.recipeData.value
          : this.recipeData,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FavoriteRecipeEntry(')
          ..write('id: $id, ')
          ..write('recipeData: $recipeData')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, recipeData);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FavoriteRecipeEntry &&
          other.id == this.id &&
          other.recipeData == this.recipeData);
}

class FavoriteRecipesCompanion extends UpdateCompanion<FavoriteRecipeEntry> {
  final Value<String> id;
  final Value<String> recipeData;
  final Value<int> rowid;
  const FavoriteRecipesCompanion({
    this.id = const Value.absent(),
    this.recipeData = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FavoriteRecipesCompanion.insert({
    required String id,
    required String recipeData,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       recipeData = Value(recipeData);
  static Insertable<FavoriteRecipeEntry> custom({
    Expression<String>? id,
    Expression<String>? recipeData,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (recipeData != null) 'recipe_data': recipeData,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FavoriteRecipesCompanion copyWith({
    Value<String>? id,
    Value<String>? recipeData,
    Value<int>? rowid,
  }) {
    return FavoriteRecipesCompanion(
      id: id ?? this.id,
      recipeData: recipeData ?? this.recipeData,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (recipeData.present) {
      map['recipe_data'] = Variable<String>(recipeData.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FavoriteRecipesCompanion(')
          ..write('id: $id, ')
          ..write('recipeData: $recipeData, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CustomRecipesTable extends CustomRecipes
    with TableInfo<$CustomRecipesTable, CustomRecipeEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CustomRecipesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _recipeDataMeta = const VerificationMeta(
    'recipeData',
  );
  @override
  late final GeneratedColumn<String> recipeData = GeneratedColumn<String>(
    'recipe_data',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, recipeData];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'custom_recipes';
  @override
  VerificationContext validateIntegrity(
    Insertable<CustomRecipeEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('recipe_data')) {
      context.handle(
        _recipeDataMeta,
        recipeData.isAcceptableOrUnknown(data['recipe_data']!, _recipeDataMeta),
      );
    } else if (isInserting) {
      context.missing(_recipeDataMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CustomRecipeEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CustomRecipeEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      recipeData: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}recipe_data'],
      )!,
    );
  }

  @override
  $CustomRecipesTable createAlias(String alias) {
    return $CustomRecipesTable(attachedDatabase, alias);
  }
}

class CustomRecipeEntry extends DataClass
    implements Insertable<CustomRecipeEntry> {
  final String id;
  final String recipeData;
  const CustomRecipeEntry({required this.id, required this.recipeData});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['recipe_data'] = Variable<String>(recipeData);
    return map;
  }

  CustomRecipesCompanion toCompanion(bool nullToAbsent) {
    return CustomRecipesCompanion(id: Value(id), recipeData: Value(recipeData));
  }

  factory CustomRecipeEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CustomRecipeEntry(
      id: serializer.fromJson<String>(json['id']),
      recipeData: serializer.fromJson<String>(json['recipeData']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'recipeData': serializer.toJson<String>(recipeData),
    };
  }

  CustomRecipeEntry copyWith({String? id, String? recipeData}) =>
      CustomRecipeEntry(
        id: id ?? this.id,
        recipeData: recipeData ?? this.recipeData,
      );
  CustomRecipeEntry copyWithCompanion(CustomRecipesCompanion data) {
    return CustomRecipeEntry(
      id: data.id.present ? data.id.value : this.id,
      recipeData: data.recipeData.present
          ? data.recipeData.value
          : this.recipeData,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CustomRecipeEntry(')
          ..write('id: $id, ')
          ..write('recipeData: $recipeData')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, recipeData);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CustomRecipeEntry &&
          other.id == this.id &&
          other.recipeData == this.recipeData);
}

class CustomRecipesCompanion extends UpdateCompanion<CustomRecipeEntry> {
  final Value<String> id;
  final Value<String> recipeData;
  final Value<int> rowid;
  const CustomRecipesCompanion({
    this.id = const Value.absent(),
    this.recipeData = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CustomRecipesCompanion.insert({
    required String id,
    required String recipeData,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       recipeData = Value(recipeData);
  static Insertable<CustomRecipeEntry> custom({
    Expression<String>? id,
    Expression<String>? recipeData,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (recipeData != null) 'recipe_data': recipeData,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CustomRecipesCompanion copyWith({
    Value<String>? id,
    Value<String>? recipeData,
    Value<int>? rowid,
  }) {
    return CustomRecipesCompanion(
      id: id ?? this.id,
      recipeData: recipeData ?? this.recipeData,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (recipeData.present) {
      map['recipe_data'] = Variable<String>(recipeData.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CustomRecipesCompanion(')
          ..write('id: $id, ')
          ..write('recipeData: $recipeData, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $HiddenRecipesTable extends HiddenRecipes
    with TableInfo<$HiddenRecipesTable, HiddenRecipeEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HiddenRecipesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'hidden_recipes';
  @override
  VerificationContext validateIntegrity(
    Insertable<HiddenRecipeEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  HiddenRecipeEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HiddenRecipeEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
    );
  }

  @override
  $HiddenRecipesTable createAlias(String alias) {
    return $HiddenRecipesTable(attachedDatabase, alias);
  }
}

class HiddenRecipeEntry extends DataClass
    implements Insertable<HiddenRecipeEntry> {
  final String id;
  const HiddenRecipeEntry({required this.id});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    return map;
  }

  HiddenRecipesCompanion toCompanion(bool nullToAbsent) {
    return HiddenRecipesCompanion(id: Value(id));
  }

  factory HiddenRecipeEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HiddenRecipeEntry(id: serializer.fromJson<String>(json['id']));
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{'id': serializer.toJson<String>(id)};
  }

  HiddenRecipeEntry copyWith({String? id}) =>
      HiddenRecipeEntry(id: id ?? this.id);
  HiddenRecipeEntry copyWithCompanion(HiddenRecipesCompanion data) {
    return HiddenRecipeEntry(id: data.id.present ? data.id.value : this.id);
  }

  @override
  String toString() {
    return (StringBuffer('HiddenRecipeEntry(')
          ..write('id: $id')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => id.hashCode;
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HiddenRecipeEntry && other.id == this.id);
}

class HiddenRecipesCompanion extends UpdateCompanion<HiddenRecipeEntry> {
  final Value<String> id;
  final Value<int> rowid;
  const HiddenRecipesCompanion({
    this.id = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  HiddenRecipesCompanion.insert({
    required String id,
    this.rowid = const Value.absent(),
  }) : id = Value(id);
  static Insertable<HiddenRecipeEntry> custom({
    Expression<String>? id,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (rowid != null) 'rowid': rowid,
    });
  }

  HiddenRecipesCompanion copyWith({Value<String>? id, Value<int>? rowid}) {
    return HiddenRecipesCompanion(
      id: id ?? this.id,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HiddenRecipesCompanion(')
          ..write('id: $id, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $FavoriteRecipesTable favoriteRecipes = $FavoriteRecipesTable(
    this,
  );
  late final $CustomRecipesTable customRecipes = $CustomRecipesTable(this);
  late final $HiddenRecipesTable hiddenRecipes = $HiddenRecipesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    favoriteRecipes,
    customRecipes,
    hiddenRecipes,
  ];
}

typedef $$FavoriteRecipesTableCreateCompanionBuilder =
    FavoriteRecipesCompanion Function({
      required String id,
      required String recipeData,
      Value<int> rowid,
    });
typedef $$FavoriteRecipesTableUpdateCompanionBuilder =
    FavoriteRecipesCompanion Function({
      Value<String> id,
      Value<String> recipeData,
      Value<int> rowid,
    });

class $$FavoriteRecipesTableFilterComposer
    extends Composer<_$AppDatabase, $FavoriteRecipesTable> {
  $$FavoriteRecipesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get recipeData => $composableBuilder(
    column: $table.recipeData,
    builder: (column) => ColumnFilters(column),
  );
}

class $$FavoriteRecipesTableOrderingComposer
    extends Composer<_$AppDatabase, $FavoriteRecipesTable> {
  $$FavoriteRecipesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get recipeData => $composableBuilder(
    column: $table.recipeData,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$FavoriteRecipesTableAnnotationComposer
    extends Composer<_$AppDatabase, $FavoriteRecipesTable> {
  $$FavoriteRecipesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get recipeData => $composableBuilder(
    column: $table.recipeData,
    builder: (column) => column,
  );
}

class $$FavoriteRecipesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FavoriteRecipesTable,
          FavoriteRecipeEntry,
          $$FavoriteRecipesTableFilterComposer,
          $$FavoriteRecipesTableOrderingComposer,
          $$FavoriteRecipesTableAnnotationComposer,
          $$FavoriteRecipesTableCreateCompanionBuilder,
          $$FavoriteRecipesTableUpdateCompanionBuilder,
          (
            FavoriteRecipeEntry,
            BaseReferences<
              _$AppDatabase,
              $FavoriteRecipesTable,
              FavoriteRecipeEntry
            >,
          ),
          FavoriteRecipeEntry,
          PrefetchHooks Function()
        > {
  $$FavoriteRecipesTableTableManager(
    _$AppDatabase db,
    $FavoriteRecipesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FavoriteRecipesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FavoriteRecipesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FavoriteRecipesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> recipeData = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FavoriteRecipesCompanion(
                id: id,
                recipeData: recipeData,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String recipeData,
                Value<int> rowid = const Value.absent(),
              }) => FavoriteRecipesCompanion.insert(
                id: id,
                recipeData: recipeData,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$FavoriteRecipesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FavoriteRecipesTable,
      FavoriteRecipeEntry,
      $$FavoriteRecipesTableFilterComposer,
      $$FavoriteRecipesTableOrderingComposer,
      $$FavoriteRecipesTableAnnotationComposer,
      $$FavoriteRecipesTableCreateCompanionBuilder,
      $$FavoriteRecipesTableUpdateCompanionBuilder,
      (
        FavoriteRecipeEntry,
        BaseReferences<
          _$AppDatabase,
          $FavoriteRecipesTable,
          FavoriteRecipeEntry
        >,
      ),
      FavoriteRecipeEntry,
      PrefetchHooks Function()
    >;
typedef $$CustomRecipesTableCreateCompanionBuilder =
    CustomRecipesCompanion Function({
      required String id,
      required String recipeData,
      Value<int> rowid,
    });
typedef $$CustomRecipesTableUpdateCompanionBuilder =
    CustomRecipesCompanion Function({
      Value<String> id,
      Value<String> recipeData,
      Value<int> rowid,
    });

class $$CustomRecipesTableFilterComposer
    extends Composer<_$AppDatabase, $CustomRecipesTable> {
  $$CustomRecipesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get recipeData => $composableBuilder(
    column: $table.recipeData,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CustomRecipesTableOrderingComposer
    extends Composer<_$AppDatabase, $CustomRecipesTable> {
  $$CustomRecipesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get recipeData => $composableBuilder(
    column: $table.recipeData,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CustomRecipesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CustomRecipesTable> {
  $$CustomRecipesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get recipeData => $composableBuilder(
    column: $table.recipeData,
    builder: (column) => column,
  );
}

class $$CustomRecipesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CustomRecipesTable,
          CustomRecipeEntry,
          $$CustomRecipesTableFilterComposer,
          $$CustomRecipesTableOrderingComposer,
          $$CustomRecipesTableAnnotationComposer,
          $$CustomRecipesTableCreateCompanionBuilder,
          $$CustomRecipesTableUpdateCompanionBuilder,
          (
            CustomRecipeEntry,
            BaseReferences<
              _$AppDatabase,
              $CustomRecipesTable,
              CustomRecipeEntry
            >,
          ),
          CustomRecipeEntry,
          PrefetchHooks Function()
        > {
  $$CustomRecipesTableTableManager(_$AppDatabase db, $CustomRecipesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CustomRecipesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CustomRecipesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CustomRecipesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> recipeData = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CustomRecipesCompanion(
                id: id,
                recipeData: recipeData,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String recipeData,
                Value<int> rowid = const Value.absent(),
              }) => CustomRecipesCompanion.insert(
                id: id,
                recipeData: recipeData,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CustomRecipesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CustomRecipesTable,
      CustomRecipeEntry,
      $$CustomRecipesTableFilterComposer,
      $$CustomRecipesTableOrderingComposer,
      $$CustomRecipesTableAnnotationComposer,
      $$CustomRecipesTableCreateCompanionBuilder,
      $$CustomRecipesTableUpdateCompanionBuilder,
      (
        CustomRecipeEntry,
        BaseReferences<_$AppDatabase, $CustomRecipesTable, CustomRecipeEntry>,
      ),
      CustomRecipeEntry,
      PrefetchHooks Function()
    >;
typedef $$HiddenRecipesTableCreateCompanionBuilder =
    HiddenRecipesCompanion Function({required String id, Value<int> rowid});
typedef $$HiddenRecipesTableUpdateCompanionBuilder =
    HiddenRecipesCompanion Function({Value<String> id, Value<int> rowid});

class $$HiddenRecipesTableFilterComposer
    extends Composer<_$AppDatabase, $HiddenRecipesTable> {
  $$HiddenRecipesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );
}

class $$HiddenRecipesTableOrderingComposer
    extends Composer<_$AppDatabase, $HiddenRecipesTable> {
  $$HiddenRecipesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$HiddenRecipesTableAnnotationComposer
    extends Composer<_$AppDatabase, $HiddenRecipesTable> {
  $$HiddenRecipesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);
}

class $$HiddenRecipesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $HiddenRecipesTable,
          HiddenRecipeEntry,
          $$HiddenRecipesTableFilterComposer,
          $$HiddenRecipesTableOrderingComposer,
          $$HiddenRecipesTableAnnotationComposer,
          $$HiddenRecipesTableCreateCompanionBuilder,
          $$HiddenRecipesTableUpdateCompanionBuilder,
          (
            HiddenRecipeEntry,
            BaseReferences<
              _$AppDatabase,
              $HiddenRecipesTable,
              HiddenRecipeEntry
            >,
          ),
          HiddenRecipeEntry,
          PrefetchHooks Function()
        > {
  $$HiddenRecipesTableTableManager(_$AppDatabase db, $HiddenRecipesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HiddenRecipesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HiddenRecipesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$HiddenRecipesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => HiddenRecipesCompanion(id: id, rowid: rowid),
          createCompanionCallback:
              ({required String id, Value<int> rowid = const Value.absent()}) =>
                  HiddenRecipesCompanion.insert(id: id, rowid: rowid),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$HiddenRecipesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $HiddenRecipesTable,
      HiddenRecipeEntry,
      $$HiddenRecipesTableFilterComposer,
      $$HiddenRecipesTableOrderingComposer,
      $$HiddenRecipesTableAnnotationComposer,
      $$HiddenRecipesTableCreateCompanionBuilder,
      $$HiddenRecipesTableUpdateCompanionBuilder,
      (
        HiddenRecipeEntry,
        BaseReferences<_$AppDatabase, $HiddenRecipesTable, HiddenRecipeEntry>,
      ),
      HiddenRecipeEntry,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$FavoriteRecipesTableTableManager get favoriteRecipes =>
      $$FavoriteRecipesTableTableManager(_db, _db.favoriteRecipes);
  $$CustomRecipesTableTableManager get customRecipes =>
      $$CustomRecipesTableTableManager(_db, _db.customRecipes);
  $$HiddenRecipesTableTableManager get hiddenRecipes =>
      $$HiddenRecipesTableTableManager(_db, _db.hiddenRecipes);
}
