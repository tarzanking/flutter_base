import 'package:lottery/global/define.dart';

import 'config.dart';

enum Env {
  dev,
  prod
}

class AppConfig {
  late Config config;

  String get appName => Define.appName;
  Env get env => Env.values.firstWhere((element) => element.toString() == "Env.${Define.appEnv}", orElse: () => Env.prod);

  AppConfig() {
    switch(this.env) {
      case Env.dev :
        {
          config = Config(
            appName: 'Lottery',
            appUrlKey: 'https://api-metarewards.securevws.com/api/app',
          );
        }
        break;
      case Env.prod :
        {
          config = Config(
            appName: 'Lottery',
            appUrlKey: 'https://app-api.meta-rewards.biz/api/app',
          );
        }
        break;
    }
  }

  @override
  String toString() {
    return "appUrlKey : ${config.appUrlKey}\n"
        "appName : $appName\n"
        "jPushPkgName : ${config.jPushPkgName}\n"
        "jPushAppKey : ${config.jPushAppKey}\n"
        "jPushChannel : ${config.jPushChannel}\n";
  }
}