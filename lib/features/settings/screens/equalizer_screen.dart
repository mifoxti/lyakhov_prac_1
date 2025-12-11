import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../cubit/equalizer_cubit.dart';
import '../../../theme/app_theme.dart';

class EqualizerScreen extends StatelessWidget {
  const EqualizerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EqualizerCubit(),
      child: const _EqualizerScreenContent(),
    );
  }
}

class _EqualizerScreenContent extends StatelessWidget {
  const _EqualizerScreenContent();

  @override
  Widget build(BuildContext context) {
    final primaryColor = AppTheme.getPrimaryColor(context);
    final backgroundColor = AppTheme.getBackgroundColor(context);
    final textColor = AppTheme.getTextColor(context);
    final isDark = AppTheme.isDarkMode(context);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text('Эквалайзер'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: BlocBuilder<EqualizerCubit, EqualizerState>(
        builder: (context, state) {
          return SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 20),
                _buildStatusCard(context, state, primaryColor, isDark),
                const SizedBox(height: 30),
                _buildPresetsSection(context, state, primaryColor, textColor),
                const SizedBox(height: 30),
                _buildVisualizerSection(context, state, primaryColor, isDark),
                const SizedBox(height: 20),
                _buildSlidersSection(context, state, primaryColor),
                const SizedBox(height: 30),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatusCard(
    BuildContext context,
    EqualizerState state,
    Color primaryColor,
    bool isDark,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  primaryColor.withOpacity(0.3),
                  primaryColor.withOpacity(0.1),
                ]
              : [
                  primaryColor,
                  primaryColor.withOpacity(0.8),
                ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: isDark ? Colors.white.withOpacity(0.1) : Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(
              state.isEnabled ? Icons.graphic_eq : Icons.equalizer,
              size: 40,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  state.isEnabled ? 'Эквалайзер включен' : 'Эквалайзер выключен',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'Пресет: ${state.selectedPreset}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: state.isEnabled,
            onChanged: (value) {
              context.read<EqualizerCubit>().toggleEqualizer();
            },
            activeColor: Colors.white,
            activeTrackColor: Colors.white.withOpacity(0.5),
          ),
        ],
      ),
    );
  }

  Widget _buildPresetsSection(
    BuildContext context,
    EqualizerState state,
    Color primaryColor,
    Color textColor,
  ) {
    final cubit = context.read<EqualizerCubit>();
    final presets = cubit.getPresets();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'Пресеты',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ),
        const SizedBox(height: 15),
        SizedBox(
          height: 45,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: presets.length,
            itemBuilder: (context, index) {
              final preset = presets[index];
              final isSelected = state.selectedPreset == preset;

              return Container(
                margin: const EdgeInsets.only(right: 10),
                child: InkWell(
                  onTap: () => cubit.applyPreset(preset),
                  borderRadius: BorderRadius.circular(25),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: isSelected ? primaryColor : Colors.transparent,
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(
                        color: isSelected ? primaryColor : primaryColor.withOpacity(0.5),
                        width: 2,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        preset,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          color: isSelected ? Colors.white : textColor,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildVisualizerSection(
    BuildContext context,
    EqualizerState state,
    Color primaryColor,
    bool isDark,
  ) {
    return Container(
      height: 200,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.05) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(state.bands.length, (index) {
          final band = state.bands[index];
          final normalizedValue = (band.value + 10) / 20;
          final barHeight = normalizedValue * 140;

          return Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                width: 20,
                height: barHeight,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      primaryColor,
                      primaryColor.withOpacity(0.5),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: primaryColor.withOpacity(0.3),
                      blurRadius: 5,
                      spreadRadius: 1,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Container(
                width: 4,
                height: 4,
                decoration: BoxDecoration(
                  color: state.isEnabled ? primaryColor : Colors.grey,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildSlidersSection(
    BuildContext context,
    EqualizerState state,
    Color primaryColor,
  ) {
    final isDark = AppTheme.isDarkMode(context);
    final textColor = AppTheme.getTextColor(context);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.05) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Ручная настройка',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              TextButton.icon(
                onPressed: () {
                  context.read<EqualizerCubit>().resetToFlat();
                },
                icon: const Icon(Icons.refresh, size: 18),
                label: const Text('Сбросить'),
                style: TextButton.styleFrom(
                  foregroundColor: primaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 250,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(state.bands.length, (index) {
                final band = state.bands[index];
                return Expanded(
                  child: Column(
                    children: [
                      Expanded(
                        child: RotatedBox(
                          quarterTurns: 3,
                          child: SliderTheme(
                            data: SliderThemeData(
                              activeTrackColor: primaryColor,
                              inactiveTrackColor: primaryColor.withOpacity(0.2),
                              thumbColor: primaryColor,
                              overlayColor: primaryColor.withOpacity(0.2),
                              trackHeight: 3,
                              thumbShape: const RoundSliderThumbShape(
                                enabledThumbRadius: 6,
                              ),
                            ),
                            child: Slider(
                              value: band.value,
                              min: -10,
                              max: 10,
                              divisions: 40,
                              onChanged: state.isEnabled
                                  ? (value) {
                                      context.read<EqualizerCubit>().updateBand(index, value);
                                    }
                                  : null,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        band.frequency,
                        style: TextStyle(
                          fontSize: 10,
                          color: textColor.withOpacity(0.7),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 3),
                      Text(
                        '${band.value.toStringAsFixed(0)} dB',
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
