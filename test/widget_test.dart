import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dittmanga/app/app.dart';
import 'package:dittmanga/core/network/local_data_source.dart';
import 'package:dittmanga/features/home/data/repositories/manga_repository.dart';
import 'package:dittmanga/features/home/domain/models/manga.dart';
import 'package:dittmanga/features/manga_detail/domain/models/chapter.dart';
import 'package:dittmanga/features/manga_detail/domain/models/chapter_page.dart';

class MockMangaRepository implements MangaRepository {
  @override
  Future<List<Manga>> getTopManga({int page = 1}) async => [];

  @override
  Future<List<Manga>> getLatestManga({int page = 1}) async => [];

  @override
  Future<List<Manga>> searchManga(String query, {int page = 1}) async => [];

  @override
  Future<List<Manga>> getPopularManga({int page = 1}) async => [];

  @override
  Future<Manga> getMangaDetail(String id) async {
    return Manga(
      id: '1',
      title: 'Test',
      imageUrl: '',
      score: 0,
      genres: [],
      authors: [],
    );
  }

  @override
  Future<List<Chapter>> getMangaChapters(String id, {int page = 1}) async => [];

  @override
  Future<ChapterPagesResponse> getChapterPages(String chapterId) async => ChapterPagesResponse(pages: []);
}

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
          mangaRepositoryProvider.overrideWithValue(MockMangaRepository()),
        ],
        child: const MangaApp(),
      ),
    );

    await tester.pumpAndSettle();

    // Verify that the app builds and shows Home.
    expect(find.text('Top Rated'), findsOneWidget);
    expect(find.text('Latest Updates'), findsOneWidget);
  });
}
