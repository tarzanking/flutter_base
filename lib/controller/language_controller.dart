import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:lottery/global/local_storage.dart';
import 'package:lottery/model/language_model.dart';
import 'package:lottery/model/select_option.dart';

class LanguageController {
  late Locale appLocale;

  List<LanguageModel> languageList = [
    LanguageModel(locale: 'en', name: 'English', fbName: 'ENG', animLiveName: 'en'),
    LanguageModel(locale: 'zh-cn', name: '简体中文', fbName: 'CMN', animLiveName: 'zh'),
  ];

  List<SelectOption> get languageListSelection => List.generate(languageList.length, (index) {
    return SelectOption(id: index, name: languageList[index].name);
  });

  List<String> get _languageList => languageList.map((e) => e.locale ?? '').toList();

  final selectedLangIndex = 0.obs;
  String get langName {
    if (selectedLangIndex.value < languageList.length) {
      return languageList.elementAt(selectedLangIndex.value).name ?? '';
    }
    return '';
  }
  String get fbLangName {
    if (selectedLangIndex.value < languageList.length) {
      return languageList.elementAt(selectedLangIndex.value).fbName ?? '';
    }
    return '';
  }

  String get animLiveLangName {
    if (selectedLangIndex.value < languageList.length) {
      return languageList.elementAt(selectedLangIndex.value).animLiveName ?? '';
    }
    return '';
  }

  Future<LanguageController> init() async {
    // await _getLanguageList();
    // await _loadTranslation();
    await _fetchLocale();
    return this;
  }

  changeLanguage(int index,{bool init=false}) async {
    if (languageList.isNotEmpty) {
      await Get.find<LocalStorage>().setLangId(languageList.elementAt(index).locale);
      selectedLangIndex.value = index;
      if(init){
        appLocale = Locale(languageList.elementAt(index).locale ?? 'en');
      }else{
        Get.updateLocale(Locale(languageList.elementAt(index).locale ?? 'en'));
      }
    }
  }

  _fetchLocale({bool checkLocal = true}) async {

    final String locale = Get.find<LocalStorage>().langId;
    if (locale.isNotEmpty && checkLocal) {
      final int index = languageList.indexWhere((element) => element.locale == locale);
      if (index != -1) {
        selectedLangIndex.value = index;
        appLocale = Locale(locale);
      }
    } else {
      int? defaultIndex;
      for (int i = 0; i < _languageList.length; i++) {
        if (_languageList.elementAt(i).contains(Get.deviceLocale?.languageCode ?? '')) {
          defaultIndex = i;
          break;
        }
      }
      if (defaultIndex != null) {
        await changeLanguage(defaultIndex,init: true);
      } else {
        await changeLanguage(0, init: true);
      }
    }
  }

  // _getLanguageList() async {
  //   var entity = await Get.find<ServerRepoUser>().loadEntityData(Api.languages,
  //       decoder: (json) => LanguageModel.fromJson(json), method: 'GET');
  //   if (entity.success) {
  //     languageList = entity.listData;
  //   }
  // }

  // _loadTranslation() async {
  //   List<Map<String, dynamic>> jsonMap = [];
  //
  //   final appList = await _fetchFromApi(await Get.find<ConfigController>().translationAppUrl);
  //   final apiList = await _fetchFromApi(await Get.find<ConfigController>().translationApiUrl);
  //
  //   try {
  //     if (appList.isNotEmpty) {
  //       jsonMap = appList;
  //       jsonMap.addAll(apiList);
  //     } else {
  //       jsonMap = await _fetchFromLocal();
  //     }
  //   } catch (e) {
  //     jsonMap = await _fetchFromLocal();
  //   }
  //
  //   Map<String, Map<String, String>> translate = {};
  //   for (var element in _languageList) {
  //     translate[element] = jsonMap.asMap().map((key, value) {
  //       if (value.containsKey(element)) {
  //         return MapEntry(value['key'], value[element].toString());
  //       }
  //       return const MapEntry('', '');
  //     });
  //   }
  //   Get.addTranslations(translate);
  // }

  Future<List<Map<String, dynamic>>> _fetchFromLocal() async {
    List<Map<String, dynamic>> jsonMap = [];

    String jsonString = await rootBundle.loadString('assets/translations/translation.json');
    jsonMap = List.from(json.decode(jsonString).map((x) => x));

    String jsonStringApi = await rootBundle.loadString('assets/translations/translation_api.json');
    List<Map<String, dynamic>> jsonMapApi = List.from(json.decode(jsonStringApi).map((x) => x));
    jsonMap.addAll(jsonMapApi);

    return jsonMap;
  }

  Future<List<Map<String, dynamic>>> _fetchFromApi(String url) async {
    try {
      final res = await http.get(Uri.parse(url));
      if (res.statusCode == 200) {
        final data = utf8.decode(res.bodyBytes);
        List<Map<String, dynamic>> jsonMap = List.from(json.decode(data).map((x) => x));
        return jsonMap;
      }
    } catch (e) {
      debugPrint('Fetch translation error');
    }

    return [];
  }

  Future<List<Map<String, dynamic>>> _fetchFromGoogleSheet(int gid) async {
    try {
      final target = 'https://docs.google.com/spreadsheets/d/e/2PACX-1vSwohUWmHDRGw7mRS2zVHe94jTH57Qxk8uZDhQ2MU-qNb2egiBRXgistDA4zEjmr8aA-liZiShXcxmK/pub?gid=$gid&single=true&output=tsv';
      final res = await http.get(Uri.parse(target), headers: {'Content-Type': 'text/csv;charset=UTF-8'});

      if (res.statusCode == 200) {
        final data = res.body;
        const separator = '\t';
        final output = <Map<String, String>>[];

        final rows = data.replaceAll('\u2028', '\n').replaceAll('\u2029', '\n').split('\r\n');
        final keys = rows[0].split(separator);

        rows.removeAt(0); // Remove the first element (keys) from the list

        for (final row in rows) {
          final items = row.split(separator);
          final temp = <String, String>{};
          for (var idx = 0; idx < items.length; idx++) {
            temp[keys[idx]] = items[idx];
          }

          output.add(temp);
        }

        return output;
      }
    } catch (e) {
      debugPrint('Fetch translation error');
    }

    return [];
  }
}