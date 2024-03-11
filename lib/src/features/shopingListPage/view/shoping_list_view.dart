import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:hive/hive.dart';
import 'package:wingo/core/init/lang/locale_keys.g.dart';
import 'package:wingo/src/features/shopingListPage/model/image_item.model.dart';
import 'package:wingo/src/features/shopingListPage/model/list_model.dart';
import 'package:wingo/src/features/shopingListPage/model/text_item_model.dart';
import 'package:wingo/src/features/shopingListPage/sqlite/repo.dart';
import 'package:wingo/src/features/shopingListPage/view_model/shopping_list_cubit.dart';
import 'package:wingo/src/features/shopingListPage/view_model/shopping_list_state.dart';
import 'package:wingo/src/shared/utils/extension/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:http/http.dart' as http;

@RoutePage(name: 'ListRoute')
class ShopingListPage extends StatefulWidget {
  const ShopingListPage({super.key});

  @override
  State<ShopingListPage> createState() => _ShopingListPageState();
}

class _ShopingListPageState extends State<ShopingListPage> {
  final ScrollController _firstController = ScrollController();
  final TextEditingController _textController = TextEditingController();
  final TextEditingController _topTextController = TextEditingController();

  final TextEditingController _listNameController = TextEditingController();
  int textIndex = 0;
  ListModel textResult = ListModel(name: "", result: []);
  bool sizeBool = true;

  @override
  void initState() {
    _topTextController.addListener(() {});
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
      body: Center(child: bodyPage(context)),
    );
  }

  SingleChildScrollView bodyPage(BuildContext context) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(), //NeverScrollableScrollPhysics(),
      child: Container(
        width: context.width,
        //height: context.height,
        padding: context.padding2,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            leftSide(context),
            SizedBox(
              width: 10.w,
            ),
            Expanded(child: rightSide(context)),
          ],
        ),
      ),
    );
  }

  //Right Side Component
  Widget rightSide(BuildContext context) {
    return Container(
      width: 230.w,
      height: 580.h,
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
            //const Spacer(),
            bottomSearchField(context),
          ],
        ),
      ),
    );
  }

  Widget bottomSearchField(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
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
              textAlign: TextAlign.left,
              controller: _textController,
              style: context.textTheme.bodyLarge,
              cursorHeight: 14.h,
              decoration: InputDecoration(
                contentPadding: context.leftPadding2,
                hintText: "${LocaleKeys.shopping_list_page_what_do_you_whant.tr()}",
                hintStyle: context.textTheme.titleMedium!.copyWith(color: context.colorScheme.onPrimary),
                filled: true,
                fillColor: context.colorScheme.background,
                suffixIcon: Padding(
                  padding: context.leftPadding1,
                  child: BlocBuilder<ShoppingListViewCubit, ShoppingListView>(
                    builder: (context, state) {
                      return GestureDetector(
                        onTap: () {
                          if (state is ShoppingListViewEvent) {
                            BlocProvider.of<ShoppingListViewCubit>(context)
                                .addTextItem(textIndex, textResult, _textController.text);
                            _textController.clear();
                          }
                        },
                        child: Icon(
                          Icons.send,
                          color: context.colorScheme.onPrimary,
                        ),
                      );
                    },
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
          controller: _topTextController,
          textAlign: TextAlign.left,
          onChanged: (value) {
            if (value.length > 2) {
              BlocProvider.of<SearchListViewCubit>(context).getList(_topTextController.text);
            } else {
              BlocProvider.of<SearchListViewCubit>(context).emptyList();
            }
          },
          style: context.textTheme.bodyLarge,
          cursorHeight: 14.h,
          onTap: () {
            setState(() {
              sizeBool = false;
            });
          },
          onEditingComplete: () {
            setState(() {
              sizeBool = true;
              FocusScope.of(context).unfocus();
            });
          },
          decoration: InputDecoration(
            contentPadding: context.leftPadding2,
            hintText: "${LocaleKeys.shopping_list_page_search_item.tr()}",
            hintStyle: context.textTheme.titleMedium!.copyWith(color: context.colorScheme.onPrimary),
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

  shopListContainer(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.only(bottom: context.value2, left: context.value2, right: context.value2),
        child: Container(
          width: double.maxFinite,
          //height: sizeBool == true ? context.height - 210.h : 197.h,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BlocBuilder<ShoppingListViewCubit, ShoppingListView>(builder: (BuildContext context, state) {
                if (state is ShoppingListViewEventInitial) {
                  return Text("");
                } else if (state is ShoppingListViewEvent) {
                  return Text(
                    state.shopList.name,
                    style: context.textTheme.titleMedium!.copyWith(color: context.colorScheme.onPrimary),
                  );
                }
                return Text("");
              }),
              BlocBuilder<ShoppingListViewCubit, ShoppingListView>(
                builder: (BuildContext context, state) {
                  if (state is ShoppingListViewEventInitial) {
                    return Center(
                      child: Text(
                        "Liste Seç",
                        style: context.textTheme.titleMedium!.copyWith(color: context.colorScheme.onPrimary),
                      ),
                    );
                  } else if (state is ShoppingListViewEvent) {
                    if (state.shopList.result.isEmpty) {
                      return Center(
                          child: Text(
                        "Bu Liste Boş",
                        style: context.textTheme.titleMedium!.copyWith(color: context.colorScheme.onPrimary),
                      ));
                    }
                    return Expanded(
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        itemCount: state.shopList.result.length + 1,
                        itemBuilder: (context, index) {
                          if (index == state.shopList.result.length || state.shopList.result.isEmpty) {
                            return null;
                          } else if (state.shopList.result[index] is TextItem) {
                            var a = state.shopList.result[index] as TextItem;
                            return itemWithoutImage(index, context, a.text);
                          } else if (state.shopList.result[index] is ImageItem) {
                            var a = state.shopList.result[index] as ImageItem;
                            return itemWithImage(context, false, a.text, a.bottomText, a.adet, index, a.imageUrl);
                          }

                          return null;
                        },
                      ),
                    );
                  } else {
                    return Text("bir Hata oluştu");
                  }
                },
              ),
            ],
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
            child: Container(
              width: double.maxFinite,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${LocaleKeys.shopping_list_page_most_used.tr()}",
                    style: context.textTheme.titleMedium!.copyWith(color: context.colorScheme.onPrimary),
                  ),
                  divider(context),
                  Expanded(
                    child: Container(
                        child: BlocBuilder<SearchListViewCubit, SearchListView>(builder: (BuildContext context, state) {
                      if (state is SearchListViewInitial) {
                        return Center(
                            child: Text(
                          "Arama Yapmak için 3 harf yada fazlasını giriniz",
                          textAlign: TextAlign.center,
                          style: context.textTheme.titleMedium!.copyWith(color: context.colorScheme.onPrimary),
                        ));
                      } else if (state is SearchListViewOnItemCame) {
                        return ListView.builder(
                          itemCount: state.list.length,
                          itemBuilder: (context, index) {
                            return itemWithImage(context, true, state.list.elementAt(index).productName.toString(), "",
                                index, index, state.list.elementAt(index).productImages!.elementAt(0).toString());
                          },
                        );
                      } else {
                        return Text("Ürün Yok");
                      }
                    })),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  Padding itemWithoutImage(
    int index,
    BuildContext context,
    String text,
  ) {
    return Padding(
      padding: context.topPadding1,
      child: Container(
        width: 200.w,
        decoration: BoxDecoration(color: context.colorScheme.background, borderRadius: BorderRadius.circular(4)),
        child: Padding(
          padding: context.padding1,
          child: Row(
            children: [
              Container(
                width: context.width / 2.3,
                child: Text(
                  text,
                  style: context.textTheme.bodyLarge,
                ),
              ),
              Spacer(),
              GestureDetector(
                onTap: () {
                  BlocProvider.of<ShoppingListViewCubit>(context).deleteTextItem(index, textResult);
                },
                child: Icon(
                  Icons.delete,
                  color: context.colorScheme.error,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Padding itemWithImage(
      BuildContext context, bool searchBool, String marka, String bottomText, int count, int index, String image) {
    return Padding(
      padding: context.topPadding1,
      child: Container(
        width: 200.w,
        height: 50.h,
        decoration: BoxDecoration(color: context.colorScheme.background, borderRadius: BorderRadius.circular(4)),
        child: Row(
          children: [
            Padding(
              padding: context.padding1,
              child: Container(
                width: 40.w,
                height: 50.h,
                decoration: BoxDecoration(color: context.colorScheme.onPrimary, borderRadius: BorderRadius.circular(4)),
                child: Image.network(image, fit: BoxFit.cover),
              ),
            ),
            Padding(
              padding: context.topPadding1.copyWith(),
              child: Container(
                width: searchBool == true ? 120.w : 92.w,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      marka,
                      overflow: TextOverflow.ellipsis,
                      style: context.textTheme.labelSmall,
                    ),
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
                        GestureDetector(
                          onTap: () {
                            textResult.name != ""
                                ? BlocProvider.of<ShoppingListViewCubit>(context)
                                    .addImageItem(1, textResult, marka, bottomText, image)
                                : null;
                          },
                          child: Container(
                            alignment: Alignment.center,
                            width: 18.w,
                            height: 18.h,
                            decoration: BoxDecoration(color: context.colorScheme.onTertiary, shape: BoxShape.circle),
                            child: Text(
                              "+",
                              textAlign: TextAlign.center,
                              style: context.textTheme.headlineSmall,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 4.h,
                        ),
                        /*Container(
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
                        )*/
                      ],
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                BlocProvider.of<ShoppingListViewCubit>(context).incrementItem(index, textResult);
                              },
                              child: Container(
                                alignment: Alignment.center,
                                width: 18.w,
                                height: 18.h,
                                decoration:
                                    BoxDecoration(color: context.colorScheme.onTertiary, shape: BoxShape.circle),
                                child: Text(
                                  "+",
                                  textAlign: TextAlign.center,
                                  style: context.textTheme.headlineSmall,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 4.w,
                            ),
                            GestureDetector(
                              onTap: () {
                                BlocProvider.of<ShoppingListViewCubit>(context).decrementItem(index, textResult);
                              },
                              child: Container(
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
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 4.h,
                        ),
                        Text(
                          count.toString() + " Adet",
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
  //Yeni liste Ekleme işlemi burada
  Column leftSide(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 500.h,
          width: 80.w,
          decoration: BoxDecoration(color: context.colorScheme.onSurface, borderRadius: BorderRadius.circular(4)),
          child: Padding(
            padding: context.paddingHorizontal1,
            child: Column(children: [
              Container(
                width: 80.w,
                height: 410.h,
                child: RawScrollbar(
                  crossAxisMargin: -context.value2,
                  thickness: 5,
                  thumbVisibility: true,
                  controller: _firstController,
                  interactive: true,
                  thumbColor: context.colorScheme.onTertiary,
                  radius: Radius.circular(4),
                  child: BlocBuilder<ShoppingListAddCubit, ShoppingListChangeEvent>(
                    builder: (BuildContext context, ShoppingListChangeEvent state) {
                      return ListView.builder(
                        padding: EdgeInsets.zero,
                        controller: _firstController,
                        itemCount: state.shopList.length + 1,
                        itemBuilder: (BuildContext context, int index) {
                          if (index == state.shopList.length || state.shopList.isEmpty) {
                            return GestureDetector(
                                onTap: () {
                                  showLoaderDialog(BuildContext context) {
                                    AlertDialog alert = AlertDialog(
                                      backgroundColor: Colors.transparent,
                                      elevation: 0,
                                      content: Container(
                                        width: context.width,
                                        height: context.height,
                                        child: Center(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              //CircularProgressIndicator(color: context.colorScheme.onPrimary),
                                              Container(
                                                  alignment: Alignment.centerLeft,
                                                  margin: EdgeInsets.only(left: 7),
                                                  child: Text(
                                                    "Listeye isim giriniz..",
                                                    textAlign: TextAlign.center,
                                                    style: context.textTheme.titleLarge!
                                                        .copyWith(color: context.colorScheme.onPrimary),
                                                  )),
                                              Padding(
                                                padding: const EdgeInsets.only(top: 8.0),
                                                child: TextField(controller: _listNameController),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(top: 8.0),
                                                child: ElevatedButton.icon(
                                                  style: ElevatedButton.styleFrom(
                                                      backgroundColor: context.colorScheme.onPrimary),
                                                  onPressed: () {
                                                    BlocProvider.of<ShoppingListAddCubit>(context).addShoppingList(
                                                        ListModel(name: _listNameController.text, result: []));
                                                    Navigator.pop(context);
                                                  },
                                                  icon: Icon(
                                                    Icons.verified,
                                                    color: context.colorScheme.onSurface,
                                                  ),
                                                  label: Text(
                                                    "Onayla",
                                                    style: context.textTheme.labelMedium,
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                    showDialog(
                                      barrierDismissible: false,
                                      context: context,
                                      builder: (BuildContext context) {
                                        return alert;
                                      },
                                    );
                                  }

                                  showLoaderDialog(context);
                                },
                                child: addShopListContainer(context));
                          }
                          return shopListNameContainer(
                              context, state.shopList[index].name, index, state.shopList[index]);
                        },
                      );
                    },
                  ),
                ),
              ),
            ]),
          ),
        ),
        SizedBox(
          height: context.value1,
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
        decoration:
            BoxDecoration(color: context.colorScheme.background, borderRadius: BorderRadius.all(Radius.circular(4))),
        child: Text("+",
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            textAlign: TextAlign.center,
            style: context.textTheme.displayLarge!.copyWith(color: context.colorScheme.onPrimary)),
      ),
    );
  }

  //liste getirme ve o listeyi silme işlemleri burada
  Padding shopListNameContainer(BuildContext context, String name, int index, ListModel result) {
    return Padding(
      padding: context.topPadding1,
      child: GestureDetector(
        onTap: () {
          setState(() {
            textIndex = index;
            textResult = result;
          });

          _textController.clear();
          BlocProvider.of<ShoppingListViewCubit>(context).getList(result);
        },
        onLongPress: () {
          textResult = ListModel(name: "", result: []);
          BlocProvider.of<ShoppingListAddCubit>(context).deleteShoppingList(index, context);
        },
        child: Container(
          padding: context.padding1,
          width: double.maxFinite,
          alignment: Alignment.center,
          height: 60.h,
          decoration:
              BoxDecoration(color: context.colorScheme.background, borderRadius: BorderRadius.all(Radius.circular(4))),
          child: Text(name,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              textAlign: TextAlign.center,
              style: context.textTheme.labelSmall!.copyWith(fontSize: 10.sp)),
        ),
      ),
    );
  }

  Container shareButton(BuildContext context) {
    var box = Hive.box("GlobalList");
    var repo = box.get(0) as Repo;
    List<pw.Image> imageList = [];
    var imageIndex = -1;
    ListModel list;
    list = ListModel(name: "", result: []);
    try {
      if (repo.list.isNotEmpty) {
        print("object share" + textIndex.toString());
        list = repo.list.elementAt(textIndex);
      } else {
        list = ListModel(name: "name", result: []);
      }
    } catch (e) {
      print(e);
    }

    showLoaderDialog(BuildContext context) {
      AlertDialog alert = AlertDialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        content: Container(
          width: context.width,
          height: context.height,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(color: context.colorScheme.onPrimary),
                Container(
                    margin: EdgeInsets.only(left: 7),
                    child: Text(
                      "PDF oluşturuluyor lütfen bekleyin...",
                      textAlign: TextAlign.center,
                      style: context.textTheme.titleLarge!.copyWith(color: context.colorScheme.onPrimary),
                    )),
              ],
            ),
          ),
        ),
      );
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
    }

    Future<void> getWidget(int index) async {
      var imageurl = list.result.elementAt(index).imageUrl.toString();
      final response = await http.get(Uri.parse(imageurl));
      final bytes = response.bodyBytes;

      final directory = await getTemporaryDirectory();

      final directoryPath = "${directory.path}/Wingoo";

      if (!await Directory(directoryPath).exists()) {
        await Directory(directoryPath).create(recursive: true);
      }
      final imageFile = File('${directoryPath}/image_$index.jpg');
      await imageFile.writeAsBytes(bytes);
      imageList.add(pw.Image(pw.MemoryImage(imageFile.readAsBytesSync()), fit: pw.BoxFit.cover));
    }

    return Container(
      padding: context.padding1,
      height: 74.h,
      width: 80.w,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: context.colorScheme.inversePrimary.withOpacity(0.5),
          border: Border.all(
            color: context.colorScheme.inversePrimary,
            width: 2,
          ),
          borderRadius: BorderRadius.all(Radius.circular(4))),
      child: Builder(builder: (context) {
        return GestureDetector(
          onTap: () async {
            showLoaderDialog(context);
            imageList.clear();
            imageIndex = -1;
            for (var i = 0; i < list.result.length; i++) {
              if (list.result.elementAt(i) is ImageItem) {
                await getWidget(i);
              }
            }
            print(" length " + imageList.length.toString());
            final pdf = pw.Document();
            final font = pw.Font.ttf(await rootBundle.load("assets/fonts/Roboto-Regular.ttf"));

            pdf.addPage(
              pw.MultiPage(
                footer: (context) {
                  return pw.Footer(
                      trailing: pw.Text(
                    "Wingoo",
                    style: pw.TextStyle(
                      fontSize: 8,
                      font: font,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.white,
                    ),
                  ));
                },
                pageTheme: pw.PageTheme(
                  buildBackground: (context) {
                    return pw.FullPage(ignoreMargins: true, child: pw.Container(color: PdfColor.fromHex("282828")));
                  },
                ),
                build: (pw.Context context) {
                  return [
                    pw.Row(
                      crossAxisAlignment: pw.CrossAxisAlignment.end,
                      children: [
                        pw.Text(
                          list.name,
                          style: pw.TextStyle(
                            fontSize: 25,
                            font: font,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.white,
                          ),
                        ),
                      ],
                    ),
                    pw.ListView.builder(
                      itemCount: list.result.length,
                      itemBuilder: (context, index) {
                        if (list.result.elementAt(index) is ImageItem) {
                          imageIndex = imageIndex + 1;
                          return pw.Padding(
                            padding: pw.EdgeInsets.only(top: this.context.value1),
                            child: pw.Container(
                              decoration: pw.BoxDecoration(
                                  color: PdfColor.fromHex("494949"), borderRadius: pw.BorderRadius.circular(4)),
                              child: pw.Row(
                                crossAxisAlignment: pw.CrossAxisAlignment.start,
                                children: [
                                  pw.Padding(
                                    padding: pw.EdgeInsets.all(this.context.value1),
                                    child: pw.Container(
                                        width: 60,
                                        height: 60,
                                        decoration: pw.BoxDecoration(
                                            color: PdfColors.white, borderRadius: pw.BorderRadius.circular(4)),
                                        child: imageList[imageIndex]),
                                  ),
                                  pw.Padding(
                                    padding: pw.EdgeInsets.only(top: this.context.value1, bottom: this.context.value1),
                                    child: pw.Container(
                                      width: 380,
                                      child: pw.Column(
                                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                                        children: [
                                          pw.Row(children: [
                                            pw.Text(
                                              list.result.elementAt(index).text,
                                              style: pw.TextStyle(
                                                fontSize: 14,
                                                font: font,
                                                fontWeight: pw.FontWeight.bold,
                                                color: PdfColors.white,
                                              ),
                                            ),
                                            pw.Text(
                                              " - " + list.result.elementAt(index).adet.toString() + "adet",
                                              style: pw.TextStyle(
                                                fontSize: 14,
                                                font: font,
                                                fontWeight: pw.FontWeight.bold,
                                                color: PdfColors.green300,
                                              ),
                                            ),
                                          ]),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        } else {
                          return pw.Padding(
                            padding: pw.EdgeInsets.only(top: this.context.value1),
                            child: pw.Container(
                              width: 5000.w,
                              padding: pw.EdgeInsets.all(this.context.value1),
                              decoration: pw.BoxDecoration(
                                  color: PdfColor.fromHex("494949"), borderRadius: pw.BorderRadius.circular(4)),
                              child: pw.Text(
                                list.result.elementAt(index).text,
                                style: pw.TextStyle(
                                  fontSize: 14,
                                  font: font,
                                  fontWeight: pw.FontWeight.bold,
                                  color: PdfColors.white,
                                ),
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ];
                },
              ),
            );

            final directory = await getTemporaryDirectory();

            final directoryPath = "${directory.path}/Wingoo";

            if (!await Directory(directoryPath).exists()) {
              await Directory(directoryPath).create(recursive: true);
            }

            final file = File("${directoryPath}/MyPdf.pdf");
            await file.writeAsBytes(await pdf.save());

            print("PDF dosyası cihaza kaydedildi: ${file.path}");

            Navigator.pop(context);
            if (Platform.isIOS) {
              final box = context.findRenderObject() as RenderBox?;

              final result = await Share.shareXFiles([XFile('${directoryPath}/MyPdf.pdf')],
                  sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size);

              if (result.status == ShareResultStatus.success) {
                print('Send');
              }
            } else {
              final result = await Share.shareXFiles(
                [XFile('${directoryPath}/MyPdf.pdf')],
              );

              if (result.status == ShareResultStatus.success) {
                print('Send File');
              }
            }
          },
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
                  style: context.textTheme.labelSmall!.copyWith(color: context.colorScheme.onPrimary)),
            ],
          ),
        );
      }),
    );
  }

  AppBar appBar(BuildContext context) {
    return AppBar(
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
