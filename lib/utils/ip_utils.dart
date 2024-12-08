import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:lottery/utils/data_extension.dart';

class IpUtils {
  Map<String, dynamic> ipInfo = {};
  String get timeZone => ipInfo.mapValue('timezone', defaultValue: '');
  String get country => ipInfo.mapValue('country', defaultValue: '');
  bool get isChinaCountry => country == 'CN';
  String get ip => ipInfo.mapValue('ip', defaultValue: '');
  String get region => ipInfo.mapValue('region', defaultValue: '');
  String get ipRegion => '$region($ip)';
  int serverTimeOffset = 0;

  Future<IpUtils> init() async {
    return this;
  }

  getIpInfo() async {
    try {
      final response = await http.get(Uri.parse('https://ipinfo.io/json'));
      if (response.statusCode == 200) {
        final bodyMap = jsonDecode(response.body);
        ipInfo = bodyMap;
      }
    } catch (e) {
      debugPrint('Get IP info error');
    }
  }
}