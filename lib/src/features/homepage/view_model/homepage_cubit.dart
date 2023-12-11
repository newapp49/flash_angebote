import 'dart:developer';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
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
  Map<int, double> locationList = {};

  late Position locationData;

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
            FlyerModel.fromJson(docSnapshot.data() as Map<String, dynamic>));
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
    print(mesafe);
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

  Future<void> init() async {
    emit(const HomePageLoading());
    //final fcmToken = await FirebaseMessaging.instance.getToken();
    locationData = await _determinePosition();
    await readCompanyData();
    await readFlyerData();
    fillLocationList();
    emit(const HomePageComplete());
  }
}
