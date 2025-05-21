import 'package:flutter/material.dart';
import 'package:snib_order_tracking_app/core/utils/commonWidgets/common_button.dart';
import 'package:snib_order_tracking_app/core/utils/commonWidgets/custom_textField.dart';
import 'package:snib_order_tracking_app/core/utils/constants/app_colors.dart';
import 'package:snib_order_tracking_app/core/utils/helper/screen_utils.dart';

class SigninScreen extends StatefulWidget {
  const SigninScreen({super.key});

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: ScreenUtils().screenHeight(context),
        width: ScreenUtils().screenWidth(context),
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColors.drawerColor, AppColors.drawerColor1])),
        child: Padding(
          padding: EdgeInsets.all(ScreenUtils().screenWidth(context) * 0.04),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Login",
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: AppColors.white,
                    fontSize: 30),
              ),
              SizedBox(height: ScreenUtils().screenHeight(context) * 0.01),
              Text(
                "Please login the app to access the app content",
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: AppColors.white,
                    fontSize: 14),
              ),
              SizedBox(height: ScreenUtils().screenHeight(context) * 0.05),
              CustomTextField(
                controller: emailController,
                hintText: 'Enter your email',
                prefixIcon: Icons.email,
              ),
              SizedBox(height: ScreenUtils().screenHeight(context) * 0.01),
              CustomTextField(
                controller: passwordController,
                hintText: 'Password',
                prefixIcon: Icons.lock,
                suffixIcon: Icons.visibility,
                isPassword: true,
              ),
              SizedBox(height: ScreenUtils().screenHeight(context) * 0.05),
              CommonButton(
                onTap: () {
                  Navigator.pushReplacementNamed(context, "/DashboardScannerScreen");
                },
                height: ScreenUtils().screenHeight(context) * 0.05,
                width: ScreenUtils().screenWidth(context),
                buttonName: "Sign in",
                borderRadius: 12,
                buttonTextColor: AppColors.white,
                fontSize: 18,
                gradientColor1: AppColors.rewardBg,
                gradientColor2: AppColors.exploreCardColor,
              )
            ],
          ),
        ),
      ),
    );
  }
}

