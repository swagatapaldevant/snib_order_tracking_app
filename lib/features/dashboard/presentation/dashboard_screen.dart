import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:snib_order_tracking_app/core/network/apiHelper/api_endpoint.dart';
import 'package:snib_order_tracking_app/core/network/apiHelper/locator.dart';
import 'package:snib_order_tracking_app/core/network/dioClient/dio_client.dart';
import 'package:snib_order_tracking_app/core/services/localStorage/shared_pref.dart';
import 'package:snib_order_tracking_app/core/utils/commonWidgets/common_button.dart';
import 'package:snib_order_tracking_app/core/utils/commonWidgets/common_dialog.dart';
import 'package:snib_order_tracking_app/core/utils/commonWidgets/custom_shimmer.dart';
import 'package:snib_order_tracking_app/core/utils/constants/app_colors.dart';
import 'package:snib_order_tracking_app/core/utils/helper/common_utils.dart';
import 'package:snib_order_tracking_app/core/utils/helper/screen_utils.dart';
import 'package:snib_order_tracking_app/features/dashboard/model/getOrderListModel.dart';
import 'package:snib_order_tracking_app/features/dashboard/widgets/order_list_container.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  DateTime? currentBackPressTime;
  final Dio _dio = DioClient().dio;
  final SharedPref _pref = getIt<SharedPref>();
  String name = "";
  String token = "";
  bool isLoading = false;
  List<GetOrderList> orderList = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLocalData();
    getDashboardOrderList();
  }

  Future<void> getLocalData() async {
    try {
      final userName = await _pref.getUserName();

      setState(() {
        name = userName ?? "";
      });
    } catch (e) {
      print('Error loading local data: $e');
    }
  }

  Future<void> _refreshData() async {
    await Future.delayed(Duration(seconds: 2)); // Simulate a network call
    setState(() {
      getDashboardOrderList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        DateTime now = DateTime.now();
        if (didPop ||
            currentBackPressTime == null ||
            now.difference(currentBackPressTime!) > Duration(seconds: 2)) {
          currentBackPressTime = now;
          Fluttertoast.showToast(msg: 'Tap back again to Exit');
          // return false;
        } else {
          SystemNavigator.pop();
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.drawerColor2,
        body: SafeArea(
          child: RefreshIndicator(
            backgroundColor: AppColors.white,
            color: AppColors.colorBlue700,
            onRefresh: _refreshData,
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(
                    //top: ScreenUtils().screenWidth(context)*0.04,
                    left: ScreenUtils().screenWidth(context) * 0.04,
                    right: ScreenUtils().screenWidth(context) * 0.04),
                child: Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Image.asset(
                            "assets/icons/S&IB.png",
                            height: ScreenUtils().screenHeight(context) * 0.13,
                            width: ScreenUtils().screenWidth(context) * 0.7,
                            fit: BoxFit.fill,
                          ),
                        ),
                        SizedBox(
                          height: ScreenUtils().screenHeight(context) * 0.01,
                        ),
                        isLoading?loading():Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              spacing: 10,
                              children: [
                                Expanded(
                                  child: Text(
                                    "Hi $name ",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: "Poppins",
                                        color: AppColors.alphabetFunContainer4),
                                  ),
                                ),
                                CommonButton(
                                  onTap: (){
                                    Navigator.pushNamed(context, "/DeliveryReportScreen");
                                  },
                                    height: ScreenUtils().screenHeight(context)*0.04,
                                    width: ScreenUtils().screenWidth(context)*0.4,
                                    buttonName: "Delivery Report",
                                    fontSize: 14,
                                    borderRadius: 10,
                                    buttonTextColor: AppColors.white,
                                    gradientColor1: AppColors.darkBlue,
                                    gradientColor2: AppColors.darkBlue
                                )
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              "Today's orders list : ",
                              style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: "Poppins",
                                  color: AppColors.alphabetFunContainer4),
                            ),
                            SizedBox(
                              height: ScreenUtils().screenHeight(context) * 0.02,
                            ),
                            orderList.isEmpty? Center(
                              child: Text("No Orders assigned for you\nPlease contact with admin\n\nTo get new orders, tap the refresh icon at the top right of the screen",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: "Poppins",
                                  color: AppColors.colorBlack),),
                            ):
                            ListView.builder(
                                itemCount: orderList.length,
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemBuilder: (BuildContext context, int index) {
                                  return Padding(
                                    padding: EdgeInsets.only(
                                        bottom:
                                            ScreenUtils().screenWidth(context) * 0.04),
                                    child: OrderListContainer(
                                      orderItem: orderList[index],
                                      onTap: () {
                                        Navigator.pushNamed(context, "/OrderItemDetailsScreen",
                                        arguments: orderList[index]
                                        );
                                       // _showPickupDropDialog();
                                      },
                                    ),
                                  );
                                }),
                          ],
                        )
                      ],
                    ),
                    Positioned(
                        top:  ScreenUtils().screenWidth(context)*0.05,
                        right: 0,
                        child: Row(
                          spacing: 15,
                          children: [

                            Bounceable(

                                onTap: () {
                                  getDashboardOrderList();
                                },
                                child: Icon(Icons.refresh, color: AppColors.alphabetFunContainer4,size: 25,)),

                            Bounceable(
                                onTap: (){
                                  CommonDialog(
                                      icon: Icons.logout,
                                      title: "Log Out",
                                      msg:
                                      "You are about to logout of your account. Please confirm.",
                                      activeButtonLabel: "Log Out",
                                      context: context,
                                      activeButtonOnClicked: () {
                                        _pref.clearOnLogout();
                                        Navigator.pushNamedAndRemoveUntil(
                                          context,
                                          "/SigninScreen",
                                              (Route<dynamic> route) =>
                                          false, // Removes all previous routes
                                        );
                                      });
                                },
                                child: Icon(Icons.logout, color: AppColors.alphabetFunContainer4,size: 25,)),
                          ],
                        ))
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> getDashboardOrderList() async {
    setState(() {
      isLoading = true;
    });
    try {
      final authToken = await _pref.getUserAuthToken();
      final response = await _dio.get(
        ApiEndPoint.dashboardApi,
        options: Options(
          headers: {
            'Authorization': 'Bearer $authToken',
          },
        ),
        // data: {
        //   'email': email,
        //   'password': password,
        // },
      );

      if (response.statusCode == 200) {
        orderList = (response.data["getData"] as List)
            .map((x) => GetOrderList.fromJson(x))
            .toList();
      } else {
        print("⚠️ Unexpected status: ${response.statusCode}");
      }

      setState(() {
        isLoading = false;
      });
    } on DioException catch (e) {
      if (e.response != null) {
        CommonUtils().flutterSnackBar(
            context: context,
            mes: "Dio error response: ${e.response?.data}",
            messageType: 4);

        print("Dio error response: ${e.response?.data}");
      } else {
        CommonUtils().flutterSnackBar(
            context: context,
            mes: "Dio error message: ${e.message}",
            messageType: 4);

        print("Dio error message: ${e.message}");
      }
      setState(() {
        isLoading = false;
      });
    }
  }

  Widget loading() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomShimmer(
          height: ScreenUtils().screenHeight(context) * 0.025,
          width: ScreenUtils().screenWidth(context) * 0.5,
          radius: 10,
        ),
        SizedBox(
          height: ScreenUtils().screenHeight(context) * 0.01,
        ),
        CustomShimmer(
          height: ScreenUtils().screenHeight(context) * 0.02,
          width: ScreenUtils().screenWidth(context) * 0.4,
          radius: 10,
        ),
        SizedBox(
          height: ScreenUtils().screenHeight(context) * 0.02,
        ),
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: AppColors.gray7,
              width: 4
            ),
            borderRadius: BorderRadius.circular(10)
          ),
          child: Padding(
            padding:  EdgeInsets.all(ScreenUtils().screenWidth(context)*0.04),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomShimmer(
                      height: ScreenUtils().screenHeight(context) * 0.018,
                      width: ScreenUtils().screenWidth(context) * 0.35,
                      radius: 10,
                    ),
                    CustomShimmer(
                      height: ScreenUtils().screenHeight(context) * 0.018,
                      width: ScreenUtils().screenWidth(context) * 0.35,
                      radius: 10,
                    ),
                  ],
                ),
                SizedBox(
                  height: ScreenUtils().screenHeight(context) * 0.01,
                ),
                Divider(),
                SizedBox(
                  height: ScreenUtils().screenHeight(context) * 0.01,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomShimmer(
                      height: ScreenUtils().screenHeight(context) * 0.12,
                      width: ScreenUtils().screenWidth(context) * 0.38,
                      radius: 10,
                    ),
                    CustomShimmer(
                      height: ScreenUtils().screenHeight(context) * 0.12,
                      width: ScreenUtils().screenWidth(context) * 0.38,
                      radius: 10,
                    ),
                  ],
                ),
                SizedBox(
                  height: ScreenUtils().screenHeight(context) * 0.01,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        CustomShimmer(
                          height: ScreenUtils().screenHeight(context) * 0.02,
                          width: ScreenUtils().screenWidth(context) * 0.3,
                          radius: 10,
                        ),
                        SizedBox(
                          height: ScreenUtils().screenHeight(context) * 0.01,
                        ),
                        CustomShimmer(
                          height: ScreenUtils().screenHeight(context) * 0.02,
                          width: ScreenUtils().screenWidth(context) * 0.3,
                          radius: 10,
                        ),
                      ],
                    ),
                    CustomShimmer(
                      height: ScreenUtils().screenHeight(context) * 0.03,
                      width: ScreenUtils().screenWidth(context) * 0.3,
                      radius: 10,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: ScreenUtils().screenHeight(context) * 0.02,
        ),
        Container(
          decoration: BoxDecoration(
              border: Border.all(
                  color: AppColors.gray7,
                  width: 4
              ),
              borderRadius: BorderRadius.circular(10)
          ),
          child: Padding(
            padding:  EdgeInsets.all(ScreenUtils().screenWidth(context)*0.04),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomShimmer(
                      height: ScreenUtils().screenHeight(context) * 0.018,
                      width: ScreenUtils().screenWidth(context) * 0.35,
                      radius: 10,
                    ),
                    CustomShimmer(
                      height: ScreenUtils().screenHeight(context) * 0.018,
                      width: ScreenUtils().screenWidth(context) * 0.35,
                      radius: 10,
                    ),
                  ],
                ),
                SizedBox(
                  height: ScreenUtils().screenHeight(context) * 0.01,
                ),
                Divider(),
                SizedBox(
                  height: ScreenUtils().screenHeight(context) * 0.01,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomShimmer(
                      height: ScreenUtils().screenHeight(context) * 0.12,
                      width: ScreenUtils().screenWidth(context) * 0.38,
                      radius: 10,
                    ),
                    CustomShimmer(
                      height: ScreenUtils().screenHeight(context) * 0.12,
                      width: ScreenUtils().screenWidth(context) * 0.38,
                      radius: 10,
                    ),
                  ],
                ),
                SizedBox(
                  height: ScreenUtils().screenHeight(context) * 0.01,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        CustomShimmer(
                          height: ScreenUtils().screenHeight(context) * 0.02,
                          width: ScreenUtils().screenWidth(context) * 0.3,
                          radius: 10,
                        ),
                        SizedBox(
                          height: ScreenUtils().screenHeight(context) * 0.01,
                        ),
                        CustomShimmer(
                          height: ScreenUtils().screenHeight(context) * 0.02,
                          width: ScreenUtils().screenWidth(context) * 0.3,
                          radius: 10,
                        ),
                      ],
                    ),
                    CustomShimmer(
                      height: ScreenUtils().screenHeight(context) * 0.03,
                      width: ScreenUtils().screenWidth(context) * 0.3,
                      radius: 10,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: ScreenUtils().screenHeight(context) * 0.02,
        ),
        Container(
          decoration: BoxDecoration(
              border: Border.all(
                  color: AppColors.gray7,
                  width: 4
              ),
              borderRadius: BorderRadius.circular(10)
          ),
          child: Padding(
            padding:  EdgeInsets.all(ScreenUtils().screenWidth(context)*0.04),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomShimmer(
                      height: ScreenUtils().screenHeight(context) * 0.018,
                      width: ScreenUtils().screenWidth(context) * 0.35,
                      radius: 10,
                    ),
                    CustomShimmer(
                      height: ScreenUtils().screenHeight(context) * 0.018,
                      width: ScreenUtils().screenWidth(context) * 0.35,
                      radius: 10,
                    ),
                  ],
                ),
                SizedBox(
                  height: ScreenUtils().screenHeight(context) * 0.01,
                ),
                Divider(),
                SizedBox(
                  height: ScreenUtils().screenHeight(context) * 0.01,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomShimmer(
                      height: ScreenUtils().screenHeight(context) * 0.12,
                      width: ScreenUtils().screenWidth(context) * 0.38,
                      radius: 10,
                    ),
                    CustomShimmer(
                      height: ScreenUtils().screenHeight(context) * 0.12,
                      width: ScreenUtils().screenWidth(context) * 0.38,
                      radius: 10,
                    ),
                  ],
                ),
                SizedBox(
                  height: ScreenUtils().screenHeight(context) * 0.01,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        CustomShimmer(
                          height: ScreenUtils().screenHeight(context) * 0.02,
                          width: ScreenUtils().screenWidth(context) * 0.3,
                          radius: 10,
                        ),
                        SizedBox(
                          height: ScreenUtils().screenHeight(context) * 0.01,
                        ),
                        CustomShimmer(
                          height: ScreenUtils().screenHeight(context) * 0.02,
                          width: ScreenUtils().screenWidth(context) * 0.3,
                          radius: 10,
                        ),
                      ],
                    ),
                    CustomShimmer(
                      height: ScreenUtils().screenHeight(context) * 0.03,
                      width: ScreenUtils().screenWidth(context) * 0.3,
                      radius: 10,
                    ),
                  ],
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  // void _showPickupDropDialog() {
  //   showGeneralDialog(
  //     context: context,
  //     barrierDismissible: false,
  //     barrierLabel: "PickupDropDialog",
  //     transitionDuration: Duration(milliseconds: 300),
  //     pageBuilder: (context, animation, secondaryAnimation) {
  //       return Center(
  //         child: Container(
  //           width: MediaQuery.of(context).size.width * 0.85,
  //           padding: EdgeInsets.all(20),
  //           decoration: BoxDecoration(
  //             color: Colors.white,
  //             borderRadius: BorderRadius.circular(20),
  //           ),
  //           child: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             children: [
  //               Align(
  //                   alignment: Alignment.topRight,
  //                   child: Bounceable(
  //                       onTap: () {
  //                         Navigator.pop(context); // Close dialog
  //                         // controller?.resumeCamera(); // Resume camera
  //                         // setState(() {
  //                         //   scanned = false; // Allow re-scan
  //                         // });
  //                       },
  //                       child: Icon(
  //                         Icons.highlight_remove,
  //                         size: 40,
  //                       ))),
  //               Icon(Icons.qr_code_scanner, size: 50, color: Colors.blueAccent),
  //               SizedBox(height: 10),
  //               Text(
  //                 "QR Code Scanned!",
  //                 style: TextStyle(
  //                   fontSize: 20,
  //                   fontWeight: FontWeight.bold,
  //                   color: Colors.black87,
  //                   decoration: TextDecoration.none,
  //                 ),
  //               ),
  //               SizedBox(height: 40),
  //               // Text(
  //               //   "Data: $data",
  //               //   style: TextStyle(fontSize: 16, color: Colors.black54),
  //               //   textAlign: TextAlign.center,
  //               // ),
  //               // SizedBox(height: 20),
  //               Row(
  //                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //                 children: [
  //                   CommonButton(
  //                       onTap: () {
  //                         Navigator.pop(context);
  //                         //Navigator.pushNamed(context, "/DashboardScannerScreen");
  //                         Navigator.pushNamed(context, "/OtpScreen");
  //                       },
  //                       height: ScreenUtils().screenHeight(context) * 0.05,
  //                       width: ScreenUtils().screenWidth(context) * 0.3,
  //                       icon: Icons.local_shipping,
  //                       buttonName: "Pickup",
  //                       fontSize: 14,
  //                       borderRadius: 8,
  //                       buttonTextColor: AppColors.white,
  //                       gradientColor1: AppColors.alphabetSafeArea,
  //                       gradientColor2: AppColors.colorSkyBlue500),
  //                   CommonButton(
  //                       onTap: () {
  //                         Navigator.pop(context);
  //
  //                         //Navigator.pushNamed(context,"/DashboardScannerScreen");
  //                         Navigator.pushNamed(context, "/OtpScreen");
  //                       },
  //                       height: ScreenUtils().screenHeight(context) * 0.05,
  //                       width: ScreenUtils().screenWidth(context) * 0.3,
  //                       buttonName: "Dropoff",
  //                       icon: Icons.location_on,
  //                       fontSize: 12,
  //                       borderRadius: 8,
  //                       buttonTextColor: AppColors.white,
  //                       gradientColor1: AppColors.welcomeButtonColor,
  //                       gradientColor2: AppColors.listenSpellBg),
  //                 ],
  //               ),
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //     transitionBuilder: (context, animation, secondaryAnimation, child) {
  //       return FadeTransition(
  //         opacity: animation,
  //         child: ScaleTransition(
  //           scale:
  //               CurvedAnimation(parent: animation, curve: Curves.easeOutBack),
  //           child: child,
  //         ),
  //       );
  //     },
  //   );
  // }
}
