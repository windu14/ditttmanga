class Manga {
  final String id;
  final String title;
  final String? titleEnglish;
  final String imageUrl;
  final double score;
  final int? rank;
  final int? popularity;
  final String? status;
  final String? type;
  final int? chapters;
  final int? volumes;
  final String? synopsis;
  final List<String> genres;
  final List<String> authors;

  Manga({
    required this.id,
    required this.title,
    this.titleEnglish,
    required this.imageUrl,
    required this.score,
    this.rank,
    this.popularity,
    this.status,
    this.type,
    this.chapters,
    this.volumes,
    this.synopsis,
    required this.genres,
    required this.authors,
  });

  factory Manga.fromJson(Map<String, dynamic> json) {
    final attributes = json['attributes'] ?? {};
    
    // Extract title (prefer en or romaji)
    final titleMap = attributes['title'] ?? {};
    final title = titleMap['en'] ?? titleMap['ja-ro'] ?? titleMap.values.firstOrNull ?? 'Unknown Title';
    
    // Extract synopsis
    final descMap = attributes['description'] ?? {};
    final synopsis = descMap['en'] ?? descMap.values.firstOrNull;

    // Extract relationships (cover, author)
    String coverFileName = '';
    List<String> authorsList = [];
    
    final relationships = json['relationships'] as List<dynamic>? ?? [];
    for (var rel in relationships) {
      if (rel['type'] == 'cover_art') {
        coverFileName = rel['attributes']?['fileName'] ?? '';
      } else if (rel['type'] == 'author') {
        final name = rel['attributes']?['name'];
        if (name != null) authorsList.add(name);
      }
    }

    final mangaId = json['id'] ?? '';
    final imageUrl = coverFileName.isNotEmpty 
        ? 'https://uploads.mangadex.org/covers/$mangaId/$coverFileName.256.jpg' 
        : '';

    // Extract tags/genres
    final tags = attributes['tags'] as List<dynamic>? ?? [];
    final genresList = tags.map((t) {
      final tagNameMap = t['attributes']?['name'] ?? {};
      return (tagNameMap['en'] ?? 'Tag').toString();
    }).toList();

    return Manga(
      id: mangaId,
      title: title,
      titleEnglish: titleMap['en'],
      imageUrl: imageUrl,
      score: 0.0, // MangaDex ratings are on a separate endpoint or statistics
      status: attributes['status'],
      type: attributes['originalLanguage'] == 'ja' ? 'Manga' : 'Comic',
      synopsis: synopsis,
      genres: genresList,
      authors: authorsList,
    );
  }
}
