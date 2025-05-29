import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';
import 'package:snib_order_tracking_app/core/utils/commonWidgets/common_button.dart';
import 'package:snib_order_tracking_app/core/utils/constants/app_colors.dart';
import 'package:snib_order_tracking_app/core/utils/helper/screen_utils.dart';

class DashboardScannerScreen extends StatefulWidget {
  const DashboardScannerScreen({super.key});

  @override
  State<DashboardScannerScreen> createState() => _DashboardScannerScreenState();
}

class _DashboardScannerScreenState extends State<DashboardScannerScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  bool scanned = false;


  @override
  void reassemble() {
    super.reassemble();
    if (controller != null) {
      controller!.pauseCamera();
      controller!.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          QRView(
            key: qrKey,
            onQRViewCreated: _onQRViewCreated,
            overlay: QrScannerOverlayShape(
              borderColor: Colors.yellow,
              borderRadius: 10,
              borderLength: 30,
              borderWidth: 10,
              cutOutSize: 250,
            ),
          ),
          Positioned(
            top: ScreenUtils().screenHeight(context)*0.05,
            left: ScreenUtils().screenWidth(context)*0.05,
            child: Bounceable(
                onTap: (){
                  Navigator.pop(context);
                },
                child: Icon(Icons.highlight_remove, color: AppColors.gray7,size: 40,)),
          )
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      if (!scanned) {
        scanned = true;
        controller.pauseCamera();
        //_showPickupDropDialog(scanData.code ?? "No Data");
        Navigator.pushNamed(context, "/AcknowledgeImageUploadScreen");
      }
    });
  }


  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
