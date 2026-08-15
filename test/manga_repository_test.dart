import 'package:flutter_test/flutter_test.dart';
import 'package:dittmanga/features/home/data/repositories/manga_repository.dart';
import 'package:dittmanga/core/network/mangadex_remote_data_source.dart';
import 'package:dittmanga/core/network/local_data_source.dart';

class MockMangadexRemoteDataSource implements MangadexRemoteDataSource {
  @override
  Future<Map<String, dynamic>> getTopManga({int page = 1}) async {
    return {
      'data': [
        {'id': '1', 'attributes': {'title': {'en': 'Top Manga'}}}
      ]
    };
  }

  @override
  Future<Map<String, dynamic>> getLatestManga({int page = 1}) async {
    return {
      'data': [
        {'id': '2', 'attributes': {'title': {'en': 'Latest Manga'}}}
      ]
    };
  }

  @override
  Future<Map<String, dynamic>> searchManga(String query, {int page = 1}) async {
    return {
      'data': [
        {'id': '3', 'attributes': {'title': {'en': 'Search Manga'}}}
      ]
    };
  }

  @override
  Future<Map<String, dynamic>> getPopularManga({int page = 1}) async {
    return {
      'data': [
        {'id': '4', 'attributes': {'title': {'en': 'Popular Manga'}}}
      ]
    };
  }

  @override
  Future<Map<String, dynamic>> getMangaDetail(String id) async {
    return {
      'data': {'id': '5', 'attributes': {'title': {'en': 'Detail Manga'}}}
    };
  }

  @override
  Future<Map<String, dynamic>> getMangaChapters(String id, {int page = 1}) async {
    return {
      'data': [
        {'id': 'c1', 'attributes': {'chapter': '1', 'title': 'Ch 1'}}
      ]
    };
  }

  @override
  Future<Map<String, dynamic>> getChapterPages(String chapterId) async {
    return {
      'baseUrl': 'https://uploads.mangadex.org',
      'chapter': {
        'hash': 'abc',
        'data': ['1.jpg']
      }
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
  late MockMangadexRemoteDataSource remoteDataSource;
  late MockLocalDataSource localDataSource;

  setUp(() {
    remoteDataSource = MockMangadexRemoteDataSource();
    localDataSource = MockLocalDataSource();
    repository = MangaRepositoryImpl(
      remoteDataSource: remoteDataSource,
      localDataSource: localDataSource,
    );
  });

  test('getTopManga returns mapped list', () async {
    final result = await repository.getTopManga();
    expect(result.length, 1);
    expect(result.first.id, '1');
    expect(result.first.title, 'Top Manga');
  });

  test('searchManga returns mapped list', () async {
    final result = await repository.searchManga('Naruto');
    expect(result.length, 1);
    expect(result.first.title, 'Search Manga');
  });

  test('getMangaDetail returns manga', () async {
    final result = await repository.getMangaDetail('5');
    expect(result.id, '5');
    expect(result.title, 'Detail Manga');
  });
}
