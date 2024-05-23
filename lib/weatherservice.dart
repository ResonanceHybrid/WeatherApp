import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:weatherapp/weathermodel.dart';
import 'dart:convert';

class Weatherservice {
  static const BASE_URL = "http://api.openweathermap.org/data/2.5/weather";
  final String apiKey;

  Weatherservice(this.apiKey);

  Future<Weather> getWeather(String cityName) async {
    final response = await http
        .get(Uri.parse('$BASE_URL?q=$cityName&APPID=$apiKey&units=metric'));

    if (response.statusCode == 200) {
      return Weather.fromJson(json.decode(response.body));
    } else {
      print('Failed to load weather information');
      throw Exception('Failed to load weather information');
    }
  }

  Future<String> getCurrentCity() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return 'Permission Denied';
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    print('Position: ${position.latitude}, ${position.longitude}');

    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);

    if (placemarks.isNotEmpty) {
      String? city = placemarks[0].locality;
      print('City: $city');
      return city ?? "Unknown";
    } else {
      return "Unknown";
    }
  }
}
