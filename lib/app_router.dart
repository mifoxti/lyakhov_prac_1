import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'features/library/screens/playlist_form_screen.dart';
import 'features/player/screens/player_form_screen.dart';
import 'main.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: 'main',
      builder: (context, state) => const MainScreen(),
      routes: [
        GoRoute(
          path: 'library/playlist-form',
          name: 'playlist-form',
          pageBuilder: (context, state) => MaterialPage(
            key: state.pageKey,
            child: PlaylistFormScreen(
              existingPlaylist: state.extra as Map<String, dynamic>?,
            ),
          ),
        ),
        GoRoute(
          path: 'player/track-form',
          name: 'track-form',
          pageBuilder: (context, state) => MaterialPage(
            key: state.pageKey,
            child: PlayerFormScreen(existingTrack: state.extra),
          ),
        ),
      ],
    ),
  ],
);
