import 'package:carbon_intensity_dashboard/data/models/carbon_intensity_model.dart';

abstract class CarbonIntensityState {}

class CarbonIntensityInitialState extends CarbonIntensityState {}

class CarbonIntensityLoadingState extends CarbonIntensityState {}

class CarbonIntensityLoadedState extends CarbonIntensityState {
  final CarbonIntensity currentHalfAnHour;
  final CarbonIntensity currentDay;
  final List<HalfHourlyIntensity> dailyIntensities;

  CarbonIntensityLoadedState({
    required this.currentHalfAnHour,
    required this.currentDay,
    required this.dailyIntensities,
  });
}

class CarbonIntensityErrorState extends CarbonIntensityState {
  final String message;
  CarbonIntensityErrorState(this.message);
}
