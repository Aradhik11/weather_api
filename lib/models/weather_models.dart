class WeatherData {
  final Current current;
  final Location location;
  final Forecast? forecast;
  final Marine? marine;

  WeatherData({
    required this.current,
    required this.location,
    this.forecast,
    this.marine,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    return WeatherData(
      current: Current.fromJson(json['current']),
      location: Location.fromJson(json['location']),
      forecast: json['forecast'] != null ? Forecast.fromJson(json['forecast']) : null,
      marine: json['marine'] != null ? Marine.fromJson(json['marine']) : null,
    );
  }
}

class Location {
  final String name;
  final String region;
  final String country;
  final double lat;
  final double lon;

  Location({
    required this.name,
    required this.region,
    required this.country,
    required this.lat,
    required this.lon,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      name: json['name'],
      region: json['region'],
      country: json['country'],
      lat: json['lat'].toDouble(),
      lon: json['lon'].toDouble(),
    );
  }
}

class Current {
  final double tempC;
  final double tempF;
  final Condition condition;
  final double windKph;
  final String windDir;
  final double humidity;
  final double feelslikeC;
  final double uv;

  Current({
    required this.tempC,
    required this.tempF,
    required this.condition,
    required this.windKph,
    required this.windDir,
    required this.humidity,
    required this.feelslikeC,
    required this.uv,
  });

  factory Current.fromJson(Map<String, dynamic> json) {
    return Current(
      tempC: json['temp_c'].toDouble(),
      tempF: json['temp_f'].toDouble(),
      condition: Condition.fromJson(json['condition']),
      windKph: json['wind_kph'].toDouble(),
      windDir: json['wind_dir'],
      humidity: json['humidity'].toDouble(),
      feelslikeC: json['feelslike_c'].toDouble(),
      uv: json['uv'].toDouble(),
    );
  }
}

class Condition {
  final String text;
  final String icon;

  Condition({required this.text, required this.icon});

  factory Condition.fromJson(Map<String, dynamic> json) {
    return Condition(
      text: json['text'],
      icon: json['icon'],
    );
  }
}

class Forecast {
  final List<ForecastDay> forecastday;

  Forecast({required this.forecastday});

  factory Forecast.fromJson(Map<String, dynamic> json) {
    return Forecast(
      forecastday: (json['forecastday'] as List)
          .map((day) => ForecastDay.fromJson(day))
          .toList(),
    );
  }
}

class ForecastDay {
  final String date;
  final Day day;
  final List<Hour> hour;

  ForecastDay({required this.date, required this.day, required this.hour});

  factory ForecastDay.fromJson(Map<String, dynamic> json) {
    return ForecastDay(
      date: json['date'],
      day: Day.fromJson(json['day']),
      hour: (json['hour'] as List).map((h) => Hour.fromJson(h)).toList(),
    );
  }
}

class Day {
  final double maxtempC;
  final double mintempC;
  final Condition condition;

  Day({required this.maxtempC, required this.mintempC, required this.condition});

  factory Day.fromJson(Map<String, dynamic> json) {
    return Day(
      maxtempC: json['maxtemp_c'].toDouble(),
      mintempC: json['mintemp_c'].toDouble(),
      condition: Condition.fromJson(json['condition']),
    );
  }
}

class Hour {
  final String time;
  final double tempC;
  final Condition condition;

  Hour({required this.time, required this.tempC, required this.condition});

  factory Hour.fromJson(Map<String, dynamic> json) {
    return Hour(
      time: json['time'],
      tempC: json['temp_c'].toDouble(),
      condition: Condition.fromJson(json['condition']),
    );
  }
}

class Marine {
  final List<MarineDay> forecastday;

  Marine({required this.forecastday});

  factory Marine.fromJson(Map<String, dynamic> json) {
    return Marine(
      forecastday: (json['forecastday'] as List)
          .map((day) => MarineDay.fromJson(day))
          .toList(),
    );
  }
}

class MarineDay {
  final String date;
  final List<MarineHour> hour;

  MarineDay({required this.date, required this.hour});

  factory MarineDay.fromJson(Map<String, dynamic> json) {
    return MarineDay(
      date: json['date'],
      hour: (json['hour'] as List).map((h) => MarineHour.fromJson(h)).toList(),
    );
  }
}

class MarineHour {
  final String time;
  final double waveHeightM;
  final double swellHeightM;
  final Map<String, dynamic> tides;

  MarineHour({
    required this.time,
    required this.waveHeightM,
    required this.swellHeightM,
    required this.tides,
  });

  factory MarineHour.fromJson(Map<String, dynamic> json) {
    return MarineHour(
      time: json['time'],
      waveHeightM: json['wave_height_m']?.toDouble() ?? 0.0,
      swellHeightM: json['swell_height_m']?.toDouble() ?? 0.0,
      tides: json['tides'] ?? {},
    );
  }
}