import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'providers/manga_reader_providers.dart';

class MangaReaderScreen extends ConsumerWidget {
  final String chapterId;
  const MangaReaderScreen({super.key, required this.chapterId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pagesAsync = ref.watch(chapterPagesProvider(chapterId));

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Read Chapter', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: pagesAsync.when(
        data: (response) {
          if (response.pages.isEmpty) {
            return const Center(child: Text('No pages found.', style: TextStyle(color: Colors.white)));
          }
          return ListView.builder(
            itemCount: response.pages.length,
            itemBuilder: (context, index) {
              final page = response.pages[index];
              return CachedNetworkImage(
                imageUrl: page.imageUrl,
                fit: BoxFit.fitWidth,
                width: double.infinity,
                placeholder: (context, url) => const SizedBox(
                  height: 400,
                  child: Center(child: CircularProgressIndicator(color: Colors.white)),
                ),
                errorWidget: (context, url, error) => const SizedBox(
                  height: 400,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.broken_image, color: Colors.grey, size: 50),
                        SizedBox(height: 10),
                        Text('Failed to load image', style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator(color: Colors.white)),
        error: (err, stack) => Center(
          child: Text('Error loading chapter.\n$err', textAlign: TextAlign.center, style: const TextStyle(color: Colors.red)),
        ),
      ),
    );
  }
}
