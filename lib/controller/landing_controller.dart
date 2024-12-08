import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lottery/controller/base/state_controller.dart';
import 'package:lottery/controller/tab_controller_mixin.dart';
import 'package:lottery/pages/homePage/home_page.dart';
import 'package:lottery/pages/secondPage/second_page.dart';
import 'package:lottery/res/label.dart';
import 'package:lottery/utils/device_details.dart';
import 'package:lottery/utils/ip_utils.dart';

class TabBarData {
  final String activeIcon;
  final String inactiveIcon;
  final String? title;
  final Widget page;

  TabBarData({
    this.activeIcon = '',
    this.inactiveIcon = '',
    this.title,
    required this.page,
  });
}

class LandingController extends StateController
    with WidgetsBindingObserver, TabControllerMixin {
  static const tag = 'LandingController';

  DeviceDetails get _deviceDetails => Get.find<DeviceDetails>();

  final List<TabBarData> tabsList = [];
  final currentTabIndex = 0.obs;

  int get tabListLength => tabsList.length;

  ScrollController scrollControllerHome = ScrollController();
  Offset? chatBotOffset;
  Timer? _timer;
  Timer? _timerHeartBeat;
  StreamSubscription? subscription;
  final Connectivity _connectivity = Connectivity();
  bool _networkConnected = true;
  final networkConnected = true.obs;
  final appInForeground = true.obs;
  DateTime? _leaveTime;
  DateTime? _stayTime;

  _onTabIndexChanged(int index) {}

  @override
  void onInit() {
    WidgetsBinding.instance.addObserver(this);
    _initBottomTab();
    debounce(currentTabIndex, (index) => _onTabIndexChanged(index));
    _initConnectivity();
    subscription = _connectivity.onConnectivityChanged.listen((event) async {
      if (!_networkConnected && !event.contains(ConnectivityResult.none)) {
        _networkConnected = true;
        await Get.find<IpUtils>().init();

        networkConnected.value = true;
      } else if (event.contains(ConnectivityResult.none) && _networkConnected) {
        networkConnected.value = false;
        _networkConnected = false;
      }
    });
    _stayTime = DateTime.now();
    super.onInit();
  }

  _initBottomTab() {
    tabsList.addAll([
      TabBarData(
        activeIcon: 'home',
        inactiveIcon: 'home',
        title: Label.home.tr,
        page: const HomePage(),
      ),
      TabBarData(
        activeIcon: 'home',
        inactiveIcon: 'home',
        title: Label.secondPage.tr,
        page: const SecondPage(),
      ),
    ]);
  }

  refreshBottomTab() {
    tabsList.clear();
    _initBottomTab();
    update();
  }

  onScrollHomeToTop() {
    if (scrollControllerHome.position.pixels != 0) {
      scrollControllerHome.animateTo(0.0,
          duration: 800.milliseconds, curve: Curves.fastOutSlowIn);
    }
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    _timer?.cancel();
    _timerHeartBeat?.cancel();
    subscription?.cancel();
    scrollControllerHome.dispose();
    super.onClose();
  }

  @override
  void onReady() async {
    super.onReady();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      appInForeground.value = true;
      _stayTime = DateTime.now();
      if (_leaveTime != null) {
        final timeDifference = DateTime.now().difference(_leaveTime!);
      }
    } else if (state == AppLifecycleState.paused) {
      appInForeground.value = false;
      _leaveTime = DateTime.now();
      if (_stayTime != null) {
        final timeDifference = DateTime.now().difference(_stayTime!);
        _stayTime = null;
        print('Last Stay time: $timeDifference');
      }
    }
  }

  _initConnectivity() async {
    try {
      final result = await _connectivity.checkConnectivity();
      if (result.contains(ConnectivityResult.none)) {
        networkConnected.value = false;
        _networkConnected = false;
      }
    } on PlatformException {
      debugPrint('Check connectivity error');
    }
  }
}
