class HourlyForecast {
  final String time;  // The time of the forecast (e.g., "14:00")
  final double temperature;  // Temperature for that hour
  final String iconCode;  // Weather icon code (to fetch icon from the API)

  HourlyForecast({
    required this.time,
    required this.temperature,
    required this.iconCode,
  });
}
