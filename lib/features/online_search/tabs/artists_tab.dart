import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
              hintText: 'Поиск исполнителей...',
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
                  // TODO: Replace with proper Artist model
                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    child: ListTile(
                      leading: Container(
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
                        artist.toString(), // TODO: Use proper artist name
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.deepPurple,
                        ),
                      ),
                      subtitle: const Text(
                        'Исполнитель',
                        style: TextStyle(color: Colors.deepPurple),
                      ),
                      trailing: IconButton(
                        icon: const Icon(
                          Icons.chevron_right,
                          color: Colors.deepPurple,
                        ),
                        onPressed: () {
                          // TODO: Navigate to artist detail
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
