import 'package:flutter/material.dart';

class SettingsService {
  static ValueNotifier<double> textScaleFactor = ValueNotifier(1.0);

  static void updateTextScale(double scale) {
    textScaleFactor.value = scale;
  }
}
