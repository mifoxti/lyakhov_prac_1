import '../models/track_dto.dart';

class InMemoryTrackDataSource {
  final List<TrackDto> _tracks = [];

  int _nextId = 1;

  Future<List<TrackDto>> getTracks() async {
    return List.from(_tracks);
  }

  Future<void> addTrack(TrackDto track) async {
    final newTrack = TrackDto(
      id: _nextId++,
      title: track.title,
      artist: track.artist,
      duration: track.duration,
      imageUrl: track.imageUrl,
    );
    _tracks.add(newTrack);
  }

  Future<void> updateTrack(int id, TrackDto track) async {
    final index = _tracks.indexWhere((t) => t.id == id);
    if (index != -1) {
      _tracks[index] = track;
    }
  }

  Future<void> removeTrack(int id) async {
    _tracks.removeWhere((t) => t.id == id);
  }
}
