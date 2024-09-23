import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../gen/assets.gen.dart';
import '../../../infrastructure/resources/app_colors.dart';
import '../../../infrastructure/resources/app_styles.dart';
import '../../widgets/app_button.dart';
import '../../../domain/models/fan_model.dart';
import '../add_fan/bloc/fan_bloc.dart';

class TotalCostScreen extends StatefulWidget {
  final List<FanModel> fanModels;

  const TotalCostScreen({super.key, required this.fanModels});

  @override
  _TotalCostScreenState createState() => _TotalCostScreenState();
}

class _TotalCostScreenState extends State<TotalCostScreen> {
  List<FanModel> fanModels = [];
  bool hasPurchased = false;

  @override
  void initState() {
    super.initState();
    fanModels = widget.fanModels;
  }

  @override
  Widget build(BuildContext context) {
    double totalPrice = fanModels.fold(0, (sum, item) => sum + item.price!);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.black,
        leading: Center(
          child: AppButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: SvgPicture.asset(
              Assets.svg.arrowBack,
              fit: BoxFit.contain,
              width: 24.w,
              height: 24.h,
            ),
          ),
        ),
        title: Text(
          'Total cost',
          style: AppStyles.helper2.copyWith(fontWeight: FontWeight.w700),
        ),
      ),
      body: hasPurchased
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Success',
                    style: AppStyles.helper3.copyWith(

                      color: AppColors.green48484A,
                    ),
                  ),
                  Text(
                    'Congratulations on your new purchase',
                    style: AppStyles.helper2.copyWith(
                      fontSize: 13.sp,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          : Column(
              children: [
                SizedBox(height: 20.h),
                if (fanModels.isEmpty) SizedBox(height: 270.h),
                fanModels.isEmpty
                    ? Center(
                        child: Text(
                          "You haven't added anything to your cart yet",
                          style: AppStyles.helper2,
                          textAlign: TextAlign.center,
                        ),

                      )
                    : Container(
                        margin: EdgeInsets.symmetric(horizontal: 16.w),
                        padding: const EdgeInsets.all(10),
                        height: 148.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.r),
                          color: AppColors.gray2C2C2E,
                        ),
                        child: Column(
                          children: [
                            Expanded(
                              child: ListView.separated(
                                itemBuilder: (BuildContext context, int index) {
                                  final fanModel = fanModels[index];
                                  return Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        fanModel.name,
                                        style: AppStyles.helper2
                                            .copyWith(fontSize: 16.sp),
                                      ),
                                      Text(
                                        '\$ ${fanModel.price?.toStringAsFixed(2)}',
                                        style: AppStyles.helper2
                                            .copyWith(fontSize: 16.sp),
                                      ),
                                    ],
                                  );
                                },
                                separatorBuilder:
                                    (BuildContext context, int index) =>
                                        SizedBox(height: 10.h),
                                itemCount: fanModels.length,
                              ),
                            ),
                            Divider(
                              color: Colors.white.withOpacity(0.2),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Total cost',
                                  style: AppStyles.helper2
                                      .copyWith(fontSize: 16.sp),
                                ),
                                Text(
                                  '\$ ${totalPrice.toStringAsFixed(2)}',
                                  style: AppStyles.helper2.copyWith(
                                    fontSize: 16.sp,
                                    color: const Color(0xFF34C759),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
              ],
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: fanModels.isNotEmpty && !hasPurchased
          ? AppButton(
              onPressed: () {
                for (var fan in fanModels) {
                  context.read<FanBloc>().add(DeleteFan(fan.id));
                }
                setState(() {
                  fanModels.clear();
                  hasPurchased = true;
                });
              },
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 20.w),
                alignment: Alignment.center,
                height: 52.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.r),
                  color: AppColors.red,
                ),
                child: Text(
                  'Buy',
                  style: AppStyles.helper2,
                ),
              ),
            )
          : null,
    );
  }
}
