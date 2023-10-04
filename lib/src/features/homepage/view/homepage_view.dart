import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flash_angebote/src/routing/app_router.dart';
import 'package:flash_angebote/src/shared/utils/extension/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/init/lang/locale_keys.g.dart';

@RoutePage(name: 'HomeRoute')
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(context.width, 40.h),
        child: appBar(context),
      ),
      backgroundColor: context.colorScheme.background,
      body: pageBody(context),
    );
  }

  SingleChildScrollView pageBody(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          billboardCards(),
          SizedBox(height: 5.h),
          buildPageIndicators(),
          SizedBox(height: 5.h),
          recommendedText(context),
          SizedBox(height: 3.h),
          recommendedFlyerCards(context),
          divider(context),
          closeMarketFlyers()
        ],
      ),
    );
  }

  GridView closeMarketFlyers() {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 10,
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          childAspectRatio: 0.65.w, crossAxisCount: 2),
      itemBuilder: (context, index) {
        return Padding(
          padding: context.paddingHorizontal2,
          child: Container(
            margin: context.paddingVertical1,
            decoration: BoxDecoration(
                color: context.colorScheme.onSurface,
                borderRadius: BorderRadius.circular(5.w)),
            child: Padding(
              padding: EdgeInsets.all(2.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                      height: 20.h,
                      child: Text(
                        "A101",
                        style: context.textTheme.headlineMedium,
                      )),
                  Container(
                    width: 150.w,
                    height: 135.h,
                    color: context.randomColor,
                  ),
                  SizedBox(
                    height: 15.h,
                    child: Text(
                      "4 ${LocaleKeys.homepage_days_left.tr()}",
                      style: context.textTheme.labelSmall!
                          .copyWith(letterSpacing: 0),
                    ),
                  ),
                  SizedBox(
                    height: 15.h,
                    child: Text(
                      "1.2 ${LocaleKeys.homepage_km.tr()}",
                      style: context.textTheme.labelSmall!
                          .copyWith(letterSpacing: 0),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Container divider(BuildContext context) {
    return Container(
      padding: context.paddingHorizontal2,
      height: 20.h,
      child: Divider(
        color: context.colorScheme.onSurface,
        thickness: 1.5.w,
      ),
    );
  }

  Row recommendedFlyerCards(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          width: 100.w,
          height: 150.h,
          decoration: BoxDecoration(
              color: context.colorScheme.onSurface,
              borderRadius: BorderRadius.circular(5.w)),
          child: Padding(
            padding: EdgeInsets.all(2.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                    height: 20.h,
                    child: Text(
                      "A101",
                      style: context.textTheme.headlineMedium,
                    )),
                Container(
                  width: 100.w,
                  height: 95.h,
                  color: context.randomColor,
                ),
                const Spacer(),
                SizedBox(
                  height: 15.h,
                  child: Text(
                    "4 ${LocaleKeys.homepage_days_left.tr()}",
                    style: context.textTheme.labelSmall!
                        .copyWith(letterSpacing: 0),
                  ),
                ),
                SizedBox(
                  height: 15.h,
                  child: Text(
                    "1.2 ${LocaleKeys.homepage_km.tr()}",
                    style: context.textTheme.labelSmall!
                        .copyWith(letterSpacing: 0),
                  ),
                )
              ],
            ),
          ),
        ),
        Container(
          width: 100.w,
          height: 150.h,
          decoration: BoxDecoration(
              color: context.colorScheme.onSurface,
              borderRadius: BorderRadius.circular(5.w)),
          child: Padding(
            padding: EdgeInsets.all(2.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                    height: 20.h,
                    child: Text(
                      "A101",
                      style: context.textTheme.headlineMedium,
                    )),
                Container(
                  width: 100.w,
                  height: 95.h,
                  color: context.randomColor,
                ),
                const Spacer(),
                SizedBox(
                  height: 15.h,
                  child: Text(
                    "4 ${LocaleKeys.homepage_days_left.tr()}",
                    style: context.textTheme.labelSmall!
                        .copyWith(letterSpacing: 0),
                  ),
                ),
                SizedBox(
                  height: 15.h,
                  child: Text(
                    "1.2 ${LocaleKeys.homepage_km.tr()}",
                    style: context.textTheme.labelSmall!
                        .copyWith(letterSpacing: 0),
                  ),
                )
              ],
            ),
          ),
        ),
        Container(
          width: 100.w,
          height: 150.h,
          decoration: BoxDecoration(
              color: context.colorScheme.onSurface,
              borderRadius: BorderRadius.circular(5.w)),
          child: Padding(
            padding: EdgeInsets.all(2.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                    height: 20.h,
                    child: Text(
                      "A101",
                      style: context.textTheme.headlineMedium,
                    )),
                Container(
                  width: 100.w,
                  height: 95.h,
                  color: context.randomColor,
                ),
                const Spacer(),
                SizedBox(
                  height: 15.h,
                  child: Text(
                    "4 ${LocaleKeys.homepage_days_left.tr()}",
                    style: context.textTheme.labelSmall!
                        .copyWith(letterSpacing: 0),
                  ),
                ),
                SizedBox(
                  height: 15.h,
                  child: Text(
                    "1.2 ${LocaleKeys.homepage_km.tr()}",
                    style: context.textTheme.labelSmall!
                        .copyWith(letterSpacing: 0),
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  Container recommendedText(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: context.paddingHorizontal2,
      child: Text(
        LocaleKeys.homepage_recommended.tr(),
        style: context.textTheme.bodyLarge!.copyWith(letterSpacing: 0),
      ),
    );
  }

  SizedBox buildPageIndicators() {
    return SizedBox(
      height: 5.h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ListView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            itemCount: 4,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 2.w),
                child: CircleAvatar(
                  radius: 3.sp,
                  backgroundColor: context.colorScheme.surface,
                ),
              );
            },
          )
        ],
      ),
    );
  }

  SizedBox billboardCards() {
    return SizedBox(
      height: 140.h,
      child: PageView.builder(
        itemCount: 4,
        onPageChanged: (value) {},
        itemBuilder: (context, index) {
          return Container(
            width: context.width,
            margin: context.paddingHorizontal2,
            decoration: BoxDecoration(
                color: context.randomColor,
                borderRadius: BorderRadius.circular(5.w)),
          );
        },
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
          context.router.push(const ListRoute());
        },
        icon: Icon(
          Icons.menu,
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
