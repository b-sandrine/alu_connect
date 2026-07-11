import 'package:flutter/material.dart';

import 'app_color_tokens.dart';

extension BuildContextThemeX on BuildContext {
  AppColorTokens get colors => Theme.of(this).extension<AppColorTokens>()!;

  bool get isDark => Theme.of(this).brightness == Brightness.dark;
}
