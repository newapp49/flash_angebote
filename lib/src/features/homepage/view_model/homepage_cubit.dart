import 'package:flash_angebote/src/features/homepage/view_model/homepage_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePageCubit extends Cubit<HomePageState> {
  HomePageCubit() : super(HomePageInitial());

  Future<void> getData() async {
    try {
      emit(HomePageLoading());
      await Future.delayed(Duration(seconds: 5));
      emit(HomePageComplete());
    } catch (e) {
      emit(HomePageError(e.toString()));
    }
  }
}
