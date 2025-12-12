import 'package:flutter_bloc/flutter_bloc.dart';

class Podcast {
  final int id;
  final String title;
  final String author;
  final String duration;
  final String imageUrl;

  Podcast({
    required this.id,
    required this.title,
    required this.author,
    required this.duration,
    this.imageUrl = '',
  });

  Podcast copyWith({
    int? id,
    String? title,
    String? author,
    String? duration,
    String? imageUrl,
  }) {
    return Podcast(
      id: id ?? this.id,
      title: title ?? this.title,
      author: author ?? this.author,
      duration: duration ?? this.duration,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}

class PodcastState {
  final List<Podcast> podcasts;
  final bool isLoading;

  const PodcastState({
    this.podcasts = const [],
    this.isLoading = false,
  });

  PodcastState copyWith({
    List<Podcast>? podcasts,
    bool? isLoading,
  }) {
    return PodcastState(
      podcasts: podcasts ?? this.podcasts,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  int get podcastCount => podcasts.length;
}

class PodcastsCubit extends Cubit<PodcastState> {
  PodcastsCubit() : super(const PodcastState()) {
    _loadInitialPodcasts();
  }

  void _loadInitialPodcasts() {
    emit(
      PodcastState(
        podcasts: [
          Podcast(
            id: 1,
            title: 'Tech Talks Daily',
            author: 'Tech Podcast Network',
            duration: '45:30',
            imageUrl: 'https://i.pinimg.com/736x/d4/93/70/d49370dcf687eca6ef3af1fe69a2982f.jpg',
          ),
          Podcast(
            id: 2,
            title: 'Mindfulness Moments',
            author: 'Wellness Studio',
            duration: '30:15',
            imageUrl: 'https://i.pinimg.com/1200x/f1/16/4b/f1164beca80ea6925ae5448f9a21262c.jpg',
          ),
          Podcast(
            id: 3,
            title: 'Business Insights',
            author: 'Entrepreneur Hub',
            duration: '52:20',
            imageUrl: 'https://i.pinimg.com/736x/a7/cf/e0/a7cfe02be1dcf6b8f4ee71e08258eedd.jpg',
          ),
          Podcast(
            id: 4,
            title: 'Science Simplified',
            author: 'Science Today',
            duration: '38:45',
            imageUrl: 'https://i.pinimg.com/736x/1f/46/2b/1f462b1ece3b93d501b592401558748d.jpg',
          ),
        ],
      ),
    );
  }

  int _nextId = 5;

  void addPodcast(String title, String author, String duration) {
    final newPodcast = Podcast(
      id: _nextId++,
      title: title,
      author: author,
      duration: duration,
    );
    emit(state.copyWith(podcasts: List.of(state.podcasts)..add(newPodcast)));
  }

  void updatePodcast(int index, Podcast updatedPodcast) {
    final updated = List.of(state.podcasts);
    updated[index] = updatedPodcast;
    emit(state.copyWith(podcasts: updated));
  }

  void removePodcast(int index) {
    final updated = List.of(state.podcasts);
    updated.removeAt(index);
    emit(state.copyWith(podcasts: updated));
  }
}
