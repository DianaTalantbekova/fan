import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../gen/assets.gen.dart';
import '../../../domain/models/collection_model.dart';
import '../../../infrastructure/resources/app_colors.dart';
import '../../../infrastructure/resources/app_styles.dart';
import '../../widgets/app_button.dart';
import '../../widgets/confirmation_dialog.dart';
import '../add_fan/widgets/custom_text_field.dart';
import 'bloc/collection_bloc.dart';

class AddCollectionScreen extends StatefulWidget {
  const AddCollectionScreen({super.key});

  @override
  State<AddCollectionScreen> createState() => _AddCollectionScreenState();
}

class _AddCollectionScreenState extends State<AddCollectionScreen> {
  final _nameController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  File? _image;
  bool _isImageAdded = false;

  Future<void> _pickImage() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
          _isImageAdded = true;
        });
      }
    } catch (e) {
      print("Error picking image: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    _nameController.addListener(() {
      setState(() {});
    });
  }

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
          'Сreate collection',
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
              AppButton(
                onPressed: _pickImage,
                child: Container(
                  alignment: Alignment.center,
                  height: 362.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.r),
                    color: AppColors.gray2C2C2E,
                  ),
                  child: _image != null
                      ? GestureDetector(
                          onTap: () {
                            _showImageDeleteDialog(context);
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12.r),
                            child: Image.file(
                              _image!,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                            ),
                          ),
                        )
                      : SvgPicture.asset(
                          Assets.svg.camera,
                          fit: BoxFit.contain,
                          width: 24.w,
                          height: 24.h,
                        ),
                ),
              ),
              SizedBox(height: 20.h),
              CustomTextField(
                hintText: 'Enter the name of the collection',
                controller: _nameController,
              ),
              SizedBox(height: 120.h),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AppButton(
        onPressed: () {
          if (_nameController.text.isNotEmpty && _image != null) {
            final colId = DateTime.now().toIso8601String();
            final addCollection = CollectionModel(
              name: _nameController.text,
              id: colId,
              imagePath: _image!.path,
            );
            context.read<CollectionBloc>().add(AddCollection(addCollection));

            Navigator.pop(context);
          } else {
            null;
          }
        },
        child: Container(
          alignment: Alignment.center,
          height: 52.h,
          margin: EdgeInsets.symmetric(horizontal: 16.w),
          decoration: BoxDecoration(
            color: _nameController.text.isNotEmpty && _image != null
                ? AppColors.red
                : AppColors.gray48484A,
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

  void _showImageDeleteDialog(BuildContext context) {
    showCupertinoDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return ConfirmationDialog(
          onTap: () {
            Navigator.pop(context);
            setState(() {
              _image = null;
              _isImageAdded = false;
            });
          },
          name: 'Delete a photo?',
          description: 'You will have to upload the photo again',
          rightText: 'Cancel',
          isRed: false,
        );
      },
    );
  }
}
