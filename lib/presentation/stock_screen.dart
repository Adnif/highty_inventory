import 'package:flutter/material.dart';

class StockScreen extends StatefulWidget {
  const StockScreen({super.key});

  @override
  State<StockScreen> createState() => _StockScreenState();
}

class _StockScreenState extends State<StockScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'Ini Stock Screen',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      )
    );
  }
}