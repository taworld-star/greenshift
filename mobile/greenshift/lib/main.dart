import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:greenshift/presentation/auth/login_page.dart';
import 'package:greenshift/presentation/auth/register_page.dart';
import 'package:greenshift/presentation/home/navbar_setting.dart';
//import 'package:greenshift/presentation/admin/admin_dashboard_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GreenShift',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/home': (context) => const NavbarSetting(),
       // '/admin': (context) => const AdminDashboardPage(),
      },
    );
  }
}
