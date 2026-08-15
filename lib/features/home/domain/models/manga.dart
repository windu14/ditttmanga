class Manga {
  final int malId;
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
    required this.malId,
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
    final images = json['images']?['jpg'] ?? {};
    final imageUrl = images['image_url'] ?? '';

    final genresList = (json['genres'] as List<dynamic>?)
            ?.map((e) => e['name'] as String)
            .toList() ??
        [];

    final authorsList = (json['authors'] as List<dynamic>?)
            ?.map((e) => e['name'] as String)
            .toList() ??
        [];

    return Manga(
      malId: json['mal_id'] ?? 0,
      title: json['title'] ?? 'Unknown',
      titleEnglish: json['title_english'],
      imageUrl: imageUrl,
      score: (json['score'] as num?)?.toDouble() ?? 0.0,
      rank: json['rank'],
      popularity: json['popularity'],
      status: json['status'],
      type: json['type'],
      chapters: json['chapters'],
      volumes: json['volumes'],
      synopsis: json['synopsis'],
      genres: genresList,
      authors: authorsList,
    );
  }
}
