import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'imp_localizations_de.dart';
import 'imp_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of ImpLocalizations
/// returned by `ImpLocalizations.of(context)`.
///
/// Applications need to include `ImpLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/imp_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: ImpLocalizations.localizationsDelegates,
///   supportedLocales: ImpLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the ImpLocalizations.supportedLocales
/// property.
abstract class ImpLocalizations {
  ImpLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static ImpLocalizations of(BuildContext context) {
    return Localizations.of<ImpLocalizations>(context, ImpLocalizations)!;
  }

  static const LocalizationsDelegate<ImpLocalizations> delegate = _ImpLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en')
  ];

  /// No description provided for @successfullyRead.
  ///
  /// In en, this message translates to:
  /// **'Successfully read'**
  String get successfullyRead;

  /// No description provided for @readingFailed.
  ///
  /// In en, this message translates to:
  /// **'Reading failed'**
  String get readingFailed;

  /// No description provided for @primeFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to prepare for reading'**
  String get primeFailed;

  /// No description provided for @readingFailedMessage.
  ///
  /// In en, this message translates to:
  /// **'Could not detect a p-Chip.'**
  String get readingFailedMessage;

  /// No description provided for @holdTriggerHint.
  ///
  /// In en, this message translates to:
  /// **'Hold trigger button to read the p-Chip'**
  String get holdTriggerHint;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @buttonContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get buttonContinue;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @connected.
  ///
  /// In en, this message translates to:
  /// **'Connected'**
  String get connected;

  /// No description provided for @turnOnPrompt.
  ///
  /// In en, this message translates to:
  /// **'Press the button on the reader to turn it on'**
  String get turnOnPrompt;

  /// No description provided for @timeHint.
  ///
  /// In en, this message translates to:
  /// **'Once started you will have 30s to read'**
  String get timeHint;

  /// No description provided for @readyToScan.
  ///
  /// In en, this message translates to:
  /// **'Ready to read'**
  String get readyToScan;

  /// No description provided for @startScan.
  ///
  /// In en, this message translates to:
  /// **'Start reading'**
  String get startScan;

  /// No description provided for @primingTitle.
  ///
  /// In en, this message translates to:
  /// **'Getting ready to read...'**
  String get primingTitle;

  /// No description provided for @connecting.
  ///
  /// In en, this message translates to:
  /// **'Connecting...'**
  String get connecting;

  /// No description provided for @searching.
  ///
  /// In en, this message translates to:
  /// **'Searching...'**
  String get searching;

  /// No description provided for @scanning.
  ///
  /// In en, this message translates to:
  /// **'Reading...'**
  String get scanning;

  /// No description provided for @distanceHint.
  ///
  /// In en, this message translates to:
  /// **'Distance the reader 2-5mm from the p-Chip'**
  String get distanceHint;

  /// No description provided for @secondsLeft.
  ///
  /// In en, this message translates to:
  /// **'{seconds}s left'**
  String secondsLeft(Object seconds);

  /// No description provided for @searchingHint.
  ///
  /// In en, this message translates to:
  /// **'Make sure the LED \n on the reader is flashing blue.'**
  String get searchingHint;

  /// No description provided for @primingFailed.
  /// 
  /// In en, this message translates to:
  /// **'Firmware incompatible. Please update!'**
  String get incompatibleFirmware;

  /// No description provided for @tokenFailed.
  /// 
  /// In en, this message translates to:
  /// **'Getting new token failed!'**
  String get tokenFailed;

  /// No description provided for @readingsLeft
  /// 
  /// In en, this message translates to:
  /// **'Readings left for this token:'
  String get readingsLeft;
}

class _ImpLocalizationsDelegate extends LocalizationsDelegate<ImpLocalizations> {
  const _ImpLocalizationsDelegate();

  @override
  Future<ImpLocalizations> load(Locale locale) {
    return SynchronousFuture<ImpLocalizations>(lookupImpLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['de', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_ImpLocalizationsDelegate old) => false;
}

ImpLocalizations lookupImpLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de': return ImpLocalizationsDe();
    case 'en': return ImpLocalizationsEn();
  }

  throw FlutterError(
    'ImpLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
