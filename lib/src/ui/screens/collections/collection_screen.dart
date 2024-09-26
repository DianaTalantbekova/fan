import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';

import '../../../../gen/assets.gen.dart';
import '../../../domain/models/collection_model.dart';
import '../../../infrastructure/resources/app_colors.dart';
import '../../../infrastructure/resources/app_styles.dart';
import '../../widgets/app_button.dart';
import '../add_collection/add_collection_screen.dart';
import '../add_collection/bloc/collection_bloc.dart';
import '../edit_collection/edit_collection_screen.dart';
import '../fav_collection/fav_collection_screen.dart';
import '../favourite/favourite_screen.dart';

class CollectionScreen extends StatefulWidget {
  const CollectionScreen({super.key});

  @override
  State<CollectionScreen> createState() => _CollectionScreenState();
}

class _CollectionScreenState extends State<CollectionScreen> {
  bool expensive = false;
  bool recents = false;
  bool abc = false;
  bool xyz = false;
  bool isEdit = false;
  bool isSelecting = false;
  List<CollectionModel> selectedItems = [];

  void _toggleSelection(CollectionModel item) {
    setState(() {
      if (selectedItems.contains(item)) {
        selectedItems.remove(item);
        if (selectedItems.isEmpty) {
          isSelecting = false;
        }
      } else {
        selectedItems.add(item);
        isSelecting = true;
      }
    });
  }

  Future<void> _deleteSelectedItems(BuildContext context) async {
    final bool confirmed =
        await _showDeleteConfirmationDialog(context, selectedItems);
    if (confirmed) {
      Box<CollectionModel> collectionBox =
          GetIt.instance<Box<CollectionModel>>();
      for (var action in selectedItems) {
        collectionBox.delete(action.id);
      }
      context
          .read<CollectionBloc>()
          .add(DeleteSelectedCollections(selectedItems));

      setState(() {
        selectedItems.clear();
        isSelecting = false;
      });
    } else {}
  }

  @override
  void initState() {
    super.initState();
    context.read<CollectionBloc>().add(LoadCollections());
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
              child: BlocBuilder<CollectionBloc, CollectionState>(
                builder: (context, state) {
                  if (state is CollectionLoaded) {
                    List<CollectionModel> collectionItems = state.collections;

                    if (expensive) {
                    } else if (recents) {
                      collectionItems
                          .sort((a, b) => b.addedDate!.compareTo(a.addedDate!));
                    } else if (abc) {
                      collectionItems.sort((a, b) => a.name.compareTo(b.name));
                    } else if (xyz) {
                      collectionItems.sort((a, b) => b.name.compareTo(a.name));
                    }

                    return GridView.builder(
                      itemCount: collectionItems.length + 1,
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 8.h,
                        crossAxisSpacing: 10.w,
                        childAspectRatio: 166.w / 228.h,
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        if (index == 0) {
                          return AppButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const FavouriteScreen(),
                                ),
                              );
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 4.w),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12.r),
                                color: AppColors.gray2C2C2E,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 167.w,
                                    height: 182.h,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12.r),
                                      color: AppColors.gray2C2C2E,
                                    ),
                                    child: SvgPicture.asset(
                                      Assets.svg.starFilled,
                                      fit: BoxFit.cover,
                                      width: 40.w,
                                      height: 40.h,
                                      placeholderBuilder:
                                          (BuildContext context) => SizedBox(
                                        width: 100.w,
                                        height: 100.h,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 8.h),
                                  Text(
                                    'Favourites',
                                    style: AppStyles.helper2
                                        .copyWith(fontSize: 16.sp),
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          );
                        }

                        final collection = collectionItems[index - 1];
                        return AppButton(
                          onLongPress: () {
                            _showMenuDialog(context, collection);
                          },
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FavCollectionScreen(
                                  collectionModel: collection,
                                ),
                              ),
                            );
                          },
                          child: Container(
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
                                      borderRadius: BorderRadius.circular(6.r),
                                      child: Image.file(
                                        File(collection.imagePath!),
                                        fit: BoxFit.cover,
                                        height: 178.h,
                                      ),
                                    ),
                                    if (isSelecting)
                                      Positioned(
                                        top: 4.h,
                                        right: 4.w,
                                        child: GestureDetector(
                                          onTap: () {
                                            _toggleSelection(collection);
                                          },
                                          child: SvgPicture.asset(
                                            selectedItems.contains(collection)
                                                ? Assets.svg.selected
                                                : Assets.svg.unselected,
                                            width: 20.w,
                                            height: 20.h,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                                SizedBox(height: 8.h),
                                Text(
                                  collection.name,
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 4.h),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  } else if (state is CollectionLoading) {
                    return Center(child: CircularProgressIndicator());
                  } else {
                    return Center(child: Text('No data available'));
                  }
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation:
          isSelecting ? FloatingActionButtonLocation.centerFloat : null,
      floatingActionButton: isSelecting
          ? AppButton(
              onPressed: () {
                setState(() {
                  _deleteSelectedItems(context);
                });
              },
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 16.w),
                alignment: Alignment.center,
                height: 52.h,
                decoration: BoxDecoration(
                  color: AppColors.red,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Text(
                  'Delete',
                  style: AppStyles.helper2,
                ),
              ),
            )
          : FloatingActionButton(
              shape: const CircleBorder(
                  side: BorderSide(
                color: AppColors.red,
              )),
              backgroundColor: AppColors.red,
              heroTag: 'btn3',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddCollectionScreen(),
                  ),
                );
              },
              child: Container(
                alignment: Alignment.center,
                height: 64.h,
                decoration: const BoxDecoration(
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

  Future<void> _showMenuDialog(
      BuildContext context, CollectionModel collection) async {
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
                        setState(() {
                          isEdit = true;
                          isSelecting = false;
                        });
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditCollectionScreen(
                              collection: collection,
                            ),
                          ),
                        );
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
                        setState(() {
                          isSelecting = true;
                          isEdit = false;
                        });
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
      BuildContext context, List<CollectionModel> items) async {
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
                  'Delete collection',
                  style: TextStyle(
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                content: Text(
                  'Are you sure you want to delete these collections?',
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
