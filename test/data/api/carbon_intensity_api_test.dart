import 'package:carbon_intensity_dashboard/data/api/carbon_intensity_api.dart';
import 'package:carbon_intensity_dashboard/data/models/carbon_intensity_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks/mocks.dart';

void main() {
  late MockDio mockDio;
  late CarbonIntensityApi api;

  setUp(() {
    mockDio = MockDio();
    api = CarbonIntensityApi(mockDio);
  });

  group('getCurrentIntensity', () {
    test('returns CarbonIntensity when response is successful', () async {
      when(() => mockDio.get(any())).thenAnswer(
        (_) async => Response(
          data: {
            'data': [
              {
                'intensity': {'actual': 20}
              }
            ]
          },
          requestOptions: RequestOptions(path: ''),
          statusCode: 200,
        ),
      );

      expect(await api.getCurrentIntensity(), isA<CarbonIntensity>());
    });

    test('throws when response has no data', () async {
      when(() => mockDio.get(any())).thenAnswer(
            (_) async => Response(
          data: {
            'data': null,
          },
          requestOptions: RequestOptions(path: ''),
          statusCode: 404,
        ),
      );

      expect(api.getCurrentIntensity(), throwsException);
    });
  });
}
