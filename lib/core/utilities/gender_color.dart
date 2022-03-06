import 'package:flutter/material.dart';

final maleColor = HSVColor.fromColor(Colors.blue.shade300);
final femaleColor = HSVColor.fromColor(Colors.pink.shade300);
Color? genderColor(double femaleRatio) {
  return HSVColor.lerp(maleColor, femaleColor, femaleRatio)?.toColor();
}
