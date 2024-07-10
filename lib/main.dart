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

  final supabase = Supabase.instance.client;
  final session = supabase.auth.currentSession;

  runApp(MainApp(initialRoute: session != null ? '/home' : '/auth'));
}

class MainApp extends StatefulWidget {
  final String initialRoute;
  const MainApp({super.key, required this.initialRoute});

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
      initialRoute: widget.initialRoute,
      routes: {
        '/home': (context) => const HomeScreen(),
        '/historyscreen': (context) => const HistoryScreen(),
        '/auth': (context) => const LoginScreen(),
      }, 
    );
  
  }
}