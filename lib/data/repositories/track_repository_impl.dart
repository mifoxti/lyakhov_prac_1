import '../../../core/models/track.dart';
import '../../domain/repositories/track_repository.dart';
import '../datasources/track_local_data_source.dart';
import '../mappers/track_mapper.dart';

class TrackRepositoryImpl implements TrackRepository {
  final TrackLocalDataSource dataSource;

  TrackRepositoryImpl(this.dataSource);

  @override
  Future<List<Track>> getTracks() async {
    final dtos = await dataSource.getTracks();
    return dtos.map((dto) => TrackMapper.fromDto(dto)).toList();
  }

  @override
  Future<void> addTrack(Track track) async {
    final dto = TrackMapper.toDto(track);
    await dataSource.addTrack(dto);
  }

  @override
  Future<void> updateTrack(int id, Track track) async {
    final dto = TrackMapper.toDto(track);
    await dataSource.updateTrack(id, dto);
  }

  @override
  Future<void> removeTrack(int id) async {
    await dataSource.removeTrack(id);
  }
}
