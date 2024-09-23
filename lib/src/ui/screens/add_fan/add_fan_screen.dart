import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../gen/assets.gen.dart';
import '../../../domain/models/fan_model.dart';
import '../../../infrastructure/resources/app_colors.dart';
import '../../../infrastructure/resources/app_styles.dart';
import '../../widgets/app_button.dart';
import '../../widgets/confirmation_dialog.dart';
import 'bloc/fan_bloc.dart';
import 'widgets/custom_text_field.dart';

class AddFanScreen extends StatefulWidget {
  const AddFanScreen({super.key});

  @override
  State<AddFanScreen> createState() => _AddFanScreenState();
}

class _AddFanScreenState extends State<AddFanScreen> {
  final ImagePicker _picker = ImagePicker();
  File? _image;
  bool _isImageAdded = false;
  File? _audioFile;
  bool _isAudioAdded = false;
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;

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

  Future<void> _pickAudio() async {
    try {
      final result = await FilePicker.platform.pickFiles(type: FileType.audio);
      if (result != null && result.files.single.path != null) {
        setState(() {
          _audioFile = File(result.files.single.path!);
          _isAudioAdded = true;
        });
      }
    } catch (e) {
      print("Error picking audio: $e");
    }
  }

  Future<void> _playAudio() async {
    if (_audioFile != null) {
      if (_isPlaying) {
        await _audioPlayer.pause();
        setState(() {
          _isPlaying = false;
        });
      } else {
        await _audioPlayer.play(DeviceFileSource(_audioFile!.path));
        setState(() {
          _isPlaying = true;
        });
      }

      _audioPlayer.onPlayerStateChanged.listen((PlayerState state) {
        if (state == PlayerState.stopped) {
          setState(() {
            _isPlaying = false;
          });
        }
      });
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  bool get isFilled =>
      _nameController.text.isNotEmpty &&
      _image != null &&
      _descriptionController.text.isNotEmpty;

  // &&
  // _audioFile != null;

  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_nameController.text.isNotEmpty ||
            _image != null ||
            _descriptionController.text.isNotEmpty ||
            _audioFile != null) {
          _showExitDialog(context);
          return Future.value(false);
        }
        return Future.value(true);
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.black,
          leading: Center(
            child: AppButton(
              onPressed: () async {
                if (_nameController.text.isNotEmpty ||
                    _image != null ||
                    _descriptionController.text.isNotEmpty ||
                    _audioFile != null) {
                  bool? shouldExit = await _showExitDialog(context);
                  if (shouldExit == true) {
                    Navigator.pop(context);
                  }
                } else {
                  Navigator.pop(context);
                }
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
            'Add fan',
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
                AppButton(
                  onPressed: _pickAudio,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    height: 44.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.r),
                      color: AppColors.red,
                    ),
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          Assets.svg.download,
                          fit: BoxFit.contain,
                          width: 24.w,
                          height: 24.h,
                        ),
                        SizedBox(width: 10.w),
                        AppButton(
                          onPressed: _playAudio,
                          child: SvgPicture.asset(
                            _isPlaying ? Assets.svg.pause : Assets.svg.play,
                            fit: BoxFit.contain,
                            width: 24.w,
                            height: 24.h,
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Expanded(
                          child: Assets.png.soundLines.image(
                            fit: BoxFit.contain,
                            height: 20.h,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            _showSoundDeleteDialog(context);
                          },
                          child: SvgPicture.asset(
                            Assets.svg.trash,
                            fit: BoxFit.contain,
                            width: 24.w,
                            height: 24.h,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                CustomTextField(
                  hintText: 'Enter a name',
                  controller: _nameController,
                ),
                SizedBox(height: 24.h),
                CustomTextField(
                  hintText: 'Enter a description (optional)',
                  controller: _descriptionController,
                ),
                SizedBox(height: 120.h),
              ],
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: AppButton(
          onPressed: () {
            if (isFilled) {
              final fanId = DateTime.now().toIso8601String();
              final addFan = FanModel(
                name: _nameController.text,
                description: _descriptionController.text,
                image: _image?.path,
                audioFile: _audioFile?.path,
                isCollection: false,
                isFavorite: false,
                id: fanId, addedDate: DateTime.now(),
              );
              context.read<FanBloc>().add(AddFan(addFan));

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
              color: isFilled ? AppColors.red : AppColors.gray48484A,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Text(
              'Save',
              style: AppStyles.helper2,
            ),
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

  void _showSoundDeleteDialog(BuildContext context) {
    showCupertinoDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return ConfirmationDialog(
          onTap: () {
            Navigator.pop(context);
            setState(() {
              _audioFile = null;
              _isAudioAdded = false;
              _isPlaying = false;
              _audioPlayer.stop();
            });
          },
          name: 'Delete sound',
          description: 'Are you sure you want to delete added sound?',
          rightText: 'Cancel',
          isRed: false,
        );
      },
    );
  }

  Future<bool?> _showExitDialog(BuildContext context) {
    return showCupertinoDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return ConfirmationDialog(
          onTap: () {
            Navigator.of(context).pop(true);
          },
          name: 'Exit fan adding',
          description: 'In this case, the product will not be added',
          leftText: 'Exit',
          rightText: 'Cancel',
          isRed: false,
        );
      },
    );
  }
}
