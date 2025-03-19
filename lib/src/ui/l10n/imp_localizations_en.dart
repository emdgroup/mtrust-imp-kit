import 'imp_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class ImpLocalizationsEn extends ImpLocalizations {
  ImpLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get successfullyRead => 'Successfully read';

  @override
  String get readingFailed => 'Reading failed';

  @override
  String get primeFailed => 'Failed to prepare for reading';

  @override
  String get readingFailedMessage => 'Could not detect a p-Chip.';

  @override
  String get holdTriggerHint => 'Hold trigger button to read the p-Chip';

  @override
  String get done => 'Done';

  @override
  String get buttonContinue => 'Continue';

  @override
  String get retry => 'Retry';

  @override
  String get connected => 'Connected';

  @override
  String get turnOnPrompt => 'Press the button on the reader to turn it on';

  @override
  String get timeHint => 'Once started you will have 30s to read';

  @override
  String get readyToScan => 'Ready to read';

  @override
  String get startScan => 'Start reading';

  @override
  String get primingTitle => 'Getting ready to read...';

  @override
  String get connecting => 'Connecting...';

  @override
  String get searching => 'Searching...';

  @override
  String get scanning => 'Reading...';

  @override
  String get distanceHint => 'Distance the reader 2-5mm from the p-Chip';

  @override
  String secondsLeft(Object seconds) {
    return '${seconds}s left';
  }

  @override
  String get searchingHint => 'Make sure the LED \n on the reader is flashing blue.';

  @override
  String get incompatibleFirmware => 'Firmware incompatible. Please update!';

  @override
  String get tokenFailed => 'Getting new token failed!';

  @override
  String get readingsLeft => 'Readings left for current token:';
}
