import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:snib_order_tracking_app/features/auth/presentation/login_screen.dart';
import 'package:snib_order_tracking_app/features/dashboard/model/getOrderListModel.dart';
import 'package:snib_order_tracking_app/features/dashboard/presentation/acknowledge_image_upload_screen.dart';
import 'package:snib_order_tracking_app/features/dashboard/presentation/dashboard_scanner_screen.dart';
import 'package:snib_order_tracking_app/features/dashboard/presentation/dashboard_screen.dart';
import 'package:snib_order_tracking_app/features/dashboard/presentation/order_item_details_screen.dart';
import 'package:snib_order_tracking_app/features/dashboard/presentation/otp_verification_screen.dart';
import 'package:snib_order_tracking_app/features/dashboard/presentation/qr_generator_screen.dart';
import 'package:snib_order_tracking_app/features/dashboard/presentation/success_screen.dart';
import 'package:snib_order_tracking_app/features/splash_screen/presentation/splash_screen.dart';
import '../../utils/helper/app_fontSize.dart';

class RouteGenerator{

  // general navigation
  static const kSplash = "/";
  static const kSigninScreen = "/SigninScreen";
  static const kDashboardScannerScreen = "/DashboardScannerScreen";
  static const kAcknowledgeImageUploadScreen = "/AcknowledgeImageUploadScreen";
  static const kSuccessScreen = "/SuccessScreen";
  static const kQrGeneratorScreen = "/QrGeneratorScreen";
  static const kOtpScreen = "/OtpScreen";
  static const kDashboardScreen = "/DashboardScreen";
  static const kOrderItemDetailsScreen = "/OrderItemDetailsScreen";






  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static Route<dynamic> generateRoute(RouteSettings settings){

    final args = settings.arguments;
    switch(settings.name){

      case kSplash:
        //return MaterialPageRoute(builder: (_)=>SplashScreen());
        return _animatedPageRoute(SplashScreen());
     case kSigninScreen:
        return _animatedPageRoute(SigninScreen());
    case kDashboardScannerScreen:
        return _animatedPageRoute(DashboardScannerScreen());
      case kAcknowledgeImageUploadScreen:
        final args = settings.arguments as Map<String, dynamic>;
        return _animatedPageRoute(
          AcknowledgeImageUploadScreen(
            requisitionId: args['requisition'],
            routeListId: args['routeListId'],
            otp: args['otp'],
            type: args['type'],
          ),
        );
    case kSuccessScreen:
        return _animatedPageRoute(SuccessScreen());
    case kQrGeneratorScreen:
        return _animatedPageRoute(QrGeneratorScreen());
    case kDashboardScreen:
        return _animatedPageRoute(DashboardScreen());
    case kOtpScreen:
      final args = settings.arguments as Map<String, dynamic>;
        return _animatedPageRoute(
            OtpScreen(orderItem: args["orderItem"], type: args["type"],));
    case kOrderItemDetailsScreen:
        return _animatedPageRoute(OrderItemDetailsScreen(orderItem: args as GetOrderList,));



      default:
        return _errorRoute(errorMessage: "Route not found: ${settings.name}");

    }

  }

  static Route<dynamic> _animatedPageRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) {
        return page;  // The page to navigate to
      },
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        // Define the transition animation

        // Slide from the right (Offset animation)
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        final curve = Curves.easeInToLinear;  // A more natural easing curve

        var offsetTween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(offsetTween);

        // Scale transition (page zooms in slightly)
        var scaleTween = Tween(begin: 0.95, end: 1.0);
        var scaleAnimation = animation.drive(scaleTween);

        // Fade transition (opacity increases from 0 to 1)
        var fadeTween = Tween(begin: 0.0, end: 1.0);
        var fadeAnimation = animation.drive(fadeTween);

        // Return a combination of Slide, Fade, and Scale
        return SlideTransition(
          position: offsetAnimation,
          child: FadeTransition(
            opacity: fadeAnimation,
            child: ScaleTransition(
              scale: scaleAnimation,
              child: Material(
                color: Colors.transparent,
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0), // Add blur effect
                  child: child,
                ),
              ),
            ),
          ),
        );

      },
    );
  }




  static Route<dynamic> _errorRoute(
      {
        String errorMessage = '',
      }
      ) {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            "Error",
            style: Theme.of(_)
                .textTheme
                .displayMedium
                ?.copyWith(color: Colors.black),
          ),
        ),
        body: Center(
          child: Column(
            children: [
              Text(
                "Oops something went wrong",
                style: Theme.of(_).textTheme.displayMedium?.copyWith(
                    fontSize: AppFontSize.textExtraLarge,
                    color: Colors.black),
              ),
              Text(
                errorMessage,
                style: Theme.of(_).textTheme.displayMedium?.copyWith(
                    fontSize: AppFontSize.textExtraLarge,
                    color: Colors.black),
              ),
            ],
          ),
        ),
      );
    });
  }
}