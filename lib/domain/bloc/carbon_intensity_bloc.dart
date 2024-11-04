import 'package:carbon_intensity_dashboard/data/api/carbon_intensity_api.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'carbon_intensity_event.dart';
import 'carbon_intensity_state.dart';

class CarbonIntensityBloc extends Bloc<CarbonIntensityEvent, CarbonIntensityState> {
  final CarbonIntensityApi api;

  CarbonIntensityBloc(this.api) : super(CarbonIntensityInitialState()) {
    on<LoadCarbonIntensityEvent>(_onLoadCarbonIntensity);
  }

  Future<void> _onLoadCarbonIntensity(
      LoadCarbonIntensityEvent event, Emitter<CarbonIntensityState> emit) async {
    emit(CarbonIntensityLoadingState());
    try {
      final current = await api.getCurrentIntensity();
      final daily = await api.getDailyIntensities();
      emit(CarbonIntensityLoadedState(current, daily));
    } catch (e) {
      emit(CarbonIntensityErrorState(e.toString()));
    }
  }
}
