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
import 'package:snib_order_tracking_app/core/utils/constants/app_colors.dart';
import 'package:snib_order_tracking_app/core/utils/helper/app_dimensions.dart';
import 'package:snib_order_tracking_app/core/utils/helper/common_utils.dart';
import 'package:snib_order_tracking_app/core/utils/helper/screen_utils.dart';
import 'package:snib_order_tracking_app/features/dashboard/model/getOrderListModel.dart';

class OtpScreen extends StatefulWidget {
  final GetOrderList orderItem;
  final String type;

  const OtpScreen({
    super.key,
     required this.orderItem,
    required this.type
    // required this.email,
    // required this.password,
  });

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final List<TextEditingController> _controllers =
      List.generate(5, (index) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(5, (index) => FocusNode());
  final Dio _dio = DioClient().dio;
  final SharedPref _pref = getIt<SharedPref>();
  bool isLoading = false;
  String otp = "";
  String requisitionId = "";
   List<String> phoneNumbers =[];
   List<String> personName =[];
  String selectedPhone = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    phoneNumbers = widget.type == "pickup"?[widget.orderItem.pickupFrom?.ap1Phone.toString()??"", widget.orderItem.pickupFrom?.ap2Phone.toString()??""]:[widget.orderItem.dropOutAt?.ap1Phone.toString()??"",widget.orderItem.dropOutAt?.ap2Phone.toString()??""];
    personName = widget.type == "pickup"?[widget.orderItem.pickupFrom?.ap1Name.toString()??"", widget.orderItem.pickupFrom?.ap2Name.toString()??""]:[widget.orderItem.dropOutAt?.ap1Name.toString()??"",widget.orderItem.dropOutAt?.ap2Name.toString()??""];
    //getOtp();
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  void onOtpChanged(String value, int index) {
    if (value.isNotEmpty && index < 4) {
      _focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
  }

  String getEnteredOTP() {
    return _controllers.map((c) => c.text).join();
  }





  @override
  Widget build(BuildContext context) {
    AppDimensions.init(context);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(AppDimensions.screenPadding),
          child: Container(
            height: ScreenUtils().screenHeight(context)*0.7,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: AppColors.white,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.alphabetFunContainer4,
                    offset: const Offset(2.0, 2.0),
                    blurRadius: 2.0,
                    spreadRadius: 1.0,
                  ),
                ]),
            child: Padding(
              padding:  EdgeInsets.all(AppDimensions.screenPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Bounceable(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(
                        Icons.arrow_back,
                      )),
                  SizedBox(height: ScreenUtils().screenHeight(context) * 0.02),
                  Text(
                    "Otp Verification",
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        fontFamily: "Poppins",
                        color: AppColors.alphabetFunContainer4),
                  ),
                  SizedBox(height: ScreenUtils().screenHeight(context) * 0.02),

                  Text(
                    "Choose a number in which number you want to send otp : ",
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        fontFamily: "Poppins",
                        color: AppColors.alphabetFunContainer4),
                  ),

                  SizedBox(height: ScreenUtils().screenHeight(context) * 0.02),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(phoneNumbers.length, (index) {
                      final number = phoneNumbers[index];
                      final name = personName[index];
                      final isSelected = number == selectedPhone;

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedPhone = number;
                            getOtp(); // Call OTP function
                          });
                          print("Selected number: $selectedPhone");
                        },
                        child: Container(
                          width: ScreenUtils().screenWidth(context)*0.4,
                          height: ScreenUtils().screenHeight(context)*0.13,
                          decoration: BoxDecoration(
                            color: isSelected ? AppColors().colorBlack600 : AppColors.progressBarColor,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: isSelected ? Colors.white : Colors.transparent,
                              width: 1,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              spacing: 5,
                              children: [
                                Text(
                                  name,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: "Poppins",
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  number,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: "Poppins",
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                  ),


                  SizedBox(height: ScreenUtils().screenHeight(context) * 0.02),


                  selectedPhone==""?SizedBox.shrink():
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Enter the 5-digit code sent to your phone",
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            fontFamily: "Poppins",
                            color: AppColors.darkBlue),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: ScreenUtils().screenHeight(context) * 0.03),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: List.generate(5, (index) {
                          return SizedBox(
                            width: ScreenUtils().screenWidth(context) * 0.1,
                            child: TextField(
                              controller: _controllers[index],
                              focusNode: _focusNodes[index],
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              maxLength: 1,
                              style: const TextStyle(fontSize: 18),
                              decoration: const InputDecoration(
                                counterText: '',
                                border: OutlineInputBorder(),
                              ),
                              onChanged: (value) => onOtpChanged(value, index),
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                            ),
                          );
                        }),
                      ),
                      SizedBox(height: ScreenUtils().screenHeight(context) * 0.04),
                        Align(
                        alignment: Alignment.centerLeft,
                        child: Bounceable(
                          onTap: (){
                            getOtp();
                          },
                          child: const Text(
                            "Resend OTP",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                fontFamily: "Poppins",
                                color: AppColors.darkBlue),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      SizedBox(height: ScreenUtils().screenHeight(context) * 0.03),
                      CommonButton(
                          onTap: () {
                            final otp = getEnteredOTP();
                            if (otp.length == 5) {
                              //verifyOtp();
                              Navigator.pushNamed(context, "/AcknowledgeImageUploadScreen",
                              arguments: {
                                "requisition": widget.orderItem.requisition?.sId,
                                "routeListId": widget.orderItem.sId,
                                "otp": otp,
                                "type":widget.type
                              }

                              );

                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text("Enter a valid 5-digit OTP")),
                              );
                            }
                          },
                          height: ScreenUtils().screenHeight(context) * 0.05,
                          width: ScreenUtils().screenWidth(context),
                          buttonName: "Next",
                          fontSize: 14,
                          borderRadius: 10,
                          buttonTextColor: AppColors.white,
                          gradientColor1: AppColors.alphabetFunContainer,
                          gradientColor2: AppColors.colorSkyBlue500),
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


  Future<void> getOtp() async {
    setState(() {
      isLoading = true;
    });
    try {
      final authToken = await _pref.getUserAuthToken();
      final url = '${ApiEndPoint.getOtp}/${widget.orderItem.requisition?.sId}/$selectedPhone';
      final response = await _dio.get(
        url,
        options: Options(
          headers: {
            'Authorization': 'Bearer $authToken',
          },
        ),
      );

      if (response.statusCode == 200) {
       // requisitionId = response.data["otp"]["requisition"];
       // otp = response.data["otp"]["otp"];
        Fluttertoast.showToast(msg: "Otp send successfully",toastLength: Toast.LENGTH_LONG,);
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




}
