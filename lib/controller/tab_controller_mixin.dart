import 'package:flutter/material.dart';

mixin TabControllerMixin {
  late TabController tabController;
  bool _initialized = false;
  bool get isTabControllerInitialized => _initialized;

  initializeTabController(TabController tabController, StateSetter state) {
    if (!_initialized || this.tabController.hashCode != tabController.hashCode) {
      _initialized = true;
      this.tabController = tabController;
      this.tabController.addListener(() {
        state(() {});
      });
    }
  }
}