import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottery/global/define.dart';
import 'package:lottery/utils/date_manager.dart';
import 'package:navigation_history_observer/navigation_history_observer.dart';
import 'package:pinyin/pinyin.dart';
extension DateEx on double? {
  int get second {
    if (this == null) {
      return 0;
    }
    return (this! * 60).round();
  }
}

extension DateTimeEx on DateTime? {
  bool get isToday {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    if (this != null) {
      final checkDate = DateTime(this!.year, this!.month, this!.day);
      return checkDate == today;
    } else {
      return false;
    }
  }
}

extension ControllerEx on TextEditingController {
  void setTextAndSelection(String text) {
    this.text = text;
    selection = TextSelection.collapsed(offset: text.length);
  }

  void setRestrictTextAndSelection(String text, {
    double? minValue, double? maxValue, int decimalRange = 0,
    bool setSelection = true, bool needRestrict = true}) {
    if (needRestrict) {
      final RegExp regExp = RegExp(r'^0[1-9]');

      if (text.startsWith('00')) {
        return;
      } else if (regExp.hasMatch(text)) {
        this.text = text.substring(1);
        selection = TextSelection.collapsed(offset: this.text.length);
        return;
      }

      double value = double.tryParse(text.replaceAll(',', '')) ?? 0.0;

      if (minValue != null && value < minValue) {
        return;
      } else if (maxValue != null && value > maxValue) {
        return;
      }

      if (decimalRange > 0) {
        final RegExp reg = RegExp("^([0-9]*([.][0-9]{0,$decimalRange}){0,1}){0,1}\$");
        if (!reg.hasMatch(text)) {
          return;
        }
      }

      this.text = text.format;
      if (setSelection) {
        selection = TextSelection.collapsed(offset: this.text.length);
      }
    } else {
      final RegExp reg = RegExp(r'^[^.]*\.[^.]*$');
      if (!reg.hasMatch(text)) {
        return;
      }

      this.text = text;
      if (setSelection) {
        selection = TextSelection.collapsed(offset: this.text.length);
      }
    }
  }
}

extension MapEx on Map<String, dynamic>? {
  mapValue(String key, {dynamic defaultValue}) {
    if (this?.containsKey(key) == true) {
      return this![key];
    } else {
      return defaultValue;
    }
  }
}

extension MapIntEx on Map<int, String> {
  String mapValue(int? key, {String? defaultValue}) {
    if (containsKey(key)) {
      return this[key]!;
    } else {
      return defaultValue ?? '';
    }
  }
}

extension StringEx on String {
  String get firstChar {
    return length > 0 ? this[0] : '';
  }

  bool get validPassword {
    final RegExp regExp = RegExp(r"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]{8,}$");
    return regExp.hasMatch(this);
  }

  bool get validUsername {
    final RegExp regExp = RegExp('[^A-Za-z0-9]');
    return regExp.hasMatch(this);
  }

  String get format {
    double temp = double.tryParse(replaceAll(',', '')) ?? 0.0;
    return NumberFormat('###,##0.##').format(temp);
  }

  String get signedMd5 {
    var bytes = utf8.encode(this);
    var digest = md5.convert(bytes);
    return digest.toString();
  }

  bool get checkConsecutiveRepeatChar {
    for (int i = 0; i < length - 1; i++) {
      if (this[i] == this[i + 1]) {
        return false;
      }
    }
    return true;
  }

  bool get existInStack {
    bool routeExists = false;

    for (var route in NavigationHistoryObserver().history) {
      if (route.settings.name == this) {
        routeExists = true;
        break;
      }
    }

    return routeExists;
  }

  String get formatWalletAddress {
    if (length > 14) {
      final first = substring(0, 7);
      final endSecond = length - 7;
      final second = substring(endSecond, length);
      return '$first...$second';
    }
    return this;
  }

  String potentialWin(double? odds) {
    final amount = double.tryParse(replaceAll(',', '')) ?? 0;
    final win = amount * (odds ?? 0);
    final winDeduct = win - amount;
    return winDeduct.format.withCurrency;
  }
}

extension StringNullEx on String? {
  String formatAsFixed(int digit) {
    double temp = double.tryParse(this ?? '0') ?? 0.0;
    return temp.toStringAsFixed(digit);
  }

  String get withCurrency {
    if(this?.startsWith('-') == true) {
      return '-${Define.currencyCode} ${this?.substring(1)}';
    }
    return '${Define.currencyCode} ${this ?? ''}';
  }

  String get withCurrencyWithoutSpace {
    if(this?.startsWith('-') == true) {
      return '-${Define.currencyCode}${this?.substring(1)}';
    }
    return '${Define.currencyCode}${this ?? ''}';
  }

  String get withCurrencyWithoutNegative {
    if(this?.startsWith('-') == true) {
      return '${Define.currencyCode}${this?.substring(1)}';
    }
    return '${Define.currencyCode}${this ?? ''}';
  }

  String get formatTime {
    if (this?.isNotEmpty == true) {
      int startIndex = this!.indexOf('[');
      int endIndex = this!.indexOf(']');
      if (startIndex != -1 && endIndex != -1) {
        String result = this!.substring(startIndex + 1, endIndex);
        final list = result.split('-');
        if (list.length == 2) {
          int milliFirst = int.tryParse(list.elementAt(0)) ?? 0;
          int milliSec = int.tryParse(list.elementAt(1)) ?? 0;
          final dtFirst = DateTime.fromMillisecondsSinceEpoch(milliFirst);
          final dtSec = DateTime.fromMillisecondsSinceEpoch(milliSec);
          final displayFirst = DateManager.formatDateToString(dtFirst, dateFormat: 'dd/MM/yy HH:mm');
          final displaySec = DateManager.formatDateToString(dtSec, dateFormat: 'dd/MM/yy HH:mm');
          return '$displayFirst - $displaySec';
        }
      }
    }
    return this ?? '';
  }

  String? get filterChineseWord {
    if (this?.isNotEmpty == true) {
      final firstWord = this?.substring(0, 1) ?? '';
      RegExp chineseRegex = RegExp(r'[\u4e00-\u9fa5]');
      if (chineseRegex.hasMatch(firstWord)) {
        return PinyinHelper.getFirstWordPinyin(firstWord);
      }
    }
    return this?.toLowerCase();
  }
}

extension DoubleEx on double {
  String get format {
    return NumberFormat('###,##0.##').format(this);
  }
}

extension IntEx on int? {
  String get formatViews {
    int number = this ?? 0;
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    }
    return number.toString();
  }
}

extension ScoreEx on List<int>? {
  int score(int? sportType) {
    int totalScore = 0;
    if (this != null) {
      if (sportType == 1) {
        if (this!.length >= 6) {
          totalScore = this![5] > 0 ? this![5] : this![0];
        }
      } else if (sportType == 2) {
        for (var element in this!) {
          totalScore += element;
        }
      } else {
        if (this!.isNotEmpty) {
          totalScore = this![0];
        }
      }
    }
    return totalScore;
  }
}
