
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';

import '../constants/app_colors.dart';
import '../constants/app_string.dart';
import '../helper/screen_utils.dart';

class CommonHeader extends StatelessWidget {
  final bool isDashBoard;
  final Function()? onPressed;
  const CommonHeader({super.key,  this.isDashBoard = true, this.onPressed,});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.all(ScreenUtils().screenWidth(context) * 0.045),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              isDashBoard?Bounceable(
                onTap:onPressed,
                child: Icon(
                  Icons.menu,
                  color: AppColors.colorPrimaryText,
                ),
              ):Bounceable(
                onTap:(){
                  Navigator.pop(context);
                },
                child: Icon(
                  Icons.arrow_back,
                  color: AppColors.colorPrimaryText,
                ),
              ),
              SizedBox(
                width: ScreenUtils().screenWidth(context) * 0.05,
              ),
              Text(
                AppStrings.educareErp,
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppColors.darkBlue,
                    fontFamily: "Poppins",
                    fontSize: ScreenUtils().screenWidth(context)*0.042),
              ),
            ],
          ),
          Icon(
            Icons.shopping_cart,
            color: AppColors.colorPrimaryText,
          ),
        ],
      ),
    );
  }
}
