import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../models/weather_models.dart';
import '../services/weather_service.dart';

class WeatherProvider with ChangeNotifier {
  final WeatherService _weatherService = WeatherService();
  
  WeatherData? _currentWeather;
  WeatherData? _forecast;
  WeatherData? _marineWeather;
  WeatherData? _futureWeather;
  
  bool _isLoading = false;
  String? _error;
  String _currentLocation = 'London';

  WeatherData? get currentWeather => _currentWeather;
  WeatherData? get forecast => _forecast;
  WeatherData? get marineWeather => _marineWeather;
  WeatherData? get futureWeather => _futureWeather;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get currentLocation => _currentLocation;

  Future<void> getCurrentWeather([String? location]) async {
    _setLoading(true);
    try {
      final loc = location ?? _currentLocation;
      _currentWeather = await _weatherService.getCurrentWeather(loc);
      _currentLocation = loc;
      _error = null;
    } catch (e) {
      _error = e.toString();
    }
    _setLoading(false);
  }

  Future<void> getForecast([String? location, int days = 7]) async {
    _setLoading(true);
    try {
      final loc = location ?? _currentLocation;
      _forecast = await _weatherService.getForecast(loc, days);
      _error = null;
    } catch (e) {
      _error = e.toString();
    }
    _setLoading(false);
  }

  Future<void> getMarineWeather([String? location, int days = 7]) async {
    _setLoading(true);
    try {
      final loc = location ?? _currentLocation;
      _marineWeather = await _weatherService.getMarineWeather(loc, days);
      _error = null;
    } catch (e) {
      _error = e.toString();
    }
    _setLoading(false);
  }

  Future<void> getFutureWeather(String date, [String? location]) async {
    _setLoading(true);
    try {
      final loc = location ?? _currentLocation;
      _futureWeather = await _weatherService.getFutureWeather(loc, date);
      _error = null;
    } catch (e) {
      _error = e.toString();
    }
    _setLoading(false);
  }

  Future<void> getCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.whileInUse || 
          permission == LocationPermission.always) {
        Position position = await Geolocator.getCurrentPosition();
        _currentLocation = '${position.latitude},${position.longitude}';
        await getCurrentWeather();
      }
    } catch (e) {
      _error = 'Failed to get location: $e';
      notifyListeners();
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}