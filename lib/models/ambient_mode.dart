enum AmbientMode {
  aurora('Aurora', 'Langsam wechselnde Nordlicht-Farbverläufe', false),
  lava('Lava', 'Warme Orange/Rot-Töne, organische Formen', true),
  ocean('Ocean', 'Kühle Blau/Türkis-Töne', true);

  const AmbientMode(this.displayName, this.description, this.isPro);

  final String displayName;
  final String description;
  final bool isPro;
}
