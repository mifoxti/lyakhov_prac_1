// lib/app_router.dart

import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

// Экраны
import 'features/intro/screens/intro_screen.dart';
import 'features/main/screens/main_screen.dart';
import 'features/library/screens/library_screen.dart';
import 'features/player/state/player_container.dart';
import 'features/search/screens/search_screen.dart';
import 'features/profile/screens/profile_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/intro',
  routes: [
    GoRoute(
      path: '/',
      redirect: (context, state) => '/intro',
    ),
    GoRoute(
      path: '/intro',
      builder: (context, state) => const IntroScreen(),
    ),
    GoRoute(
      path: '/main',
      builder: (context, state) => const MainScreen(),
      routes: [
        GoRoute(path: 'library', builder: (context, state) => const LibraryScreen()),
        GoRoute(path: 'player', builder: (context, state) => PlayerContainer.withScreen()),
        GoRoute(path: 'search', builder: (context, state) => const SearchScreen()),
        GoRoute(path: 'profile', builder: (context, state) => const ProfileScreen()),
      ],
    ),
  ],
);