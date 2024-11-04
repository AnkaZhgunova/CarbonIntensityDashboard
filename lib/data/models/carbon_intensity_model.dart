class CarbonIntensity {
  final int forecast;
  final int actual;

  CarbonIntensity({required this.forecast, required this.actual});

  factory CarbonIntensity.fromJson(Map<String, dynamic> json) {
    return CarbonIntensity(
      forecast: json['intensity']['forecast'] ?? 0,
      actual: json['intensity']['actual'] ?? 0,
    );
  }
}

class HalfHourlyIntensity {
  final DateTime time;
  final int intensity;

  HalfHourlyIntensity({required this.time, required this.intensity});

  factory HalfHourlyIntensity.fromJson(Map<String, dynamic> json) {
    return HalfHourlyIntensity(
      time: DateTime.parse(json['from']),
      intensity: json['intensity']['actual'] ?? 0,
    );
  }
}
