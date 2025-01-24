class Weather {
  final String cityName;
  final double temperature;
  final String mainCondition;
  final String timeOfDay;
  final int time;

  Weather({
    required this.cityName,
    required this.temperature,
    required this.mainCondition,
    required this.timeOfDay,
    required this.time,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      cityName: json['name'] ??
          'Unknown', // Fallback to 'Unknown' if cityName is null
      temperature: json['main']['temp'] != null
          ? json['main']['temp'].toDouble()
          : 0.0, // Provide a default value (e.g., 0.0) if temperature is null
      mainCondition: json['weather'] != null && json['weather'].isNotEmpty
          ? json['weather'][0]['main'] ?? 'Unknown'
          : 'Unknown', // Fallback to 'Unknown' if mainCondition is null
      timeOfDay: json['weather'] != null && json['weather'].isNotEmpty
          ? json['weather'][0]['icon'] ?? 'Unknown'
          : 'Unknown', // Fallback to 'Unknown' if timeOfDay is null
      time: json['dt'] ?? 0, // Default to 0 if time is null
    );
  }
}
