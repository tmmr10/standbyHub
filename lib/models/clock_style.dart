enum ClockStyle {
  flipClock('Flip Clock', 'Retro Split-Flap Design', true),
  minimalDigital('Minimal Digital', 'Große dünne Zahlen', false),
  analogClassic('Analog Classic', 'Klassische Zeiger-Uhr', false),
  gradientClock('Gradient Clock', 'Tageszeit-basierte Farben', true),
  binaryClock('Binary Clock', 'LED-Dot-Matrix-Look', true);

  const ClockStyle(this.displayName, this.description, this.isPro);

  final String displayName;
  final String description;
  final bool isPro;
}
