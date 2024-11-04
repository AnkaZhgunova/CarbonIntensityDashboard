import 'package:carbon_intensity_dashboard/data/models/carbon_intensity_model.dart';
import 'package:dio/dio.dart';

class CarbonIntensityApi {
  final Dio _dio =
      Dio(BaseOptions(baseUrl: 'https://api.carbonintensity.org.uk'));

  Future<CarbonIntensity> getCurrentIntensity() async {
    final response = await _dio.get('/intensity');
    if (response.statusCode == 200 &&
        response.data['data'] != null &&
        response.data['data'].isNotEmpty) {
      final intensityData = response.data['data'][0];
      return CarbonIntensity.fromJson(intensityData);
    } else {
      throw Exception('Failed to load current carbon intensity data');
    }
  }

  Future<List<HalfHourlyIntensity>> getDailyIntensities() async {
    final response = await _dio.get('/intensity/date');
    if (response.statusCode == 200 && response.data['data'] is List) {
      return (response.data['data'] as List)
          .map((item) => HalfHourlyIntensity.fromJson(item))
          .toList();
    } else {
      throw Exception('Failed to load daily carbon intensities');
    }
  }
}
