import 'dart:convert';

import "package:geolocator/geolocator.dart";
import "package:geocoding/geocoding.dart";

import 'package:weather_app/models/weather_model.dart';
import "package:http/http.dart" as http;

class WeatherService {
  static const BASE_URL = "https://api.openweathermap.org/data/2.5/weather";
  final String apiKey;

  WeatherService(this.apiKey);

  Future<Weather> getWeather(String cityName) async {
    final response = await http
        .get(Uri.parse('$BASE_URL?q=$cityName&appid=$apiKey&units=metric'));

    if (response.statusCode == 200) {
      return Weather.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to load Data from this location");
    }
  }

  Future<String> getCurrentCity() async {
    //Requisitando permisão para o usuario
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    // Buscar a localização atual
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    //converter a localização em um marcador 
    List<Placemark> placemark = await placemarkFromCoordinates(position.latitude, position.longitude);

    //Extraindo o nome da cidade
    String? city = placemark[0].subAdministrativeArea;

    return city ?? "";
  }
}
