import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
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
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
  ];

  /// No description provided for @appSubtitle.
  ///
  /// In de, this message translates to:
  /// **'Widgets für StandBy & Home Screen'**
  String get appSubtitle;

  /// No description provided for @sectionWidgets.
  ///
  /// In de, this message translates to:
  /// **'Widgets'**
  String get sectionWidgets;

  /// No description provided for @sectionDashboard.
  ///
  /// In de, this message translates to:
  /// **'Dashboard'**
  String get sectionDashboard;

  /// No description provided for @sectionPreview.
  ///
  /// In de, this message translates to:
  /// **'Preview'**
  String get sectionPreview;

  /// No description provided for @widgetClock.
  ///
  /// In de, this message translates to:
  /// **'Uhr'**
  String get widgetClock;

  /// No description provided for @widgetClockSubtitle.
  ///
  /// In de, this message translates to:
  /// **'5 Stile, Hintergründe & Farben'**
  String get widgetClockSubtitle;

  /// No description provided for @widgetCalendar.
  ///
  /// In de, this message translates to:
  /// **'Kalender'**
  String get widgetCalendar;

  /// No description provided for @widgetCalendarSubtitle.
  ///
  /// In de, this message translates to:
  /// **'Nächster Termin & Datum'**
  String get widgetCalendarSubtitle;

  /// No description provided for @widgetWeather.
  ///
  /// In de, this message translates to:
  /// **'Wetter'**
  String get widgetWeather;

  /// No description provided for @widgetWeatherSubtitle.
  ///
  /// In de, this message translates to:
  /// **'Temperatur & Wetterlage'**
  String get widgetWeatherSubtitle;

  /// No description provided for @widgetBattery.
  ///
  /// In de, this message translates to:
  /// **'Batterie'**
  String get widgetBattery;

  /// No description provided for @widgetBatterySubtitle.
  ///
  /// In de, this message translates to:
  /// **'Ladestand & Status'**
  String get widgetBatterySubtitle;

  /// No description provided for @widgetMoonPhase.
  ///
  /// In de, this message translates to:
  /// **'Mondphase'**
  String get widgetMoonPhase;

  /// No description provided for @widgetMoonPhaseSubtitle.
  ///
  /// In de, this message translates to:
  /// **'Aktuelle Mondphase & Uhrzeit'**
  String get widgetMoonPhaseSubtitle;

  /// No description provided for @widgetPhoto.
  ///
  /// In de, this message translates to:
  /// **'Foto'**
  String get widgetPhoto;

  /// No description provided for @widgetPhotoSubtitle.
  ///
  /// In de, this message translates to:
  /// **'Eigenes Bild als Widget'**
  String get widgetPhotoSubtitle;

  /// No description provided for @dashboardBuilder.
  ///
  /// In de, this message translates to:
  /// **'Dashboard Builder'**
  String get dashboardBuilder;

  /// No description provided for @dashboardBuilderSubtitle.
  ///
  /// In de, this message translates to:
  /// **'Kombiniere Widgets oder wähle Presets'**
  String get dashboardBuilderSubtitle;

  /// No description provided for @widgetPreview.
  ///
  /// In de, this message translates to:
  /// **'Widget Preview'**
  String get widgetPreview;

  /// No description provided for @widgetPreviewSubtitle.
  ///
  /// In de, this message translates to:
  /// **'Sieh wie deine Widgets aussehen'**
  String get widgetPreviewSubtitle;

  /// No description provided for @unlockPro.
  ///
  /// In de, this message translates to:
  /// **'Pro freischalten'**
  String get unlockPro;

  /// No description provided for @licenses.
  ///
  /// In de, this message translates to:
  /// **'Lizenzen'**
  String get licenses;

  /// No description provided for @debugDisablePro.
  ///
  /// In de, this message translates to:
  /// **'DEBUG: Pro deaktivieren'**
  String get debugDisablePro;

  /// No description provided for @debugEnablePro.
  ///
  /// In de, this message translates to:
  /// **'DEBUG: Pro aktivieren'**
  String get debugEnablePro;

  /// No description provided for @guideTitle.
  ///
  /// In de, this message translates to:
  /// **'So geht\'s'**
  String get guideTitle;

  /// No description provided for @guideTabStandby.
  ///
  /// In de, this message translates to:
  /// **'StandBy'**
  String get guideTabStandby;

  /// No description provided for @guideTabHomeScreen.
  ///
  /// In de, this message translates to:
  /// **'Home Screen'**
  String get guideTabHomeScreen;

  /// No description provided for @guideStandby1Title.
  ///
  /// In de, this message translates to:
  /// **'iPhone ans Ladegerät'**
  String get guideStandby1Title;

  /// No description provided for @guideStandby1Detail.
  ///
  /// In de, this message translates to:
  /// **'Schließe dein iPhone an ein Ladegerät an und lege es im Querformat hin.'**
  String get guideStandby1Detail;

  /// No description provided for @guideStandby2Title.
  ///
  /// In de, this message translates to:
  /// **'StandBy aktiviert sich'**
  String get guideStandby2Title;

  /// No description provided for @guideStandby2Detail.
  ///
  /// In de, this message translates to:
  /// **'Der StandBy-Bildschirm erscheint automatisch. Falls nicht: Einstellungen → StandBy → einschalten.'**
  String get guideStandby2Detail;

  /// No description provided for @guideStandby3Title.
  ///
  /// In de, this message translates to:
  /// **'Widget-Bereich bearbeiten'**
  String get guideStandby3Title;

  /// No description provided for @guideStandby3Detail.
  ///
  /// In de, this message translates to:
  /// **'Halte im StandBy-Modus lange auf eine Widget-Seite gedrückt, dann tippe auf das +-Symbol.'**
  String get guideStandby3Detail;

  /// No description provided for @guideStandby4Title.
  ///
  /// In de, this message translates to:
  /// **'StandBy Hub suchen'**
  String get guideStandby4Title;

  /// No description provided for @guideStandby4Detail.
  ///
  /// In de, this message translates to:
  /// **'Suche nach \\\"StandBy Hub\\\" in der Widget-Liste und wähle dein gewünschtes Widget aus.'**
  String get guideStandby4Detail;

  /// No description provided for @guideStandby5Title.
  ///
  /// In de, this message translates to:
  /// **'Fertig!'**
  String get guideStandby5Title;

  /// No description provided for @guideStandby5Detail.
  ///
  /// In de, this message translates to:
  /// **'Dein Widget erscheint im StandBy. Konfiguriere es hier in der App — Änderungen werden sofort übernommen.'**
  String get guideStandby5Detail;

  /// No description provided for @guideHome1Title.
  ///
  /// In de, this message translates to:
  /// **'Home Screen bearbeiten'**
  String get guideHome1Title;

  /// No description provided for @guideHome1Detail.
  ///
  /// In de, this message translates to:
  /// **'Halte lange auf eine freie Stelle deines Home Screens gedrückt, bis die Apps wackeln.'**
  String get guideHome1Detail;

  /// No description provided for @guideHome2Title.
  ///
  /// In de, this message translates to:
  /// **'Widget hinzufügen'**
  String get guideHome2Title;

  /// No description provided for @guideHome2Detail.
  ///
  /// In de, this message translates to:
  /// **'Tippe oben links auf das +-Symbol, um die Widget-Galerie zu öffnen.'**
  String get guideHome2Detail;

  /// No description provided for @guideHome3Title.
  ///
  /// In de, this message translates to:
  /// **'StandBy Hub suchen'**
  String get guideHome3Title;

  /// No description provided for @guideHome3Detail.
  ///
  /// In de, this message translates to:
  /// **'Suche nach \\\"StandBy Hub\\\" und wähle die gewünschte Widget-Größe (Klein, Mittel oder Groß).'**
  String get guideHome3Detail;

  /// No description provided for @guideHome4Title.
  ///
  /// In de, this message translates to:
  /// **'Fertig!'**
  String get guideHome4Title;

  /// No description provided for @guideHome4Detail.
  ///
  /// In de, this message translates to:
  /// **'Dein Widget erscheint auf dem Home Screen. Konfiguriere es hier in der App — Änderungen werden sofort übernommen.'**
  String get guideHome4Detail;

  /// No description provided for @clockWidgetsTitle.
  ///
  /// In de, this message translates to:
  /// **'Uhren Widgets'**
  String get clockWidgetsTitle;

  /// No description provided for @selectStyle.
  ///
  /// In de, this message translates to:
  /// **'Stil wählen'**
  String get selectStyle;

  /// No description provided for @background.
  ///
  /// In de, this message translates to:
  /// **'Hintergrund'**
  String get background;

  /// No description provided for @backgroundColor.
  ///
  /// In de, this message translates to:
  /// **'Hintergrundfarbe'**
  String get backgroundColor;

  /// No description provided for @accentColor.
  ///
  /// In de, this message translates to:
  /// **'Akzentfarbe'**
  String get accentColor;

  /// No description provided for @clockAccentLabel.
  ///
  /// In de, this message translates to:
  /// **'Uhr & Text Farbe'**
  String get clockAccentLabel;

  /// No description provided for @customAccentColor.
  ///
  /// In de, this message translates to:
  /// **'Eigene Akzentfarbe'**
  String get customAccentColor;

  /// No description provided for @options.
  ///
  /// In de, this message translates to:
  /// **'Optionen'**
  String get options;

  /// No description provided for @use24HourFormat.
  ///
  /// In de, this message translates to:
  /// **'24-Stunden-Format'**
  String get use24HourFormat;

  /// No description provided for @timeOfDayReactivity.
  ///
  /// In de, this message translates to:
  /// **'Tageszeit-Reaktivität'**
  String get timeOfDayReactivity;

  /// No description provided for @timeOfDayReactivitySubtitle.
  ///
  /// In de, this message translates to:
  /// **'Farben passen sich automatisch an'**
  String get timeOfDayReactivitySubtitle;

  /// No description provided for @timeOfDayReactivityDashboard.
  ///
  /// In de, this message translates to:
  /// **'Farben passen sich an die Tageszeit an'**
  String get timeOfDayReactivityDashboard;

  /// No description provided for @backgroundOff.
  ///
  /// In de, this message translates to:
  /// **'Aus'**
  String get backgroundOff;

  /// No description provided for @calendarWidgetTitle.
  ///
  /// In de, this message translates to:
  /// **'Kalender Widget'**
  String get calendarWidgetTitle;

  /// No description provided for @calendarAccentLabel.
  ///
  /// In de, this message translates to:
  /// **'Kalender Farbe'**
  String get calendarAccentLabel;

  /// No description provided for @calendarInfoTitle.
  ///
  /// In de, this message translates to:
  /// **'Das Kalender-Widget zeigt:'**
  String get calendarInfoTitle;

  /// No description provided for @calendarInfoEvent.
  ///
  /// In de, this message translates to:
  /// **'Nächster Termin mit Uhrzeit'**
  String get calendarInfoEvent;

  /// No description provided for @calendarInfoNoEvent.
  ///
  /// In de, this message translates to:
  /// **'Datum wenn keine Termine'**
  String get calendarInfoNoEvent;

  /// No description provided for @calendarInfoFootnote.
  ///
  /// In de, this message translates to:
  /// **'Kalender-Zugriff muss in den Einstellungen erlaubt sein.'**
  String get calendarInfoFootnote;

  /// No description provided for @previewEventTitle.
  ///
  /// In de, this message translates to:
  /// **'Team Meeting'**
  String get previewEventTitle;

  /// No description provided for @previewEventTime.
  ///
  /// In de, this message translates to:
  /// **'um 14:30 Uhr'**
  String get previewEventTime;

  /// No description provided for @weatherWidgetTitle.
  ///
  /// In de, this message translates to:
  /// **'Wetter Widget'**
  String get weatherWidgetTitle;

  /// No description provided for @weatherAccentLabel.
  ///
  /// In de, this message translates to:
  /// **'Wetter Farbe'**
  String get weatherAccentLabel;

  /// No description provided for @settings.
  ///
  /// In de, this message translates to:
  /// **'Einstellungen'**
  String get settings;

  /// No description provided for @currentWeather.
  ///
  /// In de, this message translates to:
  /// **'Aktuelles Wetter'**
  String get currentWeather;

  /// No description provided for @weatherInfoTitle.
  ///
  /// In de, this message translates to:
  /// **'Das Wetter-Widget zeigt:'**
  String get weatherInfoTitle;

  /// No description provided for @weatherInfoTemp.
  ///
  /// In de, this message translates to:
  /// **'Aktuelle Temperatur'**
  String get weatherInfoTemp;

  /// No description provided for @weatherInfoIcon.
  ///
  /// In de, this message translates to:
  /// **'Wetter-Symbol (Sonne, Regen, etc.)'**
  String get weatherInfoIcon;

  /// No description provided for @weatherInfoFootnote.
  ///
  /// In de, this message translates to:
  /// **'Standort-Zugriff muss erlaubt sein für lokales Wetter.'**
  String get weatherInfoFootnote;

  /// No description provided for @batteryWidgetTitle.
  ///
  /// In de, this message translates to:
  /// **'Batterie Widget'**
  String get batteryWidgetTitle;

  /// No description provided for @batteryAccentLabel.
  ///
  /// In de, this message translates to:
  /// **'Batterie Farbe'**
  String get batteryAccentLabel;

  /// No description provided for @batteryLabel.
  ///
  /// In de, this message translates to:
  /// **'Batterie'**
  String get batteryLabel;

  /// No description provided for @batteryInfoTitle.
  ///
  /// In de, this message translates to:
  /// **'Das Batterie-Widget zeigt:'**
  String get batteryInfoTitle;

  /// No description provided for @batteryInfoLevel.
  ///
  /// In de, this message translates to:
  /// **'Aktueller Ladestand in %'**
  String get batteryInfoLevel;

  /// No description provided for @batteryInfoColor.
  ///
  /// In de, this message translates to:
  /// **'Farbwechsel bei niedrigem Akku'**
  String get batteryInfoColor;

  /// No description provided for @batteryInfoBar.
  ///
  /// In de, this message translates to:
  /// **'Visueller Balken (Medium-Widget)'**
  String get batteryInfoBar;

  /// No description provided for @moonPhaseWidgetTitle.
  ///
  /// In de, this message translates to:
  /// **'Mondphase Widget'**
  String get moonPhaseWidgetTitle;

  /// No description provided for @moonAccentLabel.
  ///
  /// In de, this message translates to:
  /// **'Mond & Text Farbe'**
  String get moonAccentLabel;

  /// No description provided for @moonInfoTitle.
  ///
  /// In de, this message translates to:
  /// **'Das Mondphase-Widget zeigt:'**
  String get moonInfoTitle;

  /// No description provided for @moonInfoPhase.
  ///
  /// In de, this message translates to:
  /// **'Aktuelle Mondphase als Emoji'**
  String get moonInfoPhase;

  /// No description provided for @moonInfoName.
  ///
  /// In de, this message translates to:
  /// **'Name der aktuellen Phase'**
  String get moonInfoName;

  /// No description provided for @moonInfoTime.
  ///
  /// In de, this message translates to:
  /// **'Uhrzeit darunter'**
  String get moonInfoTime;

  /// No description provided for @moonNewMoon.
  ///
  /// In de, this message translates to:
  /// **'Neumond'**
  String get moonNewMoon;

  /// No description provided for @moonWaxingCrescent.
  ///
  /// In de, this message translates to:
  /// **'Zunehmend'**
  String get moonWaxingCrescent;

  /// No description provided for @moonFirstQuarter.
  ///
  /// In de, this message translates to:
  /// **'Erstes Viertel'**
  String get moonFirstQuarter;

  /// No description provided for @moonWaxingGibbous.
  ///
  /// In de, this message translates to:
  /// **'Zunehmender Dreiviertelmond'**
  String get moonWaxingGibbous;

  /// No description provided for @moonFullMoon.
  ///
  /// In de, this message translates to:
  /// **'Vollmond'**
  String get moonFullMoon;

  /// No description provided for @moonWaningGibbous.
  ///
  /// In de, this message translates to:
  /// **'Abnehmender Dreiviertelmond'**
  String get moonWaningGibbous;

  /// No description provided for @moonLastQuarter.
  ///
  /// In de, this message translates to:
  /// **'Letztes Viertel'**
  String get moonLastQuarter;

  /// No description provided for @moonWaningCrescent.
  ///
  /// In de, this message translates to:
  /// **'Abnehmend'**
  String get moonWaningCrescent;

  /// No description provided for @dashboardConfigTitle.
  ///
  /// In de, this message translates to:
  /// **'Dashboard Builder'**
  String get dashboardConfigTitle;

  /// No description provided for @customComposition.
  ///
  /// In de, this message translates to:
  /// **'Eigene Zusammenstellung'**
  String get customComposition;

  /// No description provided for @reorderHint.
  ///
  /// In de, this message translates to:
  /// **'Halte das Griff-Symbol um die Reihenfolge zu ändern'**
  String get reorderHint;

  /// No description provided for @yourClock.
  ///
  /// In de, this message translates to:
  /// **'Deine {clockName}'**
  String yourClock(String clockName);

  /// No description provided for @dashboardColor.
  ///
  /// In de, this message translates to:
  /// **'Dashboard Farbe'**
  String get dashboardColor;

  /// No description provided for @customDashboardColor.
  ///
  /// In de, this message translates to:
  /// **'Eigene Dashboard-Farbe'**
  String get customDashboardColor;

  /// No description provided for @individual.
  ///
  /// In de, this message translates to:
  /// **'Individuell'**
  String get individual;

  /// No description provided for @usesGlobalColor.
  ///
  /// In de, this message translates to:
  /// **'Verwendet globale Farbe'**
  String get usesGlobalColor;

  /// No description provided for @chooseColor.
  ///
  /// In de, this message translates to:
  /// **'Farbe wählen'**
  String get chooseColor;

  /// No description provided for @dashboardAccentColor.
  ///
  /// In de, this message translates to:
  /// **'Dashboard Akzentfarbe'**
  String get dashboardAccentColor;

  /// No description provided for @noSlotsActive.
  ///
  /// In de, this message translates to:
  /// **'Keine Slots aktiv'**
  String get noSlotsActive;

  /// No description provided for @slotClock.
  ///
  /// In de, this message translates to:
  /// **'Uhrzeit'**
  String get slotClock;

  /// No description provided for @slotCalendar.
  ///
  /// In de, this message translates to:
  /// **'Nächster Termin'**
  String get slotCalendar;

  /// No description provided for @slotWeather.
  ///
  /// In de, this message translates to:
  /// **'Wetter'**
  String get slotWeather;

  /// No description provided for @slotBattery.
  ///
  /// In de, this message translates to:
  /// **'Batterie'**
  String get slotBattery;

  /// No description provided for @slotMoonPhase.
  ///
  /// In de, this message translates to:
  /// **'Mondphase'**
  String get slotMoonPhase;

  /// No description provided for @slotPhoto.
  ///
  /// In de, this message translates to:
  /// **'Foto'**
  String get slotPhoto;

  /// No description provided for @photoWidgetTitle.
  ///
  /// In de, this message translates to:
  /// **'Foto Widget'**
  String get photoWidgetTitle;

  /// No description provided for @photoSection.
  ///
  /// In de, this message translates to:
  /// **'Foto'**
  String get photoSection;

  /// No description provided for @noImageSelected.
  ///
  /// In de, this message translates to:
  /// **'Kein Bild ausgewählt'**
  String get noImageSelected;

  /// No description provided for @changeImage.
  ///
  /// In de, this message translates to:
  /// **'Bild ändern'**
  String get changeImage;

  /// No description provided for @selectImage.
  ///
  /// In de, this message translates to:
  /// **'Bild auswählen'**
  String get selectImage;

  /// No description provided for @selectPhotoSubtitle.
  ///
  /// In de, this message translates to:
  /// **'Wähle ein Foto aus deiner Galerie'**
  String get selectPhotoSubtitle;

  /// No description provided for @removeImage.
  ///
  /// In de, this message translates to:
  /// **'Bild entfernen'**
  String get removeImage;

  /// No description provided for @photoInfoTitle.
  ///
  /// In de, this message translates to:
  /// **'Das Foto-Widget zeigt:'**
  String get photoInfoTitle;

  /// No description provided for @photoInfoFill.
  ///
  /// In de, this message translates to:
  /// **'Dein Foto füllt den ganzen Widget-Bereich'**
  String get photoInfoFill;

  /// No description provided for @photoInfoOverlay.
  ///
  /// In de, this message translates to:
  /// **'Dunkler Overlay für OLED-freundliche Darstellung'**
  String get photoInfoOverlay;

  /// No description provided for @photoInfoFootnote.
  ///
  /// In de, this message translates to:
  /// **'Das Bild wird auf max. 1024px komprimiert und im App-Container gespeichert.'**
  String get photoInfoFootnote;

  /// No description provided for @info.
  ///
  /// In de, this message translates to:
  /// **'Info'**
  String get info;

  /// No description provided for @paywallSubtitle.
  ///
  /// In de, this message translates to:
  /// **'Einmalkauf — kein Abo'**
  String get paywallSubtitle;

  /// No description provided for @paywallClockStyles.
  ///
  /// In de, this message translates to:
  /// **'Exklusive Uhren-Stile'**
  String get paywallClockStyles;

  /// No description provided for @paywallBackgrounds.
  ///
  /// In de, this message translates to:
  /// **'Premium Hintergründe'**
  String get paywallBackgrounds;

  /// No description provided for @paywallAllFeatures.
  ///
  /// In de, this message translates to:
  /// **'Alle Pro-Features'**
  String get paywallAllFeatures;

  /// No description provided for @paywallFeatureClocks.
  ///
  /// In de, this message translates to:
  /// **'Flip Clock, Binary & Pixel Art'**
  String get paywallFeatureClocks;

  /// No description provided for @paywallFeatureAmbients.
  ///
  /// In de, this message translates to:
  /// **'Sunset, Forest, Nebula & Custom'**
  String get paywallFeatureAmbients;

  /// No description provided for @paywallFeatureColors.
  ///
  /// In de, this message translates to:
  /// **'Eigene Akzent- & Hintergrundfarbe'**
  String get paywallFeatureColors;

  /// No description provided for @paywallFeatureSlots.
  ///
  /// In de, this message translates to:
  /// **'Alle Dashboard-Slots'**
  String get paywallFeatureSlots;

  /// No description provided for @paywallFeatureTimeOfDay.
  ///
  /// In de, this message translates to:
  /// **'Automatische Tageszeit-Farben'**
  String get paywallFeatureTimeOfDay;

  /// No description provided for @paywallProActive.
  ///
  /// In de, this message translates to:
  /// **'Pro ist aktiv'**
  String get paywallProActive;

  /// No description provided for @paywallBuyButton.
  ///
  /// In de, this message translates to:
  /// **'9,99 € — Einmalig freischalten'**
  String get paywallBuyButton;

  /// No description provided for @paywallRestore.
  ///
  /// In de, this message translates to:
  /// **'Käufe wiederherstellen'**
  String get paywallRestore;

  /// No description provided for @previewTitle.
  ///
  /// In de, this message translates to:
  /// **'Widget Preview'**
  String get previewTitle;

  /// No description provided for @previewTabClock.
  ///
  /// In de, this message translates to:
  /// **'Uhr'**
  String get previewTabClock;

  /// No description provided for @previewTabCalendar.
  ///
  /// In de, this message translates to:
  /// **'Kalender'**
  String get previewTabCalendar;

  /// No description provided for @previewTabWeather.
  ///
  /// In de, this message translates to:
  /// **'Wetter'**
  String get previewTabWeather;

  /// No description provided for @previewTabBattery.
  ///
  /// In de, this message translates to:
  /// **'Batterie'**
  String get previewTabBattery;

  /// No description provided for @previewTabMoon.
  ///
  /// In de, this message translates to:
  /// **'Mond'**
  String get previewTabMoon;

  /// No description provided for @previewTabPhoto.
  ///
  /// In de, this message translates to:
  /// **'Foto'**
  String get previewTabPhoto;

  /// No description provided for @previewTabDashboard.
  ///
  /// In de, this message translates to:
  /// **'Dashboard'**
  String get previewTabDashboard;

  /// No description provided for @previewNextEvent.
  ///
  /// In de, this message translates to:
  /// **'Nächster Termin'**
  String get previewNextEvent;

  /// No description provided for @previewWeather.
  ///
  /// In de, this message translates to:
  /// **'Wetter'**
  String get previewWeather;

  /// No description provided for @previewBattery.
  ///
  /// In de, this message translates to:
  /// **'Batterie'**
  String get previewBattery;

  /// No description provided for @previewMoonPhase.
  ///
  /// In de, this message translates to:
  /// **'Mondphase'**
  String get previewMoonPhase;

  /// No description provided for @previewPhoto.
  ///
  /// In de, this message translates to:
  /// **'Foto'**
  String get previewPhoto;

  /// No description provided for @previewSmartDashboard.
  ///
  /// In de, this message translates to:
  /// **'Smart Dashboard'**
  String get previewSmartDashboard;

  /// No description provided for @previewCurrentWeather.
  ///
  /// In de, this message translates to:
  /// **'Aktuelles Wetter'**
  String get previewCurrentWeather;

  /// No description provided for @previewBatteryLabel.
  ///
  /// In de, this message translates to:
  /// **'Batterie'**
  String get previewBatteryLabel;

  /// No description provided for @previewFullMoon.
  ///
  /// In de, this message translates to:
  /// **'Vollmond'**
  String get previewFullMoon;

  /// No description provided for @previewCurrentMoonPhase.
  ///
  /// In de, this message translates to:
  /// **'Aktuelle Mondphase'**
  String get previewCurrentMoonPhase;

  /// No description provided for @previewPhotoWidget.
  ///
  /// In de, this message translates to:
  /// **'Foto Widget'**
  String get previewPhotoWidget;

  /// No description provided for @previewNoPhoto.
  ///
  /// In de, this message translates to:
  /// **'Kein Foto gewählt'**
  String get previewNoPhoto;

  /// No description provided for @previewChoosePhoto.
  ///
  /// In de, this message translates to:
  /// **'Wähle ein Foto in der Foto-Konfiguration'**
  String get previewChoosePhoto;

  /// No description provided for @previewBackground.
  ///
  /// In de, this message translates to:
  /// **'Hintergrund'**
  String get previewBackground;

  /// No description provided for @previewDashboardSubtitle.
  ///
  /// In de, this message translates to:
  /// **'Kombiniertes Widget mit deinen gewählten Slots'**
  String get previewDashboardSubtitle;

  /// No description provided for @previewPhotoSubtitle.
  ///
  /// In de, this message translates to:
  /// **'Zeigt dein gewähltes Foto als Widget'**
  String get previewPhotoSubtitle;

  /// No description provided for @previewWidgetSubtitle.
  ///
  /// In de, this message translates to:
  /// **'Füge das Widget über den iOS Widget-Picker hinzu'**
  String get previewWidgetSubtitle;

  /// No description provided for @ambientNone.
  ///
  /// In de, this message translates to:
  /// **'Kein Hintergrund'**
  String get ambientNone;

  /// No description provided for @ambientNoneDesc.
  ///
  /// In de, this message translates to:
  /// **'Reines OLED Schwarz'**
  String get ambientNoneDesc;

  /// No description provided for @ambientAurora.
  ///
  /// In de, this message translates to:
  /// **'Aurora'**
  String get ambientAurora;

  /// No description provided for @ambientAuroraDesc.
  ///
  /// In de, this message translates to:
  /// **'Nordlicht-Farbverläufe'**
  String get ambientAuroraDesc;

  /// No description provided for @ambientLava.
  ///
  /// In de, this message translates to:
  /// **'Lava'**
  String get ambientLava;

  /// No description provided for @ambientLavaDesc.
  ///
  /// In de, this message translates to:
  /// **'Warme Orange/Rot-Töne'**
  String get ambientLavaDesc;

  /// No description provided for @ambientOcean.
  ///
  /// In de, this message translates to:
  /// **'Ocean'**
  String get ambientOcean;

  /// No description provided for @ambientOceanDesc.
  ///
  /// In de, this message translates to:
  /// **'Kühle Blau/Türkis-Töne'**
  String get ambientOceanDesc;

  /// No description provided for @ambientSunset.
  ///
  /// In de, this message translates to:
  /// **'Sunset'**
  String get ambientSunset;

  /// No description provided for @ambientSunsetDesc.
  ///
  /// In de, this message translates to:
  /// **'Warme Abendrot-Töne'**
  String get ambientSunsetDesc;

  /// No description provided for @ambientForest.
  ///
  /// In de, this message translates to:
  /// **'Forest'**
  String get ambientForest;

  /// No description provided for @ambientForestDesc.
  ///
  /// In de, this message translates to:
  /// **'Tiefes Waldgrün'**
  String get ambientForestDesc;

  /// No description provided for @ambientNebula.
  ///
  /// In de, this message translates to:
  /// **'Nebula'**
  String get ambientNebula;

  /// No description provided for @ambientNebulaDesc.
  ///
  /// In de, this message translates to:
  /// **'Kosmisches Violett/Pink'**
  String get ambientNebulaDesc;

  /// No description provided for @ambientCustom.
  ///
  /// In de, this message translates to:
  /// **'Eigene Farbe'**
  String get ambientCustom;

  /// No description provided for @ambientCustomDesc.
  ///
  /// In de, this message translates to:
  /// **'Wähle deine Hintergrundfarbe'**
  String get ambientCustomDesc;

  /// No description provided for @ambientImage.
  ///
  /// In de, this message translates to:
  /// **'Eigenes Bild'**
  String get ambientImage;

  /// No description provided for @ambientImageDesc.
  ///
  /// In de, this message translates to:
  /// **'Foto als Hintergrund'**
  String get ambientImageDesc;

  /// No description provided for @clockFlipClock.
  ///
  /// In de, this message translates to:
  /// **'Flip Clock'**
  String get clockFlipClock;

  /// No description provided for @clockFlipClockDesc.
  ///
  /// In de, this message translates to:
  /// **'Retro Split-Flap Design'**
  String get clockFlipClockDesc;

  /// No description provided for @clockDigital.
  ///
  /// In de, this message translates to:
  /// **'Digital'**
  String get clockDigital;

  /// No description provided for @clockDigitalDesc.
  ///
  /// In de, this message translates to:
  /// **'Schlichte Digitaluhr'**
  String get clockDigitalDesc;

  /// No description provided for @clockAnalog.
  ///
  /// In de, this message translates to:
  /// **'Analog Classic'**
  String get clockAnalog;

  /// No description provided for @clockAnalogDesc.
  ///
  /// In de, this message translates to:
  /// **'Klassische Zeiger-Uhr'**
  String get clockAnalogDesc;

  /// No description provided for @clockBinary.
  ///
  /// In de, this message translates to:
  /// **'Binary Clock'**
  String get clockBinary;

  /// No description provided for @clockBinaryDesc.
  ///
  /// In de, this message translates to:
  /// **'LED-Dot-Matrix-Look'**
  String get clockBinaryDesc;

  /// No description provided for @clockPixelArt.
  ///
  /// In de, this message translates to:
  /// **'Pixel Art Uhr'**
  String get clockPixelArt;

  /// No description provided for @clockPixelArtDesc.
  ///
  /// In de, this message translates to:
  /// **'Retro-Pixel-Szenen & Uhrzeit'**
  String get clockPixelArtDesc;

  /// No description provided for @widgetSizeSmall.
  ///
  /// In de, this message translates to:
  /// **'Klein'**
  String get widgetSizeSmall;

  /// No description provided for @widgetSizeMedium.
  ///
  /// In de, this message translates to:
  /// **'Mittel'**
  String get widgetSizeMedium;

  /// No description provided for @widgetSizeLarge.
  ///
  /// In de, this message translates to:
  /// **'Groß'**
  String get widgetSizeLarge;

  /// No description provided for @showDefaults.
  ///
  /// In de, this message translates to:
  /// **'Standardwerte'**
  String get showDefaults;

  /// No description provided for @showDefaultsSubtitle.
  ///
  /// In de, this message translates to:
  /// **'Vorschau ohne Anpassungen'**
  String get showDefaultsSubtitle;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['de', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
