enum DashboardSlotType {
  calendar('Nächster Termin', 'calendar_today', false),
  weather('Wetter', 'cloud', false),
  battery('Batterie', 'battery_full', false);

  const DashboardSlotType(this.displayName, this.iconName, this.isPro);

  final String displayName;
  final String iconName;
  final bool isPro;
}

class DashboardSlot {
  const DashboardSlot({
    required this.type,
    this.enabled = true,
    this.position = 0,
  });

  final DashboardSlotType type;
  final bool enabled;
  final int position;

  DashboardSlot copyWith({
    DashboardSlotType? type,
    bool? enabled,
    int? position,
  }) {
    return DashboardSlot(
      type: type ?? this.type,
      enabled: enabled ?? this.enabled,
      position: position ?? this.position,
    );
  }

  Map<String, dynamic> toJson() => {
        'type': type.name,
        'enabled': enabled,
        'position': position,
      };

  factory DashboardSlot.fromJson(Map<String, dynamic> json) => DashboardSlot(
        type: DashboardSlotType.values.byName(json['type'] as String),
        enabled: json['enabled'] as bool? ?? true,
        position: json['position'] as int? ?? 0,
      );
}
