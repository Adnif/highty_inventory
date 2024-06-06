import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:highty_inventory/presentation/home_screen.dart';

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
    return const MaterialApp(
      home:Scaffold(
        body: HomeScreen(),
      ) 
    );
  
  }
}