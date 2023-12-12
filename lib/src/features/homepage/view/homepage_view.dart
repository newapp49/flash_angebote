import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flash_angebote/src/features/homepage/model/flyer_model.dart';
import 'package:flash_angebote/src/features/homepage/view_model/homepage_cubit.dart';
import 'package:flash_angebote/src/features/homepage/view_model/homepage_state.dart';
import 'package:flash_angebote/src/routing/app_router.dart';
import 'package:flash_angebote/src/shared/utils/extension/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/init/lang/locale_keys.g.dart';

@RoutePage(name: 'HomeRoute')
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late HomePageCubit _cubit;

  @override
  void initState() {
    _cubit = BlocProvider.of<HomePageCubit>(context);
    _cubit.init();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(context.width, 40.h),
        child: appBar(context),
      ),
      backgroundColor: context.colorScheme.background,
      body: BlocBuilder<HomePageCubit, HomePageState>(
        builder: (BuildContext context, state) {
          if (state is HomePageInitial) {
            return pageBody(context);
          } else if (state is HomePageLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is HomePageComplete) {
            return pageBody(context);
          } else {
            final error = state is HomePageError;
            return Text(error.toString());
          }
        },
      ),
    );
  }

  SingleChildScrollView pageBody(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          billboardCards(_cubit),
          SizedBox(height: 5.h),
          buildPageIndicators(_cubit.topsideFlyerUrls.length),
          SizedBox(height: 5.h),
          recommendedText(context),
          SizedBox(height: 5.h),
          recommendedFlyerCards(context),
          divider(context),
          closeMarketFlyers(_cubit, context)
        ],
      ),
    );
  }

  GridView closeMarketFlyers(HomePageCubit cubit, BuildContext context) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      itemCount: cubit.flyerList!.length,
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          childAspectRatio: 0.65.w, crossAxisCount: 2),
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            FlyerModel? selectedFlyer = cubit.flyerList![index];
            showDialog(
              context: context,
              builder: (context) => Dialog(
                child: Container(
                  color: context.colorScheme.background,
                  width: context.width,
                  height: 465.w,
                  child: Column(
                    children: [
                      SizedBox(
                        width: context.width,
                        height: 450.w,
                        child: PageView.builder(
                          itemCount: selectedFlyer!.pageCount!,
                          itemBuilder: (context, index) => Container(
                            height: 450.w,
                            width: context.width,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: NetworkImage(
                                    selectedFlyer.flyerUrls![index]!,
                                  ),
                                  fit: BoxFit.cover),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 2.w,
                      ),
                      buildPageIndicators(selectedFlyer.pageCount!)
                    ],
                  ),
                ),
              ),
            );
          },
          child: Padding(
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
                    Container(
                        margin: context.paddingHorizontal1,
                        height: 20.h,
                        child: Text(
                          cubit.companyList![index]!.companyName!,
                          style: context.textTheme.headlineMedium!
                              .copyWith(fontWeight: FontWeight.bold),
                        )),
                    Container(
                      width: 150.w,
                      height: 135.h,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: NetworkImage(
                                cubit.flyerList![index]!.flyerUrls![0]!),
                            fit: BoxFit.fitWidth),
                      ),
                    ),
                    SizedBox(
                      height: 15.h,
                      child: Text(
                        cubit.getExpireDay(
                              DateFormat('dd/MM/yyyy')
                                  .parse(cubit.flyerList![index]!.expireDate!),
                            ) +
                            ' ' +
                            LocaleKeys.homepage_days_left.tr(),
                        style: context.textTheme.labelSmall!
                            .copyWith(letterSpacing: 0),
                      ),
                    ),
                    SizedBox(
                      height: 15.h,
                      child: Text(
                        "${cubit.locationList.values.toList()[index].toInt()} ${LocaleKeys.homepage_km.tr()}",
                        style: context.textTheme.labelSmall!
                            .copyWith(letterSpacing: 0),
                      ),
                    )
                  ],
                ),
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

  Widget recommendedFlyerCards(BuildContext context) {
    return Container(
      padding: context.paddingHorizontal2,
      width: context.width,
      height: 120.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.zero,
        itemCount: 3,
        shrinkWrap: true,
        itemBuilder: (context, index) => Container(
          margin: index == 1 ? context.paddingHorizontal2 : EdgeInsets.zero,
          width: 99.w,
          decoration: BoxDecoration(
              color: context.colorScheme.onSurface,
              borderRadius: BorderRadius.circular(5.w)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  alignment: Alignment.center,
                  height: 20.h,
                  child: Text(
                    _cubit.companyList![index]!.companyName!,
                    style: context.textTheme.headlineMedium!
                        .copyWith(fontSize: 12.sp, fontWeight: FontWeight.bold),
                  )),
              Container(
                width: 100.w,
                height: 95.h,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage(
                            _cubit.companyList![index]!.companyLogo!),
                        fit: BoxFit.cover)),
              ),
              // const Spacer(),
              // SizedBox(
              //   height: 15.h,
              //   child: Text(
              //     "4 ${LocaleKeys.homepage_days_left.tr()}",
              //     style: context.textTheme.labelSmall!
              //         .copyWith(letterSpacing: 0),
              //   ),
              // ),
              // SizedBox(
              //   height: 15.h,
              //   child: Text(
              //     "1.2 ${LocaleKeys.homepage_km.tr()}",
              //     style: context.textTheme.labelSmall!
              //         .copyWith(letterSpacing: 0),
              //   ),
              // )
            ],
          ),
        ),
      ),
    );
  }

  Container recommendedText(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: context.paddingHorizontal2,
      child: Text(
        LocaleKeys.homepage_recommended.tr(),
        style: context.textTheme.bodyLarge!
            .copyWith(letterSpacing: 0, fontSize: 15.sp),
      ),
    );
  }

  SizedBox buildPageIndicators(int itemCount) {
    return SizedBox(
      height: 5.h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ListView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            itemCount: itemCount,
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

  SizedBox billboardCards(HomePageCubit cubit) {
    return SizedBox(
      height: 140.h,
      child: PageView.builder(
        itemCount: _cubit.topsideFlyerUrls.length,
        onPageChanged: (value) {},
        itemBuilder: (context, index) {
          return Container(
            width: context.width,
            margin: context.paddingHorizontal2,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: NetworkImage(
                    cubit.topsideFlyerUrls[index],
                  ),
                  fit: BoxFit.cover),
              borderRadius: BorderRadius.circular(5.w),
            ),
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
