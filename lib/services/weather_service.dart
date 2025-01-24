import 'dart:convert';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_app/models/weather_model.dart' as weather;
import 'package:http/http.dart' as http;

class WeatherService {
  // ignore: constant_identifier_names
  static const BASE_URL = 'http://api.openweathermap.org/data/2.5';
  final String apiKey;

  WeatherService(this.apiKey) {
    if (apiKey.isEmpty) {
      throw Exception("API Key is empty!"); // Add this for debugging
    }
  }

  Future<weather.Weather> getWeather(String cityName, String measure) async {
    final response = await http.get(Uri.parse(
        '$BASE_URL/weather?q=$cityName&appid=$apiKey&units=$measure'));

    if (response.statusCode == 200) {
      // print(response.body);
      return weather.Weather.fromJson(jsonDecode(response.body));
    } else {
      // ignore: avoid_print
      print('Failed to load weather data: ${response.statusCode}');
      return weather.Weather(
          cityName: '',
          temperature: 0,
          mainCondition: '',
          timeOfDay: '',
          time: 0);
    }
  }

  Future<String> getCurrentCity() async {
    // get permission from user
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    // fetch the current location
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    // convert the location into a list of placemark objects
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);

    // extract tht city name from the first placemark
    String? city = placemarks[0].locality;

    return city ?? "";
  }
}
