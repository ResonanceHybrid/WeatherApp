class Weather {
  final String cityName;
  final double temperature;
  final String Condition;
  final double sunrise;
  final double sunset;
  final double pressure;
  final double humidity;
  final double windspeeed;

  Weather({
    required this.cityName,
    required this.temperature,
    required this.Condition,
    required this.sunrise,
    required this.sunset,
    required this.pressure,
    required this.humidity,
    required this.windspeeed,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      cityName: json['name'],
      temperature: json['main']['temp'].toDouble(),
      Condition: json['weather'][0]['main'],
      sunrise: json['sys']['sunrise'],
      sunset: json['sys']['sunset'],
      pressure: json['main']['pressure'].toDouble(),
      windspeeed: json['wind']['speed'].toDouble(),
      humidity: json['main']['humidity'].toDouble(),
    );
  }
}
