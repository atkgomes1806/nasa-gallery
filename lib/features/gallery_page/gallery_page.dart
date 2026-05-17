import 'package:flutter/material.dart';
import 'package:nasa_app/common/constants/app_colors.dart';
import 'package:nasa_app/common/constants/app_text_styles.dart';
import 'package:nasa_app/features/gallery_page/gallery_detail_page.dart';
import 'package:nasa_app/features/home_page/home_page.dart';
import 'package:nasa_app/service/nasa_service.dart';
import 'package:nasa_app/widgets/custom_form_field.dart';
import 'package:skeletonizer/skeletonizer.dart';

class GalleryPage extends StatefulWidget {
  const GalleryPage({super.key});

  @override
  State<GalleryPage> createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
  late Future<List<dynamic>> _nasaPhotos;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nasaPhotos = NasaService().searchImages('Mars');
  }

  void _executeSearch(String value) {
    if (value.isNotEmpty) {
      setState(() {
        _nasaPhotos = NasaService().searchImages(value);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Scaffold(
        floatingActionButton: IconButton(
          onPressed: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          },
          icon: Icon(Icons.home),
          color: AppColors.white,
          style: IconButton.styleFrom(
            shape: CircleBorder(),
            padding: .all(16),
            backgroundColor: AppColors.bluePrimary,
          ),
        ),
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: AppColors.grey,
          elevation: 4,
          shadowColor: AppColors.black,
          shape: Border(
            bottom: BorderSide(color: AppColors.redPrimary, width: 4),
          ),
          title: Text(
            'Gallery',
            style: AppTextStyles.titleAppBar.copyWith(
              color: AppColors.redPrimary,
            ),
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                spacing: 10,
                children: [
                  Expanded(
                    child: CustomFormField(
                      controller: _searchController,
                      onFieldSubmited: _executeSearch,
                      sufixIcon: Icon(Icons.search),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: FutureBuilder<List<dynamic>>(
                future: _nasaPhotos,
                builder: (context, snapshot) {
                  final bool isLoading =
                      snapshot.connectionState == ConnectionState.waiting;

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return ListView.builder(
                      padding: const EdgeInsets.all(20),
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        return const Padding(
                          padding: EdgeInsets.only(bottom: 20),
                          child: Skeletonizer(
                            enabled: true,
                            child: _GallerySkeletonCard(),
                          ),
                        );
                      },
                    );
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Erro ao carregar galeria',
                        style: AppTextStyles.mediumText,
                      ),
                    );
                  }

                  final items = snapshot.data ?? [];

                  if (items.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: .center,
                        children: [
                          Icon(
                            Icons.search_off,
                            size: 80,
                            color: AppColors.redPrimary,
                          ),
                          Text(
                            'Nothing founded for:\n "${_searchController.text}"',
                            style: AppTextStyles.mediumText.copyWith(
                              color: AppColors.redSecondary,
                            ),
                            textAlign: .center,
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.all(20),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      final String imageUrl = item['links'][0]['href'];
                      final String title = item['data'][0]['title'];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => GalleryDetailPage(
                                item: item,
                                imageUrl: imageUrl,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          margin: EdgeInsets.only(bottom: 20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: AppColors.grey,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      width: 3,
                                      color: AppColors.blueSecondary,
                                    ),
                                  ),
                                ),
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(20),
                                  ),
                                  child: Skeletonizer(
                                    enabled: isLoading,
                                    child: Image.network(
                                      imageUrl,
                                      height: 250,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              Icon(Icons.broken_image),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(12),
                                child: Text(
                                  title,
                                  style: AppTextStyles.titleAppBar.copyWith(
                                    fontSize: 14,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GallerySkeletonCard extends StatelessWidget {
  const _GallerySkeletonCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.grey,
        borderRadius: BorderRadius.circular(20),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(height: 250, color: AppColors.grey),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 14,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.grey,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    height: 12,
                    width: 180,
                    decoration: BoxDecoration(
                      color: AppColors.grey,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    height: 12,
                    width: 120,
                    decoration: BoxDecoration(
                      color: AppColors.grey,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
