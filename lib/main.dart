import 'package:coworking/admin/admin_dashboard.dart';
import 'package:coworking/pages/one_day_pass.dart';


import 'package:flutter/material.dart';
import 'package:coworking/login/login.dart';
import 'package:coworking/splash_screen.dart';
import 'package:coworking/pages/home_page.dart';

void main() {
  runApp( 
    const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RAW Coworking',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // Initial screen when app starts
      home: const SplashScreen(),

      // Define all routes for easy navigation
      routes: {
        '/login': (context) => const LoginPage(),
        '/home': (context) => const HomePage(),
        '/adminDashboard': (context) => const AdminDashboard(),
  
         '/oneDayPass': (context) => const OneDayPassesPage(), // if applicable
      },
    );
  }
}