import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:greenshift/data/repository/auth_repository.dart';
import 'package:greenshift/data/repository/profile_repository.dart';
import 'package:greenshift/data/model/user_model.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ProfileRepository _profileRepository = ProfileRepository();
  final ImagePicker _imagePicker = ImagePicker();
  
  User? _user;
  bool _isLoading = true;
  String? _profileImagePath;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  /// Memuat data profil dari backend
  Future<void> _loadProfile() async {
    final result = await _profileRepository.getProfile();
    setState(() {
      _user = result;
      _isLoading = false;
    });
  }

  /// Ganti foto profil
  Future<void> _changeProfilePhoto() async {
    final XFile? image = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (image != null) {
      setState(() => _profileImagePath = image.path);
      _showSnackBar('Foto profil berhasil diubah');
    }
  }

  /// Tentang Aplikasi
  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.eco, color: Colors.green),
            ),
            const SizedBox(width: 12),
            const Text('GreenShift'),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Versi 1.0.0'),
            SizedBox(height: 12),
            Text(
              'Aplikasi klasifikasi sampah untuk mendukung SDGs Goal 12 - Responsible Consumption and Production.',
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(height: 12),
            Text(
              '2026 GreenShift ',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  /// Galeri Scan
  void _showScanGalleryDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Galeri Scan'),
        content: const Text('Fitur galeri akan segera diupdate!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  /// Konfirmasi logout
  void _confirmLogout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Logout'),
        content: const Text('Yakin ingin keluar?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tidak'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // Tutup dialog konfirmasi
              _performLogout(); // Jalankan logout
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Keluar'),
          ),
        ],
      ),
    );
  }

  /// Melakukan proses logout dengan loading indicator
  Future<void> _performLogout() async {
    // loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(color: Colors.green),
      ),
    );

    try {
      await AuthRepository().logout();
    } catch (e) {
      debugPrint('Logout error: $e');
    }
    if (mounted) {
      Navigator.pop(context); 
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.green))
          : SingleChildScrollView(
              child: Column(
                children: [
                  _buildHeader(),
                  const SizedBox(height: 24),
                  _buildStatsCard(),
                  const SizedBox(height: 24),
                  _buildMenuList(),
                  const SizedBox(height: 24),
                  _buildLogoutButton(),
                  const SizedBox(height: 100),
                ],
              ),
            ),
    );
  }

  /// Header dengan avatar dan info user
  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 60, bottom: 30),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF4CAF50), Color(0xFF81C784)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          // Avatar dengan tombol ganti foto
          Stack(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.white,
                child: _profileImagePath != null
                    ? ClipOval(
                        child: Image.file(
                          File(_profileImagePath!),
                          width: 96,
                          height: 96,
                          fit: BoxFit.cover,
                        ),
                      )
                    : const Icon(Icons.person, size: 50, color: Colors.grey),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: _changeProfilePhoto,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.camera_alt, color: Colors.white, size: 18),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Nama
          Text(
            _user?.name ?? 'Pengguna',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          // Email
          Text(
            _user?.email ?? '-',
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 12),
          // Badge bergabung
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'Bergabung ${_formatJoinDate()}',
              style: const TextStyle(
                color: Colors.green,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Format tanggal bergabung 
  String _formatJoinDate() {
    final now = DateTime.now();
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun', 'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'];
    return '${months[now.month - 1]} ${now.year}';
  }

  /// Card statistik
  Widget _buildStatsCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Expanded(
            child: _buildStatItem(
              icon: Icons.qr_code_scanner,
              value: '${_user?.totalScans ?? 0}',
              label: 'Total Scan',
              iconColor: Colors.green,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildStatItem(
              icon: Icons.eco,
              value: '${_user?.points ?? 0}%',
              label: 'Skor Hijau',
              iconColor: Colors.green,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String value,
    required String label,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
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
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 28),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: iconColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  /// Menu list
  Widget _buildMenuList() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          _buildMenuItem(
            icon: Icons.photo_library,
            iconBgColor: Colors.green.shade50,
            iconColor: Colors.green,
            title: 'Galeri Scan',
            subtitle: 'Lihat riwayat foto sampah',
            onTap: _showScanGalleryDialog,
          ),
          const SizedBox(height: 12),
          _buildMenuItem(
            icon: Icons.info_outline,
            iconBgColor: Colors.blue.shade50,
            iconColor: Colors.blue,
            title: 'Tentang Aplikasi',
            subtitle: 'Informasi GreenShift',
            onTap: _showAboutDialog,
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required Color iconBgColor,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: iconColor, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.grey.shade400),
          ],
        ),
      ),
    );
  }

  /// Tombol logout
  Widget _buildLogoutButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: _confirmLogout,
          icon: const Icon(Icons.logout),
          label: const Text('Keluar'),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFEF5350),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
        ),
      ),
    );
  }
}
