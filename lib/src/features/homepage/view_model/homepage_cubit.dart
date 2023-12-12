import 'dart:developer';
import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flash_angebote/src/features/homepage/model/company_model.dart';
import 'package:flash_angebote/src/features/homepage/model/flyer_model.dart';
import 'package:flash_angebote/src/features/homepage/view_model/homepage_state.dart';
import 'package:flash_angebote/src/routing/app_router.dart';
import 'package:flutter/material.dart';
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
  Map<int, double> locationList = {};

  List<String> topsideFlyerUrls = [
    "https://imgv3.fotor.com/images/share/Fotors-party-flyer-templates.jpg",
    "https://www.befunky.com/images/wp/wp-2021-11-event-flyers-featured-image.jpg?auto=avif,webp&format=jpg&width=1136&crop=16:9",
    "https://fiverr-res.cloudinary.com/images/t_main1,q_auto,f_auto,q_auto,f_auto/gigs/308749758/original/1dfbf2e0c1297b127e16504413bb5c4805b94f45/do-professional-flyers-invitations-and-posters-for-specific-theme-based-events.png",
  ];

  DateTime get todayDateTime => DateTime.now();
  late Position locationData;
  String getExpireDay(DateTime expireDate) {
    Duration remainingDay = expireDate.difference(todayDateTime);
    return remainingDay.inDays.toString();
  }

  Future<void> readCompanyData() async {
    await companyDB.get().then((value) {
      for (var docSnapshot in value.docs) {
        companyList!.add(
            CompanyModel.fromJson(docSnapshot.data() as Map<String, dynamic>));
      }
    });
    companyList!.sort((a, b) => a!.companyId!.compareTo(b!.companyId!));
    inspect(companyList);
  }

  Future<void> readFlyerData() async {
    await flyerDB.get().then((value) {
      for (var docSnapshot in value.docs) {
        flyerList!.add(
          FlyerModel.fromJson(docSnapshot.data() as Map<String, dynamic>),
        );
      }
    });
    flyerList!.sort((a, b) => a!.companyId!.compareTo(b!.companyId!));
  }

  void fillLocationList() {
    double distance;

    for (var company in companyList!) {
      distance = calculateDistance(company!.latitude!, company.longtitude!)
          .roundToDouble();
      locationList.addAll({company.companyId!: distance});
    }
  }

  double calculateDistance(double hedefEnlem, double hedefBoylam) {
    // Dünya'nın yarıçapı (ortalama olarak) - km cinsinden
    const double dunyaYariCap = 6371.0;
    double referansEnlem = locationData.latitude;
    double referansBoylam = locationData.longitude;

    // Derece cinsinden koordinat farklarını radyan cinsine çevir
    double enlemFarki = _degreesToRadians(hedefEnlem - referansEnlem);
    double boylamFarki = _degreesToRadians(hedefBoylam - referansBoylam);

    // Haversine formülü kullanarak mesafeyi hesapla
    double a = pow(sin(enlemFarki / 2), 2) +
        cos(_degreesToRadians(referansEnlem)) *
            cos(_degreesToRadians(hedefEnlem)) *
            pow(sin(boylamFarki / 2), 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    double mesafe = dunyaYariCap * c;
    return mesafe;
  }

  double _degreesToRadians(double degree) {
    return degree * (pi / 180.0);
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

  void navigateSettings(BuildContext context) {
    context.router.push(const SettingsRoute());
  }

  Future<void> init() async {
    emit(const HomePageLoading());
    //final fcmToken = await FirebaseMessaging.instance.getToken();
    locationData = await _determinePosition();
    await readCompanyData();
    await readFlyerData();
    fillLocationList();
    inspect(flyerList);
    emit(const HomePageComplete());
  }
}
