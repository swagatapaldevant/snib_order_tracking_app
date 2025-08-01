import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:snib_order_tracking_app/core/network/apiHelper/api_endpoint.dart';
import 'package:snib_order_tracking_app/core/network/apiHelper/locator.dart';
import 'package:snib_order_tracking_app/core/network/dioClient/dio_client.dart';
import 'package:snib_order_tracking_app/core/services/localStorage/shared_pref.dart';
import 'package:snib_order_tracking_app/core/utils/constants/app_colors.dart';
import 'package:snib_order_tracking_app/core/utils/helper/common_utils.dart';
import 'package:snib_order_tracking_app/core/utils/helper/screen_utils.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late Animation<double> _logoScaleAnimation;

  late AnimationController _textController;
  late Animation<double> _textFadeAnimation;
  final SharedPref _pref = getIt<SharedPref>();
  final Dio _dio = DioClient().dio;
  bool isLoading = false;
  String appVersion = "1.2";


  @override
  void initState() {
    super.initState();

    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..forward();

    _logoScaleAnimation = Tween<double>(begin: 0.2, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.elasticOut),
    );

    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _textFadeAnimation = CurvedAnimation(
      parent: _textController,
      curve: Curves.easeIn,
    );

    // Delay before showing text
    Future.delayed(const Duration(milliseconds: 1000), () {
      _textController.forward();
    });

    // Navigation
    Future.delayed(const Duration(seconds: 2), () {
      checkToken();
      //Navigator.pushReplacementNamed(context, "/SigninScreen");
    });
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = ScreenUtils().screenHeight(context);
    final screenWidth = ScreenUtils().screenWidth(context);

    return Scaffold(
      body: Stack(
        children: [
          CustomPaint(
            size: Size(screenWidth, screenHeight),
            painter: SplashBackgroundPainter(),
          ),

          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ScaleTransition(
                  scale: _logoScaleAnimation,
                  child: Image.asset(
                    "assets/icons/S&IB.png",
                    height: ScreenUtils().screenHeight(context) * 0.13,
                    width: ScreenUtils().screenWidth(context) * 0.7,
                    fit: BoxFit.fill,
                  ),
                ),
                const SizedBox(height: 10),
                // FadeTransition(
                //   opacity: _textFadeAnimation,
                //   child: Text(
                //     "Welcome!!",
                //     textAlign: TextAlign.center,
                //     style: TextStyle(
                //         color: AppColors.darkBlue,
                //         fontSize: 28,
                //         fontWeight: FontWeight.w700,
                //         letterSpacing: 1.2,
                //         fontFamily: "Poppins"
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // void setTimerNavigation() async {
  //   String token = await _pref.getUserAuthToken();
  //   bool loginStatus = await _pref.getLoginStatus();
  //   String userType = await _pref.getUserType();
  //
  //   try {
  //     if (token.length > 10) {
  //       Navigator.pushReplacementNamed(context, "/DashboardScreen");
  //     }
  //     else{
  //       Navigator.pushReplacementNamed(context, "/SigninScreen");
  //     }
  //
  //   } catch (ex) {
  //     Navigator.pushReplacementNamed(context, "/SigninScreen");
  //   }
  // }


  Future<void> checkToken() async {
    // setState(() {
    //   //isLoading = true;
    // });
    try {
      final authToken = await _pref.getUserAuthToken();
      final response = await _dio.get(
        ApiEndPoint.tokenVerify,
        options: Options(
          headers: {
            'Authorization': 'Bearer $authToken',
          },
        ),
      );
      if (response.statusCode == 200) {
        //
        if(appVersion == response.data["appVersion"].toString())
          {
            Navigator.pushReplacementNamed(context, "/DashboardScreen");
          }
        else{
          Navigator.pushReplacementNamed(context, "/AppVersionUpgradeScreen", arguments: response.data["appDownloadLink"].toString());
        }

      } else {
        Navigator.pushReplacementNamed(context, "/SigninScreen");
      }

      setState(() {
        isLoading = false;
      });
    } on DioException catch (e) {
      if (e.response != null) {
        Navigator.pushReplacementNamed(context, "/SigninScreen");

        print("Dio error response: ${e.response?.data}");
      } else {
        Navigator.pushReplacementNamed(context, "/SigninScreen");

        print("Dio error message: ${e.message}");
      }
      setState(() {
        isLoading = false;
      });
    }
  }

}

class SplashBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint1 = Paint()
      ..shader = LinearGradient(
        colors: [
          AppColors.blue.withOpacity(0.8),
          AppColors.blue.withOpacity(0.3),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final path1 = Path()
      ..moveTo(0, size.height * 0.75)
      ..quadraticBezierTo(
          size.width * 0.3, size.height * 0.7, size.width * 0.6, size.height)
      ..lineTo(0, size.height)
      ..close();

    final paint2 = Paint()..color = AppColors.blue.withOpacity(0.2);

    final path2 = Path()
      ..moveTo(size.width, size.height * 0.4)
      ..quadraticBezierTo(
          size.width * 0.6, size.height * 0.5, 0, size.height * 0.2)
      ..lineTo(0, 0)
      ..lineTo(size.width, 0)
      ..close();

    canvas.drawPath(path1, paint1);
    canvas.drawPath(path2, paint2);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
