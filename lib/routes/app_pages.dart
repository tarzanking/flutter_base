import 'package:get/get.dart';
import 'package:lottery/bindings/landing_binding.dart';
import 'package:lottery/pages/homePage/home_page.dart';
import 'package:lottery/pages/landing_page.dart';
import 'package:lottery/pages/secondPage/second_page.dart';
import 'package:lottery/pages/splash/splash_screen_page.dart';
import 'package:lottery/routes/app_routes.dart';

class AppPage {
  static final routes = [
    GetPage(
        name: AppRoutes.landingPage,
        page: () => const LandingPage(),
        binding: LandingBinding()),
    GetPage(
      name: AppRoutes.splashScreenPage,
      page: () => const SplashScreenPage(),
    ),
    GetPage(
      name: AppRoutes.homePage,
      page: () => const HomePage(),
    ),
    GetPage(
      name: AppRoutes.secondPage,
      page: () => const SecondPage(),
    ),
  ];
}
