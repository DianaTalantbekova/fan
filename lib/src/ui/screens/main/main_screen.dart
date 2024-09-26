import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';

import '../../../../gen/assets.gen.dart';
import '../../../domain/models/fan_model.dart';
import '../../../infrastructure/resources/app_colors.dart';
import '../../../infrastructure/resources/app_styles.dart';
import '../../widgets/app_button.dart';
import '../add_collection/add_collection_screen.dart';
import '../add_collection/bloc/collection_bloc.dart';
import '../add_fan/add_fan_screen.dart';
import '../add_fan/bloc/fan_bloc.dart';
import '../add_to_cart/add_to_cart_screen.dart';
import '../edit_fan/edit_fan_screen.dart';
import 'bottom_detail_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  bool expensive = false;
  bool recents = false;
  bool abc = false;
  bool xyz = false;
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool isPlaying = false;
  int? currentPlayingIndex;

  @override
  void initState() {
    super.initState();
    context.read<FanBloc>().add(LoadFans());
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
    print('LALALLA');
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
                    List<FanModel> fanItems = state.fans.where((fan) => fan.isCart != true).toList();

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
                              "You haven't added anything yet",
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
                              childAspectRatio: 167.w / 262.h,
                            ),
                            itemBuilder: (BuildContext context, int index) {
                              FanModel fan = fanItems[index];

                              return AppButton(
                                onPressed: () {
                                  _showBottomSheet(context, fan, fanItems);
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.r),
                                    color: AppColors.gray2C2C2E,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                                var index =
                                                    fanItems.indexOf(fan);
                                                var fanItem = fanItems[index];

                                                if (fanItem.isFavorite ||
                                                    fanItem.isCollection) {
                                                  var dataBox = GetIt.I
                                                      .get<Box<FanModel>>();

                                                  var collectionModel =
                                                      FanModel(
                                                    name: fan.name,
                                                    id: fan.id,
                                                    image: fan.image,
                                                    isFavorite: false,
                                                    description:
                                                        fan.description,
                                                    isCollection: false,
                                                    audioFile: fan.audioFile,
                                                    keyCollection: null,
                                                    addedDate: fan.addedDate,
                                                  );

                                                  dataBox.put(
                                                      fan.id, collectionModel);
                                                  setState(() {
                                                    fanItem.isFavorite = false;
                                                    fanItem.isCollection =
                                                        false;
                                                  });
                                                } else {
                                                  if (!fanItem.isCollection &&
                                                      !_isBottomSheetShown) {
                                                    _showAddToCollectionSheet(
                                                        context,
                                                        fanItems,
                                                        index);
                                                    _isBottomSheetShown = true;
                                                  }
                                                }
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
                                                child: fan.isFavorite ||
                                                        fan.isCollection
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
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: AppButton(
                                              onPressed: () =>
                                                  _togglePlayPause(index, fan),
                                              child: Container(
                                                alignment: Alignment.center,
                                                height: 32.h,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.r),
                                                  color: AppColors.red,
                                                ),
                                                child: isPlaying &&
                                                        currentPlayingIndex ==
                                                            index
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
                                          ),
                                          SizedBox(width: 4.w),
                                          AppButton(
                                            onPressed: () {
                                              _showMenuDialog(context, fan);
                                            },
                                            child: Container(
                                              alignment: Alignment.center,
                                              width: 52.w,
                                              height: 32.h,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(12.r),
                                                color: AppColors.white
                                                    .withOpacity(0.2),
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
                                    ],
                                  ),
                                ),
                              );
                            },
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
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(
            side: BorderSide(
              color: AppColors.red,
            )),
        backgroundColor: AppColors.red,
        heroTag: 'btn1',
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddFanScreen(),
            ),
          ).then((_) {
            context.read<FanBloc>().add(LoadFans());
          });
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

  void _showBottomSheet(
      BuildContext context, FanModel fanModel, List<FanModel> fanModelList) {
    showModalBottomSheet(
      backgroundColor: AppColors.gray2C2C2E,
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20.r),
        ),
      ),
      builder: (context) {
        return BottomDetailScreen(fanModel: fanModel);
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

  Widget _buildCategory(
    String text,
    bool selected,
    VoidCallback onTap,
  ) {
    return AppButton(
      onPressed: onTap,
      child: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.symmetric(horizontal: 4.w),
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        decoration: BoxDecoration(
          color: !selected ? AppColors.red : Colors.transparent,
          borderRadius: BorderRadius.circular(10.r),
          border:
              Border.all(color: selected ? AppColors.red : Colors.transparent),
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
