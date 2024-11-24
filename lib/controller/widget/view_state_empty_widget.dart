import 'package:flutter/material.dart';

import 'view_state_widget.dart';

/// display empty page
class ViewStateEmptyWidget extends StatelessWidget {
  /// error message
  final String? message;

  /// image show on the top list
  final Widget? image;

  /// refresh button message
  final String? buttonText;

  /// call back on press on screen
  final VoidCallback onPressed;

  const ViewStateEmptyWidget({
    Key? key,
    this.image,
    this.message,
    this.buttonText,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewStateWidget(
      onPressed: this.onPressed,
      image: image,
      message: message,
      buttonText: buttonText,
    );
  }
}