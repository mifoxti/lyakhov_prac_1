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
            imageUrl: 'https://i.pinimg.com/736x/8d/1b/3b/8d1b3b8e3c8e4a8d1b3b8e3c8e4a8d1.jpg',
          ),
          Podcast(
            id: 2,
            title: 'Mindfulness Moments',
            author: 'Wellness Studio',
            duration: '30:15',
            imageUrl: 'https://i.pinimg.com/736x/9e/2c/4d/9e2c4d8e2c4d9e2c4d8e2c4d9e2c4d8e.jpg',
          ),
          Podcast(
            id: 3,
            title: 'Business Insights',
            author: 'Entrepreneur Hub',
            duration: '52:20',
            imageUrl: 'https://i.pinimg.com/736x/7a/05/e2/7a05e28ac2cc660b976f03a70f84dba4.jpg',
          ),
          Podcast(
            id: 4,
            title: 'Science Simplified',
            author: 'Science Today',
            duration: '38:45',
            imageUrl: 'https://i.pinimg.com/736x/f9/63/6a/f9636a282f8d673219ddc29bdd742bd5.jpg',
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
