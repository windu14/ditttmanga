import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../features/home/data/repositories/manga_repository.dart';
import '../../../manga_detail/domain/models/chapter_page.dart';

final chapterPagesProvider = FutureProvider.family<ChapterPagesResponse, String>((ref, chapterId) async {
  final repo = ref.watch(mangaRepositoryProvider);
  return repo.getChapterPages(chapterId);
});
