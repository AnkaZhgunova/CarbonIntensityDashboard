import 'package:carbon_intensity_dashboard/data/models/carbon_intensity_model.dart';
import 'package:dio/dio.dart';

class CarbonIntensityApi {
  final Dio dio;
  CarbonIntensityApi(this.dio);
  Future<CarbonIntensity> getCurrentIntensity() async {
    final response = await dio.get('/intensity');
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
    final response = await dio.get('/intensity/date');
    if (response.statusCode == 200 && response.data['data'] is List) {
      return (response.data['data'] as List)
          .map((item) => HalfHourlyIntensity.fromJson(item))
          .toList();
    } else {
      throw Exception('Failed to load daily carbon intensities');
    }
  }

  Future<CarbonIntensity> getCurrentDayIntensity() async {
    final now = DateTime.now();
    final formattedDate = '${now.year.toString().padLeft(4, '0')}-'
        '${now.month.toString().padLeft(2, '0')}-'
        '${now.day.toString().padLeft(2, '0')}';

    final response = await dio.get('/intensity/date/$formattedDate');

    if (response.statusCode == 200 &&
        response.data['data'] != null &&
        response.data['data'].isNotEmpty) {
      final intensityData = response.data['data'][0];
      return CarbonIntensity.fromJson(intensityData);
    } else {
      throw Exception('Failed to load current day intensity');
    }
  }
}
