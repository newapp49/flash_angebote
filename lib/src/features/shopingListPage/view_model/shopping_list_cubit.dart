import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:hive/hive.dart';
import 'package:wingo/src/features/shopingListPage/model/firebaseProductModel.dart';
import 'package:wingo/src/features/shopingListPage/model/image_item.model.dart';
import 'package:wingo/src/features/shopingListPage/model/list_model.dart';
import 'package:wingo/src/features/shopingListPage/model/text_item_model.dart';
import 'package:wingo/src/features/shopingListPage/sqlite/repo.dart';
import 'package:wingo/src/features/shopingListPage/view_model/shopping_list_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ShoppingListCubit extends Cubit<ShoppingListState> {
  ShoppingListCubit() : super(ShoppingListInitial());
}

class ShoppingListAddCubit extends Cubit<ShoppingListChangeEvent> {
  final Repo _repo;

  ShoppingListAddCubit(this._repo) : super(ShoppingListChangeEvent(_repo.list));

  void addShoppingList(ListModel model) {
    _repo.list.add(model);
    _repo.save();
    var list = _repo.list;
    emit(ShoppingListChangeEvent(list));
  }

  void deleteShoppingList(int index, BuildContext context) {
    var list = _repo.list;
    if (index == 0) {
      if (list.length == 1) {
        BlocProvider.of<ShoppingListViewCubit>(context).getList(list[index]);
      } else {
        BlocProvider.of<ShoppingListViewCubit>(context).getList(list[index + 1]);
      }
    }
    if (index > 0) {
      BlocProvider.of<ShoppingListViewCubit>(context).getList(list[index - 1]);
    }
    list.removeAt(index);

    _repo.save();
    // Hiç Alışveriş Listesi Yoksa giricek initiale çevircek
    if (list.isEmpty) {
      BlocProvider.of<ShoppingListViewCubit>(context).empty();
    }

    emit(ShoppingListChangeEvent(list));
  }
}

Future<Box> getBox() async {
  var box = await Hive.openBox("GlobalList");
  return box;
}

class ShoppingListViewCubit extends Cubit<ShoppingListView> {
  final Repo _repo;
  ShoppingListViewCubit(this._repo) : super(ShoppingListViewEventInitial());
  void getList(ListModel list) {
    emit(ShoppingListViewEvent(list));
  }

  Future<void> addTextItem(int index, ListModel result, String text) async {
    var list = result;

    list.result.add(TextItem(text: text));

    _repo.save();
    emit(ShoppingListViewEvent(list));
  }

  void addImageItem(int index, ListModel result, String text, String bottext, String image) {
    var list = result;
    list.result.add(ImageItem(adet: index, text: text, bottomText: bottext, imageUrl: image));
    _repo.save();
    emit(ShoppingListViewEvent(list));
  }

  void deleteTextItem(int index, ListModel result) {
    var list = result;

    list.result.removeAt(index);

    _repo.save();
    emit(ShoppingListViewEvent(list));
  }

  void incrementItem(int index, ListModel result) {
    var list = result;
    var a = list.result.elementAt(index) as ImageItem;
    a.adet = a.adet + 1;
    _repo.save();
    emit(ShoppingListViewEvent(list));
  }

  void decrementItem(int index, ListModel result) {
    var list = result;
    var a = list.result.elementAt(index) as ImageItem;
    a.adet = a.adet - 1;
    if (a.adet == 0) {
      list.result.removeAt(index);
    }
    _repo.save();
    emit(ShoppingListViewEvent(list));
  }

  void empty() {
    emit(ShoppingListViewEventInitial());
  }
}

class SearchListViewCubit extends Cubit<SearchListView> {
  final Repo _repo;
  SearchListViewCubit(this._repo) : super(SearchListViewInitial());
  var db = FirebaseFirestore.instance;

  void getList(String text) async {
    var model = await getFirestoreData(text);
    emit(SearchListViewOnItemCame(model));
  }

  void emptyList() {
    emit(const SearchListViewInitial());
  }

  Future<List<FirebaseProductModel>> getFirestoreData(String text) async {
    List<FirebaseProductModel> modelList = [];

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('products')
        .where('productName_tr', isGreaterThanOrEqualTo: text)
        .where('productName_tr', isLessThan: text + "z")
        .get();
    var locale_name = Platform.localeName;
    String productName;

    querySnapshot.docs.forEach((doc) {
      String uuid = doc['uuid'];
      switch (locale_name) {
        case "tr_TR":
          productName = doc['productName_tr'];
          break;
        case "en_US":
          productName = doc['productName_en'];
          break;
        case "de_DE":
          productName = doc['productName_de'];
          break;
        case "fr_FR":
          productName = doc['productName_fra'];
          break;
        case "nl_NL":
          productName = doc['productName_nl'];
          break;
        default:
          productName = doc['productName_en'];
          break;
      }

      List<String> productImages = List<String>.from(doc['productImages']);
      FirebaseProductModel model = FirebaseProductModel();

      model.uuid = uuid;
      model.productName = productName;
      model.productImages = productImages;
      modelList.add(model);
    });

    return modelList;
  }
}
