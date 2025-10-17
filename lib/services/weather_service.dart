import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather_models.dart';

class WeatherService {
  static const String _baseUrl = 'http://api.weatherapi.com/v1';
  static const String _apiKey = '13f43ce7e7d64b43b34113032251710'; 

  Future<WeatherData> getCurrentWeather(String location) async {
    final url = '$_baseUrl/current.json?key=$_apiKey&q=$location&aqi=no';
    final response = await http.get(Uri.parse(url));
    
    if (response.statusCode == 200) {
      return WeatherData.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load current weather');
    }
  }

  Future<WeatherData> getForecast(String location, int days) async {
    final url = '$_baseUrl/forecast.json?key=$_apiKey&q=$location&days=$days&aqi=no&alerts=no';
    final response = await http.get(Uri.parse(url));
    
    if (response.statusCode == 200) {
      return WeatherData.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load forecast');
    }
  }

  Future<WeatherData> getMarineWeather(String location, int days) async {
    final url = '$_baseUrl/marine.json?key=$_apiKey&q=$location&days=$days';
    final response = await http.get(Uri.parse(url));
    
    if (response.statusCode == 200) {
      return WeatherData.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load marine weather');
    }
  }

  Future<WeatherData> getFutureWeather(String location, String date) async {
    final url = '$_baseUrl/future.json?key=$_apiKey&q=$location&dt=$date';
    final response = await http.get(Uri.parse(url));
    
    if (response.statusCode == 200) {
      return WeatherData.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load future weather');
    }
  }
}