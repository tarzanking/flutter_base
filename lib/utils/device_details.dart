import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:get/get.dart';

class DeviceDetails extends GetxService {
  final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();

  String? _model;
  String? _osVersion;
  String? _manufacture;

  Future<DeviceDetails> init() async {
    if (Platform.isIOS) {
      final iosDeviceInfo = await deviceInfoPlugin.iosInfo;
      _model = iosDeviceInfo.model;
      _osVersion = iosDeviceInfo.systemVersion;
      _manufacture = 'APPLE';
    } else if (Platform.isAndroid) {
      final androidDeviceInfo = await deviceInfoPlugin.androidInfo;
      _model = androidDeviceInfo.model;
      _osVersion = androidDeviceInfo.version.release;
      _manufacture = androidDeviceInfo.manufacturer;
    }
    return this;
  }

  String get os => Platform.operatingSystem;

  String get model => _model ?? '';

  String get osVersion => _osVersion ?? '';

  String get manufacture => _manufacture ?? '';
}