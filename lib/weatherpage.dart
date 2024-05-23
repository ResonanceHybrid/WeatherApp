import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
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
  bool _loading = true;

  Future<void> _fetchWeather() async {
    setState(() {
      _loading = true;
    });
    await Future.delayed(
        Duration(milliseconds: 500)); // Adding delay for loading effect
    try {
      String cityName = await _weatherservie.getCurrentCity();
      print('Fetched City Name: $cityName');
      if (cityName.isNotEmpty && cityName != 'Unknown') {
        final weather = await _weatherservie.getWeather(cityName);
        setState(() {
          _weather = weather;
        });
      } else {
        print('Failed to get city name');
      }
    } catch (e) {
      print(e);
    }
    setState(() {
      _loading = false;
    });
  }

  String getWeatherAnimation(String? mainCondition) {
    if (mainCondition == null) return 'assets/sunny.json';

    switch (mainCondition.toLowerCase()) {
      case 'clouds':
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog':
        return 'assets/cloud.json';
      case 'rain':
      case 'drizzle':
      case 'shower rain':
        return 'assets/rain.json';
      case 'thunderstorm':
        return 'assets/thunder.json';
      case 'clear':
        return 'assets/sunny.json';
      default:
        return 'assets/sunny.json';
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
      appBar: AppBar(
        title: Text('Weather App'),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: _fetchWeather,
        child: _loading
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 40.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _weather?.cityName ?? 'Fetching city...',
                          style: TextStyle(
                              fontSize: 28, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 20),
                        Lottie.asset(
                          getWeatherAnimation(_weather?.Condition),
                          height: 200,
                        ),
                        SizedBox(height: 20),
                        Text(
                          _weather != null
                              ? '${_weather!.temperature.round()}°C'
                              : 'Fetching temperature...',
                          style: TextStyle(fontSize: 32),
                        ),
                        SizedBox(height: 10),
                        Text(
                          _weather != null
                              ? 'Pressure: ${_weather!.pressure.round()} hPa'
                              : 'Fetching pressure...',
                          style: TextStyle(fontSize: 18),
                        ),
                        SizedBox(height: 10),
                        Text(
                          _weather != null
                              ? 'Humidity: ${_weather!.humidity.round()}%'
                              : 'Fetching humidity...',
                          style: TextStyle(fontSize: 18),
                        ),
                        SizedBox(height: 10),
                        Text(
                          _weather?.Condition ?? "Fetching condition...",
                          style: TextStyle(
                              fontSize: 18, fontStyle: FontStyle.italic),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
