# Weather API Flutter App

A comprehensive weather application built with Flutter that consumes the WeatherAPI.com service using Provider pattern for state management.

## Features

- **Real-time Weather**: Current weather conditions with temperature, humidity, wind speed, UV index
- **7-Day Forecast**: Daily and hourly weather forecasts
- **Marine Weather**: Wave heights, swell data, and tide information
- **Future Weather**: Weather predictions up to 300 days ahead
- **Location Services**: GPS-based location detection or manual city search
- **Clean Architecture**: Provider pattern for state management

## Setup Instructions

### 1. Get WeatherAPI Key
1. Visit [WeatherAPI.com](https://www.weatherapi.com/)
2. Sign up for a free account
3. Get your API key from the dashboard

### 2. Configure API Key
1. Open `lib/services/weather_service.dart`
2. Replace `YOUR_API_KEY` with your actual API key:
```dart
static const String _apiKey = 'your_actual_api_key_here';
```

### 3. Install Dependencies
```bash
flutter pub get
```

### 4. Run the App
```bash
flutter run
```

## Dependencies

- `provider: ^6.1.2` - State management
- `http: ^1.2.2` - HTTP requests
- `geolocator: ^13.0.1` - Location services
- `intl: ^0.19.0` - Date formatting

## API Endpoints Used

- `/current.json` - Real-time weather data
- `/forecast.json` - 7-day weather forecast
- `/marine.json` - Marine weather and tide data
- `/future.json` - Future weather (up to 300 days)

## App Structure

```
lib/
├── models/
│   └── weather_models.dart     # Data models
├── providers/
│   └── weather_provider.dart   # State management
├── screens/
│   ├── home_screen.dart        # Current weather
│   ├── forecast_screen.dart    # 7-day forecast
│   ├── marine_screen.dart      # Marine weather
│   └── future_screen.dart      # Future weather
├── services/
│   └── weather_service.dart    # API service
└── main.dart                   # App entry point
```

## Usage

1. **Home Screen**: View current weather, search by city, or use GPS location
2. **Forecast**: Tap "7-Day Forecast" to see daily and hourly predictions
3. **Marine Weather**: Access wave heights and tide data
4. **Future Weather**: Select any date up to 300 days ahead for weather prediction

## Permissions

The app requires:
- Internet access for API calls
- Location permissions for GPS-based weather (optional)

## Note

Replace the API key in `weather_service.dart` before running the app. The free tier of WeatherAPI.com provides sufficient quota for development and testing.