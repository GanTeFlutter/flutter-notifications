import 'package:flutter/material.dart';

final class ProjectPadding {
  const ProjectPadding._();

  static const double small = 8;
  static const double medium = 16;
  static const double large = 32;
  static const double xLarge = 48;

  static const EdgeInsets allSmall = EdgeInsets.all(small);
  static const EdgeInsets allMedium = EdgeInsets.all(medium);
  static const EdgeInsets allLarge = EdgeInsets.all(large);

  static const EdgeInsets horizontalSmall = EdgeInsets.symmetric(
    horizontal: small,
  );
  static const EdgeInsets horizontalMedium = EdgeInsets.symmetric(
    horizontal: medium,
  );

  static const EdgeInsets verticalSmall = EdgeInsets.symmetric(vertical: small);
  static const EdgeInsets verticalMedium = EdgeInsets.symmetric(
    vertical: medium,
  );
}
