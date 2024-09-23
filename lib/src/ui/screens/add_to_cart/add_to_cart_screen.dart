import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../gen/assets.gen.dart';
import '../../../domain/models/fan_model.dart';
import '../../../infrastructure/resources/app_colors.dart';
import '../../../infrastructure/resources/app_styles.dart';
import '../../widgets/app_button.dart';
import '../add_fan/bloc/fan_bloc.dart';
import '../add_fan/widgets/custom_text_field.dart';

class AddToCartScreen extends StatefulWidget {
  const AddToCartScreen({super.key, required this.fanModel});

  final FanModel fanModel;

  @override
  State<AddToCartScreen> createState() => _AddToCartScreenState();
}

class _AddToCartScreenState extends State<AddToCartScreen> {
  final _priceController = TextEditingController();
  final bool _isButtonEnabled = false;

  @override
  Widget build(BuildContext context) {
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
          'Add to cart',
          style: AppStyles.helper2.copyWith(fontWeight: FontWeight.w700),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.h),
              Container(
                  alignment: Alignment.center,
                  height: 362.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.r),
                    color: AppColors.gray2C2C2E,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12.r),
                    child: Image.file(
                      File(widget.fanModel.image!),
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  )),
              SizedBox(height: 20.h),
              CustomTextField(
                hintText: 'Enter the price',
                controller: _priceController,
              ),
              SizedBox(height: 120.h),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AppButton(
        onPressed: () {
          final price = double.tryParse(_priceController.text);
          var updateFanModel = FanModel(
            id: widget.fanModel.id,
            name: widget.fanModel.name,
            description: widget.fanModel.description,
            isFavorite: widget.fanModel.isFavorite,
            image: widget.fanModel.image,
            isCart: true,
            keyCollection: widget.fanModel.keyCollection,
            price: price,
            audioFile: widget.fanModel.audioFile,
            isCollection: widget.fanModel.isCollection,
            addedDate: widget.fanModel.addedDate,
          );

          context.read<FanBloc>().add(AddFan(updateFanModel));
          print(price);
          Navigator.pop(context);
        },
        child: Container(
          alignment: Alignment.center,
          height: 52.h,
          margin: EdgeInsets.symmetric(horizontal: 16.w),
          decoration: BoxDecoration(
            color: AppColors.red,
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Text(
            'Save',
            style: AppStyles.helper2,
          ),
        ),
      ),
    );
  }
}
