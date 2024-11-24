import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:lottery/config/app_config.dart';
import 'package:lottery/controller/language_controller.dart';
import 'package:lottery/controller/profile_controller.dart';
import 'package:lottery/global/define.dart';
import 'package:lottery/global/local_storage.dart';
import 'package:lottery/global/secure_local_storage.dart';
import 'package:lottery/server/server_repository.dart';
import 'package:lottery/utils/device_details.dart';
import 'package:lottery/utils/package_details.dart';

class SubMain {
  static Future initServices() async {
    await SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

    // init logger
    var logger = Logger(
        output: ConsoleOutput(),
        printer: HybridPrinter(
            PrettyPrinter(),
            debug: PrettyPrinter(printTime: true)
        )
    );
    Get.put(logger, permanent: true);

    Get.config(
        enableLog: !Define.inProduction,
        defaultPopGesture: true,
        defaultTransition: Transition.cupertino
    );

    // setup app config
    var appConfig = AppConfig();
    Get.put(appConfig, permanent: true);
    logger.v(appConfig.toString());

    Get.put(ServerRepository(), permanent: true);

    // init local storage services
    await Get.putAsync(() => LocalStorage().init());
    await Get.putAsync(() => SecureLocalStorage().init());

    // init deviceDetails and packageDetails
    await Get.putAsync(() => DeviceDetails().init());
    Get.put(PackageDetails(), permanent: true);

    // init profile controller and call get profile
    var profileController = ProfileController();
    Get.put(profileController, permanent: true);
    await profileController.init();

    await Get.putAsync(() => LanguageController().init(), permanent: true);
  }
}

class ConsoleOutput extends LogOutput {
  @override
  void output(OutputEvent event) {
    if (event.level == Level.debug) {
      for (var line in event.lines) {
        Get.log(line);
      }
    } else {
      for (var line in event.lines) {
        print(line);
      }
    }
  }
}