import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/weather_provider.dart';

class ForecastScreen extends StatefulWidget {
  const ForecastScreen({super.key});

  @override
  State<ForecastScreen> createState() => _ForecastScreenState();
}

class _ForecastScreenState extends State<ForecastScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WeatherProvider>().getForecast();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('7-Day Forecast'),
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
                    onPressed: () => provider.getForecast(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final forecast = provider.forecast?.forecast;
          if (forecast == null) {
            return const Center(child: Text('No forecast data'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: forecast.forecastday.length,
            itemBuilder: (context, index) {
              final day = forecast.forecastday[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ExpansionTile(
                  title: Row(
                    children: [
                      Image.network(
                        'https:${day.day.condition.icon}',
                        width: 32,
                        height: 32,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              DateFormat('EEEE, MMM d').format(DateTime.parse(day.date)),
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(day.day.condition.text),
                          ],
                        ),
                      ),
                      Text(
                        '${day.day.maxtempC.round()}°/${day.day.mintempC.round()}°',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  children: [
                    Container(
                      height: 120,
                      padding: const EdgeInsets.all(16),
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: day.hour.length,
                        itemBuilder: (context, hourIndex) {
                          final hour = day.hour[hourIndex];
                          final time = DateTime.parse(hour.time);
                          return Container(
                            width: 80,
                            margin: const EdgeInsets.only(right: 8),
                            child: Column(
                              children: [
                                Text(
                                  DateFormat('HH:mm').format(time),
                                  style: const TextStyle(fontSize: 12),
                                ),
                                const SizedBox(height: 4),
                                Image.network(
                                  'https:${hour.condition.icon}',
                                  width: 24,
                                  height: 24,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${hour.tempC.round()}°',
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
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
}