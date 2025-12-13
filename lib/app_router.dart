// lib/app_router.dart

import 'package:go_router/go_router.dart';

// Экраны
import 'features/intro/screens/intro_screen.dart';
import 'features/main/screens/main_screen.dart';
import 'features/library/screens/library_screen.dart';
import 'features/player/state/player_container.dart';
import 'features/search/screens/search_screen.dart';
import 'features/online_search/screens/online_search_screen.dart';
import 'features/profile/screens/profile_screen.dart';
import 'features/podcasts/screens/podcasts_screen.dart';
import 'features/friends/screens/friends_screen.dart';
import 'features/radio/screens/radio_screen.dart';
import 'features/artist/screens/artist_screen.dart';
import 'features/settings/screens/settings_screen.dart';
import 'features/settings/screens/equalizer_screen.dart';

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
        GoRoute(path: 'podcasts', builder: (context, state) => const PodcastsScreen()),
        GoRoute(
          path: 'player',
          builder: (context, state) {
            final track = state.uri.queryParameters['track'];
            final artist = state.uri.queryParameters['artist'];
            return PlayerContainer.withScreen(track: track, artist: artist);
          },
        ),
        GoRoute(path: 'friends', builder: (context, state) => const FriendsScreen()),
        GoRoute(path: 'online-search', builder: (context, state) => const OnlineSearchScreen()),
        GoRoute(path: 'search', builder: (context, state) => const SearchScreen()),
        GoRoute(path: 'profile', builder: (context, state) => const ProfileScreen()),
        GoRoute(path: 'radio', builder: (context, state) => const RadioScreen()),
        GoRoute(
          path: 'artist/:artistName',
          builder: (context, state) {
            final artistName = state.pathParameters['artistName'] ?? '';
            return ArtistScreen(artistName: artistName);
          },
        ),
        GoRoute(
          path: 'settings',
          builder: (context, state) => const SettingsScreen(),
          routes: [
            GoRoute(
              path: 'equalizer',
              builder: (context, state) => const EqualizerScreen(),
            ),
          ],
        ),
      ],
    ),
  ],
);
