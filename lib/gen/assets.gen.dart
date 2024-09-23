/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: directives_ordering,unnecessary_import,implicit_dynamic_list_literal,deprecated_member_use

import 'package:flutter/widgets.dart';

class $AssetsPngGen {
  const $AssetsPngGen();

  /// File path: assets/png/fan.png
  AssetGenImage get fan => const AssetGenImage('assets/png/fan.png');

  /// File path: assets/png/onb1.png
  AssetGenImage get onb1 => const AssetGenImage('assets/png/onb1.png');

  /// File path: assets/png/onb2.png
  AssetGenImage get onb2 => const AssetGenImage('assets/png/onb2.png');

  /// File path: assets/png/onb3.png
  AssetGenImage get onb3 => const AssetGenImage('assets/png/onb3.png');

  /// File path: assets/png/sound_dots.jpg
  AssetGenImage get soundDots =>
      const AssetGenImage('assets/png/sound_dots.jpg');

  /// File path: assets/png/sound_lines.png
  AssetGenImage get soundLines =>
      const AssetGenImage('assets/png/sound_lines.png');

  /// List of all assets
  List<AssetGenImage> get values =>
      [fan, onb1, onb2, onb3, soundDots, soundLines];
}

class $AssetsSvgGen {
  const $AssetsSvgGen();

  /// File path: assets/svg/arrow_back.svg
  String get arrowBack => 'assets/svg/arrow_back.svg';

  /// File path: assets/svg/camera.svg
  String get camera => 'assets/svg/camera.svg';

  /// File path: assets/svg/dots.svg
  String get dots => 'assets/svg/dots.svg';

  /// File path: assets/svg/download.svg
  String get download => 'assets/svg/download.svg';

  /// File path: assets/svg/home.svg
  String get home => 'assets/svg/home.svg';

  /// File path: assets/svg/logo.svg
  String get logo => 'assets/svg/logo.svg';

  /// File path: assets/svg/pause.svg
  String get pause => 'assets/svg/pause.svg';

  /// File path: assets/svg/play.svg
  String get play => 'assets/svg/play.svg';

  /// File path: assets/svg/plus.svg
  String get plus => 'assets/svg/plus.svg';

  /// File path: assets/svg/privacy.svg
  String get privacy => 'assets/svg/privacy.svg';

  /// File path: assets/svg/selected.svg
  String get selected => 'assets/svg/selected.svg';

  /// File path: assets/svg/settings.svg
  String get settings => 'assets/svg/settings.svg';

  /// File path: assets/svg/share.svg
  String get share => 'assets/svg/share.svg';

  /// File path: assets/svg/shop.svg
  String get shop => 'assets/svg/shop.svg';

  /// File path: assets/svg/star.svg
  String get star => 'assets/svg/star.svg';

  /// File path: assets/svg/star_filled.svg
  String get starFilled => 'assets/svg/star_filled.svg';

  /// File path: assets/svg/support.svg
  String get support => 'assets/svg/support.svg';

  /// File path: assets/svg/terms.svg
  String get terms => 'assets/svg/terms.svg';

  /// File path: assets/svg/trash.svg
  String get trash => 'assets/svg/trash.svg';

  /// File path: assets/svg/unselected.svg
  String get unselected => 'assets/svg/unselected.svg';

  /// List of all assets
  List<String> get values => [
        arrowBack,
        camera,
        dots,
        download,
        home,
        logo,
        pause,
        play,
        plus,
        privacy,
        selected,
        settings,
        share,
        shop,
        star,
        starFilled,
        support,
        terms,
        trash,
        unselected
      ];
}

class Assets {
  Assets._();

  static const $AssetsPngGen png = $AssetsPngGen();
  static const $AssetsSvgGen svg = $AssetsSvgGen();
}

class AssetGenImage {
  const AssetGenImage(
    this._assetName, {
    this.size,
    this.flavors = const {},
  });

  final String _assetName;

  final Size? size;
  final Set<String> flavors;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = false,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.low,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider({
    AssetBundle? bundle,
    String? package,
  }) {
    return AssetImage(
      _assetName,
      bundle: bundle,
      package: package,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}
