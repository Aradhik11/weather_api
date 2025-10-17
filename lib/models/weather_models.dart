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
      current: json['current'] != null ? Current.fromJson(json['current']) : Current.empty(),
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

  factory Current.empty() {
    return Current(
      tempC: 0.0,
      tempF: 0.0,
      condition: Condition(text: '', icon: ''),
      windKph: 0.0,
      windDir: '',
      humidity: 0.0,
      feelslikeC: 0.0,
      uv: 0.0,
    );
  }
}

class Condition {
  final String text;
  final String icon;

  Condition({required this.text, required this.icon});

  factory Condition.fromJson(Map<String, dynamic> json) {
    String iconUrl = json['icon'] ?? '';
    if (iconUrl.startsWith('//')) {
      iconUrl = 'https:$iconUrl';
    } else if (!iconUrl.startsWith('http')) {
      iconUrl = 'https:$iconUrl';
    }
    return Condition(
      text: json['text'] ?? '',
      icon: iconUrl,
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
  final double avgtempC;
  final double avghumidity;
  final double maxwindKph;
  final double uv;
  final Condition condition;

  Day({
    required this.maxtempC, 
    required this.mintempC, 
    required this.avgtempC,
    required this.avghumidity,
    required this.maxwindKph,
    required this.uv,
    required this.condition
  });

  factory Day.fromJson(Map<String, dynamic> json) {
    return Day(
      maxtempC: json['maxtemp_c'].toDouble(),
      mintempC: json['mintemp_c'].toDouble(),
      avgtempC: json['avgtemp_c'].toDouble(),
      avghumidity: json['avghumidity'].toDouble(),
      maxwindKph: json['maxwind_kph'].toDouble(),
      uv: json['uv'].toDouble(),
      condition: Condition.fromJson(json['condition']),
    );
  }
}

class Hour {
  final String time;
  final double tempC;
  final Condition condition;
  final double? waveHeightM;
  final double? swellHeightM;
  final Map<String, dynamic>? tides;

  Hour({
    required this.time, 
    required this.tempC, 
    required this.condition,
    this.waveHeightM,
    this.swellHeightM,
    this.tides,
  });

  factory Hour.fromJson(Map<String, dynamic> json) {
    return Hour(
      time: json['time'],
      tempC: json['temp_c'].toDouble(),
      condition: Condition.fromJson(json['condition']),
      waveHeightM: (json['sig_ht_mt'] as num?)?.toDouble(),
      swellHeightM: (json['swell_ht_mt'] as num?)?.toDouble(),
      tides: json['tides'] as Map<String, dynamic>?,
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
      time: json['time'] ?? '',
      waveHeightM: (json['wave_height_m'] as num?)?.toDouble() ?? 0.0,
      swellHeightM: (json['swell_height_m'] as num?)?.toDouble() ?? 0.0,
      tides: json['tides'] as Map<String, dynamic>? ?? {},
    );
  }
}