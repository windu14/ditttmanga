
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/home/presentation/home_screen.dart';
import '../../features/search/presentation/search_screen.dart';
import '../../features/about/presentation/about_screen.dart';
import '../../features/manga_detail/presentation/manga_detail_screen.dart';
import '../../features/manga_reader/presentation/manga_reader_screen.dart';
import 'scaffold_with_nav_bar.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return ScaffoldWithNavBar(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/',
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/search',
                builder: (context, state) => const SearchScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/about',
                builder: (context, state) => const AboutScreen(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/manga/:id',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return MangaDetailScreen(id: id);
        },
      ),
      GoRoute(
        path: '/chapter/:id',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return MangaReaderScreen(chapterId: id);
        },
      ),
    ],
  );
});
