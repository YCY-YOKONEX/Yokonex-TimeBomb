import 'package:flutter/widgets.dart';

import '../game/player_bomb_settings.dart';
import 'generated/app_localizations.dart';

export 'generated/app_localizations.dart';

extension AppLocalizationsContext on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}

extension BombSettingsLocalizations on AppLocalizations {
  String flavorLabel(PlayerBombSettings settings) {
    if (settings.numbCount > 0 && settings.spicyCount > 0) {
      return mixedFlavor(settings.numbCount, settings.spicyCount);
    }
    if (settings.numbCount > 0) {
      return settings.numbCount == 1
          ? numbFlavor
          : numbFlavorCount(settings.numbCount);
    }
    if (settings.spicyCount > 0) {
      return settings.spicyCount == 1
          ? spicyFlavor
          : spicyFlavorCount(settings.spicyCount);
    }
    return originalFlavor;
  }
}
