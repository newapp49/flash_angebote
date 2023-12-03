import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flash_angebote/src/features/homepage/model/app_model.dart';
import 'package:flash_angebote/src/features/homepage/model/company_model.dart';
import 'package:flash_angebote/src/features/homepage/model/flyer_model.dart';
import 'package:flash_angebote/src/features/homepage/view_model/homepage_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';

class HomePageCubit extends Cubit<HomePageState> {
  HomePageCubit() : super(const HomePageInitial());
  DatabaseReference dbReference = FirebaseDatabase.instance.ref('company');
  List<CompanyModel?>? companyList = [];
  List<FlyerModel?>? flyerList = [];

  Future<void> readCompanyData() async {
    DataSnapshot? response = await dbReference.root.get();
    response.value as ApplicationModel;
    final value = ApplicationModel.fromJson(
        Map<String, dynamic>.from(response.value! as Map<Object?, Object?>));
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }

  Future<void> init() async {
    emit(const HomePageLoading());
    final fcmToken = await FirebaseMessaging.instance.getToken();
    Position position = await _determinePosition();
    inspect(position);
    emit(const HomePageComplete());
  }
}
