import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:highty_inventory/presentation/screens/history_screen.dart';
import 'package:highty_inventory/presentation/screens/home_screen.dart';
import 'package:highty_inventory/presentation/screens/login_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      home: const Scaffold(
        body: LoginScreen(),
      ),
      routes: {
        '/homescreen': (context) => const HomeScreen(),
        '/historyscreen': (context) => const HistoryScreen(),
      }, 
    );
  
  }
}