import 'package:flutter_test/flutter_test.dart';
import 'package:dittmanga/features/home/domain/models/manga.dart';

void main() {
  test('Manga.fromJson parses correctly', () {
    final json = {
      'id': '12345',
      'attributes': {
        'title': {'en': 'Test Manga'},
        'tags': [
          {'attributes': {'name': {'en': 'Action'}}}
        ],
      },
      'relationships': [
        {'type': 'cover_art', 'attributes': {'fileName': 'cover.jpg'}},
        {'type': 'author', 'attributes': {'name': 'Author One'}}
      ]
    };

    final manga = Manga.fromJson(json);

    expect(manga.id, '12345');
    expect(manga.title, 'Test Manga');
    expect(manga.imageUrl, 'https://uploads.mangadex.org/covers/12345/cover.jpg.256.jpg');
    expect(manga.genres, ['Action']);
    expect(manga.authors, ['Author One']);
  });
}
