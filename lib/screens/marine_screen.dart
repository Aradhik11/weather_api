import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/weather_provider.dart';

class MarineScreen extends StatefulWidget {
  const MarineScreen({super.key});

  @override
  State<MarineScreen> createState() => _MarineScreenState();
}

class _MarineScreenState extends State<MarineScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WeatherProvider>().getMarineWeather();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Marine Weather & Tides'),
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
                    onPressed: () => provider.getMarineWeather(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final forecast = provider.marineWeather?.forecast;
          if (forecast == null) {
            return const Center(child: Text('No marine data available'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: forecast.forecastday.length,
            itemBuilder: (context, index) {
              final day = forecast.forecastday[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ExpansionTile(
                  title: Text(
                    DateFormat('EEEE, MMM d').format(DateTime.parse(day.date)),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  children: [
                    Container(
                      height: 150,
                      padding: const EdgeInsets.all(16),
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: day.hour.length,
                        itemBuilder: (context, hourIndex) {
                          final hour = day.hour[hourIndex];
                          final time = DateTime.parse(hour.time);
                          return Container(
                            width: 100,
                            margin: const EdgeInsets.only(right: 8),
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: Column(
                                  children: [
                                    Text(
                                      DateFormat('HH:mm').format(time),
                                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 8),
                                    if (hour.waveHeightM != null)
                                      _buildMarineDetail('Wave', '${hour.waveHeightM!.toStringAsFixed(1)}m'),
                                    if (hour.swellHeightM != null)
                                      _buildMarineDetail('Swell', '${hour.swellHeightM!.toStringAsFixed(1)}m'),
                                    if (hour.tides?.isNotEmpty == true)
                                      _buildMarineDetail('Tide', 'Data Available'),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildMarineDetail(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 10)),
          Text(value, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}