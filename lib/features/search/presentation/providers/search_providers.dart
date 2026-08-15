import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../home/domain/models/manga.dart';
import '../../../home/data/repositories/manga_repository.dart';

final searchQueryProvider = StateProvider<String>((ref) => '');

final searchDebounceProvider = StateNotifierProvider<SearchDebounceNotifier, String>((ref) {
  return SearchDebounceNotifier();
});

class SearchDebounceNotifier extends StateNotifier<String> {
  SearchDebounceNotifier() : super('');
  Timer? _timer;

  void updateQuery(String query) {
    if (_timer?.isActive ?? false) _timer!.cancel();
    _timer = Timer(const Duration(milliseconds: 500), () {
      state = query;
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

final searchMangaProvider = FutureProvider.autoDispose<List<Manga>>((ref) async {
  final query = ref.watch(searchDebounceProvider);
  if (query.trim().isEmpty) {
    return [];
  }
  final repo = ref.watch(mangaRepositoryProvider);
  return repo.searchManga(query);
});
