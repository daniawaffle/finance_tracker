import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../constants/app_constants.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  DatabaseHelper._internal();

  factory DatabaseHelper() => _instance;

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, AppConstants.databaseName);

    return await openDatabase(
      path,
      version: AppConstants.databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Create categories table
    await db.execute('''
      CREATE TABLE ${AppConstants.categoriesTable} (
        ${AppConstants.categoryIdColumn} TEXT PRIMARY KEY,
        ${AppConstants.categoryNameColumn} TEXT NOT NULL,
        ${AppConstants.categoryColorColumn} TEXT NOT NULL,
        ${AppConstants.categoryDescriptionColumn} TEXT,
        ${AppConstants.categoryCreatedAtColumn} INTEGER NOT NULL
      )
    ''');

    // Create transactions table
    await db.execute('''
      CREATE TABLE ${AppConstants.transactionsTable} (
        ${AppConstants.transactionIdColumn} TEXT PRIMARY KEY,
        ${AppConstants.transactionTitleColumn} TEXT NOT NULL,
        ${AppConstants.transactionAmountColumn} REAL NOT NULL,
        ${AppConstants.transactionTypeColumn} TEXT NOT NULL,
        ${AppConstants.transactionCategoryIdColumn} TEXT NOT NULL,
        ${AppConstants.transactionDescriptionColumn} TEXT,
        ${AppConstants.transactionDateColumn} INTEGER NOT NULL,
        ${AppConstants.transactionCreatedAtColumn} INTEGER NOT NULL,
        FOREIGN KEY (${AppConstants.transactionCategoryIdColumn}) 
          REFERENCES ${AppConstants.categoriesTable} (${AppConstants.categoryIdColumn})
          ON DELETE CASCADE
      )
    ''');

    // Create index for better query performance
    await db.execute('''
      CREATE INDEX idx_transactions_category_id 
      ON ${AppConstants.transactionsTable} (${AppConstants.transactionCategoryIdColumn})
    ''');

    await db.execute('''
      CREATE INDEX idx_transactions_date 
      ON ${AppConstants.transactionsTable} (${AppConstants.transactionDateColumn})
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Handle database upgrades here if needed in the future
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
    _database = null;
  }

  Future<void> deleteDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, AppConstants.databaseName);
    await databaseFactory.deleteDatabase(path);
    _database = null;
  }
}
