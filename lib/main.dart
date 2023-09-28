import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'src/constants/application_constants.dart';
import 'src/localization/language_manager.dart';
import 'src/routing/app_router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  final _appRouter = AppRouter();

  MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return EasyLocalization(
      supportedLocales: LanguageManager.instance.supportedLocales,
      path: ApplicationConstants.LANG_ASSET_PATH,
      startLocale: LanguageManager.instance.enLocale,
      child: ScreenUtilInit(
        designSize: const Size(390, 845),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) => MaterialApp.router(
          debugShowCheckedModeBanner: false,
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          routerDelegate: _appRouter.delegate(),
          routeInformationParser: _appRouter.defaultRouteParser(),
          builder: (context, widget) {
            ScreenUtil.init(context);
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
              child: widget!,
            );
          },
        ),
      ),
    );
  }
}
