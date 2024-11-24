import 'package:get/get_connect/http/src/status/http_status.dart';

class ResponseEntity<T> {
  late bool success;
  late String message;
  int? statusCode;

  T? data;
  List<T> listData = [];
  List list = [];

  ResponseEntity({
    required this.success,
    required this.message,
    this.statusCode,
  });


  ResponseEntity.fromJson(Map json, {T Function(Object json)? fromJsonT}) {
    message = json["msg"] == null ? '' : json["msg"];

    String rst = '0';
    if (json["rst"] != null) {
      if (json["rst"] is String) {
        rst = json["rst"];
      } else {
        rst = json["rst"].toString();
      }
    }

    if (rst == '1') {
      success = true;
    } else {
      success = false;
      statusCode = HttpStatus.badRequest;
    }

    List listObject(List list) {
      List newList = [];
      for (int i = 0; i < list.length; i++) {
        var item = list[i];
        if (item is List) {
          newList.add(listObject(item));
        } else if (item is String || item is int || item is double) {
          newList = list;
          break;
        } else {
          newList.add(fromJsonT?.call(item));
        }
      }
      return newList;
    }

    var _data = json["data"];
    if (_data != null) {
      if (_data is List) {
        _data.forEach((item) {
          if (item is List) {
            List tempList = listObject(item);
            list.add(tempList);
          } else {
            if (fromJsonT != null) {
              listData.add(fromJsonT(item));
            } else {
              listData.add(item);
            }
          }
        });
      } else {
        if (fromJsonT != null) {
          data = fromJsonT(_data);
        } else {
          data = _data;
        }
      }
    }
  }


}