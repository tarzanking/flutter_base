
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:lottery/config/app_config.dart';
import 'package:lottery/global/local_storage.dart';
import 'package:lottery/global/secure_local_storage.dart';
import 'package:lottery/res/label.dart';
import 'package:lottery/server/response_entity.dart';

extension MapEx on Map? {
  StringBuffer logString(String title) {
    StringBuffer requestLog = StringBuffer();
    requestLog.writeln('===================== $title =====================');
    this?.forEach((key, value) {
      requestLog.writeln('$key = $value');
    });
    return requestLog;
  }

  Map<String, dynamic> get baseParams {
    Map<String, dynamic> params;
    if (this == null) {
      params = Map();
    } else {
      params = Map.from(this!);
    }
    params['langID'] = Get.find<LocalStorage>().langId;
    params['username'] = Get.find<LocalStorage>().memberCode;
    params['token'] = Get.find<SecureLocalStorage>().accessToken;
    return params;
  }
}

extension ResponseEx on Response {
  StringBuffer get responseLog {
    StringBuffer responseLog = StringBuffer();
    responseLog.writeln('===================== Response =====================');
    responseLog.writeln('statusCode = ${this.statusCode}');
    responseLog.writeln('url = ${this.request?.url}');
    responseLog.writeln('data = ${this.bodyString}');
    return responseLog;
  }

  StringBuffer get errorLog {
    StringBuffer errorLog = StringBuffer();
    errorLog.writeln('===================== Error =====================');
    errorLog.writeln('url = ${this.request?.url}');
    errorLog.writeln('statusCode = ${this.statusCode}');
    errorLog.writeln('message = ${this.statusText}');
    errorLog.writeln('data = ${this.bodyString}');
    return errorLog;
  }
}

class ServerRepository extends GetConnect {

  @override
  void onInit() {
    super.onInit();

    httpClient.baseUrl = Get.find<AppConfig>().config.appUrlKey;
    httpClient.timeout = Duration(seconds: 30);

    httpClient.addResponseModifier((request, response) {

      if (response.isOk) {
        Get.find<Logger>().d(response.responseLog);
      } else {
        Get.find<Logger>().d(response.errorLog);
      }

      return response;
    });
  }

  Future<ResponseEntity<T>> loadEntityData<T>(
      String url, {
        String method = 'POST',
        Map<String, dynamic>? body,
        String? contentType,
        Map<String, String>? headers,
        Map<String, dynamic>? query,
        T Function(dynamic)? decoder,
        dynamic Function(double)? uploadProgress
      }) async {
    try {
      body = body?.baseParams;

      final requestLog = Map.from({
        'url' : url,
        'headers' : headers,
        'method' : method,
        'body' : body,
        'query' : query,
      }).logString('Request');

      Get.find<Logger>().d(requestLog);

      var response = await request<ResponseEntity<T>>(
          url,
          method,
          body: body,
          contentType: contentType,
          headers: headers,
          query: query,
          decoder: (data) => data is Map ? ResponseEntity<T>.fromJson(data, fromJsonT: decoder)
              : ResponseEntity(success: false, message: Label.parse_error.tr),
          uploadProgress: uploadProgress
      );

      if (response.isOk) {
        return response.body!;
      } else if (response.statusCode == null) {
        return ResponseEntity(success: false, message: Label.connection_error.tr);
      } else {
        return ResponseEntity(success: false, message: response.statusText ?? '', statusCode: response.statusCode);
      }

    } catch(e, s) {
      final runTimeLog = Map.from({
        'url' : url,
        'headers' : headers,
        'method' : method,
        'body' : body,
        'query' : query,
        'info' : decoder == null ? '### Please check the decoder whether is null ###' : '### Parse Error ###'
      }).logString('Runtime Error');

      // Get.find<Logger>().wtf(runTimeLog, e, s);

      return ResponseEntity(success: false, message: Label.parse_error.tr);
    }
  }
}