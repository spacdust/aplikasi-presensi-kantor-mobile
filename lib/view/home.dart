import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:presencemobile/controller/login_controller.dart';
import 'package:presencemobile/view/beranda_page.dart';
import 'package:presencemobile/view/history_page.dart';
import 'package:presencemobile/view/precense_page.dart';

import 'package:presencemobile/view/profile_page.dart';
import 'package:sizer/sizer.dart';

import '../controller/home_controller.dart';
import '../theme/colors.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

List<Widget> pages = [
  const BerandaPage(),
  const BerandaPage(),
  const BerandaPage(),
  const ProfilePage(),
  //const SettingView(),
];

class _HomePageState extends State<HomePage> {
  late String _timeString = "";
  late String _dateString = "";
  int pageIndex = 0;
  final HomeController controller = Get.put(HomeController());
  final LoginController logincontroller = Get.put(LoginController());
  @override
  void initState() {
    _timeString = _formatDateTime(DateTime.now());
    _dateString = _formatDateTime2(DateTime.now());

    Timer.periodic(const Duration(seconds: 1), (Timer t) => _getTime());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final localBox = GetStorage();

    return Sizer(builder: (context, orientation, deviceType) {
      return MaterialApp(
        home: Scaffold(
          body: getBody(pageIndex),
          // bottomNavigationBar: getFooter()
        ),
      );
    });
  }

  void _getTime() {
    final DateTime now = DateTime.now();
    final String formattedDateTime = _formatDateTime(now);
    final String formattedDateTime2 = _formatDateTime2(now);
    if (mounted) {
      setState(() {
        _timeString = formattedDateTime;
        _dateString = formattedDateTime2;
      });
    }
  }

  String _formatDateTime(DateTime dateTime) {
    return DateFormat('hh:mm').format(dateTime);
  }

  String _formatDateTime2(DateTime dateTime) {
    return DateFormat('EEEE, d MMMM y', "id_ID").format(dateTime);
  }

  Widget getBody(int pageIndex) {
    return Obx(() => IndexedStack(
          index: controller.numberPageIndex.value,
          children: pages,
        ));
  }

  Widget getFooter() {
    List<IconData> iconItems = [
      CupertinoIcons.home,
      Icons.document_scanner,
      CupertinoIcons.chart_bar_square,
      CupertinoIcons.person,
      //CupertinoIcons.person,
    ];
    return Obx(
      () => AnimatedBottomNavigationBar(
          backgroundColor: primary,
          icons: iconItems,
          splashColor: primary.withAlpha(50),
          inactiveColor: Colors.white.withOpacity(0.5),
          activeColor: Colors.white,
          activeIndex: controller.numberPageIndex.value,
          gapLocation: GapLocation.none,
          iconSize: 25,
          elevation: 2,
          notchSmoothness: NotchSmoothness.verySmoothEdge,
          onTap: (index) {
            setTabs(index);
          }),
    );
  }

  setTabs(index) {
    setState(() {
      controller.numberPageIndex.value = index;
      pageIndex = index;
    });
    printInfo(info: "index : " + index.toString());
    // if (index == 0) {
    //   Get.to(() => const HomePage());
    // } else if (index == 1) {
    //   Get.to(() => const PresencePage());
    // } else if (index == 2) {
    //   Get.to(() => const HistoryPage());
    // } else if (index == 3) {
    //   Get.to(() => const ProfilePage());
    // }
  }
}
