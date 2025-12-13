import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../cubit/online_search_cubit.dart';

class ArtistsTab extends StatefulWidget {
  const ArtistsTab({super.key});

  @override
  State<ArtistsTab> createState() => _ArtistsTabState();
}

class _ArtistsTabState extends State<ArtistsTab> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Load trending artists on init
    context.read<OnlineSearchCubit>().loadTrendingArtists();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Поиск (artisttop:Geoxor, country:Россия, genre:Rock)',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  _searchController.clear();
                  context.read<OnlineSearchCubit>().loadTrendingArtists();
                },
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
            onSubmitted: (query) {
              if (query.isNotEmpty) {
                context.read<OnlineSearchCubit>().searchArtists(query);
              } else {
                context.read<OnlineSearchCubit>().loadTrendingArtists();
              }
            },
          ),
        ),
        Expanded(
          child: BlocBuilder<OnlineSearchCubit, OnlineSearchState>(
            builder: (context, state) {
              if (state.isLoadingArtists) {
                return const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurple),
                  ),
                );
              }

              if (state.error != null) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        size: 64,
                        color: Colors.red,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Ошибка: ${state.error}',
                        style: const TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          if (_searchController.text.isNotEmpty) {
                            context.read<OnlineSearchCubit>().searchArtists(_searchController.text);
                          } else {
                            context.read<OnlineSearchCubit>().loadTrendingArtists();
                          }
                        },
                        child: const Text('Повторить'),
                      ),
                    ],
                  ),
                );
              }

              // Show tracks if artisttop: was used
              if (state.showTracksInArtistsTab) {
                if (state.artistTabTracks.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.music_note,
                          size: 64,
                          color: Colors.deepPurple,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Треки не найдены',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.deepPurple,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: state.artistTabTracks.length,
                  itemBuilder: (context, index) {
                    final track = state.artistTabTracks[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      child: ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: track.imageUrl != null && track.imageUrl!.isNotEmpty
                              ? CachedNetworkImage(
                                  imageUrl: track.imageUrl!,
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => Container(
                                    width: 50,
                                    height: 50,
                                    color: Colors.deepPurple[100],
                                    child: const Center(
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurple),
                                      ),
                                    ),
                                  ),
                                  errorWidget: (context, url, error) => Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: Colors.deepPurple[100],
                                    ),
                                    child: const Icon(
                                      Icons.music_note,
                                      color: Colors.deepPurple,
                                    ),
                                  ),
                                )
                              : Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: Colors.deepPurple[100],
                                  ),
                                  child: const Icon(
                                    Icons.music_note,
                                    color: Colors.deepPurple,
                                  ),
                                ),
                        ),
                        title: Text(
                          track.title.isNotEmpty ? track.title : 'Неизвестный трек',
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.deepPurple,
                          ),
                        ),
                        subtitle: Text(
                          '${track.artist.isNotEmpty ? track.artist : 'Неизвестный исполнитель'} • ${track.duration}',
                          style: TextStyle(color: Colors.deepPurple[700]),
                        ),
                        trailing: IconButton(
                          icon: const Icon(
                            Icons.play_arrow,
                            color: Colors.deepPurple,
                          ),
                          onPressed: () {
                            // TODO: Play track
                          },
                        ),
                      ),
                    );
                  },
                );
              }

              // Show artists (default behavior)
              if (state.artists.isEmpty) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.person,
                        size: 64,
                        color: Colors.deepPurple,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Исполнители не найдены',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.deepPurple,
                        ),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                itemCount: state.artists.length,
                itemBuilder: (context, index) {
                  final artist = state.artists[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    child: ListTile(
                      leading: artist.imageUrl != null && artist.imageUrl!.isNotEmpty
                          ? CircleAvatar(
                              radius: 25,
                              backgroundImage: NetworkImage(artist.imageUrl!),
                              onBackgroundImageError: (_, __) => const Icon(
                                Icons.person,
                                color: Colors.deepPurple,
                              ),
                            )
                          : Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                color: Colors.deepPurple[100],
                              ),
                              child: const Icon(
                                Icons.person,
                                color: Colors.deepPurple,
                              ),
                            ),
                      title: Text(
                        artist.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.deepPurple,
                        ),
                      ),
                      subtitle: Text(
                        artist.genre ?? 'Исполнитель',
                        style: const TextStyle(color: Colors.deepPurple),
                      ),
                      trailing: IconButton(
                        icon: const Icon(
                          Icons.chevron_right,
                          color: Colors.deepPurple,
                        ),
                        onPressed: () {
                          // TODO: Navigate to artist detail
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Переход к ${artist.name}')),
                          );
                        },
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
