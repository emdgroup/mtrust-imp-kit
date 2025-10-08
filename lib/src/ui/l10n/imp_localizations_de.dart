// ignore: unused_import
import 'package:intl/intl.dart' as intl;
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
  String get primeFailed =>
      'Die Vorbereitung für den Lesevorgang ist fehlgeschlagen';

  @override
  String get readingFailedMessage => 'Kein p-Chip erkannt.';

  @override
  String get holdTriggerHint =>
      'Halten Sie die Taste gedrückt, um den p-Chip zu lesen';

  @override
  String get done => 'Fertig';

  @override
  String get buttonContinue => 'Weiter';

  @override
  String get retry => 'Wiederholen';

  @override
  String get connected => 'Verbunden';

  @override
  String get disconnect => 'Verbindung trennen';

  @override
  String get turnOnPrompt => 'Zum Einschalten Taste drücken';

  @override
  String get timeHint =>
      'Sobald der Vorgang gestartet wurde, haben Sie 30 Sekunden Zeit zum Lesen';

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
  String get distanceHint => 'Halten Sie den Reader 2-5mm vom p-Chip entfernt';

  @override
  String secondsLeft(Object seconds) {
    return '${seconds}s verbleibend';
  }

  @override
  String get searchingHint =>
      'Stellen Sie sicher, dass die LED \n am Reader blau blinkt.';

  @override
  String get incompatibleFirmware => 'Reader Firmware inkompatibel';

  @override
  String get requiredFirmware =>
      'Diese App benötigt einen Reader mit einer Firmware Version von';

  @override
  String get firmwareHint =>
      'Wenn Sie der Besitzer des Readers sind, können Sie die Firmware in the M-Trust Konsole aktualisieren';

  @override
  String get tokenFailed =>
      'Die Vorbereitung für den Lesevorgang ist fehlgeschlagen. Bitte stellen Sie sicher, dass Sie eine funktionierende Internetverbindung haben.';

  @override
  String readingsLeft(Object count) {
    return 'Verbleibende Messungen für aktuellen Token: $count';
  }

  @override
  String get unknown => 'Unbekannt';
}
