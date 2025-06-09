import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:snib_order_tracking_app/core/utils/constants/app_colors.dart';
import 'package:snib_order_tracking_app/core/utils/helper/screen_utils.dart';
import 'package:snib_order_tracking_app/features/dashboard/model/getOrderListModel.dart';

class OrderListContainer extends StatelessWidget {
  final GetOrderList? orderItem;

  Function() onTap;
  OrderListContainer({super.key, required this.onTap, required this.orderItem});

  @override
  Widget build(BuildContext context) {
    return Bounceable(
      onTap: onTap,
      child: Container(
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
            ]),
        child: Padding(
          padding: EdgeInsets.all(ScreenUtils().screenWidth(context) * 0.04),
          child: Column(
            spacing: 10,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    orderItem?.requisition?.billNo.toString()??"",
                    style: TextStyle(
                        fontFamily: "Poppins",
                        color: AppColors.alphabetFunContainer4,
                        fontSize: 16,
                        fontWeight: FontWeight.w600),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: AppColors.drawerColor,
                        borderRadius: BorderRadius.circular(5),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.drawerColor1,
                            offset: const Offset(2.0, 2.0),
                            blurRadius: 2.0,
                            spreadRadius: 0.0,
                          ),
                        ]),
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 8.0, vertical: 3),
                      child: Text(
                        orderItem?.requisition?.uniqueNo.toString()??"",
                        style: TextStyle(
                            fontFamily: "Poppins",
                            color: AppColors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ],
              ),
              Divider(),
              Row(
                children: [
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        text: 'Pick Up Location\n',
                        style: TextStyle(
                            fontFamily: "Poppins",
                            color: AppColors.alphabetFunContainer4,
                            fontSize: 14,
                            fontWeight: FontWeight.w600),
                        children:  <TextSpan>[
                          TextSpan(
                              text:
                                  "${orderItem?.pickupFrom?.address.toString()??""} \n${orderItem?.pickupFrom?.city.toString()??""} ${orderItem?.pickupFrom?.pincode.toString()??""}",
                              style: TextStyle(
                                  fontFamily: "Poppins",
                                  color: AppColors.colorBlack,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w400)),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        text: 'Drop Off Location\n',
                        style: TextStyle(
                            fontFamily: "Poppins",
                            color: AppColors.alphabetFunContainer4,
                            fontSize: 14,
                            fontWeight: FontWeight.w600),
                        children:  <TextSpan>[
                          TextSpan(
                              text:
                              "${orderItem?.dropOutAt?.address.toString()??""} \n${orderItem?.dropOutAt?.city.toString()??""} ${orderItem?.dropOutAt?.pincode.toString()??""}",
                              style: TextStyle(
                                  fontFamily: "Poppins",
                                  color: AppColors.colorBlack,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w400)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                          text: 'Pick up : ',
                          style: TextStyle(
                              fontFamily: "Poppins",
                              color: AppColors.alphabetFunContainer4,
                              fontSize: 12,
                              fontWeight: FontWeight.w600),
                          children:  <TextSpan>[
                            TextSpan(
                                text: orderItem?.pickupDate?.toString()??"",
                                style: TextStyle(
                                    fontFamily: "Poppins",
                                    color: AppColors.colorBlack,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500)),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      RichText(
                        text: TextSpan(
                          text: 'Drop off : ',
                          style: TextStyle(
                              fontFamily: "Poppins",
                              color: AppColors.alphabetFunContainer4,
                              fontSize: 12,
                              fontWeight: FontWeight.w600),
                          children:  <TextSpan>[
                            TextSpan(
                                text: orderItem?.dropOutDate?.toString()??"",
                                style: TextStyle(
                                    fontFamily: "Poppins",
                                    color: AppColors.colorBlack,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        "Status: ",
                        style: TextStyle(
                            fontFamily: "Poppins",
                            color: AppColors.alphabetFunContainer4,
                            fontSize: 14,
                            fontWeight: FontWeight.w500),
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: orderItem?.status == "none"?AppColors.colorTomato:
                            orderItem?.status=="shipped"?AppColors.progressBarColor:
                            AppColors.alphabetFunContainer4,
                            borderRadius: BorderRadius.circular(5),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.drawerColor1,
                                offset: const Offset(2.0, 2.0),
                                blurRadius: 2.0,
                                spreadRadius: 0.0,
                              ),
                            ]),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 3),
                          child: Text(
                            orderItem?.status.toString()??"",
                            style: TextStyle(
                                fontFamily: "Poppins",
                                color: AppColors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
