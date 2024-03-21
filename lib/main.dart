import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:wingo/src/features/activity/view_model/activity_cubit.dart';
import 'package:wingo/src/features/homepage/view_model/homepage_cubit.dart';
import 'package:wingo/src/features/settings/viewmodel/settings_cubit.dart';
import 'package:wingo/src/features/shopingListPage/model/image_item.model.dart';
import 'package:wingo/src/features/shopingListPage/model/list_model.dart';
import 'package:wingo/src/features/shopingListPage/model/text_item_model.dart';
import 'package:wingo/src/features/shopingListPage/sqlite/repo.dart';
import 'package:wingo/src/features/shopingListPage/view_model/shopping_list_cubit.dart';
import 'package:wingo/src/features/splash/viewmodel/splash_view_model.dart';
import 'package:wingo/src/shared/theme/provider/application_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'src/constants/application_constants.dart';
import 'src/localization/language_manager.dart';
import 'src/routing/app_router.dart';
import 'src/shared/theme/theme_notifier.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  if (Platform.isAndroid) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.android,
    );
  } else {
    await Firebase.initializeApp(name: 'wingo', options: DefaultFirebaseOptions.ios);
  }

  await FirebaseMessaging.instance.requestPermission();

  final appDir = await getApplicationDocumentsDirectory();
  Hive.init(appDir.path);
  Hive.registerAdapter(RepoAdapter());
  Hive.registerAdapter(ListModelAdapter());
  Hive.registerAdapter(TextItemAdapter());
  Hive.registerAdapter(ImageItemAdapter());
  var box = await Hive.openBox("GlobalList");

  if (box.isEmpty) {
    var a = Repo();
    box.add(a);
  }

  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  final _appRouter = AppRouter();

  MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    var box = Hive.box("GlobalList");

    var repo = box.get(0) as Repo;

    return MultiProvider(
      providers: [
        ...ApplicationProvider.instance.dependItems,
        BlocProvider(create: (context) => SplashCubit()),
        BlocProvider(
          create: (context) => HomePageCubit(),
        ),
        BlocProvider(
          create: (context) => ShoppingListCubit(),
        ),
        BlocProvider(
          create: (context) => ShoppingListAddCubit(repo),
        ),
        BlocProvider(
          create: (context) => SearchListViewCubit(repo),
        ),
        BlocProvider(
          create: (context) => ShoppingListViewCubit(repo),
        ),
        BlocProvider(
          create: (context) => SettingsCubit(),
        ),
        BlocProvider(
          create: (context) => ActivityPageCubit(),
        )
      ],
      child: EasyLocalization(
        supportedLocales: LanguageManager.instance.supportedLocales,
        path: ApplicationConstants.LANG_ASSET_PATH,
        startLocale: LanguageManager.instance.enLocale,
        child: ScreenUtilInit(
          designSize: const Size(390, 845),
          minTextAdapt: true,
          splitScreenMode: true,
          builder: (context, child) => MaterialApp.router(
            title: 'Wingoo',
            theme: context.watch<ThemeNotifier>().currentTheme,
            debugShowCheckedModeBanner: false,
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            routerDelegate: _appRouter.delegate(),
            routeInformationParser: _appRouter.defaultRouteParser(),
            builder: (context, widget) {
              ScreenUtil.init(context);
              return MediaQuery(
                data: MediaQuery.of(context).copyWith(
                  textScaler: const TextScaler.linear(1.0),
                ),
                child: widget!,
              );
            },
          ),
        ),
      ),
    );
  }
}
