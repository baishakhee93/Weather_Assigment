
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'WeatherProvider.dart';

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

    // Set the city name in the text field if it's not already set
    if (weatherProvider.city.isNotEmpty && _cityController.text.isEmpty) {
      _cityController.text = weatherProvider.city;
    }

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
                Icon(Icons.article, color: Colors.white),
                SizedBox(width: 10),
                Icon(Icons.settings, color: Colors.white),
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
            SizedBox(height: 20),
            // Horizontal list view for daily weather forecast
            SizedBox(
              height: 100, // Height of the horizontal list view
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: weatherProvider.hourlyForecast.length,
                itemBuilder: (context, index) {
                  final hourlyData = weatherProvider.hourlyForecast[index];
                  return Container(
                    width: 80, // Width of each item
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          hourlyData.time, // Format your time accordingly
                          style: TextStyle(color: Colors.white),
                        ),
                        SizedBox(height: 4),
                        Image.network(
                          'http://openweathermap.org/img/wn/${hourlyData.iconCode}@2x.png',
                          width: 40, // Adjust icon size
                          height: 40,
                        ),
                        SizedBox(height: 4),
                        Text(
                          "${hourlyData.temperature.toStringAsFixed(1)}°",
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
