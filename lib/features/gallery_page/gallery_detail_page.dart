import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:nasa_app/common/constants/app_colors.dart';
import 'package:nasa_app/common/constants/app_text_styles.dart';

class GalleryDetailPage extends StatelessWidget {
  const GalleryDetailPage({
    super.key,
    required this.item,
    required this.imageUrl,
  });

  final Map<String, dynamic> item;
  final String imageUrl;

  String _readDataField(String key, {String fallback = 'Not available'}) {
    final data = item['data'];
    if (data is List && data.isNotEmpty && data.first is Map<String, dynamic>) {
      final value = data.first[key];
      if (value is String && value.trim().isNotEmpty) {
        return value;
      }
    }
    return fallback;
  }

  @override
  Widget build(BuildContext context) {
    final title = _readDataField('title');
    final description = _readDataField('description');
    final photographer = _readDataField('photographer');
    final center = _readDataField('center');

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            imageUrl,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) =>
                Container(color: Colors.black),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
            child: Container(color: Colors.black.withValues(alpha: 0.35)),
          ),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                      color: AppColors.white,
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.black.withValues(alpha: 0.45),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 28),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(28),
                      ),
                    ),
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 72,
                            height: 6,
                            margin: const EdgeInsets.only(bottom: 18),
                            decoration: BoxDecoration(
                              color: AppColors.defaultText.withValues(
                                alpha: 0.35,
                              ),
                              borderRadius: BorderRadius.circular(99),
                            ),
                          ),
                          Text(
                            title,
                            style: AppTextStyles.titleAppBar.copyWith(
                              fontSize: 26,
                              color: AppColors.bluePrimary,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            description,
                            style: AppTextStyles.mediumText.copyWith(
                              fontSize: 16,
                              color: AppColors.black,
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 24),
                          _DetailRow(
                            label: 'Photographer',
                            value: photographer,
                          ),
                          const SizedBox(height: 12),
                          _DetailRow(label: 'Center', value: center),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.grey.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.inputHintText.copyWith(
              fontSize: 12,
              color: AppColors.redPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: AppTextStyles.mediumText.copyWith(
              fontSize: 15,
              color: AppColors.black,
            ),
          ),
        ],
      ),
    );
  }
}
