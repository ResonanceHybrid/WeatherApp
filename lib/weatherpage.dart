import 'package:flutter/material.dart';
import 'package:weatherapp/weathermodel.dart';
import 'package:weatherapp/weatherservice.dart';

class Weatherpage extends StatefulWidget {
  const Weatherpage({super.key});

  @override
  State<Weatherpage> createState() => _WeatherpageState();
}

class _WeatherpageState extends State<Weatherpage> {
  final _weatherservie = Weatherservice('37a2aecbfa9212f6867052dbce6be326');
  Weather? _weather;

  _fetchWeather() async {
    String cityName = await _weatherservie.getCurrentCity();
    print('Fetched City Name: $cityName');

    if (cityName.isNotEmpty && cityName != 'Unknown') {
      try {
        final weather = await _weatherservie.getWeather(cityName);
        setState(() {
          _weather = weather;
        });
      } catch (e) {
        print(e);
      }
    } else {
      print('Failed to get city name');
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_weather?.cityName ?? 'City...'),
            Text('${_weather?.temperature.round()}°C'),
            Text('Pressure: ${_weather?.pressure.round()}hPa'),
            Text('Humidity: ${_weather?.humidity.round()}%')
          ],
        ),
      ),
    );
  }
}
