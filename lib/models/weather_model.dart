class WeatherModel {
  final String city;
  final double temp;
  final String description;
  final int humidity;
  final double wind;
  final double feelsLike;

  WeatherModel({
    required this.city,
    required this.temp,
    required this.description,
    required this.humidity,
    required this.wind,
    required this.feelsLike,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      city: json['name'],
      temp: json['main']['temp'].toDouble(),
      description: json['weather'][0]['main'],
      humidity: json['main']['humidity'],
      wind: json['wind']['speed'].toDouble(),
      feelsLike: json['main']['feels_like'].toDouble(),
    );
  }
}
