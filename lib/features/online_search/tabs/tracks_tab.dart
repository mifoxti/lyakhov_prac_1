import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../cubit/online_search_cubit.dart';

class TracksTab extends StatefulWidget {
  const TracksTab({super.key});

  @override
  State<TracksTab> createState() => _TracksTabState();
}

class _TracksTabState extends State<TracksTab> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Load popular tracks on init
    context.read<OnlineSearchCubit>().loadPopularTracks();
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
              hintText: 'Поиск треков...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  _searchController.clear();
                  context.read<OnlineSearchCubit>().loadPopularTracks();
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
                context.read<OnlineSearchCubit>().searchTracks(query);
              } else {
                context.read<OnlineSearchCubit>().loadPopularTracks();
              }
            },
          ),
        ),
        Expanded(
          child: BlocBuilder<OnlineSearchCubit, OnlineSearchState>(
            builder: (context, state) {
              if (state.isLoadingTracks) {
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
                            context.read<OnlineSearchCubit>().searchTracks(_searchController.text);
                          } else {
                            context.read<OnlineSearchCubit>().loadPopularTracks();
                          }
                        },
                        child: const Text('Повторить'),
                      ),
                    ],
                  ),
                );
              }

              if (state.tracks.isEmpty) {
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
                itemCount: state.tracks.length,
                itemBuilder: (context, index) {
                  final track = state.tracks[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    child: ListTile(
                      leading: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.deepPurple[100],
                        ),
                        child: track.imageUrl != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: CachedNetworkImage(
                                  imageUrl: track.imageUrl!,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => const CircularProgressIndicator(),
                                  errorWidget: (context, url, error) => const Icon(
                                    Icons.music_note,
                                    color: Colors.deepPurple,
                                  ),
                                ),
                              )
                            : const Icon(
                                Icons.music_note,
                                color: Colors.deepPurple,
                              ),
                      ),
                      title: Text(
                        track.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.deepPurple,
                        ),
                      ),
                      subtitle: Text(
                        '${track.artist} • ${track.duration}',
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
            },
          ),
        ),
      ],
    );
  }
}
