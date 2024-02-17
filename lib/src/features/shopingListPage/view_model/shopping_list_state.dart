import 'package:wingo/src/features/shopingListPage/model/list_model.dart';

abstract class ShoppingListState {
  const ShoppingListState();
}

class ShoppingListInitial extends ShoppingListState {
  const ShoppingListInitial();
}

class ShoppingListLoading extends ShoppingListState {
  const ShoppingListLoading();
}

class ShoppingListComplete extends ShoppingListState {
  const ShoppingListComplete();
}

class ShoppingListChangeEvent {
  final List<ListModel> shopList;
  const ShoppingListChangeEvent(this.shopList);
}



abstract class ShoppingListView {
  const ShoppingListView();
}

class ShoppingListViewEventInitial extends ShoppingListView {
  const ShoppingListViewEventInitial();
}

class ShoppingListViewEvent extends ShoppingListView {
  final ListModel shopList;
  const ShoppingListViewEvent(this.shopList);
}
