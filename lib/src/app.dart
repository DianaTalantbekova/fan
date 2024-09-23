
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../di.dart';
import 'data/collection_repository.dart';
import 'data/fan_repository.dart';
import 'ui/screens/add_collection/bloc/collection_bloc.dart';
import 'ui/screens/add_fan/bloc/fan_bloc.dart';
import 'ui/screens/splash/splash.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<FanRepository>(
          create: (_) => getIt<FanRepository>(),
        ),
        BlocProvider<FanBloc>(
          create: (context) => FanBloc(
            context.read<FanRepository>(),
          ),
        ),
        Provider<CollectionRepository>(
          create: (_) => getIt<CollectionRepository>(),
        ),
        BlocProvider<CollectionBloc>(
          create: (context) => CollectionBloc(
            context.read<CollectionRepository>(),
          ),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Volley Planner',
        theme: ThemeData(
          fontFamily: 'Roboto',
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          splashFactory: NoSplash.splashFactory,
        ),
        home: const Splash(),
      ),
    );
  }
}
