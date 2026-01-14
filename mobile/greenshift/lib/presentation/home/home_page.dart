import 'package:flutter/material.dart';
import 'package:greenshift/data/repository/scan_repository.dart';
import 'package:greenshift/data/usecase/response/get_dashboard_response.dart';
import 'package:greenshift/data/usecase/response/get_scan_response.dart';
import 'package:greenshift/data/model/scan_model.dart';
import 'package:greenshift/presentation/scan/scan_result_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScanRepository _scanRepository = ScanRepository();
  DashboardData? _dashboardData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDashboard();
  }

  Future<void> _loadDashboard() async {
    final result = await _scanRepository.getDashboard();
    setState(() {
      _dashboardData = result?.data;
      _isLoading = false;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: _isLoading
      ? const Center(child: CircularProgressIndicator(
        color: Colors.green,
      ))
      : RefreshIndicator(
        onRefresh: _loadDashboard,
        color : Colors.green,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 20),
              _buildGreenScoreCard(),
              const SizedBox(height: 20),
              _buildStatistikSection(),
              const SizedBox(height: 20),
              _buildAktivitasTerbaru(),
              const SizedBox(height: 100),
            ],
          ),
        )
      ),
    );
  }

  Widget _buildHeader() {
  return Container(
    padding: const EdgeInsets.only(top: 50, left: 24, right: 24, bottom: 30),
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
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Halo,',
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
            Text(
              _dashboardData?.userName ?? 'Pengguna',  
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset('assets/logo1.png', fit: BoxFit.contain),
          ),
        ),
      ],
    ),
  );
}
 Widget _buildGreenScoreCard() {
    final score = _dashboardData?.greenScore ?? 0;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.green.withValues(alpha: 0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 100,
                  height: 100,
                  child: CircularProgressIndicator(
                    value: score / 100,
                    strokeWidth: 10,
                    backgroundColor: Colors.grey.shade200,
                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
                  ),
                ),
                Text(
                  '$score',
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 24),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Green Score Kamu',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _getMotivationalMessage(score),
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getMotivationalMessage(int score) {
    if (score >= 80) {
      return 'Luar biasa! Kamu adalah pahlawan lingkungan!';
    } else if (score >= 50) {
      return 'Hebat! Terus tingkatkan kontribusimu untuk bumi yang lebih hijau.';
    } else if (score > 0) {
      return 'Ayo tingkatkan! Setiap sampah yang dipilah membantu bumi.';
    } else {
      return 'Mulai scan sampahmu untuk mendapat skor!';
    }
  }

  Widget _buildStatistikSection() {
    final stats = _dashboardData?.stats;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Statistik Sampahmu', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _buildStatCard(Icons.eco, 'Organik', stats?.organik ?? 0, const Color(0xFF66BB6A))),
              const SizedBox(width: 12),
              Expanded(child: _buildStatCard(Icons.recycling, 'Daur Ulang', stats?.daurUlang ?? 0, const Color(0xFF42A5F5))),
              const SizedBox(width: 12),
              Expanded(child: _buildStatCard(Icons.warning_amber, 'Berbahaya', stats?.berbahaya ?? 0, const Color(0xFFEF5350))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(IconData icon, String label, int value, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: color.withValues(alpha: 0.1), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: color.withValues(alpha: 0.1), shape: BoxShape.circle),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 12),
          Text('$value', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: color)),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(fontSize: 12, color: Colors.grey.shade600), textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Widget _buildAktivitasTerbaru() {
    final recentItems = _dashboardData?.recentItems ?? [];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Text('Aktivitas Terbaru', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 160,
          child: recentItems.isEmpty
              ? const Center(child: Text('Belum ada aktivitas scan', style: TextStyle(color: Colors.grey)))
              : ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  itemCount: recentItems.length,
                  itemBuilder: (context, index) => _buildActivityCard(recentItems[index]),
                ),
        ),
      ],
    );
  }

  Widget _buildActivityCard(RecentItem item) {
    return GestureDetector(
      onTap: () {
        // Membuat GetScanResponse dari RecentItem
        final scanResult = GetScanResponse(
          success: true,
          data: ScanResult(
            label: item.label,
            category: item.category,
            confidence: item.confidence.toString(),
          ),
        );
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ScanResultPage(
              imagePath: item.image,
              scanResult: scanResult,
            ),
          ),
        );
      },
      child: Container(
        width: 140,
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: Container(
                height: 90,
                width: double.infinity,
                color: Colors.grey.shade200,
                child: item.image.isNotEmpty
                    ? Image.network(item.image, fit: BoxFit.cover, errorBuilder: (_, __, ___) => _buildImagePlaceholder())
                    : _buildImagePlaceholder(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13), maxLines: 1, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 4),
                  Text(item.category, style: TextStyle(fontSize: 11, color: _getCategoryColor(item.category), fontWeight: FontWeight.w500)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePlaceholder() {
    return Center(child: Icon(Icons.image, color: Colors.grey.shade400, size: 40));
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'organik':
        return const Color(0xFF66BB6A);
      case 'daur ulang':
        return const Color(0xFF42A5F5);
      case 'berbahaya':
        return const Color(0xFFEF5350);
      default:
        return Colors.green;
    }
  }
}