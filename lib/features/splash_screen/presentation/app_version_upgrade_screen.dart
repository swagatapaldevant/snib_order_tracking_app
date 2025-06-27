import 'package:flutter/material.dart';
import 'package:snib_order_tracking_app/core/utils/constants/app_colors.dart';
import 'package:snib_order_tracking_app/core/utils/helper/screen_utils.dart';
import 'package:url_launcher/url_launcher.dart';

class AppVersionUpgradeScreen extends StatefulWidget {
  final String url;
  const AppVersionUpgradeScreen({super.key, required this.url});

  @override
  State<AppVersionUpgradeScreen> createState() => _AppVersionUpgradeScreenState();
}

class _AppVersionUpgradeScreenState extends State<AppVersionUpgradeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding:  EdgeInsets.all(ScreenUtils().screenWidth(context)*0.04),
          child: Container(
            width:ScreenUtils().screenWidth(context) ,
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
              padding:  EdgeInsets.all(ScreenUtils().screenWidth(context)*0.04),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Please update your App : ",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          fontFamily: "Poppins",
                          color: AppColors.alphabetFunContainer4),
                    ),
                    SizedBox(height: ScreenUtils().screenHeight(context)*0.05,),
              GestureDetector(
                onTap: () async {
                  final Uri url = Uri.parse(widget.url);
                  try {
                    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Could not launch link")),
                      );
                    }
                  } catch (e) {
                    debugPrint("Error launching URL: $e");
                  }
                },
                child: Text(
                  widget.url,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    fontFamily: "Poppins",
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
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
