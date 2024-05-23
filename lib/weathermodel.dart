class Weather {
  final String cityName;
  final double temperature;
  final String Condition;
  final double min_temperature;
  final double max_temperature;
  final double pressure;
  final double humidity;

  Weather({
    required this.cityName,
    required this.temperature,
    required this.Condition,
    required this.min_temperature,
    required this.max_temperature,
    required this.pressure,
    required this.humidity,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      cityName: json['name'],
      temperature: json['main']['temp'].toDouble(),
      Condition: json['weather'][0]['main'],
      min_temperature: json['main']['temp_min'].toDouble(),
      max_temperature: json['main']['temp_max'].toDouble(),
      pressure: json['main']['pressure'].toDouble(),
      humidity: json['main']['humidity'].toDouble(),
    );
  }
}
