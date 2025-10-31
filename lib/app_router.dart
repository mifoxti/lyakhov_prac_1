import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

import 'features/home/screens/home_screen.dart';
import 'features/library/screens/library_screen.dart';
import 'features/player/state/player_container.dart';
import 'features/search/screens/search_screen.dart';
import 'features/profile/screens/profile_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: 'home',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/library',
      name: 'library',
      builder: (context, state) => const LibraryScreen(),
    ),
    GoRoute(
      path: '/player',
      name: 'player',
      builder: (context, state) => PlayerContainer.withScreen(),
    ),
    GoRoute(
      path: '/search',
      name: 'search',
      builder: (context, state) => const SearchScreen(),
    ),
    GoRoute(
      path: '/profile',
      name: 'profile',
      builder: (context, state) => const ProfileScreen(),
    ),
  ],
);