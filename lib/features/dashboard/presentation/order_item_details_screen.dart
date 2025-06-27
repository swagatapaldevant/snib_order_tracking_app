import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:snib_order_tracking_app/core/utils/commonWidgets/common_button.dart';
import 'package:snib_order_tracking_app/core/utils/constants/app_colors.dart';
import 'package:snib_order_tracking_app/core/utils/helper/screen_utils.dart';
import 'package:snib_order_tracking_app/features/dashboard/model/getOrderListModel.dart';

class OrderItemDetailsScreen extends StatelessWidget {
  final GetOrderList orderItem;

  const OrderItemDetailsScreen({super.key, required this.orderItem});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.drawerColor2,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(ScreenUtils().screenWidth(context) * 0.04),
          child: Container(
            width: ScreenUtils().screenWidth(context),
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
              padding:
                  EdgeInsets.all(ScreenUtils().screenWidth(context) * 0.04),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Bounceable(
                      onTap: (){
                        Navigator.pop(context);
                      },
                      child: Icon(Icons.arrow_back, size: 30,)),
                  SizedBox(
                    height: ScreenUtils().screenHeight(context) * 0.02,
                  ),

                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.alphabetFunContainer1,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Padding(
                      padding:  EdgeInsets.symmetric(horizontal: ScreenUtils().screenWidth(context)*0.04,
                          vertical: ScreenUtils().screenHeight(context)*0.005),
                      child: Text(
                        "Requisition details : ",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            fontFamily: "Poppins",
                            color: AppColors.white),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: ScreenUtils().screenHeight(context) * 0.01,
                  ),
                  RichText(
                    text: TextSpan(
                      text: 'Bill No : ',
                      style: TextStyle(
                          fontFamily: "Poppins",
                          color: AppColors.alphabetFunContainer4,
                          fontSize: 14,
                          fontWeight: FontWeight.w600),
                      children: <TextSpan>[
                        TextSpan(
                            text:
                                orderItem.requisition?.billNo.toString() ?? "",
                            style: TextStyle(
                                fontFamily: "Poppins",
                                color: AppColors.colorBlack,
                                fontSize: 12,
                                fontWeight: FontWeight.w400)),
                      ],
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      text: 'Unique No : ',
                      style: TextStyle(
                          fontFamily: "Poppins",
                          color: AppColors.alphabetFunContainer4,
                          fontSize: 14,
                          fontWeight: FontWeight.w600),
                      children: <TextSpan>[
                        TextSpan(
                            text: orderItem.requisition?.uniqueNo.toString() ??
                                "",
                            style: TextStyle(
                                fontFamily: "Poppins",
                                color: AppColors.colorBlack,
                                fontSize: 12,
                                fontWeight: FontWeight.w400)),
                      ],
                    ),
                  ),
                  SizedBox(height: ScreenUtils().screenHeight(context)*0.02,),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: AppColors.white,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.gray7,
                            offset: const Offset(2.0, 2.0),
                            blurRadius: 2.0,
                            spreadRadius: 1.0,
                          )
                        ]),
                    child: Padding(
                      padding:  EdgeInsets.all(ScreenUtils().screenWidth(context)*0.03),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(

                            decoration: BoxDecoration(
                              color: AppColors.alphabetFunContainer1,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Padding(
                              padding:  EdgeInsets.symmetric(
                                  horizontal: ScreenUtils().screenWidth(context)*0.03,
                                  vertical: ScreenUtils().screenHeight(context)*0.002
                              ),
                              child: Text("Pick Up Location Details", style: TextStyle(
                                  fontFamily: "Poppins",
                                  color: AppColors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600),),
                            ),
                          ),
                          SizedBox(height: ScreenUtils().screenHeight(context)*0.01,),
                          RichText(
                            text: TextSpan(
                              text: 'Address : ',
                              style: TextStyle(
                                  fontFamily: "Poppins",
                                  color: AppColors.alphabetFunContainer4,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500),
                              children:  <TextSpan>[
                                TextSpan(
                                    text:
                                    orderItem.pickupFrom?.address.toString()??"",
                                    style: TextStyle(
                                        fontFamily: "Poppins",
                                        color: AppColors.colorBlack,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w400)),
                              ],
                            ),
                          ),
                          SizedBox(height: ScreenUtils().screenHeight(context)*0.01,),
                          RichText(
                            text: TextSpan(
                              text: 'Location : ',
                              style: TextStyle(
                                  fontFamily: "Poppins",
                                  color: AppColors.alphabetFunContainer4,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500),
                              children:  <TextSpan>[
                                TextSpan(
                                    text:
                                    orderItem.pickupFrom?.name.toString()??"",
                                    style: TextStyle(
                                        fontFamily: "Poppins",
                                        color: AppColors.colorBlack,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w500)),
                              ],
                            ),
                          ),
                          SizedBox(height: ScreenUtils().screenHeight(context)*0.005,),
                          RichText(
                            text: TextSpan(
                              text: 'City : ',
                              style: TextStyle(
                                  fontFamily: "Poppins",
                                  color: AppColors.alphabetFunContainer4,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500),
                              children:  <TextSpan>[
                                TextSpan(
                                    text:
                                    "${orderItem.pickupFrom?.city.toString()??""} (${orderItem.pickupFrom?.pincode.toString()??""})",
                                    style: TextStyle(
                                        fontFamily: "Poppins",
                                        color: AppColors.colorBlack,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w500)),
                              ],
                            ),
                          ),
                          SizedBox(height: ScreenUtils().screenHeight(context)*0.01,),
                          RichText(
                            text: TextSpan(
                              text: 'Contact person \n',
                              style: TextStyle(
                                  fontFamily: "Poppins",
                                  color: AppColors.alphabetFunContainer4,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500),
                              children:  <TextSpan>[
                                TextSpan(
                                    text:
                                    " 1. ${orderItem.pickupFrom?.ap1Name.toString()??""} (${orderItem.pickupFrom?.ap1Phone.toString()??""}) \n"
                                        " 2. ${orderItem.pickupFrom?.ap2Name.toString()??""} (${orderItem.pickupFrom?.ap2Phone.toString()??""})",
                                    style: TextStyle(
                                        fontFamily: "Poppins",
                                        color: AppColors.colorBlack,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w400)),
                              ],
                            ),
                          ),
                          SizedBox(height: ScreenUtils().screenHeight(context)*0.01,),
                          RichText(
                            text: TextSpan(
                              text: 'Pick up date : ',
                              style: TextStyle(
                                  fontFamily: "Poppins",
                                  color: AppColors.alphabetFunContainer4,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500),
                              children:  <TextSpan>[
                                TextSpan(
                                    text:
                                    " ${extractDate(orderItem.pickupDate.toString())??""}",
                                    style: TextStyle(
                                        fontFamily: "Poppins",
                                        color: AppColors.colorBlack,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w400)),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: ScreenUtils().screenHeight(context)*0.02,),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: AppColors.white,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.gray7,
                            offset: const Offset(2.0, 2.0),
                            blurRadius: 2.0,
                            spreadRadius: 1.0,
                          )
                        ]),
                    child: Padding(
                      padding:  EdgeInsets.all(ScreenUtils().screenWidth(context)*0.03),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: AppColors.alphabetFunContainer1,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Padding(
                              padding:  EdgeInsets.symmetric(
                                  horizontal: ScreenUtils().screenWidth(context)*0.03,
                                  vertical: ScreenUtils().screenHeight(context)*0.002
                              ),
                              child: Text("Drop off Location Details", style: TextStyle(
                                  fontFamily: "Poppins",
                                  color: AppColors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600),),
                            ),
                          ),
                          SizedBox(height: ScreenUtils().screenHeight(context)*0.01,),
                          RichText(
                            text: TextSpan(
                              text: 'Address : ',
                              style: TextStyle(
                                  fontFamily: "Poppins",
                                  color: AppColors.alphabetFunContainer4,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500),
                              children:  <TextSpan>[
                                TextSpan(
                                    text:
                                    orderItem.dropOutAt?.address.toString()??"",
                                    style: TextStyle(
                                        fontFamily: "Poppins",
                                        color: AppColors.colorBlack,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w400)),
                              ],
                            ),
                          ),
                          SizedBox(height: ScreenUtils().screenHeight(context)*0.01,),
                          RichText(
                            text: TextSpan(
                              text: 'Location : ',
                              style: TextStyle(
                                  fontFamily: "Poppins",
                                  color: AppColors.alphabetFunContainer4,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500),
                              children:  <TextSpan>[
                                TextSpan(
                                    text:
                                    orderItem.dropOutAt?.name.toString()??"",
                                    style: TextStyle(
                                        fontFamily: "Poppins",
                                        color: AppColors.colorBlack,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w500)),
                              ],
                            ),
                          ),
                          SizedBox(height: ScreenUtils().screenHeight(context)*0.005,),
                          RichText(
                            text: TextSpan(
                              text: 'City : ',
                              style: TextStyle(
                                  fontFamily: "Poppins",
                                  color: AppColors.alphabetFunContainer4,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500),
                              children:  <TextSpan>[
                                TextSpan(
                                    text:
                                    "${orderItem.dropOutAt?.city.toString()??""} (${orderItem.dropOutAt?.pincode.toString()??""})",
                                    style: TextStyle(
                                        fontFamily: "Poppins",
                                        color: AppColors.colorBlack,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w500)),
                              ],
                            ),
                          ),
                          SizedBox(height: ScreenUtils().screenHeight(context)*0.01,),
                          RichText(
                            text: TextSpan(
                              text: 'Contact person \n',
                              style: TextStyle(
                                  fontFamily: "Poppins",
                                  color: AppColors.alphabetFunContainer4,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500),
                              children:  <TextSpan>[
                                TextSpan(
                                    text:
                                    " 1. ${orderItem.dropOutAt?.ap1Name.toString()??""} (${orderItem.dropOutAt?.ap1Phone.toString()??""}) \n"
                                        " 2. ${orderItem.dropOutAt?.ap2Name.toString()??""} (${orderItem.dropOutAt?.ap2Phone.toString()??""})",
                                    style: TextStyle(
                                        fontFamily: "Poppins",
                                        color: AppColors.colorBlack,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w400)),
                              ],
                            ),
                          ),
                          SizedBox(height: ScreenUtils().screenHeight(context)*0.01,),
                          RichText(
                            text: TextSpan(
                              text: 'Drop off date : ',
                              style: TextStyle(
                                  fontFamily: "Poppins",
                                  color: AppColors.alphabetFunContainer4,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500),
                              children:  <TextSpan>[
                                TextSpan(
                                    text:
                                    " ${extractDate(orderItem.pickupDate.toString())??""}",
                                    style: TextStyle(
                                        fontFamily: "Poppins",
                                        color: AppColors.colorBlack,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w400)),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: ScreenUtils().screenHeight(context)*0.02,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                     orderItem.status == "pending"? CommonButton(
                          onTap: () {
                            Navigator.pushNamed(context, "/OtpScreen", arguments:{
                              "orderItem":orderItem,
                              "type":"pickup"
                            } );
                          },
                          height: ScreenUtils().screenHeight(context) * 0.05,
                          width: ScreenUtils().screenWidth(context) * 0.4,
                          icon: Icons.local_shipping,
                          buttonName: "Pickup",
                          fontSize: 14,
                          borderRadius: 8,
                          buttonTextColor: AppColors.white,
                          gradientColor1: AppColors.alphabetSafeArea,
                          gradientColor2: AppColors.colorSkyBlue500):SizedBox.shrink(),
                      orderItem.status == "shipped"? CommonButton(
                          onTap: () {
                            Navigator.pushNamed(context, "/OtpScreen", arguments:{
                              "orderItem":orderItem,
                              "type":"dropOff"
                            });
                          },
                          height: ScreenUtils().screenHeight(context) * 0.05,
                          width: ScreenUtils().screenWidth(context) * 0.4,
                          buttonName: "Dropoff",
                          icon: Icons.location_on,
                          fontSize: 12,
                          borderRadius: 8,
                          buttonTextColor: AppColors.white,
                          gradientColor1: AppColors.welcomeButtonColor,
                          gradientColor2: AppColors.listenSpellBg):SizedBox.shrink(),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }


  String extractDate(String isoString) {
    DateTime dateTime = DateTime.parse(isoString);
    return dateTime.toIso8601String().split('T').first;
  }
}
