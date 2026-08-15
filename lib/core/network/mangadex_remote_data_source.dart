import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'api_client.dart';

abstract class MangadexRemoteDataSource {
  Future<Map<String, dynamic>> getTopManga({int page = 1});
  Future<Map<String, dynamic>> getLatestManga({int page = 1});
  Future<Map<String, dynamic>> searchManga(String query, {int page = 1});
  Future<Map<String, dynamic>> getPopularManga({int page = 1});
  Future<Map<String, dynamic>> getMangaDetail(String id);
  Future<Map<String, dynamic>> getMangaChapters(String id, {int page = 1});
  Future<Map<String, dynamic>> getChapterPages(String chapterId);
}

class MangadexRemoteDataSourceImpl implements MangadexRemoteDataSource {
  final ApiClient apiClient;

  MangadexRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<Map<String, dynamic>> getTopManga({int page = 1}) async {
    final offset = (page - 1) * 10;
    final response = await apiClient.get('/manga', queryParameters: {
      'limit': 10,
      'offset': offset,
      'includes[]': ['cover_art', 'author'],
      'order[rating]': 'desc',
    });
    return response.data;
  }

  @override
  Future<Map<String, dynamic>> getLatestManga({int page = 1}) async {
    final offset = (page - 1) * 10;
    final response = await apiClient.get('/manga', queryParameters: {
      'limit': 10,
      'offset': offset,
      'includes[]': ['cover_art', 'author'],
      'order[updatedAt]': 'desc',
    });
    return response.data;
  }

  @override
  Future<Map<String, dynamic>> searchManga(String query, {int page = 1}) async {
    final offset = (page - 1) * 10;
    final response = await apiClient.get('/manga', queryParameters: {
      'title': query,
      'limit': 10,
      'offset': offset,
      'includes[]': ['cover_art', 'author'],
    });
    return response.data;
  }

  @override
  Future<Map<String, dynamic>> getPopularManga({int page = 1}) async {
    final offset = (page - 1) * 10;
    final response = await apiClient.get('/manga', queryParameters: {
      'limit': 10,
      'offset': offset,
      'includes[]': ['cover_art', 'author'],
      'order[followedCount]': 'desc',
    });
    return response.data;
  }

  @override
  Future<Map<String, dynamic>> getMangaDetail(String id) async {
    final response = await apiClient.get('/manga/$id', queryParameters: {
      'includes[]': ['cover_art', 'author'],
    });
    return response.data;
  }

  @override
  Future<Map<String, dynamic>> getMangaChapters(String id, {int page = 1}) async {
    final offset = (page - 1) * 100;
    final response = await apiClient.get('/manga/$id/feed', queryParameters: {
      'limit': 100,
      'offset': offset,
      'translatedLanguage[]': ['en', 'id'],
      'order[chapter]': 'desc',
    });
    return response.data;
  }

  @override
  Future<Map<String, dynamic>> getChapterPages(String chapterId) async {
    final response = await apiClient.get('/at-home/server/$chapterId');
    return response.data;
  }
}

final mangadexRemoteDataSourceProvider = Provider<MangadexRemoteDataSource>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return MangadexRemoteDataSourceImpl(apiClient: apiClient);
});
