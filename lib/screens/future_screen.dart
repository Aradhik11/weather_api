import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/weather_models.dart';
import '../providers/weather_provider.dart';

class FutureScreen extends StatefulWidget {
  const FutureScreen({super.key});

  @override
  State<FutureScreen> createState() => _FutureScreenState();
}

class _FutureScreenState extends State<FutureScreen> {
  DateTime? _selectedDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Future Weather'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Consumer<WeatherProvider>(
        builder: (context, provider, child) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        const Text(
                          'Select Future Date',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                _selectedDate != null
                                    ? DateFormat('yyyy-MM-dd').format(_selectedDate!)
                                    : 'No date selected',
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () => _selectDate(context),
                              child: const Text('Select Date'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _selectedDate != null
                                ? () => provider.getFutureWeather(
                                      DateFormat('yyyy-MM-dd').format(_selectedDate!),
                                    )
                                : null,
                            child: const Text('Get Future Weather'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                if (provider.isLoading)
                  const Center(child: CircularProgressIndicator())
                else if (provider.error != null)
                  Center(
                    child: Column(
                      children: [
                        Text('Error: ${provider.error}'),
                        ElevatedButton(
                          onPressed: () => provider.clearError(),
                          child: const Text('Clear Error'),
                        ),
                      ],
                    ),
                  )
                else if (provider.futureWeather != null)
                  Expanded(child: _buildFutureWeatherCard(provider.futureWeather!))
                else
                  const Center(
                    child: Text(
                      'Select a date between 14 and 300 days in the future to get weather forecast',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime now = DateTime.now();
    final DateTime minDate = now.add(const Duration(days: 14));
    final DateTime maxDate = now.add(const Duration(days: 300));
    
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: minDate,
      firstDate: minDate,
      lastDate: maxDate,
    );
    
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Widget _buildFutureWeatherCard(WeatherData weather) {
    final day = weather.forecast!.forecastday.first.day;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              '${weather.location.name}, ${weather.location.country}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              DateFormat('EEEE, MMM d, yyyy').format(DateTime.parse(weather.forecast!.forecastday.first.date)),
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                day.condition.icon.isNotEmpty
                    ? Image.network(
                        day.condition.icon,
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
                      '${day.maxtempC.round()}°C / ${day.mintempC.round()}°C',
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    Text(day.condition.text),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildWeatherDetail('Avg Temp', '${day.avgtempC.round()}°C'),
                _buildWeatherDetail('Humidity', '${day.avghumidity.round()}%'),
                _buildWeatherDetail('Max Wind', '${day.maxwindKph.round()} km/h'),
                _buildWeatherDetail('UV Index', day.uv.toString()),
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
        Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
      ],
    );
  }
}