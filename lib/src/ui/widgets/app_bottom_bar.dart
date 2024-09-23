import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../gen/assets.gen.dart';
import '../../infrastructure/resources/app_colors.dart';
import '../screens/cart/cart_screen.dart';
import '../screens/collections/collection_screen.dart';
import '../screens/main/main_screen.dart';
import '../screens/settings/settings_screen.dart';
import 'app_button.dart';

class AppBottomBarState extends State<AppBottomBar> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.indexScr;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: ClipRRect(
        child: Container(
          color: AppColors.gray2C2C2E,
          height: 120.h,
          width: MediaQuery.of(context).size.width,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: buildNavItem(0, Assets.svg.home),
              ),
              Expanded(
                child: buildNavItem(1, Assets.svg.star),
              ),
              Expanded(
                child: buildNavItem(2, Assets.svg.shop),
              ),
              Expanded(
                child: buildNavItem(3, Assets.svg.settings),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildNavItem(int index, String iconPath) {
    bool isActive = _currentIndex == index;

    return AppButton(
      onPressed: () {
        setState(() {
          _currentIndex = index;
        });
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(18.r),
            decoration: BoxDecoration(
              color: isActive ? AppColors.red : Colors.transparent,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: SvgPicture.asset(
              iconPath,
              width: 30.sp,
              height: 30.sp,
              color:  AppColors.white,
            ),
          ),
          SizedBox(height: 8.h),
        ],
      ),
    );
  }

  final _pages = <Widget>[
    const MainScreen(),
    const CollectionScreen(),
    const CartScreen(),
    const SettingsScreen(),
  ];
}

class AppBottomBar extends StatefulWidget {
  const AppBottomBar({super.key, this.indexScr = 0});
  final int indexScr;

  @override
  State<AppBottomBar> createState() => AppBottomBarState();
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Your App Title',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const AppBottomBar(),
    );
  }
}
