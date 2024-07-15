import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:highty_inventory/presentation/constants/fonts.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QrCheck extends StatefulWidget {
  final String receipt;
  String? packageId; //required if it's order from lazada

  QrCheck({required this.receipt, super.key, this.packageId});

  @override
  State<QrCheck> createState() => _QrCheckState();
}

class _QrCheckState extends State<QrCheck> {
  final String sama = '#Q543234';
  final String beda = '#Q543434';

  Barcode? _barcode;

  final MobileScannerController controller = MobileScannerController();

  Widget _buildBarcode(Barcode? value) {
    if (value == null) {
      return const Text(
        'Scan something!',
        overflow: TextOverflow.fade,
        style: TextStyle(color: Colors.white),
      );
    }

    return Text(
      value.displayValue ?? 'No display value.',
      overflow: TextOverflow.fade,
      style: const TextStyle(color: Colors.white),
    );
  }

   Widget _buildScanWindow(Rect scanWindowRect) {
    return ValueListenableBuilder(
      valueListenable: controller,
      builder: (context, value, child) {
        // Not ready.
        if (!value.isInitialized ||
            !value.isRunning ||
            value.error != null ||
            value.size.isEmpty) {
          return const SizedBox();
        }

        return CustomPaint(
          //size: Size(300, 300),
          painter: ScannerOverlay(scanWindowRect),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size; // Get the size of the screen
    final center = Offset(size.width / 2, size.height / 2.5); // Calculate the center

    final scanWindow = Rect.fromCenter(
      center: center,
      width: 300, 
      height: 300
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Confirm ${widget.receipt}',
          style: primary,
        ),
      ),
      body: Stack(
        //fit: StackFit.expand,
        children: [
          MobileScanner(
            //fit: BoxFit.contain,
            scanWindow: scanWindow,
            controller: controller,
            onDetect:  (capture){
              final List<Barcode> barcodes = capture.barcodes;
              final Uint8List? image = capture.image;
              for(final barcode in barcodes) {
                log('Barcode found! ${barcode.rawValue}');
                log('Resi : ${widget.receipt}');
                if(barcode.rawValue == widget.receipt){
                  Navigator.pop(context);
                  Fluttertoast.showToast(msg: 'Pesanan terkonfirmasi');
                  
                } else {
                  Fluttertoast.showToast(msg: 'Sepertinya paketnya tidak sama dengan orderan ini');
                }
              }
              // if(image != null){
              //   showDialog(
              //     context: context,
              //     builder: (context){
              //       return AlertDialog(
              //         title: Text(
              //           barcodes.first.rawValue ?? "",
              //         ),
              //         content: Image(
              //           image: MemoryImage(image),
              //         ),
              //       );
              //     }
              //   );
                
              // }
            },
          ),
          _buildScanWindow(scanWindow)
        ]
      )
    );
  }
}

class ScannerOverlay extends CustomPainter {
  ScannerOverlay(this.scanWindow);

  final Rect scanWindow;

  @override
  void paint(Canvas canvas, Size size) {
    // TODO: use `Offset.zero & size` instead of Rect.largest
    // we need to pass the size to the custom paint widget
    final backgroundPath = Path()..addRect(Rect.largest);
    final cutoutPath = Path()..addRect(scanWindow);

    final backgroundPaint = Paint()
      ..color = Colors.black.withOpacity(0.5)
      ..style = PaintingStyle.fill
      ..blendMode = BlendMode.dstOut;

    final backgroundWithCutout = Path.combine(
      PathOperation.difference,
      backgroundPath,
      cutoutPath,
    );
    canvas.drawPath(backgroundWithCutout, backgroundPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
