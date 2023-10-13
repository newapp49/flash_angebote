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

class ShoppingListChangeEvent  {
  final List<String> shopList;
  const ShoppingListChangeEvent(this.shopList);
}
