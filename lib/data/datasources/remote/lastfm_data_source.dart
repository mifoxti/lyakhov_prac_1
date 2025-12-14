import 'package:dio/dio.dart';

import '../../models/track_dto.dart';
import 'lastfm_api.dart';
import 'deezer_data_source.dart';

class LastFmDataSource {
  final LastFmApi _api;
  final DeezerDataSource? _deezerDataSource;

  LastFmDataSource(Dio dio, {DeezerDataSource? deezerDataSource})
      : _api = LastFmApi(dio),
        _deezerDataSource = deezerDataSource;

  Future<List<TrackDto>> searchTracks(String query) async {
    try {
      final response = await _api.searchTracks(track: query);
      final data = response.data;

      // Last.fm API structure: data.results.trackmatches.track[]
      if (data['results'] != null &&
          data['results']['trackmatches'] != null &&
          data['results']['trackmatches']['track'] != null) {
        final tracksData = data['results']['trackmatches']['track'];
        final List<dynamic> rawTracks = tracksData is List ? tracksData : [tracksData];

        // Ограничиваем до 5 треков, как в Python коде
        final limitedTracks = rawTracks.take(5).toList();

        final List<TrackDto> results = [];
        for (var track in limitedTracks) {
          final name = track['name']?.toString() ?? '';
          final artist = track['artist']?.toString() ?? '';

          if (name.isEmpty || artist.isEmpty) continue;

          print('DEBUG: Processing track: $name by $artist');

          // Получаем полную информацию о треке для обложки (как в Python коде)
          final trackInfo = await _getTrackInfo(name, artist);
          results.add(
            TrackDto(
              title: name,
              artist: artist,
              duration: _parseDuration(track['duration']),
              imageUrl: trackInfo,
            ),
          );
        }
        return results;
      }
    } catch (e) {
      print('Error searching tracks: $e');
      // Return mock data for demo purposes
      return [
        TrackDto(
          title: 'Shape of You',
          artist: 'Ed Sheeran',
          duration: '3:53',
          imageUrl: '',
        ),
        TrackDto(
          title: 'Blinding Lights',
          artist: 'The Weeknd',
          duration: '3:20',
          imageUrl: '',
        ),
      ];
    }
    return [];
  }

  Future<String> _getTrackInfo(String trackName, String artistName) async {
    try {
      final response = await _api.getTrackInfo(track: trackName, artist: artistName);
      final data = response.data;

      if (data['track'] != null) {
        final track = data['track'];
        final album = track['album'];
        if (album != null && album['image'] != null) {
          final images = album['image'];
          if (images is List) {
            // Ищем самый крупный размер (extralarge или mega), но не слишком большой
            for (var image in images.reversed) {
              if (image is Map) {
                final size = image['size']?.toString();
                final url = image['#text']?.toString();

                // Prefer 'large' or 'extralarge' size (not 'mega' which can be too big)
                if ((size == 'large' || size == 'extralarge') && url != null && url.isNotEmpty) {
                  // Check if it's not a placeholder
                  if (!url.contains('2a96cbd8b46e442fc41c2b86b821562f')) {
                    print('DEBUG: Found Last.fm image ($size): $url');
                    return url;
                  }
                }
              }
            }

            // If no large/extralarge, try any size except placeholders
            for (var image in images.reversed) {
              if (image is Map) {
                final url = image['#text']?.toString();
                if (url != null && url.isNotEmpty && !url.contains('2a96cbd8b46e442fc41c2b86b821562f')) {
                  print('DEBUG: Found Last.fm image (any size): $url');
                  return url;
                }
              }
            }
          }
        }
      }
    } catch (e) {
      print('Error getting track info for $trackName by $artistName: $e');
    }

    // If Last.fm didn't provide a valid image, try Deezer
    if (_deezerDataSource != null) {
      print('DEBUG: Trying Deezer for $trackName by $artistName');
      final deezerCover = await _deezerDataSource!.getTrackCoverUrl(trackName, artistName);
      if (deezerCover != null && deezerCover.isNotEmpty) {
        return deezerCover;
      }
    }

    print('DEBUG: No image found for $trackName by $artistName');
    return '';
  }

  Future<List<TrackDto>> getPopularTracks() async {
    try {
      final response = await _api.getTopTracks();
      final data = response.data;

      if (data['tracks'] != null && data['tracks']['track'] != null) {
        final tracksData = data['tracks']['track'];
        if (tracksData is List) {
          final List<TrackDto> tracks = [];
          for (var track in tracksData) {
            final title = track['name']?.toString() ?? '';
            final artist = track['artist']?['name']?.toString() ?? '';
            final imageUrl = await _getImageUrlWithFallback(track['image'], title, artist);

            tracks.add(TrackDto(
              title: title,
              artist: artist,
              duration: _parseDuration(track['duration']),
              imageUrl: imageUrl,
            ));
          }
          return tracks;
        }
      }
    } catch (e) {
      print('Error getting popular tracks: $e');
    }
    // Return mock popular tracks
    return [
      TrackDto(
        title: 'Levitating',
        artist: 'Dua Lipa',
        duration: '3:23',
        imageUrl: '',
      ),
      TrackDto(
        title: 'Good 4 U',
        artist: 'Olivia Rodrigo',
        duration: '2:58',
        imageUrl: '',
      ),
      TrackDto(
        title: 'Stay',
        artist: 'The Kid Laroi & Justin Bieber',
        duration: '2:21',
        imageUrl: '',
      ),
    ];
  }

  Future<List<TrackDto>> getTracksByArtist(String artist) async {
    try {
      final response = await _api.searchTracksByArtist(artist: artist);
      final data = response.data;

      if (data['toptracks'] != null && data['toptracks']['track'] != null) {
        final tracks = data['toptracks']['track'] as List?;
        if (tracks != null) {
          final List<TrackDto> results = [];
          for (var track in tracks) {
            final title = track['name'] ?? '';
            final imageUrl = await _getImageUrlWithFallback(track['image'], title, artist);

            results.add(TrackDto(
              title: title,
              artist: artist,
              duration: _parseDuration(track['duration']),
              imageUrl: imageUrl,
            ));
          }
          return results;
        }
      }
    } catch (e) {
      print('Error getting tracks by artist $artist: $e');
      // Return mock tracks for demo purposes if API fails
      return [
        TrackDto(
          title: 'Popular Track 1',
          artist: artist,
          duration: '3:30',
          imageUrl: '',
        ),
        TrackDto(
          title: 'Popular Track 2',
          artist: artist,
          duration: '4:15',
          imageUrl: '',
        ),
      ];
    }
    return [];
  }

  Future<List<TrackDto>> getTracksByTag(String tag) async {
    try {
      final response = await _api.getTracksByTag(tag: tag);
      final data = response.data;

      if (data['tracks'] != null && data['tracks']['track'] != null) {
        final tracks = data['tracks']['track'] as List?;
        if (tracks != null) {
          final List<TrackDto> results = [];
          for (var track in tracks) {
            final title = track['name'] ?? '';
            final artist = track['artist']?['name'] ?? '';
            final imageUrl = await _getImageUrlWithFallback(track['image'], title, artist);

            results.add(TrackDto(
              title: title,
              artist: artist,
              duration: _parseDuration(track['duration']),
              imageUrl: imageUrl,
            ));
          }
          return results;
        }
      }
    } catch (e) {
      print('Error getting tracks by tag $tag: $e');
      // Return mock tracks for demo purposes if API fails
      return [
        TrackDto(
          title: 'Track with $tag tag 1',
          artist: 'Various Artists',
          duration: '3:30',
          imageUrl: '',
        ),
        TrackDto(
          title: 'Track with $tag tag 2',
          artist: 'Various Artists',
          duration: '4:15',
          imageUrl: '',
        ),
      ];
    }
    return [];
  }

  Future<TrackDto?> getTrackInfo(String artist, String track) async {
    try {
      final response = await _api.getTrackInfo(artist: artist, track: track);
      final data = response.data;

      if (data['track'] != null) {
        final trackData = data['track'];
        final title = trackData['name'] ?? '';
        final artistName = trackData['artist']?['name'] ?? '';
        final imageUrl = await _getImageUrlWithFallback(trackData['album']?['image'], title, artistName);

        return TrackDto(
          title: title,
          artist: artistName,
          duration: _parseDuration(trackData['duration']),
          imageUrl: imageUrl,
        );
      }
    } catch (e) {
      print('Error getting track info for $track by $artist: $e');
    }
    return null;
  }

  String _extractImageUrl(dynamic images) {
    print('DEBUG: Extracting image URL from: $images');
    if (images is List && images.isNotEmpty) {
      // Prefer 'large' or 'extralarge' size (not too big, not too small)
      for (var image in images.reversed) {
        print('DEBUG: Processing image: $image');
        if (image is Map) {
          final size = image['size']?.toString();
          final url = image['#text']?.toString() ?? image['url']?.toString() ?? '';
          print('DEBUG: Extracted URL (size: $size): $url');

          // Prefer medium to large sizes
          if ((size == 'large' || size == 'extralarge' || size == 'medium') &&
              url.isNotEmpty &&
              url.startsWith('http')) {
            // Check if it's not a placeholder image
            if (!url.contains('2a96cbd8b46e442fc41c2b86b821562f')) {
              print('DEBUG: Valid image URL found ($size): $url');
              return url;
            }
          }
        }
      }

      // If no preferred size found, try any non-placeholder image
      for (var image in images.reversed) {
        if (image is Map) {
          final url = image['#text']?.toString() ?? image['url']?.toString() ?? '';
          if (url.isNotEmpty && url.startsWith('http') && !url.contains('2a96cbd8b46e442fc41c2b86b821562f')) {
            print('DEBUG: Valid image URL found (any size): $url');
            return url;
          }
        }
      }
    }
    print('DEBUG: No valid image URL found');
    return '';
  }

  /// Gets image URL with automatic fallback to Deezer if Last.fm returns placeholder
  Future<String> _getImageUrlWithFallback(dynamic images, String trackName, String artistName) async {
    final lastFmUrl = _extractImageUrl(images);

    // If Last.fm provided a valid image, use it
    if (lastFmUrl.isNotEmpty) {
      return lastFmUrl;
    }

    // Otherwise, try Deezer as fallback
    if (_deezerDataSource != null) {
      print('DEBUG: No valid Last.fm image, trying Deezer for "$trackName" by "$artistName"');
      final deezerCover = await _deezerDataSource!.getTrackCoverUrl(trackName, artistName);
      if (deezerCover != null && deezerCover.isNotEmpty) {
        return deezerCover;
      }
    }

    return '';
  }

  String _parseDuration(dynamic duration) {
    if (duration is int) {
      // Duration в миллисекундах - конвертируем в минуты:секунды
      final totalSeconds = duration ~/ 1000;
      final minutes = totalSeconds ~/ 60;
      final seconds = totalSeconds % 60;
      return '$minutes:${seconds.toString().padLeft(2, '0')}';
    } else if (duration is String) {
      // Если duration уже строка, возвращаем как есть
      final trimmed = duration.trim();
      if (trimmed.isNotEmpty && trimmed.contains(':')) {
        return trimmed;
      }
      // Если строка содержит число (возможно, секунды или миллисекунды)
      final parsed = int.tryParse(trimmed);
      if (parsed != null) {
        final totalSeconds = parsed > 1000 ? parsed ~/ 1000 : parsed;
        final minutes = totalSeconds ~/ 60;
        final seconds = totalSeconds % 60;
        return '$minutes:${seconds.toString().padLeft(2, '0')}';
      }
    }
    return '0:00';
  }
}
