import 'package:flutter/material.dart';

final class ProjectRadius {
  const ProjectRadius._();

  static const double small = 8;
  static const double medium = 12;
  static const double large = 16;
  static const double xLarge = 24;
  static const double circular = 999;

  static const Radius radiusSmall = Radius.circular(small);
  static const Radius radiusMedium = Radius.circular(medium);
  static const Radius radiusLarge = Radius.circular(large);
  static const Radius radiusXLarge = Radius.circular(xLarge);
  static const Radius radiusCircular = Radius.circular(circular);

  static const BorderRadius allSmall = BorderRadius.all(radiusSmall);
  static const BorderRadius allMedium = BorderRadius.all(radiusMedium);
  static const BorderRadius allLarge = BorderRadius.all(radiusLarge);
  static const BorderRadius allXLarge = BorderRadius.all(radiusXLarge);
  static const BorderRadius allCircular = BorderRadius.all(radiusCircular);

  static const BorderRadius topSmall = BorderRadius.only(
    topLeft: radiusSmall,
    topRight: radiusSmall,
  );
  static const BorderRadius topMedium = BorderRadius.only(
    topLeft: radiusMedium,
    topRight: radiusMedium,
  );
  static const BorderRadius topLarge = BorderRadius.only(
    topLeft: radiusLarge,
    topRight: radiusLarge,
  );

  static const BorderRadius bottomSmall = BorderRadius.only(
    bottomLeft: radiusSmall,
    bottomRight: radiusSmall,
  );
  static const BorderRadius bottomMedium = BorderRadius.only(
    bottomLeft: radiusMedium,
    bottomRight: radiusMedium,
  );
  static const BorderRadius bottomLarge = BorderRadius.only(
    bottomLeft: radiusLarge,
    bottomRight: radiusLarge,
  );

  // Proje özelinde kullanım
  static const BorderRadius card = allMedium;
  static const BorderRadius button = allSmall;
  static const BorderRadius dialog = allLarge;
  static const BorderRadius bottomSheet = BorderRadius.only(
    topLeft: radiusLarge,
    topRight: radiusLarge,
    bottomLeft: radiusMedium,
    bottomRight: radiusMedium,
  );
}
