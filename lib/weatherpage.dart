import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:weatherapp/weathermodel.dart';
import 'package:weatherapp/weatherservice.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({Key? key}) : super(key: key);

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final _weatherService = Weatherservice('37a2aecbfa9212f6867052dbce6be326');
  Weather? _weather;
  bool _isLoading = false;

  _fetchWeather() async {
    setState(() {
      _isLoading = true;
    });
    String cityName = await _weatherService.getCurrentCity();
    print('Fetched City Name: $cityName');

    if (cityName.isNotEmpty && cityName != 'Unknown') {
      try {
        final weather = await _weatherService.getWeather(cityName);
        setState(() {
          _weather = weather;
          _isLoading = false;
        });
      } catch (e) {
        print(e);
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      print('Failed to get city name');
      setState(() {
        _isLoading = false;
      });
    }
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

  Future<void> _refreshWeather() async {
    await _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[800], // Background color set to dark gray
      body: Center(
        child: _isLoading
            ? Lottie.asset(
                'assets/loading2.json',
                height: 300,
                width: 300,
                repeat: true,
              ) // Custom loading animation
            : SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 50),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.location_on,
                            color: Colors.white), // Location icon
                        Text(
                          _weather?.cityName ?? 'City...',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Lottie.asset(
                      getWeatherAnimation(_weather?.Condition),
                      height: 200,
                      width: 200,
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.thermostat_outlined,
                            color: Colors.white), // Temperature icon
                        SizedBox(width: 5),
                        Text(
                          '${_weather?.temperature.round()}°C',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 50),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildInfoBox(
                          icon: Icons.opacity_outlined,
                          label: 'Humidity',
                          value: '${_weather?.humidity.round()}%',
                        ),
                        _buildInfoBox(
                          icon: Icons.cloud_outlined,
                          label: 'Pressure',
                          value: '${_weather?.pressure.round()}hPa',
                        ),
                        _buildInfoBox(
                          icon: Icons.waves_outlined,
                          label: 'Condition',
                          value: _weather?.Condition ?? "",
                        ),
                      ],
                    ),
                    SizedBox(height: 50),
                    ElevatedButton.icon(
                      onPressed: _fetchWeather,
                      icon: Icon(Icons.refresh,
                          color: Colors.white), // Icon color set to white
                      label: Text(
                        'Refresh Weather',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal:
                                20), // Padding around the button content
                        backgroundColor:
                            Colors.grey[700], // Background color of the button
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              10), // Rounded corners for the button
                        ),
                      ),
                    ),

                    // SizedBox(height: 50),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildInfoBox(
      {required IconData icon, required String label, required String value}) {
    return Column(
      children: [
        Icon(icon, color: Colors.white),
        SizedBox(height: 5),
        Text(
          label,
          style: TextStyle(color: Colors.white),
        ),
        Text(
          value,
          style: TextStyle(color: Colors.white),
        ),
      ],
    );
  }
}
