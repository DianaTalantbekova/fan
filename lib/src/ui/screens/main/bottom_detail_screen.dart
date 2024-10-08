import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:fan/src/domain/models/fan_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';

import '../../../../gen/assets.gen.dart';
import '../../../infrastructure/resources/app_colors.dart';
import '../../../infrastructure/resources/app_styles.dart';
import '../../widgets/app_button.dart';
import '../add_collection/add_collection_screen.dart';
import '../add_collection/bloc/collection_bloc.dart';
import '../add_fan/bloc/fan_bloc.dart';
import '../add_to_cart/add_to_cart_screen.dart';
import '../edit_fan/edit_fan_screen.dart';

class BottomDetailScreen extends StatefulWidget {
  const BottomDetailScreen({super.key, required this.fanModel});

  final FanModel fanModel;

  @override
  State<BottomDetailScreen> createState() => _BottomDetailScreenState();
}

class _BottomDetailScreenState extends State<BottomDetailScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool isPlaying = false;
  int? currentPlayingIndex;
  late FanModel fanModel;
  late List<FanModel> fanModelList;

  @override
  void initState() {
    super.initState();
    context.read<FanBloc>().add(LoadFans());
    fanModel = widget.fanModel;
    fanModelList = [widget.fanModel];
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _togglePlayPause(int index, FanModel fanModel) async {
    try {
      if (isPlaying && currentPlayingIndex == index) {
        await _audioPlayer.pause();
        setState(() {
          isPlaying = false;
        });
      } else {
        final audioPath = fanModel.audioFile;

        if (audioPath != null && audioPath.isNotEmpty) {
          try {
            final adjustedPath = audioPath.startsWith('assets/')
                ? audioPath.replaceFirst('assets/', '')
                : audioPath;

            if (adjustedPath.startsWith('sounds/')) {
              await _audioPlayer.setSourceAsset(adjustedPath);
            } else {
              await _audioPlayer.setSourceUrl(adjustedPath);
            }

            await _audioPlayer.resume();
            setState(() {
              isPlaying = true;
              currentPlayingIndex = index;
            });
          } catch (e) {
            print('Error playing audio: $e');
          }
        } else {
          print('Audio path is null or empty');
        }
      }
    } catch (e) {
      print('Error toggling play/pause: $e');
    }
  }
  @override
  Widget build(BuildContext context) {
    bool _isBottomSheetShown = false;
    return BlocBuilder<FanBloc, FanState>(
  builder: (context, state) {
    if(state is FanLoaded){
      return Container(
        height: 730.h,
        padding: EdgeInsets.all(10.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20.r),
              child: Image.file(
                File(widget.fanModel.image!),
                width: double.infinity,
                height: 362.h,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 10.h),
            Text(
              fanModel.name,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 10.h),
            Text(
              fanModel.description ?? 'No description',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 12.h),
            Row(
              children: [
                AppButton(
                  onPressed: () {
                    int index = fanModelList.indexOf(fanModel);
                    _togglePlayPause(index, fanModel);
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: 32.h,
                    width: 102.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.r),
                      color: AppColors.red,
                    ),
                    child: isPlaying && currentPlayingIndex == fanModelList.indexOf(fanModel)
                        ? SvgPicture.asset(
                      Assets.svg.pause,
                      fit: BoxFit.contain,
                      width: 24.w,
                      height: 24.h,
                    )
                        : SvgPicture.asset(
                      Assets.svg.play,
                      fit: BoxFit.contain,
                      width: 24.w,
                      height: 24.h,
                    ),
                  ),
                ),
                SizedBox(width: 4.w),
                AppButton(
                  onPressed: () {
                    if (fanModel.isFavorite || fanModel.isCollection) {
                      var dataBox = GetIt.I.get<Box<FanModel>>();
                      var updatedModel = FanModel(
                        name: fanModel.name,
                        id: fanModel.id,
                        image: fanModel.image,
                        isFavorite: false,
                        description: fanModel.description,
                        isCollection: false,
                        audioFile: fanModel.audioFile,
                        keyCollection: null,
                        addedDate: fanModel.addedDate,
                      );

                      dataBox.put(fanModel.id, updatedModel);
                      setState(() {
                        fanModel.isFavorite = false;
                        fanModel.isCollection = false;
                      });
                    } else if (!fanModel.isCollection && !_isBottomSheetShown) {
                      int index = fanModelList.indexOf(fanModel);
                      _showAddToCollectionSheet(context, fanModelList, index);
                      _isBottomSheetShown = true;
                    }
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: 52.w,
                    height: 32.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.r),
                      color: AppColors.white.withOpacity(0.2),
                    ),
                    child: fanModel.isFavorite || fanModel.isCollection
                        ? SvgPicture.asset(
                      Assets.svg.starFilled,
                      fit: BoxFit.contain,
                      width: 24.w,
                      height: 24.h,
                    )
                        : SvgPicture.asset(
                      Assets.svg.star,
                      fit: BoxFit.contain,
                      width: 24.w,
                      height: 24.h,
                    ),
                  ),
                ),
                SizedBox(width: 4.w),
                AppButton(
                  onPressed: () {
                    _showMenuDialog(context, fanModel);
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: 52.w,
                    height: 32.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.r),
                      color: AppColors.white.withOpacity(0.2),
                    ),
                    child: SvgPicture.asset(
                      Assets.svg.settings,
                      fit: BoxFit.contain,
                      width: 24.w,
                      height: 24.h,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.h),
            AppButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddToCartScreen(fanModel: fanModel),
                  ),
                );
              },
              child: Container(
                alignment: Alignment.center,
                height: 52.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.r),
                  color: AppColors.red,
                ),
                child: Text(
                  'Add to cart',
                  style: AppStyles.helper2,
                ),
              ),
            ),
          ],
        ),
      );
    } else if (state is FanLoading) {
      return Center(child: CircularProgressIndicator());
    } else {
      return Center(
        child: Text(
          "You haven't added anything to your favorites yet",
          style: AppStyles.helper2,
        ),
      );
    }
  },
);
  }
  void _showAddToCollectionSheet(
      BuildContext context, List<FanModel> fanModel, int index) {
    showModalBottomSheet(
      context: context,
      barrierColor: Colors.black.withOpacity(0.4),
      backgroundColor: Colors.transparent,
      builder: (BuildContext cont) {
        return BlocBuilder<CollectionBloc, CollectionState>(
          builder: (context, state) {
            if (state is CollectionLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is CollectionLoaded) {
              final collectionModels = state.collections;

              return Container(
                height: 408.h,
                decoration: BoxDecoration(
                  color: AppColors.gray2C2C2E,
                  borderRadius:
                  BorderRadius.vertical(top: Radius.circular(20.r)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 4.h),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 16.w, vertical: 12.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AppButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text(
                              'Close',
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          AppButton(
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                  const AddCollectionScreen(),
                                ),
                              );
                            },
                            child: Text(
                              'Add new',
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      color: Colors.white.withOpacity(0.5),
                    ),
                    SizedBox(height: 16.h),
                    Expanded(
                      child: GridView.builder(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisSpacing: 20,
                          crossAxisSpacing: 20,
                          childAspectRatio: 0.75,
                        ),
                        itemCount: collectionModels.length + 1,
                        itemBuilder: (context, collectionIndex) {
                          if (collectionIndex == 0) {
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  fanModel[index].isCollection = false;
                                  fanModel[index].isFavorite = true;
                                  var dataBox = GetIt.I.get<Box<FanModel>>();
                                  dataBox.put(
                                    fanModel[index].id,
                                    fanModel[index],
                                  );
                                });
                                Navigator.pop(context);
                              },
                              child: Column(
                                children: [
                                  Container(
                                    width: 100.w,
                                    height: 100.h,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12.r),
                                      border: Border.all(color: Colors.white),
                                    ),
                                    alignment: Alignment.center,
                                    child: SvgPicture.asset(
                                      Assets.svg.starFilled,
                                      fit: BoxFit.contain,
                                      width: 32.w,
                                      height: 32.h,
                                    ),
                                  ),
                                  SizedBox(height: 8.h),
                                  Text(
                                    'Favourites',
                                    style: AppStyles.helper1
                                        .copyWith(fontSize: 16.sp),
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            );
                          } else {
                            final collection =
                            collectionModels[collectionIndex - 1];

                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  fanModel[index].isCollection = true;
                                  var dataBox = GetIt.I.get<Box<FanModel>>();

                                  var collectionModel = FanModel(
                                    name: fanModel[index].name,
                                    id: fanModel[index].id,
                                    image: fanModel[index].image,
                                    isFavorite: fanModel[index].isFavorite,
                                    description: fanModel[index].description,
                                    isCollection: true,
                                    audioFile: fanModel[index].audioFile,
                                    keyCollection: collection.id,
                                    addedDate: fanModel[index].addedDate,
                                  );

                                  dataBox.put(
                                      fanModel[index].id, collectionModel);
                                });
                                Navigator.pop(context);
                              },
                              child: Column(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12.r),
                                    child: collection.imagePath != null &&
                                        collection.imagePath!.isNotEmpty
                                        ? Image.file(
                                      File(collection.imagePath!),
                                      fit: BoxFit.cover,
                                      width: 100.w,
                                      height: 100.h,
                                    )
                                        : Container(
                                      color: Colors.grey,
                                      width: 100.w,
                                      height: 100.h,
                                    ),
                                  ),
                                  SizedBox(height: 8.h),
                                  Text(
                                    collection.name,
                                    style: AppStyles.helper1
                                        .copyWith(fontSize: 16.sp),
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              );
            } else if (state is CollectionError) {
              return Center(child: Text('Error loading collections'));
            }
            return Container();
          },
        );
      },
    );
  }
  Future<void> _showMenuDialog(BuildContext context, FanModel fan) async {
    return showModalBottomSheet<void>(
      context: context,
      barrierColor: AppColors.black.withOpacity(0.5),
      backgroundColor: Colors.transparent,
      builder: (BuildContext cont) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              height: 112.h,
              width: 359.w,
              alignment: Alignment.center,
              margin: EdgeInsets.symmetric(horizontal: 8.w),
              decoration: BoxDecoration(
                color: const Color(0xFF252525).withOpacity(0.9),
                borderRadius: BorderRadius.circular(14.r),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: AppButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditFanScreen(fan: fan),
                          ),
                        ).then((_) {
                          context.read<FanBloc>().add(LoadFans());
                        });
                      },
                      child: Text(
                        "Edit",
                        style: TextStyle(
                          fontSize: 17.sp,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF0A84FF),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Divider(
                    color: const Color(0xFF3C3C43).withOpacity(0.36),
                    height: 0.5,
                  ),
                  SizedBox(height: 12.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: AppButton(
                      onPressed: () async {
                        Navigator.of(cont).pop();

                        await _showDeleteConfirmationDialog(context, fan.id);
                      },
                      child: Text(
                        "Delete",
                        style: TextStyle(
                          fontSize: 17.sp,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFFFF453A),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8.h),
            AppButton(
              onPressed: () {
                Navigator.of(cont).pop();
              },
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 8.w),
                alignment: Alignment.center,
                height: 56.h,
                decoration: BoxDecoration(
                  color: const Color(0xFF252525).withOpacity(0.9),
                  borderRadius: BorderRadius.circular(14.r),
                ),
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    color: const Color(0xFF0A84FF),
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            SizedBox(height: 30.h),
          ],
        );
      },
    );
  }
  Future<bool> _showDeleteConfirmationDialog(
      BuildContext context, String fanId) async {
    return await showCupertinoDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return CupertinoTheme(
          data: CupertinoThemeData(
            brightness: Brightness.dark,
            primaryColor: const Color(0xFF0A84FF),
            textTheme: CupertinoTextThemeData(
              actionTextStyle: TextStyle(
                fontSize: 17.sp,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF0A84FF),
              ),
              textStyle: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w400,
                color: Colors.white,
              ),
            ),
          ),
          child: CupertinoAlertDialog(
            title: Text(
              'Delete event',
              style: TextStyle(
                fontSize: 17.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            content: Text(
              'Are you sure you want to delete the added event?',
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w400,
                color: Colors.white70,
              ),
            ),
            actions: <Widget>[
              CupertinoDialogAction(
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF0A84FF),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
              CupertinoDialogAction(
                child: Text(
                  'Delete',
                  style: TextStyle(
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF0A84FF),
                  ),
                ),
                onPressed: () {
                  context.read<FanBloc>().add(DeleteFan(fanId));
                  Navigator.of(context).pop(true);
                },
              ),
            ],
          ),
        );
      },
    ) ??
        false;
  }

}
