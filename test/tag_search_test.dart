import 'package:flutter_test/flutter_test.dart';
import 'package:lyakhov_prac_1/cubit/service_locator.dart';
import 'package:lyakhov_prac_1/features/online_search/cubit/online_search_cubit.dart';

void main() {
  setUp(() async {
    setupLocator();
  });

  test('Tag search works', () async {
    final useCase = locator<GetTracksByTagUseCase>();

    // Test with a popular tag
    final tracks = await useCase.call('rock');

    expect(tracks, isNotNull);
    expect(tracks, isA<List>());

    if (tracks.isNotEmpty) {
      print('Found ${tracks.length} tracks for tag "rock":');
      for (var track in tracks.take(3)) {
        print('- ${track.title} by ${track.artist}');
      }
    } else {
      print('No tracks found for tag "rock"');
    }
  });

  test('Tag search with different tags', () async {
    final useCase = locator<GetTracksByTagUseCase>();
    final tags = ['pop', 'electronic', 'jazz'];

    for (var tag in tags) {
      final tracks = await useCase.call(tag);
      print('Tag "$tag": found ${tracks.length} tracks');

      if (tracks.isNotEmpty) {
        print('  Sample: ${tracks.first.title} by ${tracks.first.artist}');
      }
    }
  });

  test('Cubit handles # symbol for tag search', () async {
    final cubit = OnlineSearchCubit();

    // Test tag search with # symbol
    await cubit.searchTracks('#rock');

    // Wait for search to complete
    await Future.delayed(const Duration(seconds: 2));

    final state = cubit.state;
    expect(state.isTagSearch, isTrue);
    expect(state.tracks, isNotEmpty);

    print('Tag search with #rock found ${state.tracks.length} tracks');

    // Test regular search
    await cubit.searchTracks('shape of you');

    // Wait for search to complete
    await Future.delayed(const Duration(seconds: 2));

    final newState = cubit.state;
    expect(newState.isTagSearch, isFalse);
    print('Regular search found ${newState.tracks.length} tracks');
  });

  test('GetTrackInfo usecase works', () async {
    final useCase = locator<GetTrackInfoUseCase>();

    // Test with a known track
    final track = await useCase.call('The Beatles', 'Hey Jude');

    expect(track, isNotNull);
    if (track != null) {
      expect(track.title, isNotEmpty);
      expect(track.artist, isNotEmpty);
      expect(track.duration, isNotEmpty);
      print('Found track: ${track.title} by ${track.artist} - ${track.duration}');
    }
  });
}
