import 'package:flutter/material.dart';
import 'views/home_page.dart'; // เปลี่ยน import มาที่ home_page.dart

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Location Explorer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const HomePage(), // กำหนดหน้าแรกเป็น HomePage
    );
  }
}