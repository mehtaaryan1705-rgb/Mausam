import 'package:flutter/material.dart';
import 'package:mausam_app/data/models/weather_data.dart';
import 'package:mausam_app/data/models/persona_type.dart';
import 'package:mausam_app/ui/core/widgets/weather_badge.dart';

/// CommuterCard: Tailored for Daily Commuters & City Drivers
/// Features:
/// - Weather + Traffic impact overlay (congestion delay in minutes)
/// - Visibility conditions in meters (critical for morning fog/smog)
/// - Fog / Thunderstorm alerts
/// - Route safety rating
///
/// Data Source Integration Point:
/// TODO: [IMD API] India Meteorological Department - Fog & Highway Nowcast
/// Real endpoint: https://mausam.imd.gov.in/api/highway/visibility_nowcast
class CommuterCard extends StatelessWidget {
  final WeatherData weatherData;

  const CommuterCard({super.key, required this.weatherData});

  @override
  Widget build(BuildContext context) {
    final commuter = weatherData.commuter;
    final theme = Theme.of(context);

    Color routeSafetyColor;
    if (commuter.routeSafety.contains('Safe')) {
      routeSafetyColor = const Color(0xFF2E7D32);
    } else if (commuter.routeSafety.contains('Caution')) {
      routeSafetyColor = const Color(0xFFF57C00);
    } else {
      routeSafetyColor = const Color(0xFFC62828);
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: PersonaType.commuters.accentColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    PersonaType.commuters.icon,
                    color: PersonaType.commuters.accentColor,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Commute & Route Visibility',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                        'IMD Highway Nowcast & Traffic Impact',
                        style: TextStyle(fontSize: 11, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                WeatherBadge(
                  label: commuter.routeSafety,
                  backgroundColor: routeSafetyColor.withOpacity(0.12),
                  textColor: routeSafetyColor,
                ),
              ],
            ),

            const SizedBox(height: 14),

            // Fog / Storm Alert banner if active
            if (commuter.fogStormAlert != null) ...[
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF3E0),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFFFB74D)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.blur_on_rounded, color: Color(0xFFE65100), size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        commuter.fogStormAlert!,
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFFBF360C)),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
            ],

            // Traffic Delay & Visibility Metrics
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFECEFF1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFCFD8DC)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: const [
                            Icon(Icons.traffic_rounded, size: 14, color: Color(0xFF37474F)),
                            SizedBox(width: 4),
                            Text(
                              'Traffic Delay',
                              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF37474F)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '+${commuter.trafficDelayMins} min',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            color: commuter.trafficDelayMins > 25
                                ? const Color(0xFFC62828)
                                : const Color(0xFFE65100),
                          ),
                        ),
                        Text(
                          commuter.trafficStatus,
                          style: TextStyle(fontSize: 10, color: Colors.grey.shade800),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE0F7FA),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFB2EBF2)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: const [
                            Icon(Icons.visibility_rounded, size: 14, color: Color(0xFF006064)),
                            SizedBox(width: 4),
                            Text(
                              'Visibility',
                              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF006064)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${commuter.visibilityMeters} m',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            color: commuter.visibilityMeters < 1000
                                ? const Color(0xFFC62828)
                                : const Color(0xFF006064),
                          ),
                        ),
                        Text(
                          commuter.visibilityMeters < 2000 ? 'Reduced visibility' : 'Clear road vista',
                          style: TextStyle(fontSize: 10, color: Colors.grey.shade800),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Commuter advisory tip
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  const Icon(Icons.directions_car_filled_rounded, size: 16, color: Colors.blueGrey),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      commuter.visibilityMeters < 3000
                          ? 'Maintain safe braking distance and use fog low-beams on expressways.'
                          : 'Normal road surface traction. Drive safely.',
                      style: const TextStyle(fontSize: 11, color: Colors.black87),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
