import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_typography.dart';
import '../../../app/theme/app_radius.dart';
import 'providers/manga_detail_providers.dart';

class MangaDetailScreen extends ConsumerWidget {
  final String id;
  const MangaDetailScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailAsync = ref.watch(mangaDetailProvider(id));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Manga'),
      ),
      body: detailAsync.when(
        data: (manga) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.s16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(AppRadius.r16),
                      child: CachedNetworkImage(
                        imageUrl: manga.imageUrl,
                        width: 140,
                        height: 200,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          width: 140,
                          height: 200,
                          color: AppColors.background,
                          child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                        ),
                        errorWidget: (context, url, error) => Container(
                          width: 140,
                          height: 200,
                          color: AppColors.background,
                          child: const Icon(Icons.broken_image, color: AppColors.textSecondary),
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.s16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            manga.title,
                            style: AppTypography.h1,
                          ),
                          if (manga.titleEnglish != null && manga.titleEnglish!.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: AppSpacing.s4),
                              child: Text(
                                manga.titleEnglish!,
                                style: AppTypography.body2.copyWith(color: AppColors.textSecondary),
                              ),
                            ),
                          const SizedBox(height: AppSpacing.s12),
                          _buildInfoRow('Score', manga.score > 0 ? manga.score.toString() : 'N/A'),
                          _buildInfoRow('Rank', manga.rank?.toString() ?? 'N/A'),
                          _buildInfoRow('Popularity', manga.popularity?.toString() ?? 'N/A'),
                          _buildInfoRow('Status', manga.status ?? 'Unknown'),
                          _buildInfoRow('Type', manga.type ?? 'Unknown'),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.s24),
                
                Wrap(
                  spacing: AppSpacing.s8,
                  runSpacing: AppSpacing.s8,
                  children: manga.genres.map((g) => Chip(
                    label: Text(g, style: AppTypography.caption),
                    backgroundColor: AppColors.secondary.withValues(alpha: 0.3),
                    side: BorderSide.none,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.r10)),
                  )).toList(),
                ),
                const SizedBox(height: AppSpacing.s24),

                if (manga.authors.isNotEmpty) ...[
                  Text('Authors', style: AppTypography.h3),
                  const SizedBox(height: AppSpacing.s8),
                  Text(manga.authors.join(', '), style: AppTypography.body1),
                  const SizedBox(height: AppSpacing.s24),
                ],

                Text('Synopsis', style: AppTypography.h3),
                const SizedBox(height: AppSpacing.s8),
                Text(
                  manga.synopsis ?? 'Tidak ada sinopsis.',
                  style: AppTypography.body2.copyWith(height: 1.5),
                ),
                const SizedBox(height: AppSpacing.s24),

                Text('Chapters', style: AppTypography.h3),
                const SizedBox(height: AppSpacing.s8),
                _buildChapters(context, ref, manga.id),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(
          child: Text('Tidak dapat mengambil data.\nCoba lagi.', textAlign: TextAlign.center),
        ),
      ),
    );
  }

  Widget _buildChapters(BuildContext context, WidgetRef ref, String mangaId) {
    final chaptersAsync = ref.watch(mangaChaptersProvider(mangaId));
    
    return chaptersAsync.when(
      data: (chapters) {
        if (chapters.isEmpty) {
          return const Text('Tidak ada chapter dalam bahasa Inggris atau Indonesia.');
        }
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: chapters.length,
          itemBuilder: (context, index) {
            final chapter = chapters[index];
            return ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text('Chapter ${chapter.chapterNumber}'),
              subtitle: Text(chapter.title ?? 'No title', maxLines: 1, overflow: TextOverflow.ellipsis),
              trailing: Text(chapter.language.toUpperCase()),
              onTap: () {
                context.push('/chapter/${chapter.id}');
              },
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => const Text('Gagal memuat chapter.'),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.s4),
      child: Row(
        children: [
          Text('$label: ', style: AppTypography.body2.copyWith(fontWeight: FontWeight.w600)),
          Expanded(child: Text(value, style: AppTypography.body2, overflow: TextOverflow.ellipsis)),
        ],
      ),
    );
  }
}

