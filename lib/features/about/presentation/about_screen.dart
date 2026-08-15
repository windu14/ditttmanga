import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_typography.dart';
import '../../../app/theme/app_radius.dart';
import 'providers/doh_provider.dart';

class AboutScreen extends ConsumerWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDohEnabled = ref.watch(dohBypassProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('About & Settings'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.s24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: AppSpacing.s16),
            
            // Pengaturan
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Settings',
                style: AppTypography.h3,
              ),
            ),
            const SizedBox(height: AppSpacing.s16),
            Material(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppRadius.r16),
              clipBehavior: Clip.antiAlias,
              child: SwitchListTile(
                title: Text('Bypass ISP Block', style: AppTypography.body1.copyWith(fontWeight: FontWeight.w600)),
                subtitle: Text(
                  kIsWeb 
                    ? 'Private DNS (DoH) is not supported in the Web Browser. Please build the APK to use this feature.'
                    : 'Enable Private DNS (DoH) to bypass local network restrictions. (Requires App Restart)', 
                  style: AppTypography.caption.copyWith(
                    color: kIsWeb ? Colors.redAccent : AppColors.textSecondary
                  )
                ),
                value: isDohEnabled,
                activeTrackColor: AppColors.primary.withValues(alpha: 0.5),
                activeThumbColor: AppColors.primary,
                onChanged: kIsWeb ? null : (value) {
                  ref.read(dohBypassProvider.notifier).toggle(value);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(value ? 'Private DNS Enabled. Restart app to apply.' : 'Private DNS Disabled. Restart app to apply.'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
              ),
            ),
            
            const SizedBox(height: AppSpacing.s40),
            
            // About App
            Container(
              padding: const EdgeInsets.all(AppSpacing.s16),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: SvgPicture.asset(
                'assets/icons/info.svg',
                width: 48,
                height: 48,
                colorFilter: const ColorFilter.mode(AppColors.primary, BlendMode.srcIn),
              ),
            ),
            const SizedBox(height: AppSpacing.s24),
            Text(
              'Manga App',
              style: AppTypography.display,
            ),
            const SizedBox(height: AppSpacing.s8),
            Text(
              'v1.0.0',
              style: AppTypography.body2.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: AppSpacing.s24),
            Text(
              'Personal manga discovery application.',
              style: AppTypography.body1,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.s40),
            
            _buildAttributionCard(
              'Powered by Jikan API v4',
              'https://jikan.moe',
            ),
            const SizedBox(height: AppSpacing.s16),
            _buildAttributionCard(
              'Data sourced from MyAnimeList',
              'https://myanimelist.net',
            ),
            
            const SizedBox(height: AppSpacing.s40),
            ElevatedButton(
              onPressed: () {
                showLicensePage(
                  context: context,
                  applicationName: 'Manga App',
                  applicationVersion: '1.0.0',
                );
              },
              child: const Text('Open Source Licenses'),
            ),
            
            const SizedBox(height: AppSpacing.s40),
            Text(
              'Built with Flutter 3.44.9',
              style: AppTypography.caption,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAttributionCard(String title, String subtitle) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.s16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.r16),
      ),
      child: Column(
        children: [
          Text(title, style: AppTypography.body1.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: AppSpacing.s4),
          Text(subtitle, style: AppTypography.body2.copyWith(color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}

