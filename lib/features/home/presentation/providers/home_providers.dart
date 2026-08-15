import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/manga.dart';
import '../../data/repositories/manga_repository.dart';

final topMangaProvider = FutureProvider<List<Manga>>((ref) async {
  final repo = ref.watch(mangaRepositoryProvider);
  return repo.getTopManga();
});

final latestMangaProvider = FutureProvider<List<Manga>>((ref) async {
  final repo = ref.watch(mangaRepositoryProvider);
  return repo.getLatestManga();
});

final popularMangaProvider = FutureProvider<List<Manga>>((ref) async {
  final repo = ref.watch(mangaRepositoryProvider);
  return repo.getPopularManga();
});
