import 'package:flutter/material.dart';

class ViewStateWidget extends StatefulWidget {
  /// the image display on the top list
  final Widget? image;

  /// show error message, hide on null
  final String? message;

  /// button to display message refresh the screen, hide on null
  final String? buttonText;

  /// callback function onTap
  final VoidCallback? onPressed;

  /// auto call the [onPressed]
  final bool initToggle;

  ViewStateWidget({
    Key? key,
    this.image,
    this.message,
    this.buttonText,
    this.onPressed,
    this.initToggle = false,
  }) : super(key: key);

  @override
  _ViewStateWidgetState createState() => _ViewStateWidgetState();
}

class _ViewStateWidgetState extends State<ViewStateWidget> {
  @override
  void initState() {
    super.initState();
    if (widget.initToggle) {
      Future.delayed(Duration.zero, () {
        widget.onPressed?.call();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPressed,
      child: Container(
        width: double.infinity,
        color: Colors.transparent,
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Offstage(
                offstage: widget.image == null,
                child: Container(
                  margin: const EdgeInsets.only(left: 16.0, right: 16.0, top: 50.0),
                  child: widget.image,
                ),
              ),
              Offstage(
                offstage: widget.message == null,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(30, 20, 30, 20),
                  child: Text(
                    widget.message ?? '',
                    style: Theme.of(context).textTheme.displayMedium,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Offstage(
                offstage: widget.buttonText == null,
                child: Text(
                  widget.buttonText ?? '',
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      color: Theme.of(context).primaryColor
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}