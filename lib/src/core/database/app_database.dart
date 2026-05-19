import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'app_database.g.dart';

@DataClassName('FavoriteRecipeEntry')
class FavoriteRecipes extends Table {
  TextColumn get id => text()();
  TextColumn get recipeData => text()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('CustomRecipeEntry')
class CustomRecipes extends Table {
  TextColumn get id => text()();
  TextColumn get recipeData => text()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('HiddenRecipeEntry')
class HiddenRecipes extends Table {
  TextColumn get id => text()();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [FavoriteRecipes, CustomRecipes, HiddenRecipes])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 2; // Incremented schema version

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        if (from == 1) {
          await m.createTable(customRecipes);
          await m.createTable(hiddenRecipes);
        }
      },
    );
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'smart_chef.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
