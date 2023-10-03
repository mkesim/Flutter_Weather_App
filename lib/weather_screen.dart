import 'package:flutter/material.dart';
import 'package:weather_icons/weather_icons.dart';
import 'package:havadurumu/weather_service.dart';

class WeatherScreen extends StatefulWidget {
  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  late Future<Weather> _weather;

  @override
  void initState() {
    super.initState();
    _weather = WeatherService().getWeather();
  }

  IconData getWeatherIcon(String iconCode) {
    switch (iconCode) {
      case '01d':
        return WeatherIcons.day_sunny;
      case '01n':
        return WeatherIcons.night_clear;
    // Add more cases for each icon code
      default:
        return WeatherIcons.day_sunny;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather App'),
        backgroundColor: Colors.blueGrey[900],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [Colors.blue[900]!, Colors.blue[300]!],
          ),
        ),
        child: Center(
          child: FutureBuilder<Weather>(
            future: _weather,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(snapshot.data!.location, style: TextStyle(fontSize: 30, color: Colors.white)),
                    SizedBox(height: 20),
                    Icon(getWeatherIcon(snapshot.data!.icon), size: 100, color: Colors.white),
                    SizedBox(height: 20),
                    Text('${snapshot.data!.temperature}°C', style: TextStyle(fontSize: 50, color: Colors.white)),
                    Text(snapshot.data!.description, style: TextStyle(fontSize: 30, color: Colors.white)),
                    SizedBox(height: 20),
                    Text('Humidity: ${snapshot.data!.humidity}%', style: TextStyle(fontSize: 20, color: Colors.white)),
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
