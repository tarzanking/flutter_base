import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottery/config/app_config.dart';
import 'package:lottery/res/label.dart';
import 'package:navigation_history_observer/navigation_history_observer.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'bindings/initial_binding.dart';
import 'controller/language_controller.dart';
import 'res/colors.dart';
import 'routes/app_pages.dart';
import 'routes/app_routes.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  String get initialRoute => AppRoutes.splashScreenPage;

  @override
  Widget build(BuildContext context) {
    return KeyboardDismissOnTap(
      child: RefreshConfiguration(
        headerBuilder: () {
          return const MaterialClassicHeader(
            backgroundColor: Colors.black,
            color: Colors.red,
          );
        },
        footerBuilder: () {
          return CustomFooter(
            builder: (BuildContext context, LoadStatus? mode) {
              Widget? body;
              if (mode == LoadStatus.loading) {
                body = const CircularProgressIndicator();
              } else if (mode == LoadStatus.noMore) {
                body = Text(Label.noMoreData.tr,
                  style: Theme.of(context).textTheme.displayMedium,
                );
              }
              return SizedBox(
                height: 55.0,
                child: Center(child: body,),
              );
            },
          );
        },
        hideFooterWhenNotFull: false,
        enableBallisticLoad: true,
        child: GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: Get.find<AppConfig>().config.appName ?? '',
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('zh', 'CN'),
            Locale('en', 'US'),
          ],
          locale: Get.find<LanguageController>().appLocale,
          fallbackLocale: const Locale('en'),
          theme: _getTheme(),
          getPages: AppPage.routes,
          initialRoute: initialRoute,
          initialBinding: InitialBinding(),
          navigatorObservers: [NavigationHistoryObserver()],
        ),
      ),
    );
  }

  ThemeData _getTheme({bool isDarkMode = false}) {
    return ThemeData(
      colorScheme: isDarkMode
          ? const ColorScheme.dark(
        error: Colours.colorRedText,
        primary: Colours.primary,
        secondary: Colours.primary,
      )
          : const ColorScheme.light(
          error: Colours.colorRedText,
          primary: Colours.primary,
          secondary: Colours.primary),
      scaffoldBackgroundColor: isDarkMode ? Colours.scaffoldDarkBg : Colours.scaffoldBg,
      primaryColor: Colours.primary,
      primaryColorDark: Colours.primaryDark,
      useMaterial3: false,
      iconTheme: const IconThemeData(color: Colors.white),
      highlightColor: const Color.fromRGBO(255, 255, 255, .05),
      splashColor: Colors.transparent,
      bottomAppBarTheme: const BottomAppBarTheme(color: Colours.colorTabBar),
      textSelectionTheme:
      const TextSelectionThemeData(cursorColor: Colors.white),
      appBarTheme: AppBarTheme(color: Colors.black, titleTextStyle: GoogleFonts.inter(
          fontSize: 16.0,
          color: isDarkMode ? Colours.colorNormalText : Colors.white,
          fontWeight: FontWeight.w700
      )),
      dialogBackgroundColor: Colours.colorTagBg,
      textTheme: TextTheme(
        titleSmall: isDarkMode
            ? const TextStyle(fontSize: 14, color: Colors.white)
            : const TextStyle(fontSize: 14, color: Colors.black),
        titleMedium: isDarkMode
            ? const TextStyle(fontSize: 14, color: Colors.white)
            : const TextStyle(fontSize: 14, color: Colors.black),
        bodySmall: isDarkMode
            ? const TextStyle(color: Color(0xFF888888), fontSize: 16.0)
            : const TextStyle(color: Color(0xFF888888), fontSize: 16.0),
        bodyMedium: isDarkMode
            ? const TextStyle(color: Color(0xffcccccc), fontSize: 14.0)
            : const TextStyle(color: Colors.black54, fontSize: 14.0),
        // regular
        displaySmall: GoogleFonts.inter(
            fontSize: 14,
            color: !isDarkMode ? Colors.white : Colours.colorNormalText,
            fontWeight: FontWeight.w400),
        // medium
        displayMedium: GoogleFonts.inter(
            fontSize: 14,
            color: !isDarkMode ? Colors.white : Colours.colorNormalText,
            fontWeight: FontWeight.w500),
        // bold
        displayLarge: GoogleFonts.inter(
            fontSize: 14,
            color: !isDarkMode ? Colors.white : Colours.colorNormalText,
            fontWeight: FontWeight.w700),
        // light
        headlineSmall: GoogleFonts.inter(
            fontSize: 14,
            color: !isDarkMode ? Colors.white : Colours.colorNormalText,
            fontWeight: FontWeight.w300),
        // black
        headlineLarge: GoogleFonts.inter(
            fontSize: 14,
            color: !isDarkMode ? Colors.white : Colours.colorNormalText,
            fontWeight: FontWeight.w900),
        labelSmall: GoogleFonts.inter(
          color: !isDarkMode ? Colors.white : Colours.colorNormalText,
        ),
      ),
      tabBarTheme: const TabBarTheme(
        unselectedLabelColor: Colors.white,
        labelColor: Colors.white,
      ),
      dividerColor: Colours.colorDivider,
    );
  }
}
