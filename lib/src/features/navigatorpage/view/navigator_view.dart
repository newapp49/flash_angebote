import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flash_angebote/core/init/lang/locale_keys.g.dart';
import 'package:flash_angebote/src/features/homepage/view/homepage_view.dart';
import 'package:flash_angebote/src/shared/utils/extension/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

@RoutePage(name: 'NavigatorRoute')
class NavigatorView extends StatefulWidget {
  const NavigatorView({super.key});

  @override
  State<NavigatorView> createState() => _NavigatorViewState();
}

class _NavigatorViewState extends State<NavigatorView> {
  int _activePageIndex = 0;
  List<Widget> screenList = [const HomePage()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screenList[_activePageIndex],
      bottomNavigationBar: SizedBox(
        height: 66.h,
        child: BottomNavigationBar(
          iconSize: 18.sp,
          selectedFontSize: 12.sp,
          backgroundColor: context.colorScheme.background,
          unselectedItemColor: context.colorScheme.onPrimary,
          selectedItemColor: context.colorScheme.onPrimary,
          items: [
            BottomNavigationBarItem(
              icon: const Icon(
                Icons.home,
              ),
              label: LocaleKeys.homepage_bottombar_home.tr(),
            ),
            BottomNavigationBarItem(
                icon: const Icon(
                  Icons.analytics,
                ),
                label: LocaleKeys.homepage_bottombar_discounts.tr()),
            BottomNavigationBarItem(
                icon: const Icon(
                  Icons.calendar_month_outlined,
                ),
                label: LocaleKeys.homepage_bottombar_activity.tr())
          ],
        ),
      ),
    );
  }
}
