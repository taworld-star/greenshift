import 'package:flutter/material.dart';
import 'package:greenshift/data/repository/education_repository.dart';
import 'package:greenshift/data/model/educational_content_model.dart';
import 'package:greenshift/presentation/education/education_detail_page.dart';

class EducationListPage extends StatefulWidget {
  const EducationListPage({super.key});

  @override
  State<EducationListPage> createState() => _EducationListPageState();
}

class _EducationListPageState extends State<EducationListPage> {
  // Repository untuk akses data dari backend
  final EducationRepository _educationRepository = EducationRepository();
  
  // State variables
  List<EducationalContentModel> _contents = [];
  bool _isLoading = true;
  bool _isLoadingMore = false;
  String _selectedCategory = 'Semua';
  int _currentPage = 1;
  bool _hasMore = true;

  final List<String> _categories = ['Semua', 'Organik', 'Anorganik', 'B3 (Berbahaya)'];

  @override
  void initState() {
    super.initState();
    _loadContents();
  }

  /// Memuat konten edukasi dari backend
  Future<void> _loadContents({bool refresh = false}) async {
    if (refresh) {
      setState(() {
        _currentPage = 1;
        _contents = [];
        _hasMore = true;
      });
    }

    setState(() => _isLoading = true);

    // Konversi kategori ke format backend
    String? categoryParam;
    if (_selectedCategory != 'Semua') {
      categoryParam = _getCategoryKey(_selectedCategory);
    }

    final result = await _educationRepository.getAll(
      category: categoryParam,
      page: _currentPage,
    );

    setState(() {
      _isLoading = false;
      if (result != null && result.success) {
        _contents.addAll(result.data);
        _hasMore = result.currentPage < result.lastPage;
      }
    });
  }

  /// Konversi nama kategori display ke key backend
  String _getCategoryKey(String category) {
    switch (category) {
      case 'Organik':
        return 'organik';
      case 'Anorganik':
        return 'anorganik';
      case 'B3 (Berbahaya)':
        return 'b3';
      default:
        return category.toLowerCase();
    }
  }

  /// Handler saat kategori dipilih
  void _onCategorySelected(String category) {
    if (_selectedCategory != category) {
      setState(() => _selectedCategory = category);
      _loadContents(refresh: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Column(
        children: [
          _buildHeader(),
          _buildCategoryFilter(),
          Expanded(child: _buildContentList()),
        ],
      ),
    );
  }

  /// Header hijau dengan judul
  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 50, left: 24, right: 24, bottom: 24),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF4CAF50), Color(0xFF2E7D32)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Edukasi Sampah',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4),
          Text(
            'Pelajari cara mengelola sampah dengan bijak',
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
        ],
      ),
    );
  }

  /// Filter chips untuk kategori
  Widget _buildCategoryFilter() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Row(
          children: _categories.map((category) {
            final isSelected = _selectedCategory == category;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                label: Text(category),
                selected: isSelected,
                onSelected: (_) => _onCategorySelected(category),
                backgroundColor: Colors.white,
                selectedColor: Colors.green,
                labelStyle: TextStyle(
                  color: isSelected ? Colors.white : Colors.black87,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(
                    color: isSelected ? Colors.green : Colors.grey.shade300,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  /// List artikel edukasi
  Widget _buildContentList() {
    if (_isLoading && _contents.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.green),
      );
    }

    if (_contents.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.article_outlined, size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              'Belum ada artikel',
              style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => _loadContents(refresh: true),
      color: Colors.green,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        itemCount: _contents.length + (_hasMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == _contents.length) {
            if (!_isLoadingMore) {
              _isLoadingMore = true;
              _currentPage++;
              _loadContents().then((_) => _isLoadingMore = false);
            }
            return const Padding(
              padding: EdgeInsets.all(16),
              child: Center(child: CircularProgressIndicator(color: Colors.green)),
            );
          }
          return _buildArticleCard(_contents[index]);
        },
      ),
    );
  }

  /// Card artikel individual
  Widget _buildArticleCard(EducationalContentModel article) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EducationDetailPage(articleId: article.id),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Thumbnail
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: 80,
                height: 80,
                color: Colors.grey.shade200,
                child: article.image != null && article.image!.isNotEmpty
                    ? Image.network(
                        article.image!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _buildImagePlaceholder(),
                      )
                    : _buildImagePlaceholder(),
              ),
            ),
            const SizedBox(width: 12),
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    article.title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    article.content,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  _buildCategoryBadge(article.category),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Badge kategori dengan warna sesuai
  Widget _buildCategoryBadge(String category) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: _getCategoryColor(category).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        _getCategoryDisplayName(category),
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: _getCategoryColor(category),
        ),
      ),
    );
  }

  /// Nama kategori untuk display
  String _getCategoryDisplayName(String category) {
    switch (category.toLowerCase()) {
      case 'organik':
        return 'Organik';
      case 'anorganik':
        return 'Anorganik';
      case 'b3':
        return 'B3 (Berbahaya)';
      default:
        return category;
    }
  }

  /// Warna berdasarkan kategori
  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'organik':
        return const Color(0xFF66BB6A);
      case 'anorganik':
        return const Color(0xFF42A5F5);
      case 'b3':
        return const Color(0xFFEF5350);
      default:
        return Colors.green;
    }
  }

  Widget _buildImagePlaceholder() {
    return Icon(Icons.image, color: Colors.grey.shade400, size: 32);
  }
}
