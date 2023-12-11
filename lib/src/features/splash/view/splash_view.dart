import 'package:auto_route/auto_route.dart';
import 'package:flash_angebote/src/constants/image_constants.dart';
import 'package:flash_angebote/src/features/splash/model/splash_state.dart';
import 'package:flash_angebote/src/routing/app_router.dart';
import 'package:flash_angebote/src/shared/utils/extension/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../viewmodel/splash_view_model.dart';

@RoutePage(name: 'SplashRoute')
class SplashView extends StatefulWidget {
  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  late SplashCubit cubit;
  @override
  void initState() {
    cubit = BlocProvider.of<SplashCubit>(context);
    cubit.init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<SplashCubit, SplashState>(
          listener: (context, state) => state is SplashCompleted
              ? context.router.replace(const NavigatorRoute())
              : null,
          builder: (context, state) => AnimatedSlide(
                offset: state is SplashLoading
                    ? const Offset(0, 0)
                    : const Offset(0, -1),
                duration: const Duration(milliseconds: 700),
                curve: Curves.ease,
                child: Center(
                    child: SizedBox(
                        height: context.height,
                        width: 200.w,
                        child: Image(
                            image:
                                AssetImage(ImageConstants.instance.splash)))),
              )),
    );
  }
}
