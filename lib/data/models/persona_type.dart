import 'package:flutter/material.dart';

enum PersonaType {
  healthConscious,
  outdoorFitness,
  beachgoersSurfers,
  travelers,
  parentsFamilies,
  agricultureGardeners,
  commuters,
  eventPlanners,
}

extension PersonaTypeExtension on PersonaType {
  String get id {
    switch (this) {
      case PersonaType.healthConscious:
        return 'health_conscious';
      case PersonaType.outdoorFitness:
        return 'outdoor_fitness';
      case PersonaType.beachgoersSurfers:
        return 'beachgoers_surfers';
      case PersonaType.travelers:
        return 'travelers';
      case PersonaType.parentsFamilies:
        return 'parents_families';
      case PersonaType.agricultureGardeners:
        return 'agriculture_gardeners';
      case PersonaType.commuters:
        return 'commuters';
      case PersonaType.eventPlanners:
        return 'event_planners';
    }
  }

  String get title {
    switch (this) {
      case PersonaType.healthConscious:
        return 'Health-Conscious';
      case PersonaType.outdoorFitness:
        return 'Outdoor Fitness';
      case PersonaType.beachgoersSurfers:
        return 'Beachgoers & Surfers';
      case PersonaType.travelers:
        return 'Travelers';
      case PersonaType.parentsFamilies:
        return 'Parents & Families';
      case PersonaType.agricultureGardeners:
        return 'Agriculture & Gardeners';
      case PersonaType.commuters:
        return 'Daily Commuters';
      case PersonaType.eventPlanners:
        return 'Event Planners';
    }
  }

  String get description {
    switch (this) {
      case PersonaType.healthConscious:
        return 'AQI, PM2.5, UV index, pollen levels & air quality alerts';
      case PersonaType.outdoorFitness:
        return 'Best running hours, golden hours, wind speed & heat alerts';
      case PersonaType.beachgoersSurfers:
        return 'High/low tide timings, wave height & water temperature';
      case PersonaType.travelers:
        return 'Saved destinations, severe weather alerts & packing helper';
      case PersonaType.parentsFamilies:
        return 'School commute window (7-9 AM & 2-4 PM) & rain forecast';
      case PersonaType.agricultureGardeners:
        return 'Soil moisture estimates, 48h rain prediction & seasonal tips';
      case PersonaType.commuters:
        return 'Weather + traffic overlay, visibility & fog/storm alerts';
      case PersonaType.eventPlanners:
        return '7-10 day forecast, rain probability & 0-100 Comfort Index';
    }
  }

  IconData get icon {
    switch (this) {
      case PersonaType.healthConscious:
        return Icons.masks_outlined;
      case PersonaType.outdoorFitness:
        return Icons.directions_run_rounded;
      case PersonaType.beachgoersSurfers:
        return Icons.surfing_rounded;
      case PersonaType.travelers:
        return Icons.flight_takeoff_rounded;
      case PersonaType.parentsFamilies:
        return Icons.family_restroom_rounded;
      case PersonaType.agricultureGardeners:
        return Icons.agriculture_rounded;
      case PersonaType.commuters:
        return Icons.directions_car_rounded;
      case PersonaType.eventPlanners:
        return Icons.event_available_rounded;
    }
  }

  Color get accentColor {
    switch (this) {
      case PersonaType.healthConscious:
        return const Color(0xFF00897B); // Teal / health
      case PersonaType.outdoorFitness:
        return const Color(0xFFE65100); // Amber orange
      case PersonaType.beachgoersSurfers:
        return const Color(0xFF0277BD); // Ocean blue
      case PersonaType.travelers:
        return const Color(0xFF5E35B1); // Deep purple
      case PersonaType.parentsFamilies:
        return const Color(0xFFD81B60); // Warm rose
      case PersonaType.agricultureGardeners:
        return const Color(0xFF2E7D32); // Agro green
      case PersonaType.commuters:
        return const Color(0xFF455A64); // Slate grey
      case PersonaType.eventPlanners:
        return const Color(0xFFC2185B); // Festive ruby
    }
  }

  String get dataSourceName {
    switch (this) {
      case PersonaType.healthConscious:
        return 'CPCB (Central Pollution Control Board)';
      case PersonaType.outdoorFitness:
        return 'IMD Surface & Solar Observations';
      case PersonaType.beachgoersSurfers:
        return 'INCOIS (Indian Ocean Info Services)';
      case PersonaType.travelers:
        return 'IMD National Multi-City Forecast';
      case PersonaType.parentsFamilies:
        return 'IMD Nowcast & Doppler Radar';
      case PersonaType.agricultureGardeners:
        return 'IMD Agromet Advisory (GKMS)';
      case PersonaType.commuters:
        return 'IMD Highway Nowcast & Traffic Mesh';
      case PersonaType.eventPlanners:
        return 'IMD Extended Range Forecast (ERF)';
    }
  }

  static PersonaType fromId(String id) {
    return PersonaType.values.firstWhere(
      (p) => p.id == id,
      orElse: () => PersonaType.healthConscious,
    );
  }
}
