import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:snib_order_tracking_app/core/utils/commonWidgets/common_button.dart';
import 'package:snib_order_tracking_app/core/utils/constants/app_colors.dart';
import 'package:snib_order_tracking_app/core/utils/helper/screen_utils.dart';

class QrGeneratorScreen extends StatefulWidget {
  const QrGeneratorScreen({super.key});

  @override
  State<QrGeneratorScreen> createState() => _QrGeneratorScreenState();
}

class _QrGeneratorScreenState extends State<QrGeneratorScreen> {
  String? _qrData;
  DateTime? currentBackPressTime;

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
        body: SafeArea(
          child: Padding(
            padding:  EdgeInsets.only(
                left: ScreenUtils().screenWidth(context)*0.04,
                right: ScreenUtils().screenWidth(context)*0.04,
                top: ScreenUtils().screenWidth(context)*0.04,

            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Text("Hii Client !!", style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                  color: AppColors.darkBlue
                ),),
                  SizedBox(height: ScreenUtils().screenHeight(context)*0.04,),
                CommonButton(
                  onTap: (){
                    setState(() {
                      _qrData = "https://snibtrack.com/qr?id=12345"; // or any string
                    });
                  },
                    height: ScreenUtils().screenHeight(context)*0.05,
                    width: ScreenUtils().screenWidth(context),
                    buttonName: "Generate Qr",
                    fontSize: 14,
                    borderRadius: 10,
                    // icon: Icons.qr_code,
                    buttonTextColor: AppColors.white,
                    gradientColor1: AppColors.drawerColor,
                    gradientColor2: AppColors.colorSkyBlue300),


                SizedBox(height: ScreenUtils().screenHeight(context)*0.02,),
                Container(
                  height: ScreenUtils().screenHeight(context)*0.5,
                  width: ScreenUtils().screenHeight(context),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    // border: Border.all(
                    //   color: AppColors.darkBlue,
                    //   width: 2
                    // )
                  ),
                  child: Center(
                    child: _qrData != null
                        ? QrImageView(
                      data: _qrData!,
                      version: QrVersions.auto,
                      size: ScreenUtils().screenWidth(context) * 0.8,
                    )
                        : const Text("Click above to generate QR",
                        style: TextStyle(fontSize: 16)),
                  ),
                )

              ],
            ),
          ),
        ),
      ),
    );
  }
}
