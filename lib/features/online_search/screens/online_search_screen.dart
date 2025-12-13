import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../cubit/online_search_cubit.dart';
import '../tabs/tracks_tab.dart';
import '../tabs/artists_tab.dart';

class OnlineSearchScreen extends StatefulWidget {
  const OnlineSearchScreen({super.key});

  @override
  State<OnlineSearchScreen> createState() => _OnlineSearchScreenState();
}

class _OnlineSearchScreenState extends State<OnlineSearchScreen> {
  late OnlineSearchCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = OnlineSearchCubit();
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: Colors.deepPurple[50],
          appBar: AppBar(
            title: const Text('Онлайн поиск'),
            backgroundColor: Colors.deepPurple,
            foregroundColor: Colors.white,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => context.pop(),
            ),
            bottom: const TabBar(
              tabs: [
                Tab(
                  icon: Icon(Icons.music_note),
                  text: 'Треки',
                ),
                Tab(
                  icon: Icon(Icons.person),
                  text: 'Исполнители',
                ),
              ],
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white70,
              indicatorColor: Colors.white,
            ),
          ),
          body: const TabBarView(
            children: [
              TracksTab(),
              ArtistsTab(),
            ],
          ),
        ),
      ),
    );
  }
}
