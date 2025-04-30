import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/loyalty_card.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  static Database? _database;

  factory DatabaseService() => _instance;

  DatabaseService._internal() {
    _initDatabaseFactory();
  }

  Future<void> _initDatabaseFactory() async {
    if (kIsWeb) {
      // Initialize for web
      databaseFactory = databaseFactoryFfiWeb;
    } else {
      // Initialize for mobile/desktop
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'loyalty_cards.db');
    return await openDatabase(path, version: 1, onCreate: _createDb);
  }

  Future<void> _createDb(Database db, int version) async {
    await db.execute('''
      CREATE TABLE loyalty_cards(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        cardNumber TEXT NOT NULL,
        barcode TEXT NOT NULL,
        barcodeType TEXT,
        expiryDate TEXT NOT NULL,
        notes TEXT,
        imagePath TEXT,
        createdAt TEXT NOT NULL,
        updatedAt TEXT NOT NULL,
        isSynced INTEGER NOT NULL
      )
    ''');
  }

  Future<int> insertCard(LoyaltyCard card) async {
    final db = await database;
    return await db.insert('loyalty_cards', card.toMap());
  }

  Future<List<LoyaltyCard>> getAllCards() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('loyalty_cards');
    return List.generate(maps.length, (i) => LoyaltyCard.fromMap(maps[i]));
  }

  Future<LoyaltyCard?> getCard(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'loyalty_cards',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isEmpty) return null;
    return LoyaltyCard.fromMap(maps.first);
  }

  Future<int> updateCard(LoyaltyCard card) async {
    final db = await database;
    return await db.update(
      'loyalty_cards',
      card.toMap(),
      where: 'id = ?',
      whereArgs: [card.id],
    );
  }

  Future<int> deleteCard(int id) async {
    final db = await database;
    return await db.delete('loyalty_cards', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<LoyaltyCard>> getUnsyncedCards() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'loyalty_cards',
      where: 'isSynced = ?',
      whereArgs: [0],
    );
    return List.generate(maps.length, (i) => LoyaltyCard.fromMap(maps[i]));
  }

  Future<void> markCardAsSynced(int id) async {
    final db = await database;
    await db.update(
      'loyalty_cards',
      {'isSynced': 1},
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
