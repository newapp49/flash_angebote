import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flash_angebote/core/init/lang/locale_keys.g.dart';
import 'package:flash_angebote/src/shared/utils/extension/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
      body: bodyPage(context),
    );
  }

  SingleChildScrollView bodyPage(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: context.padding2,
        child: Row(
          children: [
            leftSide(context),
            SizedBox(
              width: 20.w,
            ),
            rightSide(context),
          ],
        ),
      ),
    );
  }

  Expanded rightSide(BuildContext context) {
    return Expanded(
      child: Container(
        width: 215.h,
        height: 65.h + 422.h + context.value2.h,
        decoration: BoxDecoration(
          color: context.colorScheme.onSurface,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Padding(
          padding: context.paddingVertical2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: context.paddingHorizontal2,
                child: Container(
                  height: 30.h,
                  child: TextFormField(
                    textAlignVertical: TextAlignVertical.bottom,
                    style: context.textTheme.bodyLarge,
                    cursorHeight: 14.h,
                    decoration: InputDecoration(
                      hintText: "Ürün aratın...",
                      hintStyle: context.textTheme.titleMedium!
                          .copyWith(color: context.colorScheme.onPrimary),
                      filled: true,
                      fillColor: context.colorScheme.background,
                      suffixIcon: Padding(
                        padding: context.leftPadding1,
                        child: Icon(
                          Icons.search,
                          color: context.colorScheme.onPrimary,
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.amber),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: context.colorScheme.onTertiary,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:
                            BorderSide(color: context.colorScheme.onTertiary),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: context.paddingHorizontal3,
                child: Padding(
                  padding: context.paddingVertical1,
                  child: Text(
                    "Eklemek/çıkarmak için dokunun",
                    style: context.textTheme.titleMedium!
                        .copyWith(color: context.colorScheme.onPrimary),
                  ),
                ),
              ),
              divider(context)
            ],
          ),
        ),
      ),
    );
  }

  Container divider(BuildContext context) {
    return Container(
      padding: context.paddingHorizontal1,
      height: 15.h,
      child: Divider(
        color: context.colorScheme.onTertiary,
        thickness: 1.5.w,
      ),
    );
  }

  Column leftSide(BuildContext context) {
    return Column(
      children: [
        Container(
          width: context.width / 4,
          height: 422.h,
          decoration: BoxDecoration(
              color: context.colorScheme.onSurface,
              borderRadius: BorderRadius.circular(4)),
          child: Padding(
            padding: context.paddingHorizontal1,
            child: Column(children: [
              SizedBox(
                width: context.width / 4,
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
                                style: context.textTheme.displayLarge!.copyWith(
                                    color: context.colorScheme.onPrimary)),
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
        SizedBox(
          height: context.value2,
        ),
        Container(
          padding: context.padding1,
          height: 65.h,
          width: context.width / 4,
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
      ],
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
