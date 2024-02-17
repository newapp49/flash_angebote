import 'dart:developer';
import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wingo/src/features/activity/view_model/activity_state.dart';
import 'package:wingo/src/features/homepage/model/flyer_model.dart';
import 'package:wingo/src/routing/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';

import '../../../../core/init/manager/locale_manager.dart';
import '../../../constants/location_constants.dart';
import '../../../shared/utils/enums/prefererences_keys.dart';
import '../../homepage/model/company_model.dart';

class ActivityPageCubit extends Cubit<ActivityPageState> {
  ActivityPageCubit() : super(const ActivityPageInitial());
  CollectionReference companyDB =
      FirebaseFirestore.instance.collection('wingo_companies');
  CollectionReference flyerDB =
      FirebaseFirestore.instance.collection('wingo_activites');

  List<CompanyModel?>? companyList = [];
  List<CompanyModel>? favouriteCompanyList = [];

  List<FlyerModel?>? flyerList = [];
  List<CompanyModel>? favouriteFlyerList = [];

  Map<String, double> locationList = {};
  late int maxDistanceFilter;

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

  FlyerModel? findFavoriteFlyer(String companyId) {
    for (var flyer in flyerList!) {
      if (flyer!.companyId == companyId) {
        return flyer;
      }
    }
    return flyerList![0];
  }

  Future<void> setDistanceFilter() async {
    if (LocaleManager.instance.getStringValue(PreferencesKeys.MAX_DISTANCE) ==
        '') {
      maxDistanceFilter = 1000;
    } else {
      maxDistanceFilter = int.parse(
          LocaleManager.instance.getStringValue(PreferencesKeys.MAX_DISTANCE));
    }
  }

  Future<void> readCompanyData() async {
    favouriteCompanyList = [];

    companyList = [];
    await companyDB.get().then((value) {
      for (var docSnapshot in value.docs) {
        companyList!.add(
            CompanyModel.fromJson(docSnapshot.data() as Map<String, dynamic>));
      }
    });
    companyList!.sort((a, b) => a!.uid!.compareTo(b!.uid!));
    inspect(companyList);
  }

  Future<void> readFlyerData() async {
    flyerList = [];
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
    locationList = {};

    for (var company in companyList!) {
      distance = calculateDistance(company!.latitude!, company.longtitude!)
          .roundToDouble();
      if (distance <= maxDistanceFilter) {
        locationList.addAll({company.uid!: distance});
      }
      if (company.isFavourite!) {
        favouriteCompanyList!.add(company);
      }
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

  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    // if (!serviceEnabled) {
    //   return Future.error('Location services are disabled.');
    // }

    // permission = await Geolocator.checkPermission();
    // if (permission == LocationPermission.denied) {
    //   permission = await Geolocator.requestPermission();
    //   if (permission == LocationPermission.denied) {
    //     return Future.error('Location permissions are denied');
    //   }
    // }

    // if (permission == LocationPermission.deniedForever) {
    //   // Permissions are denied forever, handle appropriately.
    //   return Future.error(
    //       'Location permissions are permanently denied, we cannot request permissions.');
    // }
    try {
      if (LocaleManager.instance
              .getStringValue(PreferencesKeys.CONSTANT_LOCATION) ==
          '') {
        locationData = await Geolocator.getCurrentPosition();
      } else {
        locationData = PositionConstants.positionConstants[LocaleManager
            .instance
            .getStringValue(PreferencesKeys.CONSTANT_LOCATION)]!;
      }
    } catch (e) {}
  }

  void navigateSettings(BuildContext context) {
    context.router.push(SettingsRoute(callback: init));
  }

  Future<void> init() async {
    emit(const ActivityPageLoading());
    //final fcmToken = await FirebaseMessaging.instance.getToken();
    await _determinePosition();
    await readCompanyData();
    await readFlyerData();
    await setDistanceFilter();

    fillLocationList();
    inspect(flyerList);
    emit(const ActivityPageComplete());
  }
}
