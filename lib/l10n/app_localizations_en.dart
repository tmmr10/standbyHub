// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appSubtitle => 'Widgets for StandBy & Home Screen';

  @override
  String get sectionWidgets => 'Widgets';

  @override
  String get sectionDashboard => 'Dashboard';

  @override
  String get sectionPreview => 'Preview';

  @override
  String get widgetClock => 'Clock';

  @override
  String get widgetClockSubtitle => '5 styles, backgrounds & colors';

  @override
  String get widgetCalendar => 'Calendar';

  @override
  String get widgetCalendarSubtitle => 'Next event & date';

  @override
  String get widgetWeather => 'Weather';

  @override
  String get widgetWeatherSubtitle => 'Temperature & conditions';

  @override
  String get widgetBattery => 'Battery';

  @override
  String get widgetBatterySubtitle => 'Charge level & status';

  @override
  String get widgetMoonPhase => 'Moon Phase';

  @override
  String get widgetMoonPhaseSubtitle => 'Current moon phase & time';

  @override
  String get widgetPhoto => 'Photo';

  @override
  String get widgetPhotoSubtitle => 'Your own image as widget';

  @override
  String get dashboardBuilder => 'Dashboard Builder';

  @override
  String get dashboardBuilderSubtitle => 'Combine widgets or choose presets';

  @override
  String get widgetPreview => 'Widget Preview';

  @override
  String get widgetPreviewSubtitle => 'See how your widgets look';

  @override
  String get unlockPro => 'Unlock Pro';

  @override
  String get licenses => 'Licenses';

  @override
  String get debugDisablePro => 'DEBUG: Disable Pro';

  @override
  String get debugEnablePro => 'DEBUG: Enable Pro';

  @override
  String get guideTitle => 'How it works';

  @override
  String get guideTabStandby => 'StandBy';

  @override
  String get guideTabHomeScreen => 'Home Screen';

  @override
  String get guideStandby1Title => 'Plug in your iPhone';

  @override
  String get guideStandby1Detail =>
      'Connect your iPhone to a charger and place it in landscape orientation.';

  @override
  String get guideStandby2Title => 'StandBy activates';

  @override
  String get guideStandby2Detail =>
      'The StandBy screen appears automatically. If not: Settings → StandBy → turn on.';

  @override
  String get guideStandby3Title => 'Edit widget area';

  @override
  String get guideStandby3Detail =>
      'In StandBy mode, long press on a widget page, then tap the + icon.';

  @override
  String get guideStandby4Title => 'Search StandBy Hub';

  @override
  String get guideStandby4Detail =>
      'Search for \"StandBy Hub\" in the widget list and choose your desired widget.';

  @override
  String get guideStandby5Title => 'Done!';

  @override
  String get guideStandby5Detail =>
      'Your widget appears in StandBy. Configure it here in the app — changes take effect immediately.';

  @override
  String get guideHome1Title => 'Edit Home Screen';

  @override
  String get guideHome1Detail =>
      'Long press on an empty area of your Home Screen until the apps start jiggling.';

  @override
  String get guideHome2Title => 'Add widget';

  @override
  String get guideHome2Detail =>
      'Tap the + icon in the top left to open the widget gallery.';

  @override
  String get guideHome3Title => 'Search StandBy Hub';

  @override
  String get guideHome3Detail =>
      'Search for \"StandBy Hub\" and choose the desired widget size (Small, Medium, or Large).';

  @override
  String get guideHome4Title => 'Done!';

  @override
  String get guideHome4Detail =>
      'Your widget appears on the Home Screen. Configure it here in the app — changes take effect immediately.';

  @override
  String get clockWidgetsTitle => 'Clock Widgets';

  @override
  String get selectStyle => 'Select Style';

  @override
  String get background => 'Background';

  @override
  String get backgroundColor => 'Background Color';

  @override
  String get accentColor => 'Accent Color';

  @override
  String get clockAccentLabel => 'Clock & Text Color';

  @override
  String get customAccentColor => 'Custom Accent Color';

  @override
  String get options => 'Options';

  @override
  String get use24HourFormat => '24-Hour Format';

  @override
  String get timeOfDayReactivity => 'Time of Day Reactivity';

  @override
  String get timeOfDayReactivitySubtitle => 'Colors adapt automatically';

  @override
  String get timeOfDayReactivityDashboard => 'Colors adapt to time of day';

  @override
  String get backgroundOff => 'Off';

  @override
  String get calendarWidgetTitle => 'Calendar Widget';

  @override
  String get calendarAccentLabel => 'Calendar Color';

  @override
  String get calendarInfoTitle => 'The Calendar widget shows:';

  @override
  String get calendarInfoEvent => 'Next event with time';

  @override
  String get calendarInfoNoEvent => 'Date when no events';

  @override
  String get calendarInfoFootnote =>
      'Calendar access must be allowed in Settings.';

  @override
  String get previewEventTitle => 'Team Meeting';

  @override
  String get previewEventTime => 'at 2:30 PM';

  @override
  String get weatherWidgetTitle => 'Weather Widget';

  @override
  String get weatherAccentLabel => 'Weather Color';

  @override
  String get settings => 'Settings';

  @override
  String get currentWeather => 'Current Weather';

  @override
  String get weatherInfoTitle => 'The Weather widget shows:';

  @override
  String get weatherInfoTemp => 'Current temperature';

  @override
  String get weatherInfoIcon => 'Weather icon (sun, rain, etc.)';

  @override
  String get weatherInfoFootnote =>
      'Location access must be allowed for local weather.';

  @override
  String get batteryWidgetTitle => 'Battery Widget';

  @override
  String get batteryAccentLabel => 'Battery Color';

  @override
  String get batteryLabel => 'Battery';

  @override
  String get batteryInfoTitle => 'The Battery widget shows:';

  @override
  String get batteryInfoLevel => 'Current charge level in %';

  @override
  String get batteryInfoColor => 'Color change at low battery';

  @override
  String get batteryInfoBar => 'Visual bar (Medium widget)';

  @override
  String get moonPhaseWidgetTitle => 'Moon Phase Widget';

  @override
  String get moonAccentLabel => 'Moon & Text Color';

  @override
  String get moonInfoTitle => 'The Moon Phase widget shows:';

  @override
  String get moonInfoPhase => 'Current moon phase as emoji';

  @override
  String get moonInfoName => 'Name of the current phase';

  @override
  String get moonInfoTime => 'Time below';

  @override
  String get moonNewMoon => 'New Moon';

  @override
  String get moonWaxingCrescent => 'Waxing Crescent';

  @override
  String get moonFirstQuarter => 'First Quarter';

  @override
  String get moonWaxingGibbous => 'Waxing Gibbous';

  @override
  String get moonFullMoon => 'Full Moon';

  @override
  String get moonWaningGibbous => 'Waning Gibbous';

  @override
  String get moonLastQuarter => 'Last Quarter';

  @override
  String get moonWaningCrescent => 'Waning Crescent';

  @override
  String get dashboardConfigTitle => 'Dashboard Builder';

  @override
  String get customComposition => 'Custom Composition';

  @override
  String get reorderHint => 'Hold the grip icon to change the order';

  @override
  String yourClock(String clockName) {
    return 'Your $clockName';
  }

  @override
  String get dashboardColor => 'Dashboard Color';

  @override
  String get customDashboardColor => 'Custom Dashboard Color';

  @override
  String get individual => 'Individual';

  @override
  String get usesGlobalColor => 'Uses global color';

  @override
  String get chooseColor => 'Choose Color';

  @override
  String get dashboardAccentColor => 'Dashboard Accent Color';

  @override
  String get noSlotsActive => 'No slots active';

  @override
  String get slotClock => 'Time';

  @override
  String get slotCalendar => 'Next Event';

  @override
  String get slotWeather => 'Weather';

  @override
  String get slotBattery => 'Battery';

  @override
  String get slotMoonPhase => 'Moon Phase';

  @override
  String get slotPhoto => 'Photo';

  @override
  String get photoWidgetTitle => 'Photo Widget';

  @override
  String get photoSection => 'Photo';

  @override
  String get noImageSelected => 'No image selected';

  @override
  String get changeImage => 'Change Image';

  @override
  String get selectImage => 'Select Image';

  @override
  String get selectPhotoSubtitle => 'Choose a photo from your gallery';

  @override
  String get removeImage => 'Remove Image';

  @override
  String get photoInfoTitle => 'The Photo widget shows:';

  @override
  String get photoInfoFill => 'Your photo fills the entire widget area';

  @override
  String get photoInfoOverlay => 'Dark overlay for OLED-friendly display';

  @override
  String get photoInfoFootnote =>
      'The image is compressed to max 1024px and saved in the app container.';

  @override
  String get info => 'Info';

  @override
  String get paywallSubtitle => 'One-time purchase — no subscription';

  @override
  String get paywallClockStyles => 'Exclusive Clock Styles';

  @override
  String get paywallBackgrounds => 'Premium Backgrounds';

  @override
  String get paywallAllFeatures => 'All Pro Features';

  @override
  String get paywallFeatureClocks => 'Flip Clock, Binary & Pixel Art';

  @override
  String get paywallFeatureAmbients => 'Sunset, Forest, Nebula & Custom';

  @override
  String get paywallFeatureColors => 'Custom accent & background color';

  @override
  String get paywallFeatureSlots => 'All dashboard slots';

  @override
  String get paywallFeatureTimeOfDay => 'Automatic time-of-day colors';

  @override
  String get paywallProActive => 'Pro is active';

  @override
  String get paywallBuyButton => '\$9.99 — Unlock once';

  @override
  String get paywallRestore => 'Restore Purchases';

  @override
  String get previewTitle => 'Widget Preview';

  @override
  String get previewTabClock => 'Clock';

  @override
  String get previewTabCalendar => 'Calendar';

  @override
  String get previewTabWeather => 'Weather';

  @override
  String get previewTabBattery => 'Battery';

  @override
  String get previewTabMoon => 'Moon';

  @override
  String get previewTabPhoto => 'Photo';

  @override
  String get previewTabDashboard => 'Dashboard';

  @override
  String get previewNextEvent => 'Next Event';

  @override
  String get previewWeather => 'Weather';

  @override
  String get previewBattery => 'Battery';

  @override
  String get previewMoonPhase => 'Moon Phase';

  @override
  String get previewPhoto => 'Photo';

  @override
  String get previewSmartDashboard => 'Smart Dashboard';

  @override
  String get previewCurrentWeather => 'Current Weather';

  @override
  String get previewBatteryLabel => 'Battery';

  @override
  String get previewFullMoon => 'Full Moon';

  @override
  String get previewCurrentMoonPhase => 'Current Moon Phase';

  @override
  String get previewPhotoWidget => 'Photo Widget';

  @override
  String get previewNoPhoto => 'No photo selected';

  @override
  String get previewChoosePhoto => 'Choose a photo in the Photo configuration';

  @override
  String get previewBackground => 'Background';

  @override
  String get previewDashboardSubtitle =>
      'Combined widget with your chosen slots';

  @override
  String get previewPhotoSubtitle => 'Shows your chosen photo as a widget';

  @override
  String get previewWidgetSubtitle =>
      'Add the widget via the iOS Widget Picker';

  @override
  String get ambientNone => 'No Background';

  @override
  String get ambientNoneDesc => 'Pure OLED Black';

  @override
  String get ambientAurora => 'Aurora';

  @override
  String get ambientAuroraDesc => 'Northern lights gradients';

  @override
  String get ambientLava => 'Lava';

  @override
  String get ambientLavaDesc => 'Warm orange/red tones';

  @override
  String get ambientOcean => 'Ocean';

  @override
  String get ambientOceanDesc => 'Cool blue/turquoise tones';

  @override
  String get ambientSunset => 'Sunset';

  @override
  String get ambientSunsetDesc => 'Warm sunset tones';

  @override
  String get ambientForest => 'Forest';

  @override
  String get ambientForestDesc => 'Deep forest green';

  @override
  String get ambientNebula => 'Nebula';

  @override
  String get ambientNebulaDesc => 'Cosmic violet/pink';

  @override
  String get ambientCustom => 'Custom Color';

  @override
  String get ambientCustomDesc => 'Choose your background color';

  @override
  String get ambientImage => 'Custom Image';

  @override
  String get ambientImageDesc => 'Photo as background';

  @override
  String get clockFlipClock => 'Flip Clock';

  @override
  String get clockFlipClockDesc => 'Retro split-flap design';

  @override
  String get clockDigital => 'Digital';

  @override
  String get clockDigitalDesc => 'Clean digital clock';

  @override
  String get clockAnalog => 'Analog Classic';

  @override
  String get clockAnalogDesc => 'Classic analog clock';

  @override
  String get clockBinary => 'Binary Clock';

  @override
  String get clockBinaryDesc => 'LED dot matrix look';

  @override
  String get clockPixelArt => 'Pixel Art Clock';

  @override
  String get clockPixelArtDesc => 'Retro pixel scenes & time';

  @override
  String get widgetSizeSmall => 'Small';

  @override
  String get widgetSizeMedium => 'Medium';

  @override
  String get widgetSizeLarge => 'Large';

  @override
  String get showDefaults => 'Defaults';

  @override
  String get showDefaultsSubtitle => 'Preview without customizations';
}
