import '../models/podcast_dto.dart';

class InMemoryPodcastDataSource {
  final List<PodcastDto> _podcasts = [
    PodcastDto(
      id: 1,
      title: 'Tech Talks Daily',
      author: 'Tech Podcast Network',
      duration: '45:30',
      imageUrl: 'https://i.pinimg.com/736x/d4/93/70/d49370dcf687eca6ef3af1fe69a2982f.jpg',
    ),
    PodcastDto(
      id: 2,
      title: 'Mindfulness Moments',
      author: 'Wellness Studio',
      duration: '30:15',
      imageUrl: 'https://i.pinimg.com/1200x/f1/16/4b/f1164beca80ea6925ae5448f9a21262c.jpg',
    ),
    PodcastDto(
      id: 3,
      title: 'Business Insights',
      author: 'Entrepreneur Hub',
      duration: '52:20',
      imageUrl: 'https://i.pinimg.com/736x/a7/cf/e0/a7cfe02be1dcf6b8f4ee71e08258eedd.jpg',
    ),
    PodcastDto(
      id: 4,
      title: 'Science Simplified',
      author: 'Science Today',
      duration: '38:45',
      imageUrl: 'https://i.pinimg.com/736x/1f/46/2b/1f462b1ece3b93d501b592401558748d.jpg',
    ),
  ];

  int _nextId = 5;

  Future<List<PodcastDto>> getPodcasts() async {
    return List.from(_podcasts);
  }

  Future<void> addPodcast(PodcastDto podcast) async {
    podcast = PodcastDto(
      id: _nextId++,
      title: podcast.title,
      author: podcast.author,
      duration: podcast.duration,
      imageUrl: podcast.imageUrl,
    );
    _podcasts.add(podcast);
  }

  Future<void> updatePodcast(int id, PodcastDto podcast) async {
    final index = _podcasts.indexWhere((p) => p.id == id);
    if (index != -1) {
      _podcasts[index] = podcast;
    }
  }

  Future<void> removePodcast(int id) async {
    _podcasts.removeWhere((p) => p.id == id);
  }
}
