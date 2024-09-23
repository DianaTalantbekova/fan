import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../gen/assets.gen.dart';
import '../../../domain/models/fan_model.dart';
import '../../../infrastructure/resources/app_colors.dart';
import '../../../infrastructure/resources/app_styles.dart';
import '../../widgets/app_button.dart';
import '../../widgets/confirmation_dialog.dart';
import '../add_fan/bloc/fan_bloc.dart';
import '../total_cost/total_cost_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool expensive = false;
  bool recents = false;
  bool abc = false;
  bool xyz = false;

  @override
  void initState() {
    super.initState();
    context.read<FanBloc>().add(LoadFans());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 20.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              height: 33.h,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildCategory('Expensive', expensive, () {
                    setState(() {
                      expensive = !expensive;
                    });
                  }),
                  _buildCategory('Recents', recents, () {
                    setState(() {
                      recents = !recents;
                    });
                  }),
                  _buildCategory('ABC→', abc, () {
                    setState(() {
                      abc = !abc;
                    });
                  }),
                  _buildCategory('←XYZ', xyz, () {
                    setState(() {
                      xyz = !xyz;
                    });
                  }),
                ],
              ),
            ),
            SizedBox(height: 10.h),
            Expanded(
              child: BlocBuilder<FanBloc, FanState>(
                builder: (context, state) {
                  if (state is FanLoaded) {
                    List<FanModel> fanItems =
                        state.fans.where((fan) => fan.isCart ?? false).toList();

                    if (expensive) {
                      fanItems.sort(
                              (a, b) => b.price?.compareTo(a.price ?? 0) ?? 0);
                    } else if (recents) {
                      fanItems
                          .sort((a, b) => b.addedDate!.compareTo(a.addedDate!));
                    } else if (abc) {
                      fanItems.sort((a, b) => a.name.compareTo(b.name));
                    } else if (xyz) {
                      fanItems.sort((a, b) => b.name.compareTo(a.name));
                    }

                    return fanItems.isEmpty
                        ? Center(
                            child: Text(
                              "You haven't added anything to your cart yet",
                              style: AppStyles.helper2,
                              textAlign: TextAlign.center,
                            ),
                          )
                        : GridView.builder(
                            itemCount: fanItems.length,
                            padding: EdgeInsets.symmetric(horizontal: 16.w),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 8.h,
                              crossAxisSpacing: 10.w,
                              childAspectRatio: 167.w / 254.h,
                            ),
                            itemBuilder: (BuildContext context, int index) {
                              FanModel fan = fanItems[index];

                              return Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.r),
                                  color: AppColors.gray2C2C2E,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Stack(
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(6.r),
                                          child: Image.file(
                                            File(fan.image!),
                                            fit: BoxFit.cover,
                                            height: 178.h,
                                            width: double.infinity,
                                          ),
                                        ),
                                        Positioned(
                                          right: 8.w,
                                          top: 8.h,
                                          child: AppButton(
                                            onPressed: () {
                                              _showDeleteDialog(context, fan);
                                            },
                                            child: Container(
                                                alignment: Alignment.center,
                                                width: 32.w,
                                                height: 32.h,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          2.r),
                                                  color: AppColors.whiteD1D1D6
                                                      .withOpacity(0.2),
                                                ),
                                                child: SvgPicture.asset(
                                                  Assets.svg.trash,
                                                  fit: BoxFit.contain,
                                                  width: 24.w,
                                                  height: 24.h,
                                                )),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 8.h),
                                    Text(
                                      fan.name,
                                      style: TextStyle(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(height: 4.h),
                                    AppButton(
                                      onPressed: () {
                                        context
                                            .read<FanBloc>()
                                            .add(DeleteFan(fan.id));
                                      },
                                      child: Container(
                                        alignment: Alignment.center,
                                        height: 32.h,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10.r),
                                          color: AppColors.red,
                                        ),
                                        child: Text(
                                          'Buy',
                                          style: AppStyles.helper2,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                  } else if (state is FanLoading) {
                    return Center(child: CircularProgressIndicator());
                  } else {
                    return Center(
                      child: Text(
                        "You haven't added anything to your cart yet",
                        style: AppStyles.helper2,
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'btn2',
        backgroundColor: Colors.black,
        onPressed: () {
          final state = context.read<FanBloc>().state;

          if (state is FanLoaded) {
            List<FanModel> fanItems =
                state.fans.where((fan) => fan.isCart ?? false).toList();

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TotalCostScreen(fanModels: fanItems),
              ),
            );
          }
        },
        child: Container(
          alignment: Alignment.center,
          height: 64.h,
          decoration: BoxDecoration(
            color: AppColors.red,
            shape: BoxShape.circle,
          ),
          child: SvgPicture.asset(
            Assets.svg.plus,
            fit: BoxFit.contain,
            width: 18.w,
            height: 18.h,
          ),
        ),
      ),
    );
  }

  Widget _buildCategory(
    String text,
    bool selected,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.symmetric(horizontal: 4.w),
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: AppColors.red,
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Future<bool?> _showDeleteDialog(BuildContext context, FanModel fan) {
    return showCupertinoDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return ConfirmationDialog(
          onTap: () {
            Navigator.pop(context);
            setState(() {
              context.read<FanBloc>().add(DeleteFan(fan.id));
            });
          },
          name: 'Delete from cart',
          description:
              'Are you sure you want to remove this fan from the cart?',
          leftText: 'Delete',
          rightText: 'Cancel',
          isRed: false,
        );
      },
    );
  }
}
