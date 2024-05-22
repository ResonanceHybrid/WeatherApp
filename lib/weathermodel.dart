class Weather {
  final String cityName;
  final double temperature;
  final String Condition;

  Weather({
    required this.cityName,
    required this.temperature,
    required this.Condition,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      cityName: json['cityName'],
      temperature: json['main']['temp'].toDouble(),
      Condition: json['weather'][0]['main'],
    );
  }
}
