import 'package:flutter_bloc/flutter_bloc.dart';

import '../model/splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit() : super(SplashInitial());
  Future<void> init() async {
    emit(SplashLoading());
    print("loading");
    await Future.delayed(const Duration(milliseconds: 500));
    emit(SplashCompleted());
    print("done");
  }
}
