import 'package:flutter/material.dart';
class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  const BottomNavBar({super.key, required this.currentIndex, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 20, offset: const Offset(0, -5))],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(Icons.home_outlined, Icons.home, 'Beranda', 0),
              _buildNavItem(Icons.menu_book_outlined, Icons.menu_book, 'Edukasi', 1),
              _buildScanButton(),
              _buildNavItem(Icons.person_outline, Icons.person, 'Profil', 3),
            ],
          ),
        ),
      ),
    );
  }
  Widget _buildNavItem(IconData icon, IconData activeIcon, String label, int index) {
    final isSelected = currentIndex == index;
    return GestureDetector(
      onTap: () => onTap(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(isSelected ? activeIcon : icon, color: isSelected ? Colors.green : Colors.grey, size: 28),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(fontSize: 12, color: isSelected ? Colors.green : Colors.grey, fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal)),
        ],
      ),
    );
  }
  Widget _buildScanButton() {
    return GestureDetector(
      onTap: () => onTap(2),
      child: Container(
        width: 64, height: 64,
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [Color(0xFF4CAF50), Color(0xFF2E7D32)]),
          shape: BoxShape.circle,
          boxShadow: [BoxShadow(color: Colors.green.withValues(alpha: 0.4), blurRadius: 12, offset: const Offset(0, 4))],
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.qr_code_scanner, color: Colors.white, size: 28),
            Text('Scan', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}