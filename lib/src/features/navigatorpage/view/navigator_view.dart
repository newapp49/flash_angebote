import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flash_angebote/src/routing/app_router.dart';
import 'package:flash_angebote/src/shared/utils/extension/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/init/lang/locale_keys.g.dart';
import '../../../../core/init/manager/locale_manager.dart';

@RoutePage(name: 'NavigatorRoute')
class NavigatorView extends StatefulWidget {
  const NavigatorView({super.key});

  @override
  State<NavigatorView> createState() => _NavigatorViewState();
}

class _NavigatorViewState extends State<NavigatorView> {
  List<PageRouteInfo> screenList = [const HomeRoute(), const ActivityRoute()];
  @override
  Widget build(BuildContext context) {
    LocaleManager localeManager = LocaleManager.instance;

    return AutoTabsScaffold(
        backgroundColor: context.colorScheme.background,
        routes: screenList,
        transitionBuilder: (context, child, animation) {
          return child;
        },
        extendBody: true,
        bottomNavigationBuilder: (
          context,
          tabsRouter,
        ) {
          return Container(
            width: context.width,
            height: 70.h,
            decoration: BoxDecoration(
              color: context.colorScheme.background,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () {
                        tabsRouter.navigate(screenList[0]);
                      },
                      child: Column(
                        children: [
                          Container(
                            width: 40.w,
                            height: 2.w,
                            decoration: BoxDecoration(
                                color: tabsRouter.activeIndex == 0
                                    ? context.colorScheme.onPrimary
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(10.w)),
                          ),
                          SizedBox(height: 3.h),
                          Icon(
                            Icons.shopping_basket_rounded,
                            color: context.colorScheme.onPrimary,
                            size: 24.w,
                          ),
                          SizedBox(height: 3.h),
                          Text(
                            LocaleKeys.homepage_bottombar_discounts.tr(),
                            style: context.textTheme.labelSmall!
                                .copyWith(letterSpacing: 0),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        tabsRouter.navigate(screenList[1]);
                      },
                      child: Column(
                        children: [
                          Container(
                            width: 40.w,
                            height: 2.w,
                            decoration: BoxDecoration(
                                color: tabsRouter.activeIndex == 1
                                    ? context.colorScheme.onPrimary
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(10.w)),
                          ),
                          SizedBox(height: 3.h),
                          Icon(
                            Icons.event_rounded,
                            color: context.colorScheme.onPrimary,
                            size: 24.w,
                          ),
                          SizedBox(height: 3.h),
                          Text(
                            LocaleKeys.homepage_bottombar_activity.tr(),
                            style: context.textTheme.labelSmall!
                                .copyWith(letterSpacing: 0),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10.h,
                )
              ],
            ),
          );
        });

    // Scaffold(
    //   body: screenList[_activePageIndex],
    //   bottomNavigationBar: SizedBox(
    //     height: 66.h,
    //     child: BottomNavigationBar(
    //       onTap: (value) => setState(() {
    //         _activePageIndex = value;
    //       }),
    //       currentIndex: _activePageIndex,
    //       iconSize: 18.sp,
    //       selectedFontSize: 12.sp,
    //       backgroundColor: context.colorScheme.background,
    //       unselectedItemColor: context.colorScheme.onPrimary,
    //       selectedItemColor: context.colorScheme.onPrimary,
    //       items: [
    //         BottomNavigationBarItem(
    //           icon: const Icon(
    //             Icons.home,
    //           ),
    //           label: LocaleKeys.homepage_bottombar_home.tr(),
    //         ),
    //         BottomNavigationBarItem(
    //             icon: const Icon(
    //               Icons.calendar_month_outlined,
    //             ),
    //             label: LocaleKeys.homepage_bottombar_activity.tr()),
    //       ],
    //     ),
    //   ),
    // );
  }
}
