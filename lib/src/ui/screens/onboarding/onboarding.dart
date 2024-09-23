import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../infrastructure/resources/app_colors.dart';
import '../../../infrastructure/resources/app_styles.dart';
import '../../../infrastructure/utils/box_assets.dart';
import '../../widgets/app_bottom_bar.dart';
import '../../widgets/app_button.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  @override
  _OnboardingState createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  int currentIndex = 0;
  late PageController _controller;

  @override
  void initState() {
    _controller = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: _controller,
                  itemCount: boxAssets.length,
                  onPageChanged: (int index) {
                    setState(() {
                      currentIndex = index;
                    });
                  },
                  itemBuilder: (_, i) {
                    return Column(
                      children: [
                        SizedBox(height: 20.h),
                        Text(
                          boxAssets[i].text,
                          style: AppStyles.helper1,
                        ),
                        SizedBox(height: 40.h),
                        Image.asset(
                          boxAssets[i].asset,
                          fit: BoxFit.cover,
                          height: 432.h,
                          width: double.infinity,
                        ),
                      ],
                    );
                  },
                ),
              ),
              AppButton(
                onPressed: _nextPage,
                child: Container(
                  alignment: Alignment.center,
                  height: 52.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.r),
                    color: AppColors.red,
                  ),
                  child: Text(
                    'Continue',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 20.sp,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10.h),
              if (currentIndex > 0)
                AppButton(
                  onPressed: _prevPage,
                  child: Container(
                    alignment: Alignment.center,
                    height: 52.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.r),
                      color: AppColors.black,
                    ),
                    child: Text(
                      'Back',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 20.sp,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              SizedBox(height: 15.h),
            ],
          ),
        ),
      ),
    );
  }

  void _nextPage() {
    if (currentIndex < boxAssets.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AppBottomBar(),
        ),
      );
    }
  }

  void _prevPage() {
    if (currentIndex > 0) {
      _controller.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    }
  }
}
