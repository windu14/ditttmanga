import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../home/domain/models/manga.dart';
import '../../../home/data/repositories/manga_repository.dart';

final mangaDetailProvider = FutureProvider.family<Manga, String>((ref, id) async {
  final repo = ref.watch(mangaRepositoryProvider);
  return repo.getMangaDetail(id);
});
