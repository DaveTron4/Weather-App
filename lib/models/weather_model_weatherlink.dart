class WeatherLink {
  final double temperature;
  final double humidity;
  final double windSpeed;
  final double windGusting;
  final double rainFall15min;
  final double rainFall24Hr;

  WeatherLink({
    required this.temperature,
    required this.humidity,
    required this.windSpeed,
    required this.windGusting,
    required this.rainFall15min,
    required this.rainFall24Hr,
  });

  factory WeatherLink.fromJson(Map<String, dynamic> json) {
    final sensorData = (json['sensors'] as List?)?[2]?['data'] as List?;
    final firstData =
        sensorData != null && sensorData.isNotEmpty ? sensorData[0] : null;

    return WeatherLink(
      temperature: (firstData?['temp'] as num?)?.toDouble() ?? 0.0,
      humidity: (firstData?['hum'] as num?)?.toDouble() ?? 0.0,
      windSpeed:
          (firstData?['wind_speed_hi_last_2_min'] as num?)?.toDouble() ?? 0.0,
      windGusting:
          (firstData?['wind_speed_avg_last_10_min'] as num?)?.toDouble() ?? 0.0,
      rainFall15min:
          (firstData?['rainfall_last_15_min_in'] as num?)?.toDouble() ?? 0.0,
      rainFall24Hr:
          (firstData?['rainfall_last_24_hr_in'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
