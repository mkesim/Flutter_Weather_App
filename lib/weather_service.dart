import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';

class Weather {
  final double temperature;
  final String description;
  final String location;
  final int humidity;
  final String icon;

  Weather({required this.temperature, required this.description, required this.location, required this.humidity, required this.icon});

  factory Weather.fromJsonOpenWeather(Map<String, dynamic> json) {
    return Weather(
      temperature: json['main']['temp'].toDouble(),
      description: json['weather'][0]['description'],
      location: json['name'] + ', ' + json['sys']['country'],
      humidity: json['main']['humidity'],
      icon: json['weather'][0]['icon'],
    );
  }

  factory Weather.fromJsonWeatherAPI(Map<String, dynamic> json) {
    return Weather(
      temperature: json['current']['temp_c'].toDouble(),
      description: json['current']['condition']['text'],
      location: json['location']['name'] + ', ' + json['location']['country'],
      humidity: json['current']['humidity'],
      icon: json['current']['condition']['icon'],
    );
  }
}

class WeatherService {
  Future<Weather> getWeather() async {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    try {
      // Try to fetch data from OpenWeatherMap API first
      final responseOpenWeather = await http.get(
        Uri.parse('http://api.openweathermap.org/data/2.5/weather?lat=${position.latitude}&lon=${position.longitude}&appid= &units=metric'),
      );

      if (responseOpenWeather.statusCode == 200) {
        return Weather.fromJsonOpenWeather(jsonDecode(responseOpenWeather.body));
      } else {
        throw Exception('Failed to load weather from OpenWeatherMap API');
      }
    } catch (e) {
      // If fetching data from OpenWeatherMap API fails, fetch data from WeatherAPI.com API
      final responseWeatherAPI = await http.get(
        Uri.parse('https://weatherapi-com.p.rapidapi.com/current.json?key==${position.latitude},${position.longitude}'),
        headers: {
          "X-Rapidapi-Key": "0a8eacfdfemshd05e76bd1238dfap13db1djsnec86ecf6728f",
          "X-Rapidapi-Host": "weatherapi-com.p.rapidapi.com",
          "Host": "weatherapi-com.p.rapidapi.com",
        },
      );

      if (responseWeatherAPI.statusCode == 200) {
        return Weather.fromJsonWeatherAPI(jsonDecode(responseWeatherAPI.body));
      } else {
        throw Exception('Failed to load weather from WeatherAPI.com API');
      }
    }
  }
}
