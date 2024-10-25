import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';

class WeatherProvider with ChangeNotifier {
  String apiKey = 'YOUR API Key'; // Insert your OpenWeather API key here
  String city = "Ameerpet";
  String description = "";
  double temperature = 0;
  int humidity = 0;
  double windSpeed = 0;
  String iconCode = "";
  bool isLoading = true;

  Future<void> fetchWeather({String? cityName}) async {
    String url;
    if (cityName != null && cityName.isNotEmpty) {
      url = 'https://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=$apiKey&units=metric';
    } else {
      Position position = await _determinePosition();
      url = 'https://api.openweathermap.org/data/2.5/weather?lat=${position.latitude}&lon=${position.longitude}&appid=$apiKey&units=metric';
    }

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        city = data['name'];
        temperature = data['main']['temp'];
        description = data['weather'][0]['description'];
        humidity = data['main']['humidity'];
        windSpeed = data['wind']['speed'];
        iconCode = data['weather'][0]['icon'];
        isLoading = false;
        notifyListeners();
      } else {
        throw Exception('Failed to load weather');
      }
    } catch (error) {
      isLoading = false;
      notifyListeners();
      print(error);
    }
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied');
    }

    return await Geolocator.getCurrentPosition();
  }
}
