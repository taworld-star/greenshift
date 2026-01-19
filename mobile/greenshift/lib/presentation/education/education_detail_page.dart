import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:greenshift/data/repository/education_repository.dart';
import 'package:greenshift/data/model/educational_content_model.dart';

class EducationDetailPage extends StatefulWidget {
  final int articleId;

  const EducationDetailPage({
    super.key,
    required this.articleId,
  });

  @override
  State<EducationDetailPage> createState() => _EducationDetailPageState();
}

class _EducationDetailPageState extends State<EducationDetailPage> {
  // Repository untuk akses data dari backend
  final EducationRepository _educationRepository = EducationRepository();
  
  // State variables
  EducationalContentModel? _article;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadArticle();
  }

  /// Memuat detail artikel dari backend
  Future<void> _loadArticle() async {
    final result = await _educationRepository.getById(widget.articleId);
    setState(() {
      _article = result?.data;  
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: _isLoading ? _buildLoading() : _buildContent(),
    );
  }

  Widget _buildLoading() {
    return const Center(
      child: CircularProgressIndicator(color: Colors.green),
    );
  }

  Widget _buildContent() {
    if (_article == null) {
      return _buildError();
    }

    return CustomScrollView(
      slivers: [
        _buildAppBar(),
        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeroImage(),
              _buildArticleInfo(),
              _buildArticleContent(),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ],
    );
  }

  /// AppBar dengan judul
  Widget _buildAppBar() {
    return SliverAppBar(
      backgroundColor: Colors.green,
      foregroundColor: Colors.white,
      pinned: true,
      title: const Text('Detail Artikel'),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }

  /// Hero image artikel
  Widget _buildHeroImage() {
    return Container(
      height: 200,
      width: double.infinity,
      color: Colors.grey.shade300,
      child: _article?.image != null && _article!.image!.isNotEmpty
          ? Image.network(
              _article!.image!,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => _buildImagePlaceholder(),
            )
          : _buildImagePlaceholder(),
    );
  }

  /// Info artikel (kategori, judul, tanggal)
  Widget _buildArticleInfo() {
    return Container(
      padding: const EdgeInsets.all(24),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Badge kategori
          _buildCategoryBadge(_article!.category),
          const SizedBox(height: 12),
          // Judul
          Text(
            _article!.title,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 12),
          // Tanggal
          Row(
            children: [
              Icon(Icons.calendar_today, size: 16, color: Colors.grey.shade600),
              const SizedBox(width: 6),
              Text(
                _formatDate(_article!.createdAt),
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Konten artikel
  Widget _buildArticleContent() {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(24),
      color: Colors.white,
      child: Text(
        _article!.content,
        style: const TextStyle(
          fontSize: 15,
          height: 1.8,
          color: Colors.black87,
        ),
      ),
    );
  }

  /// Badge kategori dengan warna sesuai
  Widget _buildCategoryBadge(String category) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: _getCategoryColor(category),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        _getCategoryDisplayName(category),
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    );
  }

  /// Format tanggal ke Bahasa Indonesia
  String _formatDate(DateTime? date) {
    if (date == null) return '-';
    return DateFormat('dd MMMM yyyy, HH:mm', 'id_ID').format(date);
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
    return Center(
      child: Icon(Icons.image, color: Colors.grey.shade400, size: 64),
    );
  }

  Widget _buildError() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            'Artikel tidak ditemukan',
            style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child: const Text('Kembali', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
