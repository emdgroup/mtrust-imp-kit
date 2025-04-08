import 'imp_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class ImpLocalizationsDe extends ImpLocalizations {
  ImpLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get successfullyRead => 'Lesevorgang erfolgreich';

  @override
  String get readingFailed => 'Lesevorgang fehlgeschlagen';

  @override
  String get primeFailed => 'Failed to prepare for reading';

  @override
  String get readingFailedMessage => 'Kein p-Chip erkannt.';

  @override
  String get holdTriggerHint => 'Hold trigger button to read the p-Chip';

  @override
  String get done => 'Fertig';

  @override
  String get buttonContinue => 'Weiter';

  @override
  String get retry => 'Wiederholen';

  @override
  String get connected => 'Verbunden';

  @override
  String get turnOnPrompt => 'Zum Einschalten Taste drücken';

  @override
  String get timeHint => 'Sobald der Vorgang gestartet wurde, haben Sie 30 Sekunden Zeit zum Lesen';

  @override
  String get readyToScan => 'Bereit zum Lesen';

  @override
  String get startScan => 'Lesevorgang starten';

  @override
  String get primingTitle => 'Lesevorgang vorbereiten...';

  @override
  String get connecting => 'Verbinden...';

  @override
  String get searching => 'Suchen...';

  @override
  String get scanning => 'Lesen...';

  @override
  String get distanceHint => 'Distance the reader 2-5mm from the p-Chip';

  @override
  String secondsLeft(Object seconds) {
    return '${seconds}s\nverbleibend';
  }

  @override
  String get searchingHint => 'Stellen Sie sicher, dass die LED \n am Reader blau blinkt.';

  @override
  String get incompatibleFirmware => 'Inkompatible Firmware. Bitte Update durchführen!';

  @override
  String get tokenFailed => 'Die Vorbereitung für den Lesevorgang ist fehlgeschlagen. Bitte stellen Sie sicher, dass Sie eine funktionierende Internetverbindung haben.';

  @override
  String get readingsLeft => 'Verbleibende Messungen für aktuellen Token:';
}
