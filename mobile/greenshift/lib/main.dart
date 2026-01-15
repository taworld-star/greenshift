import 'package:flutter/material.dart';
import 'package:greenshift/presentation/auth/login_page.dart';
import 'package:greenshift/presentation/auth/register_page.dart';
import 'package:greenshift/presentation/home/navbar_setting.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GreenShift',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/home': (context) => const NavbarSetting(), 
      },
    );
  }
}

