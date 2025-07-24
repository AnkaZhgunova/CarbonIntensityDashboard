import 'package:carbon_intensity_dashboard/data/api/carbon_intensity_api.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/carbon_intensity_model.dart';
import 'carbon_intensity_event.dart';
import 'carbon_intensity_state.dart';

class CarbonIntensityBloc
    extends Bloc<CarbonIntensityEvent, CarbonIntensityState> {
  final CarbonIntensityApi api;

  CarbonIntensityBloc(this.api) : super(CarbonIntensityInitialState()) {
    on<LoadCarbonIntensityEvent>(_onLoadCarbonIntensity);
  }

  Future<void> _onLoadCarbonIntensity(LoadCarbonIntensityEvent event,
      Emitter<CarbonIntensityState> emit) async {
    emit(CarbonIntensityLoadingState());
    try {
      final CarbonIntensity currentHalfAnHour = await api.getCurrentIntensity();
      final CarbonIntensity currentDay = await api.getCurrentDayIntensity();
      final List<HalfHourlyIntensity> dailyIntensities =
          await api.getDailyIntensities();
      emit(
        CarbonIntensityLoadedState(
          currentHalfAnHour: currentHalfAnHour,
          currentDay: currentDay,
          dailyIntensities: dailyIntensities,
        ),
      );
    } catch (e) {
      emit(CarbonIntensityErrorState(e.toString()));
    }
  }
}
