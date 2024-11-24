import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottery/res/label.dart';

import 'custom_button.dart';

class MessageDialog extends StatelessWidget {
  final String message;

  final bool isError;
  final bool dismissible;
  final VoidCallback? onSubmit;

  const MessageDialog(this.message,
      {super.key, this.isError = false, this.dismissible = true, this.onSubmit});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: dismissible,
      onPopInvokedWithResult: (bool didPop, Object? result) {
        if (kDebugMode) {
          print('PopScope result is what $result');
        }
        if (didPop) {
          return;
        }
      },
      child: Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
        child: Container(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(bottom: 12.0),
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border:
                        Border.all(color: isError ? Colors.red : Colors.green)),
                child: isError
                    ? Icon(
                        Icons.clear,
                        color: Colors.red,
                      )
                    : Icon(
                        Icons.done,
                        color: Colors.green,
                      ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: Text(
                  isError ? Label.error.tr : Label.success.tr,
                  style: Theme.of(context)
                      .textTheme
                      .displayMedium
                      ?.copyWith(fontSize: 18.0, color: Colors.black),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 18.0),
                child: Text(
                  message,
                  style: Theme.of(context)
                      .textTheme
                      .displayMedium
                      ?.copyWith(color: Colors.black, fontSize: 16.0),
                ),
              ),
              CustomButton(
                Label.ok.tr,
                onPressed: () {
                  Navigator.of(context).pop();
                  onSubmit?.call();
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
