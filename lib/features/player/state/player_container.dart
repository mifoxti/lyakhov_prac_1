import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../models/player_model.dart';
import '../screens/player_screen.dart';
import '../cubit/player_cubit.dart';

class PlayerContainer extends StatefulWidget {
  const PlayerContainer({super.key});

  @override
  State<PlayerContainer> createState() => _PlayerContainerState();

  static Widget withScreen() => const PlayerContainer();
}

class _PlayerContainerState extends State<PlayerContainer> {
  late PlayerCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = PlayerCubit();
    _initializeTracks();
  }

  void _initializeTracks() {
    final initialTracks = [
      Track(
        id: 1,
        title: 'Perfect Symphony',
        artist: 'Ed Sheeran & Andrea Bocelli',
        duration: '4:20',
      ),
      Track(
          id: 2,
          title: 'Blinding Lights',
          artist: 'The Weeknd',
          duration: '3:22'
      ),
      Track(
          id: 3,
          title: 'Shape of You',
          artist: 'Ed Sheeran',
          duration: '3:53'
      ),
    ];
    _cubit.initializeTracks(initialTracks);
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
      child: PlayerScreen(),
    );
  }
}