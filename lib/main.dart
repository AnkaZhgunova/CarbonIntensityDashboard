import 'package:carbon_intensity_dashboard/presentation/carbon_intensity_page.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'data/api/carbon_intensity_api.dart';
import 'domain/bloc/carbon_intensity_bloc.dart';
import 'domain/bloc/carbon_intensity_event.dart';

void main() {
  final Dio dio =
      Dio(BaseOptions(baseUrl: 'https://api.carbonintensity.org.uk'));
  runApp(MyApp(
    dio: dio,
  ));
}

class MyApp extends StatelessWidget {
  final Dio dio;

  const MyApp({super.key, required this.dio});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BlocProvider(
        create: (_) => CarbonIntensityBloc(CarbonIntensityApi(dio))
          ..add(LoadCarbonIntensityEvent()),
        child: const CarbonIntensityPage(),
      ),
    );
  }
}
