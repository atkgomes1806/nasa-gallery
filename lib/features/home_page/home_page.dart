import 'package:flutter/material.dart';
import 'package:nasa_app/common/constants/app_colors.dart';
import 'package:nasa_app/common/constants/app_text_styles.dart';
import 'package:nasa_app/features/gallery_page/gallery_page.dart';
import 'package:nasa_app/widgets/custom_button.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Future<void> _openNasaWebsite() async {
    final uri = Uri.parse('https://www.nasa.gov/');
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.grey,
        elevation: 4,
        shadowColor: AppColors.black,
        shape: Border(
          bottom: BorderSide(color: AppColors.redPrimary, width: 4),
        ),
        centerTitle: true,
        title: Text(
          "NASA",
          style: AppTextStyles.titleAppBar.copyWith(
            color: AppColors.redPrimary,
          ),
        ),
        actions: [
          IconButton(
            onPressed: _openNasaWebsite,
            tooltip: 'Abrir site da NASA',
            icon: const Icon(Icons.public_outlined, size: 18),
            color: AppColors.redPrimary.withValues(alpha: 0.85),
            style: IconButton.styleFrom(
              visualDensity: VisualDensity.compact,
              padding: const EdgeInsets.all(10),
            ),
          ),
        ],
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: ClipRRect(
              borderRadius: BorderRadiusGeometry.circular(20),
              child: Image.asset('assets/images/home_bg.jpg'),
            ),
          ),
          Text(
            'Welcome',
            style: AppTextStyles.largeText.copyWith(
              color: AppColors.bluePrimary,
            ),
            textAlign: .center,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            child: Text(
              'Explore the Cosmos in High Definition\n\nWelcome to Gallery. Dive into NASA\'s vast library and discover the beauty of the universe through stunning images and videos. Use our smart search to find space phenomena, galaxies, and historic missions in high resolution. Space has never been this close to you.',
              style: AppTextStyles.mediumText.copyWith(
                color: AppColors.defaultText,
              ),
              textAlign: .center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 90),
            child: CustomButton(
              text: "Gallery",
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => GalleryPage()),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
