import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottery/config/app_config.dart';
import 'package:lottery/routes/app_routes.dart';

class SplashScreenPage extends StatefulWidget {
  const SplashScreenPage({super.key});

  @override
  State<SplashScreenPage> createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage>
    with TickerProviderStateMixin {

  @override
  void initState() {
    super.initState();
    enterLandingPage();
  }

  enterLandingPage() async{
    await Future.delayed(Duration(seconds: 2));
    Get.offAndToNamed(AppRoutes.homePage);
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
            color: Colors.greenAccent,
            child: Center(
              child: Text(
                Get.find<AppConfig>().appName,
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontSize: 50),
              ),
            ),
          )
        ),
      ),
    );
  }
}
