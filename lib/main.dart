import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'WeatherProvider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => WeatherProvider(),
      child: WeatherApp(),

    ),

  );
}

class WeatherApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: WeatherScreen(),
      debugShowCheckedModeBanner: false,

    );
  }
}

class WeatherScreen extends StatefulWidget {
  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final TextEditingController _cityController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Fetch the weather based on the user's current location by default
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<WeatherProvider>(context, listen: false).fetchWeather();
    });
  }

  @override
  Widget build(BuildContext context) {
    final weatherProvider = Provider.of<WeatherProvider>(context);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: TextField(
                controller: _cityController,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Enter city name",
                  hintStyle: TextStyle(color: Colors.grey),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.search, color: Colors.white),
                    onPressed: () {
                      String cityName = _cityController.text;
                      if (cityName.isNotEmpty) {
                        weatherProvider.fetchWeather(cityName: cityName);
                      }
                    },
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
            Row(
              children: [
                Icon(Icons.article),
                SizedBox(width: 10),
                Icon(Icons.settings),
              ],
            ),
          ],
        ),
      ),
      body: weatherProvider.isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Current Temperature
            Text(
              "${weatherProvider.temperature.toStringAsFixed(1)}°",
              style: TextStyle(fontSize: 100, color: Colors.white),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  weatherProvider.description,
                  style: TextStyle(color: Colors.grey, fontSize: 18),
                ),
                Text(
                  "Humidity: ${weatherProvider.humidity}%",
                  style: TextStyle(color: Colors.grey, fontSize: 18),
                ),
              ],
            ),
            SizedBox(height: 20),
            // Weather icon and wind speed
            Row(
              children: [
                Image.network(
                  'http://openweathermap.org/img/wn/${weatherProvider.iconCode}@2x.png',
                  scale: 1.0,
                ),
                SizedBox(width: 20),
                Text(
                  "Wind: ${weatherProvider.windSpeed} m/s",
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}