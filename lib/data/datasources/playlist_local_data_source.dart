import '../models/playlist_dto.dart';
import 'database_helper.dart';

class PlaylistLocalDataSource {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Future<List<PlaylistDto>> getPlaylists() async {
    final db = await _dbHelper.database;
    final result = await db.query('playlists', orderBy: 'name ASC');

    List<PlaylistDto> playlists = [];
    for (var playlistMap in result) {
      final playlistId = playlistMap['id'] as int;
      final tracks = await _getPlaylistTracks(playlistId);
      final settings = await _getPlaylistSettings(playlistId);

      playlists.add(PlaylistDto.fromMap(playlistMap, tracks, settings));
    }

    return playlists;
  }

  Future<PlaylistDto?> getPlaylistById(int id) async {
    final db = await _dbHelper.database;
    final result = await db.query(
      'playlists',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (result.isNotEmpty) {
      final playlistMap = result.first;
      final tracks = await _getPlaylistTracks(id);
      final settings = await _getPlaylistSettings(id);

      return PlaylistDto.fromMap(playlistMap, tracks, settings);
    }
    return null;
  }

  Future<int> createPlaylist(PlaylistDto playlist) async {
    final db = await _dbHelper.database;

    // Начинаем транзакцию
    return await db.transaction((txn) async {
      // Вставляем плейлист
      final playlistId = await txn.insert('playlists', {
        'name': playlist.name,
        'description': playlist.description,
      });

      // Добавляем треки в плейлист
      for (int i = 0; i < playlist.tracks.length; i++) {
        await txn.insert('playlist_tracks', {
          'playlist_id': playlistId,
          'track_id': playlist.tracks[i].id,
          'position': i,
        });
      }

      // Создаем настройки плейлиста
      await txn.insert('playlist_settings', {
        'playlist_id': playlistId,
        'is_public': playlist.isPublic ? 1 : 0,
        'allow_collaboration': playlist.allowCollaboration ? 1 : 0,
      });

      return playlistId;
    });
  }

  Future<int> updatePlaylist(int id, PlaylistDto playlist) async {
    final db = await _dbHelper.database;

    return await db.transaction((txn) async {
      // Обновляем информацию о плейлисте
      final updated = await txn.update(
        'playlists',
        {
          'name': playlist.name,
          'description': playlist.description,
        },
        where: 'id = ?',
        whereArgs: [id],
      );

      if (updated > 0) {
        // Удаляем старые связи с треками
        await txn.delete(
          'playlist_tracks',
          where: 'playlist_id = ?',
          whereArgs: [id],
        );

        // Добавляем новые связи с треками
        for (int i = 0; i < playlist.tracks.length; i++) {
          await txn.insert('playlist_tracks', {
            'playlist_id': id,
            'track_id': playlist.tracks[i].id,
            'position': i,
          });
        }

        // Обновляем настройки плейлиста
        await txn.update(
          'playlist_settings',
          {
            'is_public': playlist.isPublic ? 1 : 0,
            'allow_collaboration': playlist.allowCollaboration ? 1 : 0,
          },
          where: 'playlist_id = ?',
          whereArgs: [id],
        );
      }

      return updated;
    });
  }

  Future<int> deletePlaylist(int id) async {
    final db = await _dbHelper.database;
    // Связи удалятся автоматически благодаря CASCADE
    return await db.delete(
      'playlists',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> addTrackToPlaylist(int playlistId, int trackId) async {
    final db = await _dbHelper.database;

    // Получаем максимальную позицию для этого плейлиста
    final result = await db.query(
      'playlist_tracks',
      where: 'playlist_id = ?',
      whereArgs: [playlistId],
      orderBy: 'position DESC',
      limit: 1,
    );

    int position = 0;
    if (result.isNotEmpty) {
      position = (result.first['position'] as int) + 1;
    }

    await db.insert('playlist_tracks', {
      'playlist_id': playlistId,
      'track_id': trackId,
      'position': position,
    });
  }

  Future<void> removeTrackFromPlaylist(int playlistId, int trackId) async {
    final db = await _dbHelper.database;
    await db.delete(
      'playlist_tracks',
      where: 'playlist_id = ? AND track_id = ?',
      whereArgs: [playlistId, trackId],
    );
  }

  Future<void> reorderPlaylistTracks(int playlistId, List<int> trackIds) async {
    final db = await _dbHelper.database;

    await db.transaction((txn) async {
      // Удаляем все старые связи
      await txn.delete(
        'playlist_tracks',
        where: 'playlist_id = ?',
        whereArgs: [playlistId],
      );

      // Добавляем новые связи с правильными позициями
      for (int i = 0; i < trackIds.length; i++) {
        await txn.insert('playlist_tracks', {
          'playlist_id': playlistId,
          'track_id': trackIds[i],
          'position': i,
        });
      }
    });
  }

  Future<List<Map<String, dynamic>>> _getPlaylistTracks(int playlistId) async {
    final db = await _dbHelper.database;
    return await db.rawQuery('''
      SELECT t.*, pt.position
      FROM tracks t
      INNER JOIN playlist_tracks pt ON t.id = pt.track_id
      WHERE pt.playlist_id = ?
      ORDER BY pt.position ASC
    ''', [playlistId]);
  }

  Future<Map<String, dynamic>?> _getPlaylistSettings(int playlistId) async {
    final db = await _dbHelper.database;
    final result = await db.query(
      'playlist_settings',
      where: 'playlist_id = ?',
      whereArgs: [playlistId],
    );

    if (result.isNotEmpty) {
      return result.first;
    }
    return null;
  }
}
