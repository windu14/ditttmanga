import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../home/domain/models/manga.dart';
import '../../../home/data/repositories/manga_repository.dart';
import '../../domain/models/chapter.dart';

final mangaDetailProvider = FutureProvider.family<Manga, String>((ref, id) async {
  final repo = ref.watch(mangaRepositoryProvider);
  return repo.getMangaDetail(id);
});

final mangaChaptersProvider = FutureProvider.family<List<Chapter>, String>((ref, id) async {
  final repo = ref.watch(mangaRepositoryProvider);
  return repo.getMangaChapters(id);
});
