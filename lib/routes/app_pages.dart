import 'package:get/get.dart';
import 'package:lottery/bindings/landing_binding.dart';
import 'package:lottery/pages/landing_page.dart';
import 'package:lottery/pages/splash_screen_page.dart';
import 'package:lottery/routes/app_routes.dart';

class AppPage {
  static final routes = [
    GetPage(
        name: AppRoutes.landingPage,
        page: () => LandingPage(),
        binding: LandingBinding()),
    GetPage(
      name: AppRoutes.splashScreenPage,
      page: () => const SplashScreenPage(),
    ),
  ];
}
