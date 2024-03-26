import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_app/models/weather_model.dart';
import 'package:weather_app/services/weather_service.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  //chave da API
  final _weatherService = WeatherService("74c4bd19d03c8bfb18e29696324302d5");
  Weather? _weather;

  //Buscar o clima
  _fetchWeather() async {
    //nome da cidade
    String cityName = await _weatherService.getCurrentCity();

    //Pegar o clima
    try {
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
      });
    }
    //erros
    catch (e) {
      print(e);
    }
  }

  String getWeatherAnimations(String? mainCondition){
    if(mainCondition == null) return "assets/sunny.json";

    switch( mainCondition.toLowerCase()){
      case "couds":
      case "mist":
      case "smoke":
      case "haze":
      case "dust":
      case "fog":
        return "assets/clouds.json";
      case "rain":
      case "drizzle":
      case "shower rain":
        return "assets/rain.json";
      case "thunderstorm":
        return "assets/thunder.json";
      case "clear":
        return "assets/sunny.json";
      default:
        return "assets/sunny.json";
        

    }
  }

  //init State
  @override
  void initState() {
    super.initState();

    //buscar o clima
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_weather?.cityName ?? "Loading City.."),

            Lottie.asset(getWeatherAnimations(_weather?.mainCondition)),

            Text("${_weather?.temperature.round()}°C"),
 
            Text(_weather?.mainCondition ?? "")
          ],
        ),
      ),
    );
  }
}
