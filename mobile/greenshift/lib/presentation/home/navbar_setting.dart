import 'package:flutter/material.dart';
import 'package:greenshift/presentation/home/home_page.dart';
import 'package:greenshift/presentation/education/education_list_page.dart';
import 'package:greenshift/presentation/scan/scan_page.dart';
import 'package:greenshift/presentation/profile/profile_page.dart';
import 'package:greenshift/presentation/widgets/bottom_nav_bar.dart';

class NavbarSetting extends StatefulWidget {
  const NavbarSetting({super.key});

  @override
  State<NavbarSetting> createState() => _NavbarSettingState();
}

class _NavbarSettingState extends State<NavbarSetting> {
    int _currentIndex = 0;

    final List<Widget> _pages = [
        HomePage(),
        EducationListPage(),
        ScanPage(),
        ProfilePage(),
    ];

    void _onTabTapped(int index) {
        setState(() {
            _currentIndex = index;
        });
    }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: IndexedStack(
            index: _currentIndex,
            children: _pages,
        ),
        bottomNavigationBar: BottomNavBar(
            currentIndex: _currentIndex,
            onTap: _onTabTapped,
        ),
    );
  }
}