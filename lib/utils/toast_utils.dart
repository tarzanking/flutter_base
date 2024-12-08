import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottery/res/colors.dart';

class ToastUtils {

  static void show({String? message, bool short = true, Color? bgColor = Colours.colorDivider}) {
    Fluttertoast.showToast(
      msg: message ?? '',
      toastLength: short ? Toast.LENGTH_SHORT : Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: bgColor,
    );
  }

  static void cancel() {
    Fluttertoast.cancel();
  }
}