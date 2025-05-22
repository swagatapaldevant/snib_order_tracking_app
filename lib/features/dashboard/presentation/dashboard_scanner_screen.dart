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
  DateTime? currentBackPressTime;

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
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        DateTime now = DateTime.now();
        if (didPop || currentBackPressTime == null ||
            now.difference(currentBackPressTime!) > Duration(seconds: 2)) {
          currentBackPressTime = now;
          Fluttertoast.showToast(msg: 'Tap back again to Exit');
          // return false;
        }else{
          SystemNavigator.pop();
        }
      },
      child: Scaffold(
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
          ],
        ),
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      if (!scanned) {
        scanned = true;
        controller.pauseCamera();
        _showPickupDropDialog(scanData.code ?? "No Data");
      }
    });
  }

  void _showPickupDropDialog(String data) {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: "PickupDropDialog",
      transitionDuration: Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) {
        return Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.85,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                    alignment: Alignment.topRight,
                    child: Bounceable(
                        onTap: (){
                          Navigator.pop(context); // Close dialog
                          controller?.resumeCamera(); // Resume camera
                          setState(() {
                            scanned = false; // Allow re-scan
                          });
                        },
                        child: Icon(Icons.refresh, size: 40,))),
                Icon(Icons.qr_code_scanner, size: 50, color: Colors.blueAccent),
                SizedBox(height: 10),
                Text(
                  "QR Code Scanned!",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                    decoration: TextDecoration.none,
                  ),
                ),
                SizedBox(height: 40),
                // Text(
                //   "Data: $data",
                //   style: TextStyle(fontSize: 16, color: Colors.black54),
                //   textAlign: TextAlign.center,
                // ),
                // SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [

                    CommonButton(
                      onTap: (){
                        Navigator.pushNamed(context, "/AcknowledgeImageUploadScreen");
                      },
                        height: ScreenUtils().screenHeight(context)*0.05,
                        width: ScreenUtils().screenWidth(context)*0.3,
                        icon: Icons.local_shipping,
                        buttonName: "Pickup",
                        fontSize: 14,
                        borderRadius: 8,
                        buttonTextColor: AppColors.white,
                        gradientColor1: AppColors.alphabetSafeArea,
                        gradientColor2: AppColors.colorSkyBlue500
                    ),

                    CommonButton(
                        onTap: (){
                          Navigator.pushNamed(context, "/AcknowledgeImageUploadScreen");
                        },
                        height: ScreenUtils().screenHeight(context)*0.05,
                        width: ScreenUtils().screenWidth(context)*0.3,
                        buttonName: "Dropoff",
                        icon: Icons.location_on,
                        fontSize: 12,
                        borderRadius: 8,
                        buttonTextColor: AppColors.white,
                        gradientColor1: AppColors.welcomeButtonColor,
                        gradientColor2: AppColors.listenSpellBg
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: CurvedAnimation(parent: animation, curve: Curves.easeOutBack),
            child: child,
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
