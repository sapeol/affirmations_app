import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), 'dopermations.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE seen_content(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            text TEXT,
            type TEXT,
            timestamp TEXT,
            UNIQUE(text, type)
          )
        ''');
        
        await db.execute('''
          CREATE TABLE user_history(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            type TEXT,
            data TEXT,
            timestamp TEXT
          )
        ''');
      },
    );
  }

  // Seen Content Methods
  Future<void> markSeen(String text, String type) async {
    final db = await database;
    await db.insert(
      'seen_content',
      {
        'text': text,
        'type': type,
        'timestamp': DateTime.now().toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  Future<List<String>> getSeenContent(String type) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'seen_content',
      columns: ['text'],
      where: 'type = ?',
      whereArgs: [type],
    );
    return List.generate(maps.length, (i) => maps[i]['text'] as String);
  }

  // History Methods
  Future<void> logHistory(String type, String data) async {
    final db = await database;
    await db.insert(
      'user_history',
      {
        'type': type,
        'data': data,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  Future<List<Map<String, dynamic>>> getHistory(String type) async {
    final db = await database;
    return await db.query(
      'user_history',
      where: 'type = ?',
      whereArgs: [type],
      orderBy: 'timestamp DESC',
    );
  }
}
