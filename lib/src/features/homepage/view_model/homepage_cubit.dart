import 'dart:developer';

import 'package:flash_angebote/src/features/homepage/view_model/homepage_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:location/location.dart';

class HomePageCubit extends Cubit<HomePageState> {
  HomePageCubit() : super(HomePageInitial());

  Location currentLocation = Location();

  Future<void> getLocation() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await currentLocation.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await currentLocation.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await currentLocation.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await currentLocation.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await currentLocation.getLocation();
    inspect(_locationData);
  }

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
