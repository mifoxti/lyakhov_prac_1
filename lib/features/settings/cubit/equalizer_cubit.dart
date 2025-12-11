import 'package:flutter_bloc/flutter_bloc.dart';

class EqualizerBand {
  final String frequency;
  final double value;

  EqualizerBand({
    required this.frequency,
    required this.value,
  });

  EqualizerBand copyWith({
    String? frequency,
    double? value,
  }) {
    return EqualizerBand(
      frequency: frequency ?? this.frequency,
      value: value ?? this.value,
    );
  }
}

class EqualizerState {
  final List<EqualizerBand> bands;
  final String selectedPreset;
  final bool isEnabled;

  const EqualizerState({
    required this.bands,
    required this.selectedPreset,
    required this.isEnabled,
  });

  EqualizerState copyWith({
    List<EqualizerBand>? bands,
    String? selectedPreset,
    bool? isEnabled,
  }) {
    return EqualizerState(
      bands: bands ?? this.bands,
      selectedPreset: selectedPreset ?? this.selectedPreset,
      isEnabled: isEnabled ?? this.isEnabled,
    );
  }
}

class EqualizerCubit extends Cubit<EqualizerState> {
  EqualizerCubit()
      : super(EqualizerState(
          bands: [
            EqualizerBand(frequency: '60 Hz', value: 0.0),
            EqualizerBand(frequency: '170 Hz', value: 0.0),
            EqualizerBand(frequency: '310 Hz', value: 0.0),
            EqualizerBand(frequency: '600 Hz', value: 0.0),
            EqualizerBand(frequency: '1 kHz', value: 0.0),
            EqualizerBand(frequency: '3 kHz', value: 0.0),
            EqualizerBand(frequency: '6 kHz', value: 0.0),
            EqualizerBand(frequency: '12 kHz', value: 0.0),
            EqualizerBand(frequency: '14 kHz', value: 0.0),
            EqualizerBand(frequency: '16 kHz', value: 0.0),
          ],
          selectedPreset: 'Выкл',
          isEnabled: false,
        ));

  void updateBand(int index, double value) {
    final updatedBands = List<EqualizerBand>.from(state.bands);
    updatedBands[index] = updatedBands[index].copyWith(value: value);
    emit(state.copyWith(
      bands: updatedBands,
      selectedPreset: 'Пользовательский',
      isEnabled: true,
    ));
  }

  void applyPreset(String presetName) {
    List<double> presetValues;

    switch (presetName) {
      case 'Рок':
        presetValues = [5.0, 3.0, -3.0, -5.0, -2.0, 2.0, 5.0, 6.0, 6.0, 6.0];
        break;
      case 'Джаз':
        presetValues = [3.0, 2.0, 1.0, 1.5, -1.5, -1.5, 0.0, 1.0, 2.0, 3.0];
        break;
      case 'Поп':
        presetValues = [-1.0, -1.0, 0.0, 2.0, 4.0, 4.0, 2.0, 0.0, -1.0, -1.0];
        break;
      case 'Классика':
        presetValues = [4.0, 3.0, 2.0, 1.0, -1.0, -1.0, 0.0, 1.0, 2.0, 3.0];
        break;
      case 'Электроника':
        presetValues = [5.0, 4.0, 1.0, 0.0, -2.0, 1.0, 1.0, 2.0, 4.0, 5.0];
        break;
      case 'Бас буст':
        presetValues = [8.0, 6.0, 4.0, 2.0, 0.0, -1.0, -2.0, -2.0, -2.0, -2.0];
        break;
      case 'Вокал':
        presetValues = [-2.0, -1.0, 1.0, 3.0, 5.0, 5.0, 3.0, 1.0, 0.0, -1.0];
        break;
      case 'Выкл':
        presetValues = List.filled(10, 0.0);
        break;
      default:
        presetValues = List.filled(10, 0.0);
    }

    final updatedBands = state.bands.asMap().entries.map((entry) {
      return entry.value.copyWith(value: presetValues[entry.key]);
    }).toList();

    emit(state.copyWith(
      bands: updatedBands,
      selectedPreset: presetName,
      isEnabled: presetName != 'Выкл',
    ));
  }

  void toggleEqualizer() {
    if (state.isEnabled) {
      applyPreset('Выкл');
    } else {
      emit(state.copyWith(isEnabled: true));
    }
  }

  void resetToFlat() {
    applyPreset('Выкл');
  }

  List<String> getPresets() {
    return [
      'Выкл',
      'Рок',
      'Джаз',
      'Поп',
      'Классика',
      'Электроника',
      'Бас буст',
      'Вокал',
      'Пользовательский',
    ];
  }
}
