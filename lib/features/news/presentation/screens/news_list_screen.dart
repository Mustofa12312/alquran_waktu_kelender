import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/theme/app_theme.dart';

class NewsListScreen extends StatefulWidget {
  const NewsListScreen({super.key});

  @override
  State<NewsListScreen> createState() => _NewsListScreenState();
}

class _NewsListScreenState extends State<NewsListScreen> {
  final List<_NewsItem> _news = const [
    _NewsItem(
      id: '1',
      title: 'Pesantren Modern At-Taqwa Raih Akreditasi A',
      excerpt: 'Pesantren At-Taqwa berhasil meraih akreditasi A dari Kementerian Agama RI setelah melalui serangkaian penilaian ketat selama 6 bulan.',
      imageUrl: 'https://images.unsplash.com/photo-1591280063444-d3c514eb6e13?w=800',
      category: 'Prestasi',
      date: '15 Maret 2026',
      readTime: '3 menit',
    ),
    _NewsItem(
      id: '2',
      title: 'Kegiatan Ramadhan: Khataman Al-Qur\'an Bersama Santri',
      excerpt: 'Seluruh santri mengikuti kegiatan khataman Al-Qur\'an secara berjamaah dalam rangka menyambut bulan suci Ramadhan 1447 H.',
      imageUrl: 'https://images.unsplash.com/photo-1609599006353-e629aaabfeae?w=800',
      category: 'Kegiatan',
      date: '12 Maret 2026',
      readTime: '5 menit',
    ),
    _NewsItem(
      id: '3',
      title: 'Pengumuman Pendaftaran Santri Baru Tahun 2026',
      excerpt: 'Pesantren membuka pendaftaran santri baru untuk tahun ajaran 2026/2027. Pendaftaran dibuka dari 1 April hingga 30 Juni 2026.',
      imageUrl: 'https://images.unsplash.com/photo-1522202176988-66273c2fd55f?w=800',
      category: 'Pengumuman',
      date: '10 Maret 2026',
      readTime: '2 menit',
    ),
    _NewsItem(
      id: '4',
      title: 'Kajian Kitab Kuning Bersama Kiai Agung',
      excerpt: 'Program kajian mingguan kitab kuning dimulai kembali dengan tema Fiqh Kontemporer yang akan dipimpin langsung oleh Kiai Agung.',
      imageUrl: 'https://images.unsplash.com/photo-1549060279-7e168fcee0c2?w=800',
      category: 'Kajian',
      date: '8 Maret 2026',
      readTime: '4 menit',
    ),
  ];

  int _selectedCategory = 0;
  final List<String> _categories = ['Semua', 'Prestasi', 'Kegiatan', 'Pengumuman', 'Kajian'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBg,
      appBar: AppBar(
        backgroundColor: AppColors.darkBg,
        title: const Text('Berita Pesantren', style: TextStyle(color: AppColors.textPrimary)),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: AppColors.textPrimary),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          _buildCategoryChips(),
          Expanded(child: _buildNewsList()),
        ],
      ),
    );
  }

  Widget _buildCategoryChips() {
    return SizedBox(
      height: 44,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _categories.length,
        itemBuilder: (context, i) {
          final isSelected = i == _selectedCategory;
          return GestureDetector(
            onTap: () => setState(() => _selectedCategory = i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : AppColors.darkCard,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? AppColors.primary : AppColors.darkBorder,
                ),
              ),
              child: Text(
                _categories[i],
                style: TextStyle(
                  color: isSelected ? Colors.white : AppColors.textSecondary,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildNewsList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _news.length,
      itemBuilder: (context, i) => _buildNewsCard(_news[i], i == 0),
    );
  }

  Widget _buildNewsCard(_NewsItem item, bool isFeatured) {
    if (isFeatured) return _buildFeaturedCard(item);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.darkBorder),
      ),
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(16),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.horizontal(left: Radius.circular(16)),
              child: CachedNetworkImage(
                imageUrl: item.imageUrl,
                width: 100,
                height: 90,
                fit: BoxFit.cover,
                placeholder: (_, __) => Shimmer.fromColors(
                  baseColor: AppColors.darkCard,
                  highlightColor: AppColors.darkBorder,
                  child: Container(color: AppColors.darkCard),
                ),
                errorWidget: (_, __, ___) => Container(
                  color: AppColors.darkBorder,
                  child: const Icon(Icons.image, color: AppColors.textMuted),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildCategoryBadge(item.category),
                    const SizedBox(height: 6),
                    Text(
                      item.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Text(item.date, style: const TextStyle(color: AppColors.textMuted, fontSize: 11)),
                        const Text(' • ', style: TextStyle(color: AppColors.textMuted)),
                        Text(item.readTime, style: const TextStyle(color: AppColors.textMuted, fontSize: 11)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturedCard(_NewsItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      height: 220,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: CachedNetworkImage(
                imageUrl: item.imageUrl,
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Color(0xDD000000)],
                ),
              ),
            ),
            Positioned(
              left: 16, right: 16, bottom: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildCategoryBadge(item.category),
                  const SizedBox(height: 8),
                  Text(
                    item.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.date,
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryBadge(String category) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.8),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        category,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _NewsItem {
  const _NewsItem({
    required this.id,
    required this.title,
    required this.excerpt,
    required this.imageUrl,
    required this.category,
    required this.date,
    required this.readTime,
  });

  final String id;
  final String title;
  final String excerpt;
  final String imageUrl;
  final String category;
  final String date;
  final String readTime;
}
