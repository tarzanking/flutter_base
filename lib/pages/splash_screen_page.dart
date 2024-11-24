import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottery/routes/app_routes.dart';

class SplashScreenPage extends StatefulWidget {
  const SplashScreenPage({super.key});

  @override
  State<SplashScreenPage> createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage>
    with TickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> translateIconFirst;
  late Animation<double> opacityBg;
  late Animation<Offset> translateIconSecond;
  late Animation<double> opacityIconSecond;

  late Image imageBg;
  late Image imageIconSecond;
  late Image imageIconLicense1;
  late Image imageIconLicense2;
  late Image imageIconLicense3;
  late Image imageIconSplashScreen;

  bool goToAppLanding = false;

  @override
  void initState() {
    super.initState();
    Get.offAndToNamed(AppRoutes.landingPage);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.blueAccent,
        child: ConstrainedBox(
          constraints:
              BoxConstraints.expand(width: Get.width, height: Get.height),
          child: Container(

          )
        ),
      ),
    );
  }
}
