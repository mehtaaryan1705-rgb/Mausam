class LocationResult {
  final String name;
  final String? state;
  final String country;
  final String? countryCode;
  final double latitude;
  final double longitude;
  final bool isCoastal;
  final double? coastDistanceKm;
  final String displayName;

  const LocationResult({
    required this.name,
    this.state,
    required this.country,
    this.countryCode,
    required this.latitude,
    required this.longitude,
    required this.isCoastal,
    this.coastDistanceKm,
    required this.displayName,
  });

  bool get isIndia {
    final c = country.trim().toLowerCase();
    final cc = countryCode?.trim().toUpperCase();
    return c == 'india' || cc == 'IN';
  }

  LocationResult copyWith({
    String? name,
    String? state,
    String? country,
    String? countryCode,
    double? latitude,
    double? longitude,
    bool? isCoastal,
    double? coastDistanceKm,
    String? displayName,
  }) {
    return LocationResult(
      name: name ?? this.name,
      state: state ?? this.state,
      country: country ?? this.country,
      countryCode: countryCode ?? this.countryCode,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      isCoastal: isCoastal ?? this.isCoastal,
      coastDistanceKm: coastDistanceKm ?? this.coastDistanceKm,
      displayName: displayName ?? this.displayName,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'state': state,
      'country': country,
      'countryCode': countryCode,
      'latitude': latitude,
      'longitude': longitude,
      'isCoastal': isCoastal,
      'coastDistanceKm': coastDistanceKm,
      'displayName': displayName,
    };
  }

  factory LocationResult.fromJson(Map<String, dynamic> json) {
    return LocationResult(
      name: json['name'] as String? ?? 'New Delhi',
      state: json['state'] as String?,
      country: json['country'] as String? ?? 'India',
      countryCode: json['countryCode'] as String? ?? 'IN',
      latitude: (json['latitude'] as num?)?.toDouble() ?? 28.6139,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 77.2090,
      isCoastal: json['isCoastal'] as bool? ?? false,
      coastDistanceKm: (json['coastDistanceKm'] as num?)?.toDouble(),
      displayName: json['displayName'] as String? ?? 'New Delhi, Delhi, India',
    );
  }

  static LocationResult defaultDelhi() {
    return const LocationResult(
      name: 'New Delhi',
      state: 'Delhi',
      country: 'India',
      countryCode: 'IN',
      latitude: 28.6139,
      longitude: 77.2090,
      isCoastal: false,
      coastDistanceKm: 865.0,
      displayName: 'New Delhi, Delhi, India',
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocationResult &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          state == other.state &&
          country == other.country &&
          (latitude - other.latitude).abs() < 0.001 &&
          (longitude - other.longitude).abs() < 0.001;

  @override
  int get hashCode =>
      name.hashCode ^
      (state ?? '').hashCode ^
      country.hashCode ^
      latitude.hashCode ^
      longitude.hashCode;
}
