import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottery/controller/landing_controller.dart';
import 'package:lottery/res/colors.dart';
import 'package:lottery/res/label.dart';
import 'package:lottery/utils/toast_utils.dart';
import 'package:lottery/widget/load_image.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {

  bool _canPop = false;

  _isExit(bool pop) {
    if (!pop) {
      ToastUtils.show(message: Label.clickAgainToExitTheApp.tr);
      Future.delayed(2500.milliseconds, () {
        setState(() {
          _canPop = false;
        });
      });
      setState(() {
        _canPop = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _canPop,
      onPopInvoked: _isExit,
      child: GetBuilder<LandingController>(
        init: LandingController(),
        builder: (controller) {
          return DefaultTabController(
            length: controller.tabListLength,
            child: Scaffold(
              body: Stack(
                children: [
                  Column(
                    children: [
                      Expanded(
                        child: TabBarView(
                          physics: const NeverScrollableScrollPhysics(),
                          children: controller.tabsList.map((e) => e.page).toList(),
                        ),
                      ),
                      Container(
                        color: Colours.colorTabBar,
                        padding: EdgeInsets.only(bottom: Platform.isIOS ? 8.0 : 0),
                        child: StatefulBuilder(
                          builder: (context, state) {
                            final tabController = DefaultTabController.of(context);
                            controller.initializeTabController(tabController, state);

                            return TabBar(
                              indicatorColor: Colors.transparent,
                              labelColor: Colors.white,
                              unselectedLabelColor: Colours.colorInactiveTab,
                              labelStyle: Theme.of(context).textTheme.displaySmall?.copyWith(
                                  fontSize: 10.0
                              ),
                              labelPadding: const EdgeInsets.symmetric(horizontal: 8.0),
                              onTap: (index) {
                                if (index == 0 && controller.currentTabIndex.value == 0) {
                                  controller.onScrollHomeToTop();
                                }
                                controller.currentTabIndex.value = index;
                              },
                              tabs: List.generate(controller.tabListLength, (index) {
                                final title = controller.tabsList.elementAt(index).title;
                                return Tab(
                                  text: title,
                                  iconMargin: const EdgeInsets.only(bottom: 4.0),
                                  icon: LoadAssetImage(
                                    tabController.index == index ?
                                    controller.tabsList.elementAt(index).activeIcon :
                                    controller.tabsList.elementAt(index).inactiveIcon,
                                    color: tabController.index == index ? Colours.colorActiveTab : Colours.colorInactiveTab,
                                    width: title != null ? 20.0 : 52.0,
                                    height: title != null ? 20.0 : 52.0,
                                  ),
                                );
                              }),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
