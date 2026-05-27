import 'package:carbon_intensity_dashboard/data/models/carbon_intensity_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CarbonIntensity', () {
    test('fromJson parses actual intensity correctly', () {
      final Map<String, dynamic> json = {
        'intensity': {'actual': 42}
      };
      final result = CarbonIntensity.fromJson(json);
      expect(result.actual, 42);
    });

    test('fromJson uses 0 when actual is null', () {
      final Map<String, dynamic> json = {
        'intensity': {'actual': null}
      };
      final result = CarbonIntensity.fromJson(json);
      expect(result.actual, 0);
    });
  });

  group('HalfHourlyIntensity', () {
    test('fromJson parses time and intensity correctly', () {
      final Map<String, dynamic> json = {
        'from': '2024-01-01T12:00Z',
        'intensity': {'actual': 42}
      };
      final result = HalfHourlyIntensity.fromJson(json);
      expect(result.time, DateTime.parse('2024-01-01T12:00:00Z'));
      expect(result.intensity, 42);
    });

    test('fromJson uses 0 when actual is null', () {
      final Map<String, dynamic> json = {
        'from': '2024-01-01T12:00Z',
        'intensity': {'actual': null}
      };
      final result = HalfHourlyIntensity.fromJson(json);
      expect(result.time, DateTime.parse('2024-01-01T12:00:00Z'));
      expect(result.intensity, 0);
    });
  });
}
