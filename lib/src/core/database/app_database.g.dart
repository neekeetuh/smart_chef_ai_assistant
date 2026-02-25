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

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $FavoriteRecipesTable favoriteRecipes = $FavoriteRecipesTable(
    this,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [favoriteRecipes];
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

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$FavoriteRecipesTableTableManager get favoriteRecipes =>
      $$FavoriteRecipesTableTableManager(_db, _db.favoriteRecipes);
}
