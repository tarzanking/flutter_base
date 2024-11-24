import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// display the loading indicator
class ViewStateBusyWidget extends StatelessWidget {

  ViewStateBusyWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Theme.of(context).brightness == Brightness.light
          ? CupertinoTheme(
        data: CupertinoThemeData(brightness: Brightness.light),
        child: CupertinoActivityIndicator(),
      )
          : CupertinoActivityIndicator(),
    );
  }
}