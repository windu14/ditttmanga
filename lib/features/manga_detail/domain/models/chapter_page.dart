class ChapterPage {
  final String imageUrl;

  ChapterPage({required this.imageUrl});
}

class ChapterPagesResponse {
  final List<ChapterPage> pages;

  ChapterPagesResponse({required this.pages});

  factory ChapterPagesResponse.fromJson(Map<String, dynamic> json) {
    final baseUrl = json['baseUrl'] ?? '';
    final chapter = json['chapter'] ?? {};
    final hash = chapter['hash'] ?? '';
    final data = chapter['data'] as List<dynamic>? ?? [];

    final pages = data.map((filename) {
      return ChapterPage(imageUrl: '$baseUrl/data/$hash/$filename');
    }).toList();

    return ChapterPagesResponse(pages: pages);
  }
}
