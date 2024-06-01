import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:warehousecontrol/models/warehouse.dart';
import 'package:warehousecontrol/models/provider.dart';
import 'package:warehousecontrol/models/contract.dart';

class DatabaseHelper {
  static late Database _database;

  static Future<Database> get database async {
    _database = await initDB();
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
        INSERT INTO users(username, password, role)
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

      await db.rawInsert('''
        INSERT INTO contracts(name, provider_id)
        VALUES('contract2', 2)
      ''');

      await db.execute('''
          CREATE TABLE products(
            id INTEGER PRIMARY KEY,
            name TEXT,
            price REAL
          )
        ''');

      await db.execute('''
          CREATE TABLE contract_products(
            id INTEGER PRIMARY KEY,
            contract_id INTEGER,
            product_id INTEGER,
            price REAL,
            FOREIGN KEY (contract_id) REFERENCES contracts(id),
            FOREIGN KEY (product_id) REFERENCES products(id)
          )
        ''');

      await db.rawInsert('''
        INSERT INTO products(name, price)
        VALUES('product1', 10.0)
      ''');

      await db.rawInsert('''
        INSERT INTO products(name, price)
        VALUES('product2', 15.0)
      ''');

      await db.rawInsert('''
        INSERT INTO contract_products(contract_id, product_id, price)
        VALUES(1, 1, 20.0)
      ''');

      await db.rawInsert('''
        INSERT INTO contract_products(contract_id, product_id, price)
        VALUES(1, 2, 25.0)
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

  static Future<Warehouse> getWarehouseById(int id) async {
    Database db = await database;
    List<Map<String, dynamic>> result = await db.query('warehouses', where: 'id = ?', whereArgs: [id]);
    if (result.isNotEmpty) {
      return Warehouse(
        id: result.first['id'],
        name: result.first['name'],
        address: result.first['address'],
      );
    } else {
      throw Exception('Warehouse not found');
    }
  }

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

  static Future<List<Contract>> getContracts(int providerId) async {
    Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('contracts', where: 'provider_id = ?', whereArgs: [providerId]);
    return List.generate(maps.length, (i) {
      return Contract(
        id: maps[i]['id'],
        name: maps[i]['name'],
        providerId: maps[i]['provider_id'],
      );
    });
  }

  static Future<List<Map<String, dynamic>>> getProductsWithPricesByContractId(int contractId) async {
    Database db = await database;
    return await db.rawQuery('''
    SELECT products.id, products.name, contract_products.price 
    FROM products 
    INNER JOIN contract_products ON products.id = contract_products.product_id 
    WHERE contract_products.contract_id = $contractId
  ''');
  }
}