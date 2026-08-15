import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'api_client.dart';

abstract class JikanRemoteDataSource {
  Future<Map<String, dynamic>> getTopManga({int page = 1});
  Future<Map<String, dynamic>> getLatestManga({int page = 1});
  Future<Map<String, dynamic>> searchManga(String query, {int page = 1});
  Future<Map<String, dynamic>> getPopularManga({int page = 1});
  Future<Map<String, dynamic>> getMangaDetail(String id);
}

class JikanRemoteDataSourceImpl implements JikanRemoteDataSource {
  final ApiClient apiClient;

  JikanRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<Map<String, dynamic>> getTopManga({int page = 1}) async {
    final response = await apiClient.get('/top/manga', queryParameters: {'page': page});
    return response.data;
  }

  @override
  Future<Map<String, dynamic>> getLatestManga({int page = 1}) async {
    final response = await apiClient.get('/top/manga', queryParameters: {
      'page': page,
      'filter': 'publishing',
    });
    return response.data;
  }

  @override
  Future<Map<String, dynamic>> searchManga(String query, {int page = 1}) async {
    final response = await apiClient.get('/manga', queryParameters: {
      'q': query,
      'page': page,
    });
    return response.data;
  }

  @override
  Future<Map<String, dynamic>> getPopularManga({int page = 1}) async {
    final response = await apiClient.get('/top/manga', queryParameters: {
      'page': page,
      'filter': 'bypopularity',
    });
    return response.data;
  }

  @override
  Future<Map<String, dynamic>> getMangaDetail(String id) async {
    final response = await apiClient.get('/manga/$id/full');
    return response.data;
  }
}

final jikanRemoteDataSourceProvider = Provider<JikanRemoteDataSource>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return JikanRemoteDataSourceImpl(apiClient: apiClient);
});
