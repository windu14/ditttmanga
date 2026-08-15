import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_typography.dart';
import '../../../core/widgets/manga_card.dart';
import '../../../core/widgets/loading_skeleton.dart';
import 'providers/search_providers.dart';

class SearchScreen extends ConsumerWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchController = TextEditingController(text: ref.read(searchQueryProvider));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.s16),
            child: TextField(
              controller: searchController,
              autofocus: false,
              decoration: InputDecoration(
                hintText: 'Search manga...',
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: SvgPicture.asset('assets/icons/search.svg', colorFilter: const ColorFilter.mode(AppColors.textSecondary, BlendMode.srcIn)),
                ),
                suffixIcon: Consumer(
                  builder: (context, ref, _) {
                    final query = ref.watch(searchQueryProvider);
                    if (query.isEmpty) return const SizedBox.shrink();
                    return IconButton(
                      icon: SvgPicture.asset('assets/icons/x.svg', colorFilter: const ColorFilter.mode(AppColors.textSecondary, BlendMode.srcIn)),
                      onPressed: () {
                        searchController.clear();
                        ref.read(searchQueryProvider.notifier).state = '';
                        ref.read(searchDebounceProvider.notifier).updateQuery('');
                      },
                    );
                  },
                ),
              ),
              onChanged: (value) {
                ref.read(searchQueryProvider.notifier).state = value;
                ref.read(searchDebounceProvider.notifier).updateQuery(value);
              },
            ),
          ),
          Expanded(
            child: Consumer(
              builder: (context, ref, _) {
                final query = ref.watch(searchDebounceProvider);
                if (query.trim().isEmpty) {
                  return Center(
                    child: Text(
                      'Cari manga favoritmu',
                      style: AppTypography.body1.copyWith(color: AppColors.textSecondary),
                    ),
                  );
                }

                final searchResult = ref.watch(searchMangaProvider);
                return searchResult.when(
                  data: (mangaList) {
                    if (mangaList.isEmpty) {
                      return Center(
                        child: Text(
                          'Manga tidak ditemukan',
                          style: AppTypography.body1.copyWith(color: AppColors.textSecondary),
                        ),
                      );
                    }
                    return GridView.builder(
                      padding: const EdgeInsets.all(AppSpacing.s16),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        childAspectRatio: 0.6,
                        crossAxisSpacing: AppSpacing.s16,
                        mainAxisSpacing: AppSpacing.s16,
                      ),
                      itemCount: mangaList.length,
                      itemBuilder: (context, index) {
                        return MangaCard(manga: mangaList[index]);
                      },
                    );
                  },
                  loading: () => GridView.builder(
                    padding: const EdgeInsets.all(AppSpacing.s16),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 0.6,
                      crossAxisSpacing: AppSpacing.s16,
                      mainAxisSpacing: AppSpacing.s16,
                    ),
                    itemCount: 6,
                    itemBuilder: (context, index) => const MangaCardSkeleton(),
                  ),
                  error: (err, stack) => Center(
                    child: Text('Tidak dapat mengambil data.\nCoba lagi.', textAlign: TextAlign.center),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

