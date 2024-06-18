import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:highty_inventory/presentation/constants/fonts.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QrCheck extends StatefulWidget {
  final String receipt;

  const QrCheck({required this.receipt, super.key});

  @override
  State<QrCheck> createState() => _QrCheckState();
}

class _QrCheckState extends State<QrCheck> {
  final String sama = '#Q543234';
  final String beda = '#Q543434';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Confirm ${widget.receipt}',
          style: primary,
        ),
      ),
      body: MobileScanner(
        controller: MobileScannerController(
          detectionSpeed: DetectionSpeed.noDuplicates,
          returnImage: true,
        ),
        onDetect:  (capture){
          final List<Barcode> barcodes = capture.barcodes;
          final Uint8List? image = capture.image;
          for(final barcode in barcodes) {
            log('Barcode found! ${barcode.rawValue}');
          }
          if(image != null){
            // showDialog(
            //   context: context,
            //   builder: (context){
            //     return AlertDialog(
            //       title: Text(
            //         barcodes.first.rawValue ?? "",
            //       ),
            //       content: Image(
            //         image: MemoryImage(image),
            //       ),
            //     );
            //   }
            // );
            
          }
          
        },
      )
    );
  }
}