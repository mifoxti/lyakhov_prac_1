import 'package:dio/dio.dart';

import '../../models/artist_dto.dart';
import 'deezer_api.dart';

class DeezerDataSource {
  final DeezerApi _api;

  DeezerDataSource(Dio dio) : _api = DeezerApi(dio);

  Future<List<ArtistDto>> searchArtists(String query) async {
    try {
      // Check if query contains country prefix
      if (query.toLowerCase().startsWith('country:')) {
        final country = query.substring(8).trim(); // Remove "country:" prefix
        print('DEBUG: Searching artists by country: $country');
        return await getArtistsByCountry(country);
      }

      // Check if query contains genre prefix
      if (query.toLowerCase().startsWith('genre:')) {
        final genreName = query.substring(6).trim(); // Remove "genre:" prefix
        print('DEBUG: Searching artists by genre: $genreName');
        final genreId = _getGenreIdByName(genreName);
        if (genreId != null) {
          return await getArtistsByGenre(genreId);
        } else {
          print('DEBUG: Unknown genre: $genreName');
          return [];
        }
      }

      // Regular artist search
      final response = await _api.searchArtists(query: query);
      final data = response.data;

      if (data['data'] != null) {
        final artists = data['data'] as List?;
        if (artists != null) {
          return artists.map((artist) {
            return ArtistDto(
              name: artist['name'] ?? '',
              imageUrl: _extractImageUrl(artist['picture_medium']),
              genre: artist['type'] ?? 'artist',
              listeners: artist['nb_fan'] ?? 0,
            );
          }).toList();
        }
      }
    } catch (e) {
      print('Error searching artists: $e');
    }
    return [];
  }

  Future<List<ArtistDto>> getTopArtists() async {
    final response = await _api.getTopArtists();
    final data = response.data;

    if (data['data'] != null) {
      final artists = data['data'] as List?;
      if (artists != null) {
        return artists.map((artist) {
          return ArtistDto(
            name: artist['name'] ?? '',
            imageUrl: _extractImageUrl(artist['picture_medium']),
            genre: artist['type'] ?? 'artist',
            listeners: artist['nb_fan'] ?? 0,
          );
        }).toList();
      }
    }
    return [];
  }

  Future<List<ArtistDto>> getArtistsByCountry(String country) async {
    // Используем специальный формат запроса для поиска по стране
    final response = await _api.searchArtists(query: country, limit: 50);
    final data = response.data;

    if (data['data'] != null) {
      final artists = data['data'] as List?;
      if (artists != null) {
        return artists.map((artist) {
          return ArtistDto(
            name: artist['name'] ?? '',
            imageUrl: _extractImageUrl(artist['picture_medium']),
            genre: artist['type'] ?? 'artist',
            listeners: artist['nb_fan'] ?? 0,
          );
        }).toList();
      }
    }
    return [];
  }

  Future<List<ArtistDto>> getArtistsByGenre(int genreId) async {
    final response = await _api.getArtistsByGenre(genreId: genreId);
    final data = response.data;

    if (data['data'] != null) {
      final artists = data['data'] as List?;
      if (artists != null) {
        return artists.map((artist) {
          return ArtistDto(
            name: artist['name'] ?? '',
            imageUrl: _extractImageUrl(artist['picture_medium']),
            genre: _getGenreName(genreId),
            listeners: artist['nb_fan'] ?? 0,
          );
        }).toList();
      }
    }
    return [];
  }

  Future<List<Map<String, dynamic>>> getArtistTopTracks(int artistId) async {
    try {
      print('DEBUG: Fetching top tracks for artist ID $artistId');
      final response = await _api.getArtistTopTracks(artistId: artistId);
      final data = response.data;

      print('DEBUG: Top tracks response status: ${response.response.statusCode}');

      if (data['data'] != null) {
        final tracks = data['data'] as List?;
        print('DEBUG: Found ${tracks?.length ?? 0} top tracks');

        if (tracks != null && tracks.isNotEmpty) {
          return tracks.map((track) {
            return {
              'id': track['id'],
              'title': track['title'] ?? '',
              'artist': track['artist']?['name'] ?? '',
              'duration': _parseDuration(track['duration']),
              'imageUrl': _extractImageUrl(track['album']?['cover_medium']),
            };
          }).toList();
        }
      } else {
        print('DEBUG: No top tracks data in response');
      }
    } catch (e, stackTrace) {
      print('Error getting top tracks for artist ID $artistId: $e');
      print('Stack trace: $stackTrace');
    }
    return [];
  }

  Future<List<Map<String, dynamic>>> getTopTracksByArtistName(String artistName) async {
    try {
      print('DEBUG: Searching for artist "$artistName"...');

      // First, search for the artist to get their ID
      final artistResponse = await _api.searchArtists(query: artistName, limit: 5);
      final artistData = artistResponse.data;

      print('DEBUG: Artist search response status: ${artistResponse.response.statusCode}');
      print('DEBUG: Artist search response data: $artistData');

      if (artistData['data'] != null) {
        final artists = artistData['data'] as List?;
        print('DEBUG: Found ${artists?.length ?? 0} artists');

        if (artists != null && artists.isNotEmpty) {
          // Try to find exact match first, otherwise use first result
          var selectedArtist = artists[0];

          for (var artist in artists) {
            final name = artist['name']?.toString().toLowerCase() ?? '';
            if (name == artistName.toLowerCase()) {
              selectedArtist = artist;
              print('DEBUG: Found exact match for "$artistName"');
              break;
            }
          }

          final artistId = selectedArtist['id'] as int;
          final foundName = selectedArtist['name'] as String;
          print('DEBUG: Using artist "$foundName" (ID: $artistId) for query "$artistName"');

          // Now get their top tracks
          final topTracks = await getArtistTopTracks(artistId);
          print('DEBUG: Found ${topTracks.length} top tracks for artist "$foundName"');
          return topTracks;
        } else {
          print('DEBUG: No artists found in search results');
        }
      } else {
        print('DEBUG: Response data["data"] is null');
      }
      print('DEBUG: Artist "$artistName" not found');
    } catch (e, stackTrace) {
      print('Error getting top tracks for artist "$artistName": $e');
      print('Stack trace: $stackTrace');
    }
    return [];
  }

  String _extractImageUrl(dynamic imageUrl) {
    return imageUrl?.toString() ?? '';
  }

  String _parseDuration(dynamic duration) {
    if (duration is int) {
      // Duration в секундах - конвертируем в минуты:секунды
      final minutes = duration ~/ 60;
      final seconds = duration % 60;
      return '$minutes:${seconds.toString().padLeft(2, '0')}';
    } else if (duration is String) {
      // Если duration уже строка, возвращаем как есть
      final trimmed = duration.trim();
      if (trimmed.isNotEmpty && trimmed.contains(':')) {
        return trimmed;
      }
      // Если строка содержит число (секунды)
      final parsed = int.tryParse(trimmed);
      if (parsed != null) {
        final minutes = parsed ~/ 60;
        final seconds = parsed % 60;
        return '$minutes:${seconds.toString().padLeft(2, '0')}';
      }
    }
    return '0:00';
  }

  String _getGenreName(int genreId) {
    // Map genre IDs to names (simplified)
    final genres = {
      0: 'All',
      132: 'Pop',
      116: 'Rap/Hip Hop',
      152: 'Rock',
      113: 'Dance',
      165: 'R&B',
      85: 'Alternative',
      106: 'Electro',
      466: 'Folk',
      144: 'Reggae',
      129: 'Jazz',
      52: 'Classical',
    };
    return genres[genreId] ?? 'Unknown';
  }

  int? _getGenreIdByName(String genreName) {
    // Map genre names to IDs (case-insensitive)
    final genres = {
      'all': 0,
      'pop': 132,
      'rap': 116,
      'hip hop': 116,
      'rap/hip hop': 116,
      'hiphop': 116,
      'rock': 152,
      'dance': 113,
      'r&b': 165,
      'rnb': 165,
      'alternative': 85,
      'electro': 106,
      'electronic': 106,
      'folk': 466,
      'reggae': 144,
      'jazz': 129,
      'classical': 52,
    };
    return genres[genreName.toLowerCase()];
  }

  Future<String?> getTrackCoverUrl(String trackName, String artistName) async {
    try {
      final query = '$artistName $trackName';
      final response = await _api.searchTracks(query: query, limit: 3);
      final data = response.data;

      if (data['data'] != null) {
        final tracks = data['data'] as List?;
        if (tracks != null && tracks.isNotEmpty) {
          // Try to find exact or close match
          for (var track in tracks) {
            final title = track['title']?.toString().toLowerCase() ?? '';
            final artist = track['artist']?['name']?.toString().toLowerCase() ?? '';

            // Check if track and artist match (fuzzy matching)
            if (title.contains(trackName.toLowerCase()) || trackName.toLowerCase().contains(title)) {
              if (artist.contains(artistName.toLowerCase()) || artistName.toLowerCase().contains(artist)) {
                final coverUrl = track['album']?['cover_medium']?.toString() ?? '';
                if (coverUrl.isNotEmpty) {
                  print('DEBUG: Found Deezer cover for "$trackName" by "$artistName": $coverUrl');
                  return coverUrl;
                }
              }
            }
          }

          // If no exact match, use first result
          final firstTrack = tracks.first;
          final coverUrl = firstTrack['album']?['cover_medium']?.toString() ?? '';
          if (coverUrl.isNotEmpty) {
            print('DEBUG: Using first Deezer result cover: $coverUrl');
            return coverUrl;
          }
        }
      }
    } catch (e) {
      print('Error getting track cover from Deezer: $e');
    }
    return null;
  }
}
