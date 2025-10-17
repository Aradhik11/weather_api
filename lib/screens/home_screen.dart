import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/weather_models.dart';
import '../providers/weather_provider.dart';
import 'forecast_screen.dart';
import 'marine_screen.dart';
import 'future_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _locationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WeatherProvider>().getCurrentWeather();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather App'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Consumer<WeatherProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${provider.error}'),
                  ElevatedButton(
                    onPressed: () => provider.getCurrentWeather(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final weather = provider.currentWeather;
          if (weather == null) {
            return const Center(child: Text('No weather data'));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildSearchBar(provider),
                const SizedBox(height: 20),
                _buildCurrentWeather(weather),
                const SizedBox(height: 20),
                _buildNavigationButtons(context),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSearchBar(WeatherProvider provider) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _locationController,
            decoration: const InputDecoration(
              hintText: 'Enter city name',
              border: OutlineInputBorder(),
            ),
          ),
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          onPressed: () {
            if (_locationController.text.isNotEmpty) {
              provider.getCurrentWeather(_locationController.text);
            }
          },
          child: const Text('Search'),
        ),
        IconButton(
          onPressed: () => provider.getCurrentLocation(),
          icon: const Icon(Icons.my_location),
        ),
      ],
    );
  }

  Widget _buildCurrentWeather(WeatherData weather) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              '${weather.location.name}, ${weather.location.country}',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                weather.current.condition.icon.isNotEmpty
                    ? Image.network(
                        weather.current.condition.icon,
                        width: 64,
                        height: 64,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons.cloud, size: 64);
                        },
                      )
                    : const Icon(Icons.cloud, size: 64),
                const SizedBox(width: 16),
                Column(
                  children: [
                    Text(
                      '${weather.current.tempC.round()}°C',
                      style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
                    ),
                    Text(weather.current.condition.text),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildWeatherDetail('Feels like', '${weather.current.feelslikeC.round()}°C'),
                _buildWeatherDetail('Humidity', '${weather.current.humidity.round()}%'),
                _buildWeatherDetail('Wind', '${weather.current.windKph.round()} km/h'),
                _buildWeatherDetail('UV Index', weather.current.uv.toString()),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeatherDetail(String label, String value) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildNavigationButtons(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ForecastScreen()),
            ),
            child: const Text('7-Day Forecast'),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const MarineScreen()),
            ),
            child: const Text('Marine Weather'),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const FutureScreen()),
            ),
            child: const Text('Future Weather'),
          ),
        ),
      ],
    );
  }
}