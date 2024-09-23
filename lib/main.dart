import 'package:fan/src/domain/models/collection_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'di.dart';
import 'src/app.dart';
import 'src/domain/models/fan_model.dart';


Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(FanModelAdapter());
  Hive.registerAdapter(CollectionModelAdapter());
  setUpDependencies();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp,
  ]);


  runApp(
    ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (BuildContext context, Widget? child) => const MyApp(),
    ),

  );
}
