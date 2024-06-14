import 'package:flutter/material.dart';
import 'package:highty_inventory/presentation/constants/fonts.dart';

class QrCheck extends StatefulWidget {
  final String receipt;

  const QrCheck({required this.receipt, super.key});

  @override
  State<QrCheck> createState() => _QrCheckState();
}

class _QrCheckState extends State<QrCheck> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Confirm ${widget.receipt}',
          style: primary,
        ),
      ),
    );
  }
}