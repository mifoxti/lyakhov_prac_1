import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('music_app.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    print('Database path: $path');

    return await openDatabase(
      path,
      version: 3,
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  Future _createDB(Database db, int version) async {
    // Таблица треков
    await db.execute('''
      CREATE TABLE tracks (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        artist TEXT NOT NULL,
        duration TEXT NOT NULL,
        imageUrl TEXT
      )
    ''');

    // Таблица подкастов
    await db.execute('''
      CREATE TABLE podcasts (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        author TEXT NOT NULL,
        duration TEXT NOT NULL,
        imageUrl TEXT NOT NULL
      )
    ''');

    // Таблица плейлистов
    await db.execute('''
      CREATE TABLE playlists (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        description TEXT,
        created_at TEXT DEFAULT CURRENT_TIMESTAMP
      )
    ''');

    // Таблица связи треков и плейлистов
    await db.execute('''
      CREATE TABLE playlist_tracks (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        playlist_id INTEGER NOT NULL,
        track_id INTEGER NOT NULL,
        position INTEGER NOT NULL,
        FOREIGN KEY (playlist_id) REFERENCES playlists (id) ON DELETE CASCADE,
        FOREIGN KEY (track_id) REFERENCES tracks (id) ON DELETE CASCADE,
        UNIQUE(playlist_id, track_id)
      )
    ''');

    // Таблица истории прослушивания
    await db.execute('''
      CREATE TABLE play_history (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        track_id INTEGER NOT NULL,
        played_at TEXT DEFAULT CURRENT_TIMESTAMP,
        play_duration INTEGER DEFAULT 0,
        FOREIGN KEY (track_id) REFERENCES tracks (id) ON DELETE CASCADE
      )
    ''');

    // Таблица избранных треков
    await db.execute('''
      CREATE TABLE favorites (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        track_id INTEGER NOT NULL UNIQUE,
        added_at TEXT DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (track_id) REFERENCES tracks (id) ON DELETE CASCADE
      )
    ''');

    // Таблица настроек плейлистов
    await db.execute('''
      CREATE TABLE playlist_settings (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        playlist_id INTEGER NOT NULL UNIQUE,
        is_public INTEGER DEFAULT 0,
        allow_collaboration INTEGER DEFAULT 0,
        FOREIGN KEY (playlist_id) REFERENCES playlists (id) ON DELETE CASCADE
      )
    ''');

    // Вставка начальных данных
    await _insertInitialData(db);
  }

  Future<void> _insertInitialData(Database db) async {
    print('Inserting initial data...');

    // Начальные треки
    await db.insert('tracks', {'title': 'Bohemian Rhapsody', 'artist': 'Queen', 'duration': '5:55', 'imageUrl': 'https://i.pinimg.com/736x/1a/2b/3c/1a2b3c4d5e6f7g8h9i0j.jpg'});
    await db.insert('tracks', {'title': 'Stairway to Heaven', 'artist': 'Led Zeppelin', 'duration': '8:02', 'imageUrl': 'https://i.pinimg.com/736x/2b/3c/4d/2b3c4d5e6f7g8h9i0j1k.jpg'});
    await db.insert('tracks', {'title': 'Hotel California', 'artist': 'Eagles', 'duration': '6:30', 'imageUrl': 'https://i.pinimg.com/736x/3c/4d/5e/3c4d5e6f7g8h9i0j1k2.jpg'});
    print('Inserted 3 tracks');

    // Начальные плейлисты
    await db.insert('playlists', {'name': 'Классика рока', 'description': 'Лучшие рок-хиты всех времен'});
    await db.insert('playlists', {'name': 'Для тренировки', 'description': 'Энергичная музыка для спорта'});
    await db.insert('playlists', {'name': 'Релакс', 'description': 'Спокойная музыка для отдыха'});
    print('Inserted 3 playlists');

    print('Initial data insertion completed');
  }

  Future<void> _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 3) {
      // Удаляем все таблицы и пересоздаем
      await db.execute('DROP TABLE IF EXISTS playlist_settings');
      await db.execute('DROP TABLE IF EXISTS favorites');
      await db.execute('DROP TABLE IF EXISTS play_history');
      await db.execute('DROP TABLE IF EXISTS playlist_tracks');
      await db.execute('DROP TABLE IF EXISTS playlists');
      await db.execute('DROP TABLE IF EXISTS podcasts');
      await db.execute('DROP TABLE IF EXISTS tracks');

      // Пересоздаем все таблицы
      await _createDB(db, newVersion);
    }
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
