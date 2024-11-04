import 'package:carbon_intensity_dashboard/data/api/carbon_intensity_api.dart';
import 'package:carbon_intensity_dashboard/domain/bloc/carbon_intensity_bloc.dart';
import 'package:carbon_intensity_dashboard/domain/bloc/carbon_intensity_event.dart';
import 'package:carbon_intensity_dashboard/domain/bloc/carbon_intensity_state.dart';
import 'package:carbon_intensity_dashboard/styles/colors.dart';
import 'package:carbon_intensity_dashboard/styles/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'carbon_intensity_chart.dart';

class CarbonIntensityPage extends StatelessWidget {
  const CarbonIntensityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkGray,
      body: SafeArea(
        child: BlocProvider(
          create: (_) => CarbonIntensityBloc(CarbonIntensityApi())
            ..add(LoadCarbonIntensityEvent()),
          child: BlocBuilder<CarbonIntensityBloc, CarbonIntensityState>(
            builder: (context, state) {
              if (state is CarbonIntensityLoadingState) {
                return const Center(child: CupertinoActivityIndicator());
              } else if (state is CarbonIntensityLoadedState) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 10),
                    Text(
                      'Current Carbon Intensity',
                      style: AppTextStyle.black24Medium500,
                    ),
                    const SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.black,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Table(
                        columnWidths: const {
                          0: FlexColumnWidth(0.55),
                          1: FlexColumnWidth(0.05),
                        },
                        children: [
                          TableRow(
                            children: [
                              Text(
                                'Forecast:',
                                style: AppTextStyle.black16Medium500,
                              ),
                              const SizedBox(),
                              Text(
                                '${state.current.forecast} gCO2/kWh',
                                style: AppTextStyle.black16Medium500,
                              ),
                            ],
                          ),
                          const TableRow(
                            children: [
                              SizedBox(
                                height: 5,
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              SizedBox(
                                height: 5,
                              ),
                            ],
                          ),
                          TableRow(
                            children: [
                              Text(
                                'Actual:',
                                style: AppTextStyle.black16Medium500,
                              ),
                              const SizedBox(),
                              Text(
                                '${state.current.actual} gCO2/kWh',
                                style: AppTextStyle.black16Medium500,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Half-Hourly Carbon Intensity',
                      style: AppTextStyle.black24Medium500,
                    ),
                    const SizedBox(height: 30),
                    AspectRatio(
                      aspectRatio: 1,
                      child: CarbonIntensityChart(
                        intensities: state.dailyIntensities,
                      ),
                    ),
                  ],
                );
              } else if (state is CarbonIntensityErrorState) {
                return Center(
                  child: Text(
                    state.message,
                    textAlign: TextAlign.center,
                    style: AppTextStyle.black18Medium500,
                  ),
                );
              }
              return Container();
            },
          ),
        ),
      ),
    );
  }
}
