import 'package:flutter_test/flutter_test.dart';
import 'package:dittmanga/features/home/domain/models/manga.dart';

void main() {
  test('Manga.fromJson parses correctly', () {
    final json = {
      'mal_id': 1,
      'title': 'Test Manga',
      'images': {
        'jpg': {'image_url': 'https://test.com/image.jpg'}
      },
      'score': 8.5,
      'genres': [{'name': 'Action'}],
      'authors': [{'name': 'Author One'}],
    };

    final manga = Manga.fromJson(json);

    expect(manga.malId, 1);
    expect(manga.title, 'Test Manga');
    expect(manga.imageUrl, 'https://test.com/image.jpg');
    expect(manga.score, 8.5);
    expect(manga.genres, ['Action']);
    expect(manga.authors, ['Author One']);
  });
}
