import 'persona_type.dart';
import 'location_result.dart';
import '../services/india_location_filter.dart';

class UserPreferences {
  final List<PersonaType> selectedPersonas;
  final String defaultCity;
  final bool hasCompletedOnboarding;
  final bool isOfflineDemoMode;
  final List<String> savedDestinations;
  final String? languageCode; // 'en' or 'hi' (null triggers first-launch language screen)
  final LocationResult currentLocation;
  final List<LocationResult> recentLocations;

  const UserPreferences({
    required this.selectedPersonas,
    required this.defaultCity,
    required this.hasCompletedOnboarding,
    required this.isOfflineDemoMode,
    required this.savedDestinations,
    this.languageCode,
    required this.currentLocation,
    required this.recentLocations,
  });

  factory UserPreferences.defaultPreferences() {
    return UserPreferences(
      selectedPersonas: const [
        PersonaType.healthConscious,
        PersonaType.outdoorFitness,
        PersonaType.commuters,
      ],
      defaultCity: 'New Delhi',
      hasCompletedOnboarding: false,
      isOfflineDemoMode: false,
      savedDestinations: const ['Goa', 'Shimla', 'Jaipur', 'Kochi'],
      languageCode: null, // First launch -> show LanguageScreen
      currentLocation: LocationResult.defaultDelhi(),
      recentLocations: [
        LocationResult.defaultDelhi(),
        const LocationResult(
          name: 'Mumbai',
          state: 'Maharashtra',
          country: 'India',
          countryCode: 'IN',
          latitude: 18.9220,
          longitude: 72.8347,
          isCoastal: true,
          coastDistanceKm: 2.0,
          displayName: 'Mumbai, Maharashtra, India',
        ),
        const LocationResult(
          name: 'Kochi',
          state: 'Kerala',
          country: 'India',
          countryCode: 'IN',
          latitude: 9.9312,
          longitude: 76.2673,
          isCoastal: true,
          coastDistanceKm: 0.0,
          displayName: 'Kochi, Kerala, India',
        ),
      ],
    );
  }

  UserPreferences copyWith({
    List<PersonaType>? selectedPersonas,
    String? defaultCity,
    bool? hasCompletedOnboarding,
    bool? isOfflineDemoMode,
    List<String>? savedDestinations,
    String? languageCode,
    LocationResult? currentLocation,
    List<LocationResult>? recentLocations,
  }) {
    return UserPreferences(
      selectedPersonas: selectedPersonas ?? this.selectedPersonas,
      defaultCity: defaultCity ?? this.defaultCity,
      hasCompletedOnboarding:
          hasCompletedOnboarding ?? this.hasCompletedOnboarding,
      isOfflineDemoMode: isOfflineDemoMode ?? this.isOfflineDemoMode,
      savedDestinations: savedDestinations ?? this.savedDestinations,
      languageCode: languageCode ?? this.languageCode,
      currentLocation: currentLocation ?? this.currentLocation,
      recentLocations: recentLocations ?? this.recentLocations,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'selectedPersonas': selectedPersonas.map((p) => p.id).toList(),
      'defaultCity': defaultCity,
      'hasCompletedOnboarding': hasCompletedOnboarding,
      'isOfflineDemoMode': isOfflineDemoMode,
      'savedDestinations': savedDestinations,
      'languageCode': languageCode,
      'currentLocation': currentLocation.toJson(),
      'recentLocations': recentLocations.map((l) => l.toJson()).toList(),
    };
  }

  factory UserPreferences.fromJson(Map<String, dynamic> json) {
    final rawPersonas = json['selectedPersonas'] as List<dynamic>? ?? [];
    final personas = rawPersonas
        .map((id) => PersonaTypeExtension.fromId(id.toString()))
        .toList();

    final rawRecent = json['recentLocations'] as List<dynamic>? ?? [];
    final recent = rawRecent
        .map((item) => LocationResult.fromJson(item as Map<String, dynamic>))
        .toList();

    return UserPreferences(
      selectedPersonas: personas.isEmpty
          ? const [
              PersonaType.healthConscious,
              PersonaType.outdoorFitness,
              PersonaType.commuters,
            ]
          : personas,
      defaultCity: json['defaultCity'] as String? ?? 'New Delhi',
      hasCompletedOnboarding: json['hasCompletedOnboarding'] as bool? ?? false,
      isOfflineDemoMode: json['isOfflineDemoMode'] as bool? ?? false,
      savedDestinations: (json['savedDestinations'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .where((c) => !IndiaLocationFilter.shouldRejectLocationName(c))
              .toList() ??
          const ['Goa', 'Shimla', 'Jaipur', 'Kochi'],
      languageCode: json['languageCode'] as String?,
      currentLocation: json['currentLocation'] != null
          ? LocationResult.fromJson(
              json['currentLocation'] as Map<String, dynamic>)
          : LocationResult.defaultDelhi(),
      recentLocations: recent
              .where((l) =>
                  l.isIndia &&
                  !IndiaLocationFilter.shouldRejectLocationName(l.name) &&
                  l.country.toLowerCase() == 'india')
              .isEmpty
          ? [LocationResult.defaultDelhi()]
          : recent
              .where((l) =>
                  l.isIndia &&
                  !IndiaLocationFilter.shouldRejectLocationName(l.name) &&
                  l.country.toLowerCase() == 'india')
              .toList(),
    );
  }
}
