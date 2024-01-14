import 'package:geolocator/geolocator.dart';

class PositionConstants {
  static Map<String, Position> positionConstants = {
    "istanbul": Position(
        longitude: 28.9784,
        latitude: 41.0082,
        timestamp: DateTime.timestamp(),
        accuracy: 0,
        altitude: 0,
        altitudeAccuracy: 0,
        heading: 0,
        headingAccuracy: 0,
        speed: 0,
        speedAccuracy: 0),
    "berlin": Position(
        longitude: 13.4050,
        latitude: 52.5200,
        timestamp: DateTime.timestamp(),
        accuracy: 0,
        altitude: 0,
        altitudeAccuracy: 0,
        heading: 0,
        headingAccuracy: 0,
        speed: 0,
        speedAccuracy: 0),
    "paris": Position(
        longitude: 2.3522,
        latitude: 48.8566,
        timestamp: DateTime.timestamp(),
        accuracy: 0,
        altitude: 0,
        altitudeAccuracy: 0,
        heading: 0,
        headingAccuracy: 0,
        speed: 0,
        speedAccuracy: 0),
    "stockholm": Position(
        longitude: 18.0686,
        latitude: 59.3293,
        timestamp: DateTime.timestamp(),
        accuracy: 0,
        altitude: 0,
        altitudeAccuracy: 0,
        heading: 0,
        headingAccuracy: 0,
        speed: 0,
        speedAccuracy: 0),
  };
}
