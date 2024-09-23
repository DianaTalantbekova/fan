import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../gen/assets.gen.dart';
import '../../../infrastructure/resources/app_colors.dart';
import '../../../infrastructure/resources/app_styles.dart';
import '../../widgets/app_button.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            children: [
              SizedBox(height: 20.h),
              AppButton(
                onPressed: () {},
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  height: 44.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.r),
                    color: AppColors.gray2C2C2E,
                  ),
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        Assets.svg.privacy,
                        fit: BoxFit.contain,
                        width: 24.w,
                        height: 24.h,
                      ),
                      SizedBox(width: 10.w),
                      Text(
                        'Privacy Policy',
                        style: AppStyles.helper2.copyWith(fontSize: 16.sp),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10.h),
              AppButton(
                onPressed: () {},
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  height: 44.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.r),
                    color: AppColors.gray2C2C2E,
                  ),
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        Assets.svg.terms,
                        fit: BoxFit.contain,
                        width: 24.w,
                        height: 24.h,
                      ),
                      SizedBox(width: 10.w),
                      Text(
                        'Terms of Use',
                        style: AppStyles.helper2.copyWith(fontSize: 16.sp),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10.h),
              AppButton(
                onPressed: () {},
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  height: 44.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.r),
                    color: AppColors.gray2C2C2E,
                  ),
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        Assets.svg.support,
                        fit: BoxFit.contain,
                        width: 24.w,
                        height: 24.h,
                      ),
                      SizedBox(width: 10.w),
                      Text(
                        'Support',
                        style: AppStyles.helper2.copyWith(fontSize: 16.sp),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10.h),
              AppButton(
                onPressed: () {},
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  height: 44.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.r),
                    color: AppColors.gray2C2C2E,
                  ),
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        Assets.svg.share,
                        fit: BoxFit.contain,
                        width: 24.w,
                        height: 24.h,
                      ),
                      SizedBox(width: 10.w),
                      Text(
                        'Share',
                        style: AppStyles.helper2.copyWith(fontSize: 16.sp),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
