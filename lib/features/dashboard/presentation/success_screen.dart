
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'package:snib_order_tracking_app/core/utils/commonWidgets/common_button.dart';
import 'package:snib_order_tracking_app/core/utils/constants/app_colors.dart';
import 'package:snib_order_tracking_app/core/utils/helper/screen_utils.dart';

class SuccessScreen extends StatefulWidget {
  const SuccessScreen({super.key});

  @override
  State<SuccessScreen> createState() => _SuccessScreenState();
}

class _SuccessScreenState extends State<SuccessScreen> {
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
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Center(
            child: Padding(
              padding:  EdgeInsets.all(ScreenUtils().screenWidth(context)*0.04),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Animated success Lottie
                  Lottie.asset(
                    "assets/animations/success.json",
                    width: ScreenUtils().screenWidth(context)*0.6,
                    height: ScreenUtils().screenHeight(context)*0.3,
                    repeat: false,
                  ),
                   SizedBox(height: ScreenUtils().screenHeight(context)*0.03),

                  // Success message
                  const Text(
                    "Success!",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                   SizedBox(height: ScreenUtils().screenHeight(context)*0.015),

                  const Text(
                    "Your acknowledgement has been uploaded successfully.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),

                   SizedBox(height: ScreenUtils().screenHeight(context)*0.04),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CommonButton(
                          onTap: (){
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              "/DashboardScreen",
                                  (route) => false, // removes all routes
                            );

                          },
                          height: ScreenUtils().screenHeight(context)*0.05,
                          width: ScreenUtils().screenWidth(context)*0.6,
                          buttonName: "Back to Dashboard",
                          fontSize: 14,
                          borderRadius: 10,
                          buttonTextColor: AppColors.white,
                          gradientColor1: AppColors.alphabetFunContainer,
                          gradientColor2: AppColors.colorSkyBlue500
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}