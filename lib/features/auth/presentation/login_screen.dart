import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:snib_order_tracking_app/core/network/apiHelper/api_endpoint.dart';
import 'package:snib_order_tracking_app/core/network/apiHelper/locator.dart';
import 'package:snib_order_tracking_app/core/network/dioClient/dio_client.dart';
import 'package:snib_order_tracking_app/core/services/localStorage/shared_pref.dart';
import 'package:snib_order_tracking_app/core/utils/commonWidgets/common_button.dart';
import 'package:snib_order_tracking_app/core/utils/commonWidgets/custom_textField.dart';
import 'package:snib_order_tracking_app/core/utils/constants/app_colors.dart';
import 'package:snib_order_tracking_app/core/utils/helper/common_utils.dart';
import 'package:snib_order_tracking_app/core/utils/helper/screen_utils.dart';

class SigninScreen extends StatefulWidget {
  const SigninScreen({super.key});

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool rememberMe = false;
  bool obscureText = true;
  final Dio _dio = DioClient().dio;
  final SharedPref _pref = getIt<SharedPref>();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Interval(0.2, 1.0, curve: Curves.easeIn),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            // Top background image
            Image.asset(
              "assets/icons/signin.png",
              width: ScreenUtils().screenWidth(context),
              height: ScreenUtils().screenHeight(context) * 0.45,
              fit: BoxFit.cover,
            ),

            Column(
              children: [
                SizedBox(height: ScreenUtils().screenHeight(context) * 0.3),

                // Main content container
                Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 16),
                      // Email field
                      _animatedChild(
                          index: 0,
                          child: CustomTextField(
                              controller: emailController,
                              hintText: "Enter your userId",
                              prefixIcon: Icons.email)),
                      SizedBox(
                          height: ScreenUtils().screenHeight(context) * 0.015),

                      _animatedChild(
                        index: 1,
                        child: CustomTextField(
                          controller: passwordController,
                          hintText: 'Password',
                          prefixIcon: Icons.lock,
                          suffixIcon: Icons.visibility,
                          isPassword: true,
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Remember me and Forgot Password
                      _animatedChild(
                        index: 2,
                        child: Row(
                          children: [
                            Checkbox(
                              value: rememberMe,
                              onChanged: (val) {
                                setState(() {
                                  rememberMe = val!;
                                });
                              },
                            ),
                            const Text(
                              "Remember me",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.colorBlack,
                                  fontSize: 14),
                            ),
                            const Spacer(),
                            GestureDetector(
                              onTap: () {},
                              child: const Text(
                                "Forgot Password ?",
                                style: TextStyle(
                                    color: AppColors.gray7,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600),
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                          height: ScreenUtils().screenHeight(context) * 0.05),

                      // Log In Button
                      _animatedChild(
                          index: 3,
                          child: isLoading
                              ? CircularProgressIndicator(
                                  color: AppColors.darkBlue,
                                )
                              : CommonButton(
                                  onTap: () {
                                    if (emailController.text.isNotEmpty &&
                                        passwordController.text.isNotEmpty) {
                                      loginUser(
                                          emailController.text
                                              .trim()
                                              .toString(),
                                          passwordController.text
                                              .trim()
                                              .toString());
                                    } else {
                                      CommonUtils().flutterSnackBar(
                                          context: context,
                                          mes:
                                              "Please enter userId and password",
                                          messageType: 4);
                                    }


                                  },
                                  height: 48,
                                  width: ScreenUtils().screenWidth(context),
                                  buttonName: "Signin",
                                  fontSize: 16,
                                  borderRadius: 10,
                                  buttonTextColor: AppColors.white,
                                  gradientColor1: AppColors.blue,
                                  gradientColor2:
                                      AppColors.blue.withOpacity(0.5))),

                      SizedBox(
                          height: ScreenUtils().screenHeight(context) * 0.05),
                      _animatedChild(
                        index: 4,
                        child: Image.asset(
                          "assets/icons/S&IB.png",
                          height: ScreenUtils().screenHeight(context) * 0.1,
                          width: ScreenUtils().screenWidth(context) * 0.5,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _animatedChild({required int index, required Widget child}) {
    return FadeTransition(
      opacity: CurvedAnimation(
        parent: _controller,
        curve: Interval(0.2 + index * 0.1, 1.0, curve: Curves.easeIn),
      ),
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.3),
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: _controller,
          curve: Interval(0.2 + index * 0.1, 1.0, curve: Curves.easeOut),
        )),
        child: child,
      ),
    );
  }

  Future<void> loginUser(String email, String password) async {
    setState(() {
      isLoading = true;
    });
    try {
      final response = await _dio.post(
        ApiEndPoint.loginApi,
        data: {
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        _pref.setUserAuthToken(response.data["token"].toString());
        _pref.setId(response.data["logedInUser"]["_id"].toString());
        _pref.setUserId(response.data["logedInUser"]["userId"].toString());
        _pref.setUserName(response.data["logedInUser"]["name"]);
        if(response.data["logedInUser"]["userType"].toString() == "deliverypartner")
          {
            Navigator.pushNamed(context, "/DashboardScreen");
          }

        print("Login successful: ${response.data["token"]}");
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
