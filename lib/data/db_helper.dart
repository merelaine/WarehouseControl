import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:warehousecontrol/models/warehouse.dart';
import 'package:warehousecontrol/models/provider.dart';

class DatabaseHelper {
  static late Database _database;

  static Future<Database> get database async {
    _database = await initDB();
    await DatabaseHelper.printSchema();
    return _database;
  }

  static Future<Database> initDB() async {
    String path = join(await getDatabasesPath(), 'your_database.db');
    return await openDatabase(path, onCreate: (db, version) async {
      await db.execute('''
        CREATE TABLE users(
          id INTEGER PRIMARY KEY,
          username TEXT,
          password TEXT,
          role TEXT
        )
      ''');

      await db.rawInsert('''
        INSERT INTO users(username, password, position)
        VALUES('user', '123', 'storekeeper')
      ''');

      await db.execute('''
          CREATE TABLE warehouses(
            id INTEGER PRIMARY KEY,
            name TEXT,
            address TEXT
          )
        ''');

      await db.rawInsert('''
        INSERT INTO warehouses(name, address)
        VALUES('warehouse1', 'address1')
      ''');
      await db.rawInsert('''
        INSERT INTO warehouses(name, address)
        VALUES('warehouse2', 'address2')
      ''');

      await db.execute('''
          CREATE TABLE providers(
            id INTEGER PRIMARY KEY,
            name TEXT
          )
        ''');

      await db.rawInsert('''
        INSERT INTO providers(name)
        VALUES('provider1')
      ''');
      await db.rawInsert('''
        INSERT INTO providers(name)
        VALUES('provider2')
      ''');

      await db.execute('''
          CREATE TABLE contracts(
            id INTEGER PRIMARY KEY,
            name TEXT,
            provider_id INTEGER,
            FOREIGN KEY (provider_id) REFERENCES providers(id)
          )
        ''');

      await db.rawInsert('''
        INSERT INTO contracts(name, provider_id)
        VALUES('contract1', 1)
      ''');

    }, version: 1, onConfigure: (db) async {
      await db.execute('PRAGMA foreign_keys = ON');
    });
  }

  Future<bool> authenticateUser(String username, String password) async {
    Database db = await database;
    List<Map<String, dynamic>> result = await db.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );
    return result.isNotEmpty;
  }

  static Future<void> insertWarehouse(Warehouse warehouse) async {
    Database db = await database;
    await db.insert(
      'warehouses',
      warehouse.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<Warehouse>> getWarehouses() async {
    Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('warehouses');
    return List.generate(maps.length, (i) {
      return Warehouse(
        id: maps[i]['id'],
        name: maps[i]['name'],
        address: maps[i]['address'],
      );
    });
  }



  static Future<void> printSchema() async {
    Database db = await database;

    List<Map<String, dynamic>> tables = await db.rawQuery(
      "SELECT name FROM sqlite_master WHERE type='table';",
    );

    for (Map<String, dynamic> table in tables) {
      String tableName = table['name'];
      print("Table: $tableName");

      List<Map<String, dynamic>> columns = await db.rawQuery(
        "PRAGMA table_info($tableName);",
      );

      for (Map<String, dynamic> column in columns) {
        print(" - ${column['name']} (${column['type']})");
      }}}




  static Future<List<Provider>> getProviders() async {
    Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('providers');
    return List.generate(maps.length, (i) {
      return Provider(
        id: maps[i]['id'],
        name: maps[i]['name'],
      );
    });
  }
}