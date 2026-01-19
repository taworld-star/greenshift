import 'dart:io';
import 'package:flutter/material.dart';
import 'package:greenshift/data/usecase/response/get_scan_response.dart';

class ScanResultPage extends StatelessWidget {
  final String imagePath;
  final GetScanResponse scanResult;

  const ScanResultPage({
    super.key,
    required this.imagePath,
    required this.scanResult,
  });

  @override
  Widget build(BuildContext context) {
    final data = scanResult.data;
    final classification = data?.category ?? 'Tidak Diketahui';
    final label = data?.label ?? '';
    final confidence = data?.confidence ?? '0';
    final tips = data?.tips ?? '';

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text('Hasil Scan'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildImageSection(),
            _buildResultCard(classification, label, confidence),
            _buildDisposalSection(classification, tips),
            _buildRecommendationSection(classification),
            _buildActionButtons(context),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildImageSection() {
    return Container(
      height: 220,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
      ),
      child: imagePath.startsWith('http')
          ? Image.network(imagePath, fit: BoxFit.cover)
          : Image.file(File(imagePath), fit: BoxFit.cover),
    );
  }

  Widget _buildResultCard(String classification, String label, String confidence) {
    final confidencePercent = double.tryParse(confidence) != null
        ? (double.parse(confidence) * 100).toStringAsFixed(1)
        : confidence;

    return Container(
      margin: const EdgeInsets.all(24),
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
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: _getCategoryColor(classification).withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _getCategoryIcon(classification),
              size: 48,
              color: _getCategoryColor(classification),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            label.isNotEmpty ? label : _getCategoryLabel(classification),
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: _getCategoryColor(classification).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              _getCategoryLabel(classification),
              style: TextStyle(
                color: _getCategoryColor(classification),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.verified, color: Colors.green, size: 20),
              const SizedBox(width: 6),
              Text(
                'Tingkat Keyakinan: $confidencePercent%',
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDisposalSection(String classification, String tips) {
    final displayTips = tips.isNotEmpty ? tips : _getDefaultTips(classification);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _getCategoryColor(classification).withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _getCategoryColor(classification).withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: _getCategoryColor(classification),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                _getDisposalIcon(classification),
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Cara Pembuangan',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    displayTips,
                    style: const TextStyle(fontSize: 13),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendationSection(String classification) {
    final recommendations = _getRecommendations(classification);

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Rekomendasi Pengelolaan',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          ...recommendations.map((rec) => Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.check_circle,
                        color: Colors.green.shade600,
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        rec,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                side: const BorderSide(color: Colors.green, width: 2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Scan Lagi',
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Selesai',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getCategoryColor(String classification) {
    switch (classification.toLowerCase()) {
      case 'organik':
        return const Color(0xFF66BB6A);
      case 'anorganik':
      case 'non organik':
        return const Color(0xFF42A5F5);
      case 'b3':
      case 'berbahaya':
        return const Color(0xFFEF5350);
      default:
        return Colors.green;
    }
  }

  IconData _getCategoryIcon(String classification) {
    switch (classification.toLowerCase()) {
      case 'organik':
        return Icons.eco;
      case 'anorganik':
      case 'non organik':
        return Icons.recycling;
      case 'b3':
      case 'berbahaya':
        return Icons.warning_amber;
      default:
        return Icons.category;
    }
  }

  String _getCategoryLabel(String classification) {
    switch (classification.toLowerCase()) {
      case 'organik':
        return 'Sampah Organik';
      case 'anorganik':
      case 'non organik':
        return 'Sampah Daur Ulang';
      case 'b3':
      case 'berbahaya':
        return 'Sampah Berbahaya';
      default:
        return 'Kategori Lain';
    }
  }

  IconData _getDisposalIcon(String classification) {
    switch (classification.toLowerCase()) {
      case 'organik':
        return Icons.compost;
      case 'anorganik':
      case 'non organik':
        return Icons.delete_outline;
      case 'b3':
      case 'berbahaya':
        return Icons.dangerous;
      default:
        return Icons.info_outline;
    }
  }

  String _getDefaultTips(String classification) {
    switch (classification.toLowerCase()) {
      case 'organik':
        return 'Bisa dijadikan pupuk kompos. Buang ke tong sampah HIJAU.';
      case 'anorganik':
      case 'non organik':
        return 'Kumpulkan untuk didaur ulang. Buang ke tong KUNING.';
      case 'b3':
      case 'berbahaya':
        return 'BAHAYA! Jangan buang sembarangan. Serahkan ke petugas khusus.';
      default:
        return 'Hubungi petugas kebersihan untuk informasi lebih lanjut.';
    }
  }

  List<String> _getRecommendations(String classification) {
    switch (classification.toLowerCase()) {
      case 'organik':
        return [
          'Dapat dijadikan kompos untuk pupuk tanaman',
          'Simpan di tempat sampah organik (HIJAU)',
          'Hindari mencampur dengan plastik',
        ];
      case 'anorganik':
      case 'non organik':
        return [
          'Bersihkan dari sisa makanan',
          'Pisahkan berdasarkan jenis material',
          'Simpan di tempat sampah daur ulang (KUNING)',
          'Dapat dijual ke Bank Sampah atau pengepul',
        ];
      case 'b3':
      case 'berbahaya':
        return [
          'JANGAN buang ke tempat sampah biasa',
          'Simpan di wadah tertutup khusus',
          'Serahkan ke tempat pengumpulan B3',
          'Jauhkan dari jangkauan anak-anak',
        ];
      default:
        return [
          'Pisahkan sampah sesuai jenisnya',
          'Kurangi penggunaan barang sekali pakai',
        ];
    }
  }
}
