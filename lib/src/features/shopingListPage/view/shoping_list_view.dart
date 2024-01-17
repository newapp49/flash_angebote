import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flash_angebote/core/init/lang/locale_keys.g.dart';
import 'package:flash_angebote/src/features/shopingListPage/model/image_item.model.dart';
import 'package:flash_angebote/src/features/shopingListPage/model/list_model.dart';
import 'package:flash_angebote/src/features/shopingListPage/model/text_item_model.dart';
import 'package:flash_angebote/src/features/shopingListPage/view_model/shopping_list_cubit.dart';
import 'package:flash_angebote/src/features/shopingListPage/view_model/shopping_list_state.dart';
import 'package:flash_angebote/src/shared/utils/extension/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

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
  int textIndex = 0;
  ListModel textResult = ListModel(name: "", result: Result(list: []));
  late List<String> shopLista;
  bool sizeBool = true;

  @override
  void initState() {
    shopLista = <String>[];
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
      body: Center(child: bodyPage(context, shopLista)),
    );
  }

  SingleChildScrollView bodyPage(BuildContext context, List<String> shopList) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(), //NeverScrollableScrollPhysics(),
      child: Container(
        width: context.width,
        height: context.height,
        padding: context.padding2,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            leftSide(context, shopList),
            SizedBox(
              width: 10.w,
            ),
            rightSide(context),
          ],
        ),
      ),
    );
  }

  //Right Side Component
  Widget rightSide(BuildContext context) {
    return Container(
      width: 230.w,
      height: 500.h,
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
            //     Visibility(visible: !sizeBool, child: divider(context)),
            //shopListContainer(context),
            const Spacer(),
            bottomSearchField(context),
          ],
        ),
      ),
    );
  }

  Widget bottomSearchField(BuildContext context) {
    return Row(
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
              hintText:
                  "${LocaleKeys.shopping_list_page_what_do_you_whant.tr()}",
              hintStyle: context.textTheme.titleMedium!
                  .copyWith(color: context.colorScheme.onPrimary),
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
                              .addTextItem(
                                  textIndex, textResult, _textController.text);
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
      child: Container(
        width: double.maxFinite,
        height: sizeBool == true ? context.height - 350.h : 300.h,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BlocBuilder<ShoppingListViewCubit, ShoppingListView>(
                builder: (BuildContext context, state) {
              if (state is ShoppingListViewEventInitial) {
                return Text("");
              } else if (state is ShoppingListViewEvent) {
                return Text(
                  state.shopList.name,
                  style: context.textTheme.titleMedium!
                      .copyWith(color: context.colorScheme.onPrimary),
                );
              }
              return Text("");
            }),
            Container(
              child: BlocBuilder<ShoppingListViewCubit, ShoppingListView>(
                builder: (BuildContext context, state) {
                  if (state is ShoppingListViewEventInitial) {
                    return Center(
                      child: Text(
                        "Liste Seç",
                        style: context.textTheme.titleMedium!
                            .copyWith(color: context.colorScheme.onPrimary),
                      ),
                    );
                  } else if (state is ShoppingListViewEvent) {
                    if (state.shopList.result.list.isEmpty) {
                      return Center(
                          child: Text(
                        "Bu Liste Boş",
                        style: context.textTheme.titleMedium!
                            .copyWith(color: context.colorScheme.onPrimary),
                      ));
                    }
                    return ListView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      itemCount: state.shopList.result.list.length + 1,
                      itemBuilder: (context, index) {
                        if (index == state.shopList.result.list.length ||
                            state.shopList.result.list.isEmpty) {
                          return null;
                        } else if (state.shopList.result.list[index]
                            is TextItem) {
                          var a = state.shopList.result.list[index] as TextItem;
                          return itemWithoutImage(context, a.text);
                        } else if (state.shopList.result.list[index]
                            is ImageItem) {
                          var a =
                              state.shopList.result.list[index] as ImageItem;
                          return itemWithImage(context, false, a.text,
                              a.bottomText, a.adet, index);
                        }

                        return null;
                      },
                    );
                  } else {
                    return Text("bir Hata oluştu");
                  }
                },
              ),
            ),
          ],
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
                  Container(
                      width: 250.w,
                      child: itemWithImage(context, true, "Lays",
                          "Lays 150g Yoğurt ve Mevsim Yeşillikli", 2, 1)),
                  divider(context),
                  Expanded(
                    child: Container(
                      child: ListView(children: [
                        itemWithImage(context, true, "Lays",
                            "Lays 150g Yoğurt ve Mevsim Yeşillikli", 2, 1),
                        itemWithImage(context, true, "İçim",
                            "İçim Süzme Beyaz Peynir ", 2, 1),
                        itemWithImage(context, true, "Doritos",
                            "Doritos 150g Acı ve Baharatlı", 2, 1),
                        itemWithImage(context, true, "Namet",
                            "150g Çemensiz Pastırma", 2, 1),
                      ]),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  Padding itemWithoutImage(
    BuildContext context,
    String text,
  ) {
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
            text, //"Dinozor şeklinde olan kek kalıplarından 5 tane Dinozor şeklinde olan kek kalıplarından 5 tane",
            style: context.textTheme.bodyLarge,
          ),
        ),
      ),
    );
  }

  Padding itemWithImage(BuildContext context, bool searchBool, String marka,
      String bottomText, int count, int index) {
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
                width: searchBool == true ? 120.w : 92.w,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      marka,
                      overflow: TextOverflow.ellipsis,
                      style: context.textTheme.labelSmall,
                    ),
                    Text(
                      bottomText,
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
                        GestureDetector(
                          onTap: () {
                            textResult.name != ""
                                ? BlocProvider.of<ShoppingListViewCubit>(
                                        context)
                                    .addImageItem(
                                        1, textResult, marka, bottomText)
                                : null;
                          },
                          child: Container(
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
                            GestureDetector(
                              onTap: () {
                                BlocProvider.of<ShoppingListViewCubit>(context)
                                    .incrementItem(index, textResult);
                              },
                              child: Container(
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
                            ),
                            SizedBox(
                              width: 4.w,
                            ),
                            GestureDetector(
                              onTap: () {
                                BlocProvider.of<ShoppingListViewCubit>(context)
                                    .decrementItem(index, textResult);
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
                                  style:
                                      context.textTheme.headlineSmall!.copyWith(
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
  Column leftSide(BuildContext context, List<String> shopList) {
    return Column(
      children: [
        Container(
          height: 500.h,
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
                    builder:
                        (BuildContext context, ShoppingListChangeEvent state) {
                      return ListView.builder(
                        padding: EdgeInsets.zero,
                        controller: _firstController,
                        itemCount: state.shopList.length + 1,
                        itemBuilder: (BuildContext context, int index) {
                          if (index == state.shopList.length ||
                              state.shopList.isEmpty) {
                            return GestureDetector(
                                onTap: () {
                                  BlocProvider.of<ShoppingListAddCubit>(context)
                                      .addShoppingList(ListModel(
                                          name: "Liste $index",
                                          result: Result(list: [])));
                                },
                                child: addShopListContainer(context));
                          }
                          return shopListNameContainer(
                              context,
                              state.shopList[index].name,
                              index,
                              state.shopList[index]);
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

  //liste getirme ve o listeyi silme işlemleri burada
  Padding shopListNameContainer(
      BuildContext context, String name, int index, ListModel result) {
    return Padding(
      padding: context.topPadding1,
      child: GestureDetector(
        onTap: () {
          textIndex = index;
          textResult = result;
          _textController.clear();
          BlocProvider.of<ShoppingListViewCubit>(context).getList(result);
        },
        onLongPress: () {
          textResult = ListModel(name: "", result: Result(list: []));
          BlocProvider.of<ShoppingListAddCubit>(context)
              .deleteShoppingList(index, context);
        },
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
      child: Builder(builder: (context) {
        return GestureDetector(
          onTap: () async {
            final pdf = pw.Document();
            final font = pw.Font.ttf(
                await rootBundle.load("assets/fonts/Roboto-Regular.ttf"));

            pdf.addPage(
              pw.MultiPage(
                footer: (context) {
                  return pw.Footer(
                      trailing: pw.Text(
                    "Flash Angebote",
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
                    return pw.FullPage(
                        ignoreMargins: true,
                        child: pw.Container(color: PdfColor.fromHex("282828")));
                  },
                ),
                build: (pw.Context context) {
                  return [
                    pw.Row(
                      crossAxisAlignment: pw.CrossAxisAlignment.end,
                      children: [
                        pw.Text(
                          "Piknik için listem",
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
                        itemBuilder: (context, index) {
                          if (index < 5) {
                            return pw.Padding(
                              padding:
                                  pw.EdgeInsets.only(top: this.context.value1),
                              child: pw.Container(
                                decoration: pw.BoxDecoration(
                                    color: PdfColor.fromHex("494949"),
                                    borderRadius: pw.BorderRadius.circular(4)),
                                child: pw.Row(
                                  crossAxisAlignment:
                                      pw.CrossAxisAlignment.start,
                                  children: [
                                    pw.Padding(
                                      padding: pw.EdgeInsets.all(
                                          this.context.value1),
                                      child: pw.Container(
                                        width: 60,
                                        height: 60,
                                        decoration: pw.BoxDecoration(
                                            color: PdfColors.white,
                                            borderRadius:
                                                pw.BorderRadius.circular(4)),
                                      ),
                                    ),
                                    pw.Padding(
                                      padding: pw.EdgeInsets.only(
                                          top: this.context.value1,
                                          bottom: this.context.value1),
                                      child: pw.Container(
                                        width: 380,
                                        child: pw.Column(
                                          crossAxisAlignment:
                                              pw.CrossAxisAlignment.start,
                                          children: [
                                            pw.Row(children: [
                                              pw.Text(
                                                "Lays",
                                                style: pw.TextStyle(
                                                  fontSize: 14,
                                                  font: font,
                                                  fontWeight:
                                                      pw.FontWeight.bold,
                                                  color: PdfColors.white,
                                                ),
                                              ),
                                              pw.Text(
                                                " - 10 Adet",
                                                style: pw.TextStyle(
                                                  fontSize: 14,
                                                  font: font,
                                                  fontWeight:
                                                      pw.FontWeight.bold,
                                                  color: PdfColors.green300,
                                                ),
                                              ),
                                            ]),
                                            pw.Text(
                                              "Lay's Fırından Yoğurt Mevsim Yeşillikleri Patates Cipsi Süper Boy 96 gr",
                                              style: pw.TextStyle(
                                                fontSize: 14,
                                                font: font,
                                                fontWeight: pw.FontWeight.bold,
                                                color: PdfColors.white,
                                              ),
                                            )
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
                              padding:
                                  pw.EdgeInsets.only(top: this.context.value1),
                              child: pw.Container(
                                width: 5000.w,
                                padding: pw.EdgeInsets.all(this.context.value1),
                                decoration: pw.BoxDecoration(
                                    color: PdfColor.fromHex("494949"),
                                    borderRadius: pw.BorderRadius.circular(4)),
                                child: pw.Text(
                                  "Dinozor şeklinde olan kek kalıplarından 5 tane Dinozor şeklinde olan kek kalıplarından 5 tane",
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
                        itemCount: 10),
                  ];
                },
              ),
            );

            final directory = await getTemporaryDirectory();

            final directoryPath = "${directory.path}/Flash Angebote";

            if (!await Directory(directoryPath).exists()) {
              await Directory(directoryPath).create(recursive: true);
            }

            final file = File("${directoryPath}/MyPdf.pdf");
            await file.writeAsBytes(await pdf.save());

            print("PDF dosyası cihaza kaydedildi: ${file.path}");

            if (Platform.isIOS) {
              final box = context.findRenderObject() as RenderBox?;

              final result = await Share.shareXFiles(
                  [XFile('${directoryPath}/MyPdf.pdf')],
                  sharePositionOrigin:
                      box!.localToGlobal(Offset.zero) & box.size);

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
                  style: context.textTheme.labelSmall!
                      .copyWith(color: context.colorScheme.onPrimary)),
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
