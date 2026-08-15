import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/widgets/manga_card.dart';
import '../../../core/widgets/section_header.dart';
import '../../../core/widgets/loading_skeleton.dart';
import '../../../app/theme/app_spacing.dart';
import 'providers/home_providers.dart';
import '../domain/models/manga.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manga App'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.s16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeader(title: 'Top Rated'),
            _buildHorizontalList(ref.watch(topMangaProvider)),
            const SizedBox(height: AppSpacing.s24),
            
            const SectionHeader(title: 'Latest Updates'),
            _buildHorizontalList(ref.watch(latestMangaProvider)),
            const SizedBox(height: AppSpacing.s24),
            
            const SectionHeader(title: 'Popular Manga'),
            _buildHorizontalList(ref.watch(popularMangaProvider)),
            const SizedBox(height: AppSpacing.s24),
          ],
        ),
      ),
    );
  }

  Widget _buildHorizontalList(AsyncValue<List<Manga>> asyncManga) {
    return SizedBox(
      height: 220,
      child: asyncManga.when(
        data: (mangaList) {
          if (mangaList.isEmpty) {
            return const Center(child: Text('Belum ada data.'));
          }
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: mangaList.length,
            itemBuilder: (context, index) {
              return MangaCard(manga: mangaList[index]);
            },
          );
        },
        loading: () => ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 5,
          itemBuilder: (context, index) => const MangaCardSkeleton(),
        ),
        error: (err, stack) => Center(
          child: Text('Tidak dapat mengambil data.\nCoba lagi.', textAlign: TextAlign.center),
        ),
      ),
    );
  }
}

