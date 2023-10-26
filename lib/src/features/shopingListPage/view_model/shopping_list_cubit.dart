import 'package:flash_angebote/src/features/shopingListPage/sqlite/repo.dart';
import 'package:flash_angebote/src/features/shopingListPage/view_model/shopping_list_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ShoppingListCubit extends Cubit<ShoppingListState> {
  ShoppingListCubit() : super(ShoppingListInitial());
}


class ShoppingListAddCubit extends Cubit<ShoppingListChangeEvent> {
  final Repo _repo;
  ShoppingListAddCubit(this._repo) : super(ShoppingListChangeEvent(_repo.list));

  void addShoppingList(String name) {
    _repo.list.add(name);
    var list = _repo.list;
    emit(ShoppingListChangeEvent(list));
  }
}
