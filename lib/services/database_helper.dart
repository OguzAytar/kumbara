import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/app_settings.dart';
import '../models/saving.dart';
import '../models/saving_transaction.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'kumbara.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // App Settings tablosu
    await db.execute('''
      CREATE TABLE app_settings (
        id INTEGER PRIMARY KEY,
        isFirstLaunch INTEGER NOT NULL,
        notificationsEnabled INTEGER NOT NULL,
        locale TEXT NOT NULL,
        theme TEXT NOT NULL,
        lastOpenDate INTEGER
      )
    ''');

    // Savings tablosu
    await db.execute('''
      CREATE TABLE savings (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        description TEXT NOT NULL,
        targetAmount REAL NOT NULL,
        currentAmount REAL NOT NULL DEFAULT 0,
        startDate INTEGER NOT NULL,
        targetDate INTEGER NOT NULL,
        frequency TEXT NOT NULL,
        status TEXT NOT NULL,
        iconName TEXT,
        color TEXT,
        createdAt INTEGER NOT NULL,
        updatedAt INTEGER NOT NULL
      )
    ''');

    // Saving Transactions tablosu
    await db.execute('''
      CREATE TABLE saving_transactions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        savingId INTEGER NOT NULL,
        amount REAL NOT NULL,
        date INTEGER NOT NULL,
        note TEXT,
        createdAt INTEGER NOT NULL,
        FOREIGN KEY (savingId) REFERENCES savings (id) ON DELETE CASCADE
      )
    ''');

    // Varsayılan ayarları ekle
    await db.insert('app_settings', AppSettings(
      isFirstLaunch: true,
      notificationsEnabled: false,
      locale: 'tr',
      theme: 'light',
    ).toMap());
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Gelecekteki database schema güncellemeleri için
  }

  // App Settings işlemleri
  Future<AppSettings> getAppSettings() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('app_settings');
    
    if (maps.isNotEmpty) {
      return AppSettings.fromMap(maps.first);
    } else {
      // Varsayılan ayarları döndür
      final defaultSettings = AppSettings(
        isFirstLaunch: true,
        notificationsEnabled: false,
        locale: 'tr',
        theme: 'light',
      );
      await updateAppSettings(defaultSettings);
      return defaultSettings;
    }
  }

  Future<void> updateAppSettings(AppSettings settings) async {
    final db = await database;
    await db.update(
      'app_settings',
      settings.toMap(),
      where: 'id = ?',
      whereArgs: [settings.id],
    );
  }

  // Savings işlemleri
  Future<int> insertSaving(Saving saving) async {
    final db = await database;
    return await db.insert('savings', saving.toMap());
  }

  Future<List<Saving>> getAllSavings() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'savings',
      orderBy: 'createdAt DESC',
    );
    return List.generate(maps.length, (i) => Saving.fromMap(maps[i]));
  }

  Future<Saving?> getSavingById(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'savings',
      where: 'id = ?',
      whereArgs: [id],
    );
    
    if (maps.isNotEmpty) {
      return Saving.fromMap(maps.first);
    }
    return null;
  }

  Future<void> updateSaving(Saving saving) async {
    final db = await database;
    await db.update(
      'savings',
      saving.toMap(),
      where: 'id = ?',
      whereArgs: [saving.id],
    );
  }

  Future<void> deleteSaving(int id) async {
    final db = await database;
    await db.delete(
      'savings',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Saving Transactions işlemleri
  Future<int> insertTransaction(SavingTransaction transaction) async {
    final db = await database;
    final id = await db.insert('saving_transactions', transaction.toMap());
    
    // Ana birikim miktarını güncelle
    await _updateSavingCurrentAmount(transaction.savingId);
    
    return id;
  }

  Future<List<SavingTransaction>> getTransactionsBySavingId(int savingId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'saving_transactions',
      where: 'savingId = ?',
      whereArgs: [savingId],
      orderBy: 'date DESC',
    );
    return List.generate(maps.length, (i) => SavingTransaction.fromMap(maps[i]));
  }

  Future<void> deleteTransaction(int id) async {
    final db = await database;
    
    // Transaction'ı sil
    final transaction = await _getTransactionById(id);
    await db.delete(
      'saving_transactions',
      where: 'id = ?',
      whereArgs: [id],
    );
    
    // Ana birikim miktarını güncelle
    if (transaction != null) {
      await _updateSavingCurrentAmount(transaction.savingId);
    }
  }

  Future<SavingTransaction?> _getTransactionById(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'saving_transactions',
      where: 'id = ?',
      whereArgs: [id],
    );
    
    if (maps.isNotEmpty) {
      return SavingTransaction.fromMap(maps.first);
    }
    return null;
  }

  Future<void> _updateSavingCurrentAmount(int savingId) async {
    final db = await database;
    
    // Bu birikimdeki tüm transaction'ların toplamını hesapla
    final result = await db.rawQuery(
      'SELECT SUM(amount) as total FROM saving_transactions WHERE savingId = ?',
      [savingId],
    );
    
    final total = result.first['total'] as double? ?? 0.0;
    
    // Saving'i güncelle
    await db.update(
      'savings',
      {'currentAmount': total, 'updatedAt': DateTime.now().millisecondsSinceEpoch},
      where: 'id = ?',
      whereArgs: [savingId],
    );
  }

  // Dashboard için istatistikler
  Future<Map<String, dynamic>> getDashboardStats() async {
    final db = await database;
    
    // Toplam birikim sayısı
    final totalSavingsResult = await db.rawQuery('SELECT COUNT(*) as count FROM savings');
    final totalSavings = totalSavingsResult.first['count'] as int;
    
    // Aktif birikim sayısı
    final activeSavingsResult = await db.rawQuery(
      'SELECT COUNT(*) as count FROM savings WHERE status = ?',
      ['active'],
    );
    final activeSavings = activeSavingsResult.first['count'] as int;
    
    // Toplam biriktirilen miktar
    final totalAmountResult = await db.rawQuery('SELECT SUM(currentAmount) as total FROM savings');
    final totalAmount = totalAmountResult.first['total'] as double? ?? 0.0;
    
    // En yakın hedef tarihi
    final nearestTargetResult = await db.rawQuery(
      'SELECT * FROM savings WHERE status = ? ORDER BY targetDate ASC LIMIT 1',
      ['active'],
    );
    Saving? nearestTarget;
    if (nearestTargetResult.isNotEmpty) {
      nearestTarget = Saving.fromMap(nearestTargetResult.first);
    }
    
    return {
      'totalSavings': totalSavings,
      'activeSavings': activeSavings,
      'totalAmount': totalAmount,
      'nearestTarget': nearestTarget,
    };
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}
