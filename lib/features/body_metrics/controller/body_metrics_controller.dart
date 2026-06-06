import 'package:flutter/material.dart';

class BodyMetricsController extends ChangeNotifier {
  double height = 0;
  double weight = 0;
  double age = 25;

  bool male = true;
  bool metric = true;

  // SETTERS
  void setHeight(double value) {
    height = value;
    notifyListeners();
  }

  void setWeight(double value) {
    weight = value;
    notifyListeners();
  }

  void setAge(double value) {
    age = value;
    notifyListeners();
  }

  void setGender(bool isMale) {
    male = isMale;
    notifyListeners();
  }

  void setUnit(bool isMetric) {
    metric = isMetric;
    notifyListeners();
  }

  // BMI
  double get bmi {
    if (height <= 0 || weight <= 0) return 0;

    final h = metric ? height / 100 : height * 0.0254;
    final w = metric ? weight : weight * 0.453592;

    return w / (h * h);
  }

  String get bmiCategory {
    if (bmi <= 0) return '—';
    if (bmi < 18.5) return 'Underweight';
    if (bmi < 25) return 'Normal';
    if (bmi < 30) return 'Overweight';

    return 'Obese';
  }

  Color get bmiColor {
    if (bmi < 18.5) {
      return const Color(0xFF5AC8FA);
    }

    if (bmi < 25) {
      return const Color(0xFF34C759);
    }

    if (bmi < 30) {
      return const Color(0xFFFF9500);
    }

    return const Color(0xFFFF3B30);
  }

  // BMR
  double get bmr {
    if (height <= 0 || weight <= 0) return 0;

    final h = metric ? height : height * 2.54;
    final w = metric ? weight : weight * 0.453592;

    if (male) {
      return 10 * w + 6.25 * h - 5 * age + 5;
    }

    return 10 * w + 6.25 * h - 5 * age - 161;
  }
}
