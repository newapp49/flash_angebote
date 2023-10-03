import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flash_angebote/core/init/lang/locale_keys.g.dart';
import 'package:flash_angebote/src/shared/utils/extension/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../routing/app_router.dart';

@RoutePage(name: 'ListRoute')
class ShopingListPage extends StatefulWidget {
  const ShopingListPage({super.key});

  @override
  State<ShopingListPage> createState() => _ShopingListPageState();
}

class _ShopingListPageState extends State<ShopingListPage> {
  final ScrollController _firstController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(context.width, 40.h),
        child: appBar(context),
      ),
      backgroundColor: context.colorScheme.background,
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
      body: bodyPage(context),
    );
  }

  Center bodyPage(BuildContext context) {
    return Center(
      child: Padding(
        padding: context.padding2,
        child: Row(
          children: [
            leftSide(context),
            SizedBox(
              width: context.value2,
            ),
            rightSide(context),
          ],
        ),
      ),
    );
  }

  Expanded rightSide(BuildContext context) {
    return Expanded(
      flex: 5,
      child: Container(
        color: context.colorScheme.onSurface,
      ),
    );
  }

  Expanded leftSide(BuildContext context) {
    return Expanded(
      flex: 2,
      child: Column(
        children: [
          Expanded(
            flex: 7,
            child: Container(
              color: context.colorScheme.onSurface,
              child: Padding(
                padding: context.paddingHorizontal1,
                child: Column(children: [
                  SizedBox(
                    width: double.maxFinite,
                    height: 420.h,
                    child: RawScrollbar(
                      crossAxisMargin: -context.value2,
                      thickness: 5,
                      thumbVisibility: true,
                      controller: _firstController,
                      interactive: true,
                      thumbColor: context.randomColor,
                      child: ListView.builder(
                        controller: _firstController,
                        itemCount: 10,
                        itemBuilder: (context, index) {
                          if (index == 9) {
                            return Padding(
                              padding: context.paddingVertical1,
                              child: Container(
                                padding: context.padding1,
                                width: double.maxFinite,
                                alignment: Alignment.center,
                                height: 70.h,
                                decoration: BoxDecoration(
                                    color: context.colorScheme.background,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(4))),
                                child: Text("+",
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    textAlign: TextAlign.center,
                                    style: context.textTheme.displayLarge!
                                        .copyWith(
                                            color:
                                                context.colorScheme.onPrimary)),
                              ),
                            );
                          }
                          return Padding(
                            padding: context.paddingVertical1,
                            child: Container(
                              padding: context.padding1,
                              width: double.maxFinite,
                              alignment: Alignment.center,
                              height: 70.h,
                              decoration: BoxDecoration(
                                  color: context.colorScheme.background,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4))),
                              child: Text("Alışveriş Listem 2",
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  textAlign: TextAlign.center,
                                  style: context.textTheme.labelSmall),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ]),
              ),
            ),
          ),
          SizedBox(
            height: context.value2,
          ),
          Expanded(
            flex: 1,
            child: Container(
              padding: context.padding1,
              width: double.maxFinite,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: context.colorScheme.onSurface,
                  borderRadius: BorderRadius.all(Radius.circular(4))),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.share,
                    color: context.colorScheme.onPrimary,
                    size: 25.h,
                  ),
                  Text("Paylaş",
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      style: context.textTheme.labelSmall!
                          .copyWith(color: context.colorScheme.onPrimary)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  AppBar appBar(BuildContext context) {
    return AppBar(
      actions: [
        IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.settings,
              size: 25.sp,
            ))
      ],
      leading: IconButton(
        onPressed: () {
          context.router.pop();
        },
        icon: Icon(
          Icons.turn_left_sharp,
          size: 25.sp,
        ),
      ),
      title: Text(
        LocaleKeys.homepage_title.tr(),
        style: context.textTheme.labelLarge,
      ),
      centerTitle: true,
      elevation: 0,
    );
  }
}
