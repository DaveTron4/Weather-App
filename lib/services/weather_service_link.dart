import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:weather_app/models/weather_model_weatherlink.dart';

class WeatherServiceLink {
  final String apiKey;

  WeatherServiceLink(this.apiKey) {
    if (apiKey.isEmpty) {
      throw Exception("API Key is empty!");
    }
  }

  Future<WeatherLink> getWeather() async {
    final params = {"api-key": apiKey};

    final url2 = Uri.https('api.weatherlink.com', '/v2/current/72242', params);
    final response = await http.get(url2, headers: {
      "X-Api-Secret": "afgeykia5ljyichhehnzk62dxon2dyta",
      "Accept": "application/json",
    });

    if (response.statusCode == 200) {
      // print(response.body);
      return WeatherLink.fromJson(jsonDecode(response.body));
    } else {
      print('Failed to load weather data: ${response.statusCode}');
      return WeatherLink(
          temperature: 0,
          humidity: 0,
          rainFall15min: 0,
          rainFall24Hr: 0,
          windGusting: 0,
          windSpeed: 0);
    }
  }
}
