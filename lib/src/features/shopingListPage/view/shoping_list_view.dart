import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flash_angebote/core/init/lang/locale_keys.g.dart';
import 'package:flash_angebote/src/features/shopingListPage/sqlite/repo.dart';
import 'package:flash_angebote/src/features/shopingListPage/view_model/shopping_list_cubit.dart';
import 'package:flash_angebote/src/features/shopingListPage/view_model/shopping_list_state.dart';
import 'package:flash_angebote/src/shared/utils/extension/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

@RoutePage(name: 'ListRoute')
class ShopingListPage extends StatefulWidget {
  const ShopingListPage({super.key});

  @override
  State<ShopingListPage> createState() => _ShopingListPageState();
}

class _ShopingListPageState extends State<ShopingListPage> {
  final ScrollController _firstController = ScrollController();
  late List<String> shopLista;
  bool sizeBool = true;

  @override
  void initState() {
    shopLista = <String>[];
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
      body: Center(child: bodyPage(context, shopLista)),
    );
  }

  SingleChildScrollView bodyPage(BuildContext context, List<String> shopList) {
    return SingleChildScrollView(
      physics: NeverScrollableScrollPhysics(),
      child: Padding(
        padding: context.padding2,
        child: IntrinsicHeight(
          child: Expanded(
            child: Row(
              children: [
                leftSide(context, shopList),
                SizedBox(
                  width: 10.w,
                ),
                rightSide(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //Right Side Component
  Expanded rightSide(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: context.colorScheme.onSurface,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Padding(
          padding: context.paddingVertical2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              topSearchField(context),
              divider(context),
              searchBarOpenStateTopContainer(context),
              Visibility(visible: !sizeBool, child: divider(context)),
              shopListContainer(context),
              bottomSearchField(context),
            ],
          ),
        ),
      ),
    );
  }

  Padding bottomSearchField(BuildContext context) {
    return Padding(
      padding: context.paddingHorizontal2.copyWith(top: context.value2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(
            Icons.camera_alt_outlined,
            color: context.colorScheme.onPrimary,
          ),
          Container(
            height: 30.h,
            width: 180.w,
            child: TextFormField(
              textAlignVertical: TextAlignVertical.bottom,
              style: context.textTheme.bodyLarge,
              cursorHeight: 14.h,
              decoration: InputDecoration(
                hintText:
                    "${LocaleKeys.shopping_list_page_what_do_you_whant.tr()}",
                hintStyle: context.textTheme.titleMedium!
                    .copyWith(color: context.colorScheme.onPrimary),
                filled: true,
                fillColor: context.colorScheme.background,
                suffixIcon: Padding(
                  padding: context.leftPadding1,
                  child: Icon(
                    Icons.send,
                    color: context.colorScheme.onPrimary,
                  ),
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.amber),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(
                    color: context.colorScheme.onTertiary,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: context.colorScheme.onTertiary),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Padding topSearchField(BuildContext context) {
    return Padding(
      padding: context.paddingHorizontal2,
      child: Container(
        height: 30.h,
        child: TextFormField(
          textAlignVertical: TextAlignVertical.bottom,
          style: context.textTheme.bodyLarge,
          cursorHeight: 14.h,
          decoration: InputDecoration(
            hintText: "${LocaleKeys.shopping_list_page_search_item.tr()}",
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
              borderSide: BorderSide(color: context.colorScheme.onTertiary),
            ),
          ),
        ),
      ),
    );
  }

  Padding shopListContainer(BuildContext context) {
    return Padding(
      padding: context.paddingHorizontal2,
      child: Expanded(
        child: GestureDetector(
          onTap: () {
            setState(() {
              sizeBool == true ? sizeBool = false : sizeBool = true;
            });
          },
          child: Container(
            width: double.maxFinite,
            height: sizeBool == true ? context.height - 275.h : 200.h,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Alışveriş Listem 1",
                  style: context.textTheme.titleMedium!
                      .copyWith(color: context.colorScheme.onPrimary),
                ),
                Expanded(
                  child: Container(
                    child: ListView(children: [
                      itemWithImage(context, false),
                      itemWithoutImage(context),
                      itemWithoutImage(context),
                      itemWithoutImage(context),
                    ]),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Visibility searchBarOpenStateTopContainer(BuildContext context) {
    return Visibility(
        visible: !sizeBool,
        child: Padding(
          padding: context.paddingHorizontal2,
          child: Container(
            width: double.maxFinite,
            height: context.height - 485.h,
            //height: context.height - 604.20 - 6 + context.value1 + 35,
            child: Container(
              width: double.maxFinite,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${LocaleKeys.shopping_list_page_most_used.tr()}",
                    style: context.textTheme.titleMedium!
                        .copyWith(color: context.colorScheme.onPrimary),
                  ),
                  Container(width: 250.w, child: itemWithImage(context, true)),
                  divider(context),
                  Expanded(
                    child: Container(
                      child: ListView(children: [
                        itemWithImage(context, true),
                        itemWithImage(context, true),
                        itemWithImage(context, true),
                        itemWithImage(context, true),
                      ]),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  Padding itemWithoutImage(BuildContext context) {
    return Padding(
      padding: context.topPadding1,
      child: Container(
        width: 200.w,
        decoration: BoxDecoration(
            color: context.colorScheme.background,
            borderRadius: BorderRadius.circular(4)),
        child: Padding(
          padding: context.padding1,
          child: Text(
            "Dinozor şeklinde olan kek kalıplarından 5 tane Dinozor şeklinde olan kek kalıplarından 5 tane",
            style: context.textTheme.bodyLarge,
          ),
        ),
      ),
    );
  }

  Padding itemWithImage(BuildContext context, bool searchBool) {
    return Padding(
      padding: context.topPadding1,
      child: Container(
        width: 200.w,
        height: 50.h,
        decoration: BoxDecoration(
            color: context.colorScheme.background,
            borderRadius: BorderRadius.circular(4)),
        child: Row(
          children: [
            Padding(
              padding: context.padding1,
              child: Container(
                width: 40.w,
                height: 50.h,
                decoration: BoxDecoration(
                    color: context.colorScheme.onPrimary,
                    borderRadius: BorderRadius.circular(4)),
              ),
            ),
            Padding(
              padding: context.topPadding1.copyWith(),
              child: Container(
                width: searchBool == true ? 120.w : 100.w,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Lays",
                      overflow: TextOverflow.ellipsis,
                      style: context.textTheme.labelSmall,
                    ),
                    Text(
                      "Lays 150g Yoğurt ve Mevsim Yeşillikli",
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: context.textTheme.labelSmall,
                    )
                  ],
                ),
              ),
            ),
            Spacer(),
            Padding(
              padding: context.rightPadding1,
              child: searchBool == true
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          alignment: Alignment.center,
                          width: 18.w,
                          height: 18.h,
                          decoration: BoxDecoration(
                              color: context.colorScheme.onTertiary,
                              shape: BoxShape.circle),
                          child: Text(
                            "+",
                            textAlign: TextAlign.center,
                            style: context.textTheme.headlineSmall,
                          ),
                        ),
                        SizedBox(
                          height: 4.h,
                        ),
                        Container(
                          alignment: Alignment.center,
                          width: 18.w,
                          height: 18.h,
                          decoration: BoxDecoration(
                              color: context.colorScheme.background,
                              border: Border.all(
                                color: context.colorScheme.onTertiary,
                              ),
                              shape: BoxShape.circle),
                          child: Text(
                            "-",
                            textAlign: TextAlign.center,
                            style: context.textTheme.headlineSmall!.copyWith(
                              color: context.colorScheme.onTertiary,
                            ),
                          ),
                        )
                      ],
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              alignment: Alignment.center,
                              width: 18.w,
                              height: 18.h,
                              decoration: BoxDecoration(
                                  color: context.colorScheme.onTertiary,
                                  shape: BoxShape.circle),
                              child: Text(
                                "+",
                                textAlign: TextAlign.center,
                                style: context.textTheme.headlineSmall,
                              ),
                            ),
                            SizedBox(
                              width: 4.w,
                            ),
                            Container(
                              alignment: Alignment.center,
                              width: 18.w,
                              height: 18.h,
                              decoration: BoxDecoration(
                                  color: context.colorScheme.background,
                                  border: Border.all(
                                    color: context.colorScheme.onTertiary,
                                  ),
                                  shape: BoxShape.circle),
                              child: Text(
                                "-",
                                textAlign: TextAlign.center,
                                style:
                                    context.textTheme.headlineSmall!.copyWith(
                                  color: context.colorScheme.onTertiary,
                                ),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 4.h,
                        ),
                        Text(
                          "1 Adet",
                          style: context.textTheme.labelSmall,
                        )
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Container divider(BuildContext context) {
    return Container(
      padding: context.paddingHorizontal1,
      height: 10.h,
      child: Divider(
        color: context.colorScheme.onTertiary,
        thickness: 1.5.w,
      ),
    );
  }

  //Left Side Component
  Column leftSide(BuildContext context, List<String> shopList) {
    return Column(
      children: [
        Expanded(
          child: Container(
            width: 80.w,
            decoration: BoxDecoration(
                color: context.colorScheme.onSurface,
                borderRadius: BorderRadius.circular(4)),
            child: Padding(
              padding: context.paddingHorizontal1,
              child: Column(children: [
                Container(
                  width: 80.w,
                  height: 420.h,
                  child: RawScrollbar(
                    crossAxisMargin: -context.value2,
                    thickness: 5,
                    thumbVisibility: true,
                    controller: _firstController,
                    interactive: true,
                    thumbColor: context.colorScheme.onTertiary,
                    radius: Radius.circular(4),
                    child: BlocBuilder<ShoppingListAddCubit,
                        ShoppingListChangeEvent>(
                      builder: (BuildContext context,
                          ShoppingListChangeEvent state) {
                        return ListView.builder(
                          controller: _firstController,
                          itemCount:
                              state.shopList.length + 1, //shopList.length + 1,
                          itemBuilder: (context, index) {
                            if (index == state.shopList.length ||
                                state.shopList.isEmpty) {
                              return GestureDetector(
                                  onTap: () {
                                    print(state.shopList.length);
                                    BlocProvider.of<ShoppingListAddCubit>(
                                            context)
                                        .addShoppingList("new $index");
                                  },
                                  child: addShopListContainer(context));
                            }
                            return shopListNameContainer(
                                context, state.shopList[index]);
                          },
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
        shareButton(context),
      ],
    );
  }

  Padding addShopListContainer(BuildContext context) {
    return Padding(
      padding: context.topPadding1.copyWith(bottom: context.value1),
      child: Container(
        padding: context.padding1,
        width: double.maxFinite,
        alignment: Alignment.center,
        height: 60.h,
        decoration: BoxDecoration(
            color: context.colorScheme.background,
            borderRadius: BorderRadius.all(Radius.circular(4))),
        child: Text("+",
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            textAlign: TextAlign.center,
            style: context.textTheme.displayLarge!
                .copyWith(color: context.colorScheme.onPrimary)),
      ),
    );
  }

  Padding shopListNameContainer(BuildContext context, String name) {
    return Padding(
      padding: context.topPadding1,
      child: Container(
        padding: context.padding1,
        width: double.maxFinite,
        alignment: Alignment.center,
        height: 60.h,
        decoration: BoxDecoration(
            color: context.colorScheme.background,
            borderRadius: BorderRadius.all(Radius.circular(4))),
        child: Text(name,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            textAlign: TextAlign.center,
            style: context.textTheme.labelSmall!.copyWith(fontSize: 10.sp)),
      ),
    );
  }

  Container shareButton(BuildContext context) {
    return Container(
      padding: context.padding1,
      height: 80.h,
      width: 80.w,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: context.colorScheme.inversePrimary.withOpacity(0.5),
          border: Border.all(
            color: context.colorScheme.inversePrimary,
            width: 2,
          ),
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
