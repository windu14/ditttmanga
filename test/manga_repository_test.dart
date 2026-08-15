import 'package:flutter_test/flutter_test.dart';
import 'package:dittmanga/features/home/data/repositories/manga_repository.dart';
import 'package:dittmanga/core/network/jikan_remote_data_source.dart';
import 'package:dittmanga/core/network/local_data_source.dart';

class MockJikanRemoteDataSource implements JikanRemoteDataSource {
  @override
  Future<Map<String, dynamic>> getTopManga({int page = 1}) async {
    return {
      'data': [
        {'mal_id': 1, 'title': 'Top Manga', 'score': 9.0}
      ]
    };
  }

  @override
  Future<Map<String, dynamic>> getLatestManga({int page = 1}) async {
    return {
      'data': [
        {'mal_id': 2, 'title': 'Latest Manga', 'score': 8.0}
      ]
    };
  }

  @override
  Future<Map<String, dynamic>> searchManga(String query, {int page = 1}) async {
    return {
      'data': [
        {'mal_id': 3, 'title': 'Search Manga', 'score': 7.0}
      ]
    };
  }

  @override
  Future<Map<String, dynamic>> getPopularManga({int page = 1}) async {
    return {
      'data': [
        {'mal_id': 4, 'title': 'Popular Manga', 'score': 9.5}
      ]
    };
  }

  @override
  Future<Map<String, dynamic>> getMangaDetail(String id) async {
    return {
      'data': {'mal_id': 5, 'title': 'Detail Manga', 'score': 9.9}
    };
  }
}

class MockLocalDataSource implements LocalDataSource {
  Map<String, dynamic>? _cache;
  bool _dohBypass = false;

  @override
  Future<Map<String, dynamic>?> getCache(String key) async {
    return _cache;
  }

  @override
  Future<void> saveCache(String key, Map<String, dynamic> data) async {
    _cache = data;
  }
  
  @override
  bool getDohBypass() => _dohBypass;
  
  @override
  Future<void> setDohBypass(bool value) async {
    _dohBypass = value;
  }
}

void main() {
  late MangaRepositoryImpl repository;
  late MockJikanRemoteDataSource remoteDataSource;
  late MockLocalDataSource localDataSource;

  setUp(() {
    remoteDataSource = MockJikanRemoteDataSource();
    localDataSource = MockLocalDataSource();
    repository = MangaRepositoryImpl(
      remoteDataSource: remoteDataSource,
      localDataSource: localDataSource,
    );
  });

  test('getTopManga returns mapped list', () async {
    final result = await repository.getTopManga();
    expect(result.length, 1);
    expect(result.first.malId, 1);
    expect(result.first.title, 'Top Manga');
  });

  test('searchManga returns mapped list', () async {
    final result = await repository.searchManga('Naruto');
    expect(result.length, 1);
    expect(result.first.title, 'Search Manga');
  });

  test('getMangaDetail returns manga', () async {
    final result = await repository.getMangaDetail('5');
    expect(result.malId, 5);
    expect(result.title, 'Detail Manga');
  });
}
