import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:snib_order_tracking_app/core/utils/helper/screen_utils.dart';

class AttachFileContainerWidget extends StatelessWidget {
  final Color bgColor;
  final IconData icon;
  final Color textColor;
  final String text;
  Function()? onTap;
  AttachFileContainerWidget(
      {super.key,
        required this.bgColor,
        required this.icon,
        required this.textColor,
        required this.text,
        this.onTap
      });

  @override
  Widget build(BuildContext context) {
    return Bounceable(
      onTap: onTap,
      child: Container(
        height: ScreenUtils().screenHeight(context) * 0.16,
        width: ScreenUtils().screenWidth(context) * 0.38,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), color: bgColor),
        child: Padding(
          padding: EdgeInsets.all(ScreenUtils().screenWidth(context) * 0.03),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: ScreenUtils().screenWidth(context)*0.08,
                color: textColor,
              ),
              Text(
                text,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: textColor,
                    fontSize: ScreenUtils().screenWidth(context)*0.032,
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w500),
              )
            ],
          ),
        ),
      ),
    );
  }
}
