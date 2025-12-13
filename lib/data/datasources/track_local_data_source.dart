import '../models/track_dto.dart';
import 'database_helper.dart';

class TrackLocalDataSource {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Future<List<TrackDto>> getTracks() async {
    final db = await _dbHelper.database;
    final result = await db.query('tracks', orderBy: 'title ASC');

    return result.map((map) => TrackDto.fromMap(map)).toList();
  }

  Future<TrackDto?> getTrackById(int id) async {
    final db = await _dbHelper.database;
    final result = await db.query(
      'tracks',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (result.isNotEmpty) {
      return TrackDto.fromMap(result.first);
    }
    return null;
  }

  Future<int> insertTrack(TrackDto track) async {
    final db = await _dbHelper.database;
    return await db.insert('tracks', track.toMap());
  }

  Future<int> updateTrack(int id, TrackDto track) async {
    final db = await _dbHelper.database;
    return await db.update(
      'tracks',
      track.toMap(),
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteTrack(int id) async {
    final db = await _dbHelper.database;
    return await db.delete(
      'tracks',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> addTrack(TrackDto track) async {
    final db = await _dbHelper.database;
    return await db.insert('tracks', track.toMap());
  }

  Future<int> removeTrack(int id) async {
    final db = await _dbHelper.database;
    return await db.delete(
      'tracks',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<TrackDto>> searchTracks(String query) async {
    final db = await _dbHelper.database;
    final result = await db.query(
      'tracks',
      where: 'title LIKE ? OR artist LIKE ?',
      whereArgs: ['%$query%', '%$query%'],
      orderBy: 'title ASC',
    );

    return result.map((map) => TrackDto.fromMap(map)).toList();
  }

  Future<void> addToFavorites(int trackId) async {
    final db = await _dbHelper.database;
    await db.insert('favorites', {'track_id': trackId});
  }

  Future<void> removeFromFavorites(int trackId) async {
    final db = await _dbHelper.database;
    await db.delete(
      'favorites',
      where: 'track_id = ?',
      whereArgs: [trackId],
    );
  }

  Future<List<TrackDto>> getFavoriteTracks() async {
    final db = await _dbHelper.database;
    final result = await db.rawQuery('''
      SELECT t.* FROM tracks t
      INNER JOIN favorites f ON t.id = f.track_id
      ORDER BY f.added_at DESC
    ''');

    return result.map((map) => TrackDto.fromMap(map)).toList();
  }

  Future<bool> isTrackFavorite(int trackId) async {
    final db = await _dbHelper.database;
    final result = await db.query(
      'favorites',
      where: 'track_id = ?',
      whereArgs: [trackId],
    );
    return result.isNotEmpty;
  }

  Future<void> addToPlayHistory(int trackId, int playDuration) async {
    final db = await _dbHelper.database;
    await db.insert('play_history', {
      'track_id': trackId,
      'play_duration': playDuration,
    });
  }

  Future<List<Map<String, dynamic>>> getPlayHistory() async {
    final db = await _dbHelper.database;
    return await db.rawQuery('''
      SELECT ph.*, t.title, t.artist, t.duration, t.imageUrl
      FROM play_history ph
      INNER JOIN tracks t ON ph.track_id = t.id
      ORDER BY ph.played_at DESC
      LIMIT 50
    ''');
  }
}
