import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/mangadex_remote_data_source.dart';
import '../../../../core/network/local_data_source.dart';
import '../../domain/models/manga.dart';
import '../../../manga_detail/domain/models/chapter.dart';
import '../../../manga_detail/domain/models/chapter_page.dart';

abstract class MangaRepository {
  Future<List<Manga>> getTopManga({int page = 1});
  Future<List<Manga>> getLatestManga({int page = 1});
  Future<List<Manga>> searchManga(String query, {int page = 1});
  Future<List<Manga>> getPopularManga({int page = 1});
  Future<Manga> getMangaDetail(String id);
  Future<List<Chapter>> getMangaChapters(String id, {int page = 1});
  Future<ChapterPagesResponse> getChapterPages(String chapterId);
}

class MangaRepositoryImpl implements MangaRepository {
  final MangadexRemoteDataSource remoteDataSource;
  final LocalDataSource localDataSource;

  MangaRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  List<Manga> _parseMangaList(Map<String, dynamic> data) {
    if (data['data'] == null) return [];
    return (data['data'] as List).map((e) => Manga.fromJson(e)).toList();
  }

  @override
  Future<List<Manga>> getTopManga({int page = 1}) async {
    final cacheKey = 'top_manga_$page';
    try {
      final response = await remoteDataSource.getTopManga(page: page);
      await localDataSource.saveCache(cacheKey, response);
      return _parseMangaList(response);
    } catch (e) {
      final cachedData = await localDataSource.getCache(cacheKey);
      if (cachedData != null) {
        return _parseMangaList(cachedData);
      }
      rethrow;
    }
  }

  @override
  Future<List<Manga>> getLatestManga({int page = 1}) async {
    final cacheKey = 'latest_manga_$page';
    try {
      final response = await remoteDataSource.getLatestManga(page: page);
      await localDataSource.saveCache(cacheKey, response);
      return _parseMangaList(response);
    } catch (e) {
      final cachedData = await localDataSource.getCache(cacheKey);
      if (cachedData != null) {
        return _parseMangaList(cachedData);
      }
      rethrow;
    }
  }

  @override
  Future<List<Manga>> searchManga(String query, {int page = 1}) async {
    final response = await remoteDataSource.searchManga(query, page: page);
    return _parseMangaList(response);
  }

  @override
  Future<List<Manga>> getPopularManga({int page = 1}) async {
    final cacheKey = 'popular_manga_$page';
    try {
      final response = await remoteDataSource.getPopularManga(page: page);
      await localDataSource.saveCache(cacheKey, response);
      return _parseMangaList(response);
    } catch (e) {
      final cachedData = await localDataSource.getCache(cacheKey);
      if (cachedData != null) {
        return _parseMangaList(cachedData);
      }
      rethrow;
    }
  }

  @override
  Future<Manga> getMangaDetail(String id) async {
    final cacheKey = 'manga_detail_$id';
    try {
      final response = await remoteDataSource.getMangaDetail(id);
      await localDataSource.saveCache(cacheKey, response);
      return Manga.fromJson(response['data']);
    } catch (e) {
      final cachedData = await localDataSource.getCache(cacheKey);
      if (cachedData != null) {
        return Manga.fromJson(cachedData['data']);
      }
      rethrow;
    }
  }

  @override
  Future<List<Chapter>> getMangaChapters(String id, {int page = 1}) async {
    final response = await remoteDataSource.getMangaChapters(id, page: page);
    if (response['data'] == null) return [];
    return (response['data'] as List).map((e) => Chapter.fromJson(e)).toList();
  }

  @override
  Future<ChapterPagesResponse> getChapterPages(String chapterId) async {
    final response = await remoteDataSource.getChapterPages(chapterId);
    return ChapterPagesResponse.fromJson(response);
  }
}

final mangaRepositoryProvider = Provider<MangaRepository>((ref) {
  final remoteDataSource = ref.watch(mangadexRemoteDataSourceProvider);
  final localDataSource = ref.watch(localDataSourceProvider);
  return MangaRepositoryImpl(
    remoteDataSource: remoteDataSource,
    localDataSource: localDataSource,
  );
});
