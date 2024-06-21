import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:highty_inventory/presentation/screens/history/history_screen.dart';
import 'package:highty_inventory/presentation/screens/home_screen.dart';
import 'package:highty_inventory/presentation/screens/auth/login_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );
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