import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:snib_order_tracking_app/core/utils/commonWidgets/common_button.dart';
import 'package:snib_order_tracking_app/core/utils/constants/app_colors.dart';
import 'package:snib_order_tracking_app/core/utils/helper/screen_utils.dart';
import 'package:snib_order_tracking_app/features/dashboard/widgets/order_list_container.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
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
        backgroundColor: AppColors.drawerColor2,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding:  EdgeInsets.only(
                //top: ScreenUtils().screenWidth(context)*0.04,
                left: ScreenUtils().screenWidth(context)*0.04,
                right: ScreenUtils().screenWidth(context)*0.04
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Image.asset("assets/icons/S&IB.png",
                    height: ScreenUtils().screenHeight(context)*0.13,
                      width: ScreenUtils().screenWidth(context)*0.7,
                      fit: BoxFit.fill,
                    ),
                  ),
                  SizedBox(height: ScreenUtils().screenHeight(context)*0.01,),
                  Text("Hi Sumit, ", style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      fontFamily: "Poppins",
                      color: AppColors.alphabetFunContainer4
                  ),),
                  SizedBox(height: 5,),
                  Text("Today's orders list : ", style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      fontFamily: "Poppins",
                      color: AppColors.alphabetFunContainer4
                  ),),

                  SizedBox(height: ScreenUtils().screenHeight(context)*0.02,),


                  ListView.builder(
                    itemCount: 15,
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index){
                    return Padding(
                      padding:  EdgeInsets.only(
                          bottom: ScreenUtils().screenWidth(context)*0.04),
                      child: OrderListContainer(
                        onTap: () {
                          _showPickupDropDialog();
                        },),
                    );
                  })


                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showPickupDropDialog() {
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
                          // controller?.resumeCamera(); // Resume camera
                          // setState(() {
                          //   scanned = false; // Allow re-scan
                          // });
                        },
                        child: Icon(Icons.highlight_remove, size: 40,))),
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
                          Navigator.pop(context);
                          Navigator.pushNamed(context, "/DashboardScannerScreen");
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
                          Navigator.pop(context);

                          Navigator.pushNamed(context,"/DashboardScannerScreen");
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

}
