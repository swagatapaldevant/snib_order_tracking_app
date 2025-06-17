import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:snib_order_tracking_app/core/network/apiHelper/api_endpoint.dart';
import 'package:snib_order_tracking_app/core/network/apiHelper/locator.dart';
import 'package:snib_order_tracking_app/core/network/dioClient/dio_client.dart';
import 'package:snib_order_tracking_app/core/services/localStorage/shared_pref.dart';
import 'package:snib_order_tracking_app/core/utils/commonWidgets/common_button.dart';
import 'package:snib_order_tracking_app/core/utils/commonWidgets/custom_date_picker_field.dart';
import 'package:snib_order_tracking_app/core/utils/commonWidgets/custom_shimmer.dart';
import 'package:snib_order_tracking_app/core/utils/constants/app_colors.dart';
import 'package:snib_order_tracking_app/core/utils/helper/common_utils.dart';
import 'package:snib_order_tracking_app/core/utils/helper/screen_utils.dart';
import 'package:snib_order_tracking_app/features/dashboard/model/getOrderListModel.dart';
import 'package:snib_order_tracking_app/features/dashboard/widgets/order_list_container.dart';

class DeliveryReportScreen extends StatefulWidget {
  const DeliveryReportScreen({super.key});

  @override
  State<DeliveryReportScreen> createState() => _DeliveryReportScreenState();
}

class _DeliveryReportScreenState extends State<DeliveryReportScreen> {

  String selectedFromDate = "";
  String selectedToDate = "";
  final Dio _dio = DioClient().dio;
  final SharedPref _pref = getIt<SharedPref>();
  bool isLoading = false;
  List<GetOrderList> orderList = [];

  int deliveryDoneCount = 0;
  int pickupDoneCount = 0;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.drawerColor2,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding:  EdgeInsets.only(
               left:  ScreenUtils().screenWidth(context)*0.04,
               right:  ScreenUtils().screenWidth(context)*0.04,
               top:  ScreenUtils().screenWidth(context)*0.04,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 5,
              children: [
                Bounceable(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.arrow_back,
                    )),
                Text(
                  "Delivery report",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      fontFamily: "Poppins",
                      color: AppColors.colorBlack),
                ),
                Text(
                  "Please choose the date range ",
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      fontFamily: "Poppins",
                      color: AppColors.colorBlack),
                ),
                SizedBox(height: ScreenUtils().screenHeight(context)*0.01,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomDatePickerField(
                      onDateChanged: (String value) {
                        selectedToDate = value;
                        setState(() {

                        });
                      },
                      placeholderText: 'From date',
                    ),
                    CustomDatePickerField(
                      onDateChanged: (String value) {
                        selectedFromDate = value;
                        setState(() {

                        });
                      },
                      placeholderText: 'To date',
                    ),
                  ],
                ),
                SizedBox(
                  height: ScreenUtils().screenHeight(context) * 0.02,
                ),
                selectedFromDate == "" || selectedToDate == ""
                    ? SizedBox.shrink()
                    :CommonButton(
                    onTap: () {
                      setState(() {
                        getOrderListInDateRange();
                        deliveryDoneCount = 0;
                        pickupDoneCount = 0;
                      });
                    },
                    height: ScreenUtils().screenHeight(context) * 0.045,
                    width: ScreenUtils().screenWidth(context),
                    buttonName: "Submit",
                    fontSize: 14,
                    borderRadius: 10,
                    buttonTextColor: AppColors.white,
                    gradientColor1: AppColors.darkBlue,
                    gradientColor2: AppColors.darkBlue),
                isLoading?loading():
                orderList.isEmpty?Center(
                  child: Text(
                    "No order found in this range",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        fontFamily: "Poppins",
                        color: AppColors.colorBlack),
                  ),
                ):
                Column(
                  children: [
                    SizedBox(
                      height: ScreenUtils().screenHeight(context) * 0.01,
                    ),
                    selectedFromDate == "" || selectedToDate == ""|| orderList.isEmpty
                        ? SizedBox.shrink()
                        :
                    Container(
                      width: ScreenUtils().screenWidth(context),
                      decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.alphabetFunContainer4,
                              offset: const Offset(2.0, 2.0),
                              blurRadius: 2.0,
                              spreadRadius: 1.0,
                            ),
                          ]
                      ),
                      child: Padding(
                        padding:  EdgeInsets.all(ScreenUtils().screenWidth(context)*0.04),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                              text: TextSpan(
                                text: 'Total Delivery : ',
                                style: TextStyle(
                                    fontFamily: "Poppins",
                                    color: AppColors.alphabetFunContainer4,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600),
                                children:  <TextSpan>[
                                  TextSpan(
                                      text:
                                      orderList.length.toString(),
                                      style: TextStyle(
                                          fontFamily: "Poppins",
                                          color: AppColors.colorBlack,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500)),
                                ],
                              ),
                            ),

                            RichText(
                              text: TextSpan(
                                text: 'Delivery Done: ',
                                style: TextStyle(
                                    fontFamily: "Poppins",
                                    color: AppColors.alphabetFunContainer4,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600),
                                children:  <TextSpan>[
                                  TextSpan(
                                      text:
                                      deliveryDoneCount.toString(),
                                      style: TextStyle(
                                          fontFamily: "Poppins",
                                          color: AppColors.colorBlack,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500)),
                                ],
                              ),
                            ),

                            RichText(
                              text: TextSpan(
                                text: 'Pick Up Done: ',
                                style: TextStyle(
                                    fontFamily: "Poppins",
                                    color: AppColors.alphabetFunContainer4,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600),
                                children:  <TextSpan>[
                                  TextSpan(
                                      text:
                                      pickupDoneCount.toString(),
                                      style: TextStyle(
                                          fontFamily: "Poppins",
                                          color: AppColors.colorBlack,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: ScreenUtils().screenHeight(context) * 0.01,
                    ),

                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                        itemCount:orderList.length ,
                        itemBuilder: (BuildContext context, int index){
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
          ),
        ),
      ),
    );
  }


  Future<void> getOrderListInDateRange() async {
    setState(() {
      isLoading = true;
    });
    try {
      final authToken = await _pref.getUserAuthToken();
      final String url = "${ApiEndPoint.getTaskForPartnerByDate}?startDate=$selectedToDate&endDate=$selectedFromDate";
      final response = await _dio.get(
        url,
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
      orderList.clear();
      print(orderList);
      if (response.statusCode == 200) {
        orderList = (response.data["getData"] as List)
            .map((x) => GetOrderList.fromJson(x))
            .toList();

        for(var item in orderList)
          {
            if(item.status == "delivered")
              {
                deliveryDoneCount++;
              }
            if(item.status == "shipped")
              {
                pickupDoneCount++;
              }
          }
        print(deliveryDoneCount);
        print(pickupDoneCount);
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

  Widget loading(){
    return Column(
      children: [
        SizedBox(height:ScreenUtils().screenHeight(context)*0.02 ,),

        CustomShimmer(
          height: ScreenUtils().screenHeight(context) * 0.1,
          width: ScreenUtils().screenWidth(context) ,
          radius: 10,
        ),
        SizedBox(height:ScreenUtils().screenHeight(context)*0.02 ,),
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
        SizedBox(height:ScreenUtils().screenHeight(context)*0.02 ,),
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

}
