import 'package:flutter/material.dart';
import 'package:lottery/res/colors.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final bool upperCase;
  final VoidCallback? onPressed;
  final double radius;
  final Color textColor;
  final Color backgroundColor;
  final Color? disabledColor;
  final Color? borderColor;
  final bool? isFlat;
  final int maxLines;
  final EdgeInsets? padding;
  final double fontSize;
  final double borderWidth;
  final TextStyle? textStyle;
  final bool buttonFittedBox;

  const CustomButton(
      this.text,
      {super.key,
        this.onPressed,
        this.upperCase = false,
        this.borderColor,
        this.isFlat,
        this.radius = 8.0,
        this.textColor = Colors.white,
        this.backgroundColor = Colours.colorRedText,
        this.disabledColor,
        this.maxLines = 1,
        this.padding,
        this.fontSize = 14.0,
        this.borderWidth = 1.0,
        this.textStyle,
        this.buttonFittedBox = false,
      });

  factory CustomButton.passive(String text, {VoidCallback? onPressed}) {
    return CustomButton(text, backgroundColor: Colours.colorPassiveButton, onPressed: onPressed,);
  }

  @override
  Widget build(BuildContext context) {
    return isFlat == true ? TextButton(
      style: TextButton.styleFrom(
        padding: padding ?? const EdgeInsets.all(12.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
      onPressed: onPressed,
      child: Text(upperCase ? text.toUpperCase() : text,
        style: Theme.of(context).textTheme.displayLarge?.copyWith(
            color: textColor,
            fontSize: fontSize
        ),
        overflow: TextOverflow.ellipsis,
        maxLines: maxLines,
        textAlign: TextAlign.center,
      ),
    ) : ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: padding ?? const EdgeInsets.all(12.0),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius),
            side: borderColor == null ? BorderSide.none : BorderSide(color: borderColor!, width: borderWidth)
        ),
        elevation: 3.0,
        backgroundColor: backgroundColor,
        disabledBackgroundColor: disabledColor,
      ),
      onPressed: onPressed,
      child: buttonFittedBox ?
      FittedBox(
          child: Text(upperCase ? text.toUpperCase() : text,
            style: textStyle ?? Theme.of(context).textTheme.displayLarge?.copyWith(
                color: textColor,
                fontSize: fontSize
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: maxLines,
            textAlign: TextAlign.center,
          )
      )
          : Text(upperCase ? text.toUpperCase() : text,
        style: textStyle ?? Theme.of(context).textTheme.displayLarge?.copyWith(
            color: textColor,
            fontSize: fontSize
        ),
        overflow: TextOverflow.ellipsis,
        maxLines: maxLines,
        textAlign: TextAlign.center,
      ),
    );
  }
}