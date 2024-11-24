import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:heibola/widget/custom_loading_indicator.dart';

class Show {
  static var _loadDialog;

  static showLoading({bool barrierDismissible = false}) {
    _loadDialog ??= _showLoadingDialog(barrierDismissible: barrierDismissible);
  }

  static stopLoading() {
    if (_loadDialog != null) {
      Get.back();
      _loadDialog = null;
    }
  }

  static Future _showLoadingDialog({bool barrierDismissible = false}) {
    return Get.dialog(
        PopScope(
          canPop: barrierDismissible,
          onPopInvokedWithResult: (pop, _) {
            if (pop) {
              _loadDialog = null;
            }
          },
          child: Center(
            child: Container(
              color: Colors.red,
              width: 40,
              height: 40,
            ),
            // child: CustomLoadingIndicator(),
          ),
        )
    );
  }
}