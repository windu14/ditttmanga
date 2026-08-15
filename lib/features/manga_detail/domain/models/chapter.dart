class Chapter {
  final String id;
  final String mangaId;
  final String chapterNumber;
  final String? title;
  final String language;
  final int pages;

  Chapter({
    required this.id,
    required this.mangaId,
    required this.chapterNumber,
    this.title,
    required this.language,
    required this.pages,
  });

  factory Chapter.fromJson(Map<String, dynamic> json) {
    final attributes = json['attributes'] ?? {};
    
    return Chapter(
      id: json['id'] ?? '',
      mangaId: (json['relationships'] as List<dynamic>?)?.firstWhere(
        (rel) => rel['type'] == 'manga',
        orElse: () => {'id': ''}
      )['id'] ?? '',
      chapterNumber: attributes['chapter']?.toString() ?? '0',
      title: attributes['title'],
      language: attributes['translatedLanguage'] ?? 'en',
      pages: attributes['pages'] ?? 0,
    );
  }
}
