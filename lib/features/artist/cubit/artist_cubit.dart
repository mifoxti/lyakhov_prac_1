import 'package:flutter_bloc/flutter_bloc.dart';

class Album {
  final int id;
  final String title;
  final String year;
  final String coverUrl;

  Album({
    required this.id,
    required this.title,
    required this.year,
    required this.coverUrl,
  });
}

class PopularTrack {
  final int id;
  final String title;
  final String duration;
  final int plays;

  PopularTrack({
    required this.id,
    required this.title,
    required this.duration,
    required this.plays,
  });
}

class ArtistInfo {
  final String name;
  final String genre;
  final String bio;
  final String imageUrl;
  final int monthlyListeners;
  final int followersCount;
  final List<Album> albums;
  final List<PopularTrack> popularTracks;

  ArtistInfo({
    required this.name,
    required this.genre,
    required this.bio,
    required this.imageUrl,
    required this.monthlyListeners,
    required this.followersCount,
    required this.albums,
    required this.popularTracks,
  });
}

class ArtistState {
  final ArtistInfo? artist;
  final bool isLoading;
  final bool isFollowing;

  const ArtistState({
    this.artist,
    this.isLoading = false,
    this.isFollowing = false,
  });

  ArtistState copyWith({
    ArtistInfo? artist,
    bool? isLoading,
    bool? isFollowing,
  }) {
    return ArtistState(
      artist: artist ?? this.artist,
      isLoading: isLoading ?? this.isLoading,
      isFollowing: isFollowing ?? this.isFollowing,
    );
  }
}

class ArtistCubit extends Cubit<ArtistState> {
  ArtistCubit(String artistName) : super(const ArtistState()) {
    loadArtist(artistName);
  }

  void loadArtist(String artistName) {
    emit(state.copyWith(isLoading: true));

    // Заглушка: генерация данных на основе имени артиста
    final artist = _generateArtistData(artistName);

    emit(ArtistState(
      artist: artist,
      isLoading: false,
      isFollowing: false,
    ));
  }

  ArtistInfo _generateArtistData(String artistName) {
    // Словарь с данными для известных артистов
    final artistsData = {
      'Ed Sheeran': {
        'genre': 'Поп, Фолк',
        'bio': 'Британский певец и автор песен, один из самых успешных артистов современности. Известен своими хитами "Shape of You", "Perfect" и "Thinking Out Loud".',
        'imageUrl': 'https://avatars.yandex.net/get-music-content/2419084/4d89e00c.a.11519267-1/m1000x1000',
        'monthlyListeners': 85400000,
        'albums': [
          {'title': '÷ (Divide)', 'year': '2017'},
          {'title': '= (Equals)', 'year': '2021'},
          {'title': 'x (Multiply)', 'year': '2014'},
        ],
        'popularTracks': [
          {'title': 'Shape of You', 'duration': '3:53', 'plays': 3500000000},
          {'title': 'Perfect', 'duration': '4:23', 'plays': 2800000000},
          {'title': 'Thinking Out Loud', 'duration': '4:41', 'plays': 2400000000},
        ],
      },
      'The Weeknd': {
        'genre': 'R&B, Поп',
        'bio': 'Канадский певец, автор песен и продюсер. Известен своим уникальным голосом и хитами "Blinding Lights", "Starboy" и "Can\'t Feel My Face".',
        'imageUrl': 'https://avatars.yandex.net/get-music-content/5233787/9f9f1f7e.a.20445576-1/m1000x1000',
        'monthlyListeners': 98700000,
        'albums': [
          {'title': 'After Hours', 'year': '2020'},
          {'title': 'Starboy', 'year': '2016'},
          {'title': 'Beauty Behind the Madness', 'year': '2015'},
        ],
        'popularTracks': [
          {'title': 'Blinding Lights', 'duration': '3:22', 'plays': 4200000000},
          {'title': 'Starboy', 'duration': '3:50', 'plays': 3100000000},
          {'title': 'The Hills', 'duration': '4:02', 'plays': 2600000000},
        ],
      },
      'Andrea Bocelli': {
        'genre': 'Классика, Опера',
        'bio': 'Итальянский оперный тенор и певец-кроссовер. Один из самых известных и уважаемых исполнителей классической музыки в мире.',
        'imageUrl': 'https://avatars.yandex.net/get-music-content/4413073/5e9f8d3a.a.17754328-1/m1000x1000',
        'monthlyListeners': 12500000,
        'albums': [
          {'title': 'Sì', 'year': '2018'},
          {'title': 'Cinema', 'year': '2015'},
          {'title': 'Passione', 'year': '2013'},
        ],
        'popularTracks': [
          {'title': 'Time to Say Goodbye', 'duration': '4:06', 'plays': 850000000},
          {'title': 'Con te partirò', 'duration': '4:12', 'plays': 620000000},
          {'title': 'Vivo per lei', 'duration': '4:28', 'plays': 450000000},
        ],
      },
    };

    final data = artistsData[artistName];

    if (data != null) {
      return ArtistInfo(
        name: artistName,
        genre: data['genre'] as String,
        bio: data['bio'] as String,
        imageUrl: data['imageUrl'] as String,
        monthlyListeners: data['monthlyListeners'] as int,
        followersCount: (data['monthlyListeners'] as int) ~/ 2,
        albums: (data['albums'] as List).asMap().entries.map((entry) {
          final album = entry.value as Map<String, String>;
          return Album(
            id: entry.key + 1,
            title: album['title']!,
            year: album['year']!,
            coverUrl: 'https://avatars.yandex.net/get-music-content/${2000000 + entry.key * 100000}/cover.a.${entry.key + 1}/m1000x1000',
          );
        }).toList(),
        popularTracks: (data['popularTracks'] as List).asMap().entries.map((entry) {
          final track = entry.value as Map<String, dynamic>;
          return PopularTrack(
            id: entry.key + 1,
            title: track['title'] as String,
            duration: track['duration'] as String,
            plays: track['plays'] as int,
          );
        }).toList(),
      );
    }

    // Данные по умолчанию для неизвестных артистов
    return ArtistInfo(
      name: artistName,
      genre: 'Поп, Рок',
      bio: 'Популярный исполнитель с уникальным стилем и множеством поклонников по всему миру. Их музыка вдохновляет миллионы людей.',
      imageUrl: 'https://avatars.yandex.net/get-music-content/2419084/default-artist/m1000x1000',
      monthlyListeners: 5000000,
      followersCount: 2500000,
      albums: [
        Album(id: 1, title: 'Greatest Hits', year: '2022', coverUrl: 'https://avatars.yandex.net/get-music-content/2000000/cover.a.1/m1000x1000'),
        Album(id: 2, title: 'Latest Album', year: '2023', coverUrl: 'https://avatars.yandex.net/get-music-content/2100000/cover.a.2/m1000x1000'),
      ],
      popularTracks: [
        PopularTrack(id: 1, title: 'Hit Song #1', duration: '3:45', plays: 50000000),
        PopularTrack(id: 2, title: 'Popular Track', duration: '4:12', plays: 35000000),
        PopularTrack(id: 3, title: 'Fan Favorite', duration: '3:28', plays: 28000000),
      ],
    );
  }

  void toggleFollow() {
    emit(state.copyWith(isFollowing: !state.isFollowing));
  }

  String _formatNumber(int number) {
    if (number >= 1000000000) {
      return '${(number / 1000000000).toStringAsFixed(1)}B';
    } else if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    }
    return number.toString();
  }

  String getFormattedListeners() {
    if (state.artist == null) return '0';
    return _formatNumber(state.artist!.monthlyListeners);
  }

  String getFormattedFollowers() {
    if (state.artist == null) return '0';
    return _formatNumber(state.artist!.followersCount);
  }
}
