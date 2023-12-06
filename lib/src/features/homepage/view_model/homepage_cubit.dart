import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flash_angebote/src/features/homepage/model/company_model.dart';
import 'package:flash_angebote/src/features/homepage/model/flyer_model.dart';
import 'package:flash_angebote/src/features/homepage/view_model/homepage_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';

class HomePageCubit extends Cubit<HomePageState> {
  HomePageCubit() : super(const HomePageInitial());
  CollectionReference companyDB =
      FirebaseFirestore.instance.collection('flash_angebote_companies');
  CollectionReference flyerDB =
      FirebaseFirestore.instance.collection('flash_angebote_flyers');

  List<CompanyModel?>? companyList = [];
  List<FlyerModel?>? flyerList = [];

  late Position locationData;

  Future<void> readCompanyData() async {
    await companyDB.get().then((value) {
      print("Successfully completed");
      for (var docSnapshot in value.docs) {
        companyList!.add(
            CompanyModel.fromJson(docSnapshot.data() as Map<String, dynamic>));
      }
    });
    inspect(companyList);
  }

  Future<void> readFlyerData() async {
    await flyerDB.get().then((value) {
      print("Successfully completed");
      for (var docSnapshot in value.docs) {
        flyerList!.add(
            FlyerModel.fromJson(docSnapshot.data() as Map<String, dynamic>));
      }
    });
    inspect(flyerList);
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
    //final fcmToken = await FirebaseMessaging.instance.getToken();
    locationData = await _determinePosition();
    await readCompanyData();
    await readFlyerData();
    // inspect(locationData);
    // inspect(companyDB);
    emit(const HomePageComplete());
  }
}
