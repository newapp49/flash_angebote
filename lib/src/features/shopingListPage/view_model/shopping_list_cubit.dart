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
    var list = _repo.list;
    emit(ShoppingListChangeEvent(list));
  }

  void deleteShoppingList(int index, BuildContext context) {
    var list = _repo.list;
    if (index == 0) {
      if (list.length == 1) {
        BlocProvider.of<ShoppingListViewCubit>(context).getList(list[index]);
      } else {
        BlocProvider.of<ShoppingListViewCubit>(context)
            .getList(list[index + 1]);
      }
    }
    if (index > 0) {
      BlocProvider.of<ShoppingListViewCubit>(context).getList(list[index - 1]);
    }
    list.removeAt(index);

    // Hiç Alışveriş Listesi Yoksa giricek initiale çevircek
    if (list.isEmpty) {
      BlocProvider.of<ShoppingListViewCubit>(context).empty();
    }

    emit(ShoppingListChangeEvent(list));
  }
}

class ShoppingListViewCubit extends Cubit<ShoppingListView> {
  ShoppingListViewCubit() : super(ShoppingListViewEventInitial());
  void getList(ListModel list) {
    emit(ShoppingListViewEvent(list));
  }

  void addTextItem(int index, ListModel result, String text) {
    var list = result;
    list.result.list.add(TextItem(text: text));
    emit(ShoppingListViewEvent(list));
  }

  void addImageItem(int index, ListModel result, String text, String bottext) {
    var list = result;
    list.result.list
        .add(ImageItem(adet: index, text: text, bottomText: bottext));
    emit(ShoppingListViewEvent(list));
  }

  void incrementItem(int index, ListModel result) {
    var list = result;
    var a = list.result.list.elementAt(index) as ImageItem;
    a.adet = a.adet + 1;
    emit(ShoppingListViewEvent(list));
  }

  void decrementItem(int index, ListModel result) {
    var list = result;
    var a = list.result.list.elementAt(index) as ImageItem;
    a.adet = a.adet - 1;
    if (a.adet == 0) {
      list.result.list.removeAt(index);
    }
    emit(ShoppingListViewEvent(list));
  }

  void empty() {
    emit(ShoppingListViewEventInitial());
  }
}
