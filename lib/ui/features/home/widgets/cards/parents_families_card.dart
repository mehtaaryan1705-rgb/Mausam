import 'package:flutter/material.dart';
import 'package:mausam_app/data/models/weather_data.dart';
import 'package:mausam_app/data/models/persona_type.dart';
import 'package:mausam_app/ui/core/widgets/weather_badge.dart';

/// ParentsFamiliesCard: Tailored for Parents, School Commutes & Family Activities
/// Features:
/// - School commute windows: Morning (7:00 AM - 9:00 AM) & Afternoon (2:00 PM - 4:00 PM)
/// - Rain alerts & thunderstorm warnings
/// - Child outdoor play safety guidelines
///
/// Data Source Integration Point:
/// TODO: [IMD API] India Meteorological Department - Doppler Weather Radar (DWR) Nowcast
/// Real endpoint: https://mausam.imd.gov.in/api/dwr/nowcast_station
class ParentsFamiliesCard extends StatelessWidget {
  final WeatherData weatherData;

  const ParentsFamiliesCard({super.key, required this.weatherData});

  @override
  Widget build(BuildContext context) {
    final family = weatherData.parentsFamilies;
    final theme = Theme.of(context);

    // Family weather alert banner: Never show Air Quality cautions when AQI <= 100
    final alertText = family.alert;
    final isAqiAlert = alertText != null &&
        (alertText.toLowerCase().contains('air quality') ||
            alertText.toLowerCase().contains('aqi') ||
            alertText.toLowerCase().contains('smog') ||
            alertText.toLowerCase().contains('pollution'));

    final shouldShowAlert = alertText != null &&
        (!isAqiAlert || weatherData.aqi.aqi > 100);

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
                    color: PersonaType.parentsFamilies.accentColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    PersonaType.parentsFamilies.icon,
                    color: PersonaType.parentsFamilies.accentColor,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Parents & School Commute',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                        'IMD DWR Nowcast & School Safety',
                        style: TextStyle(fontSize: 11, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                const WeatherBadge(
                  label: 'School Routine',
                  backgroundColor: Color(0xFFFCE4EC),
                  textColor: Color(0xFFC2185B),
                ),
              ],
            ),

            const SizedBox(height: 14),

            if (shouldShowAlert) ...[
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF3E0),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFFFB74D)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline_rounded, color: Color(0xFFE65100), size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        alertText,
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFFBF360C)),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
            ],

            // Commute Window 1: Morning (7-9 AM)
            _buildCommuteTile(
              window: family.morningCommute,
              icon: Icons.wb_sunny_outlined,
              accentColor: const Color(0xFFF57C00),
            ),

            const SizedBox(height: 10),

            // Commute Window 2: Afternoon (2-4 PM)
            _buildCommuteTile(
              window: family.afternoonCommute,
              icon: Icons.directions_bus_rounded,
              accentColor: const Color(0xFFD81B60),
            ),

            const SizedBox(height: 14),

            // Outdoor Play Safety Recommendation
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.shade50.withOpacity(0.5),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.green.shade200),
              ),
              child: Row(
                children: [
                  Icon(Icons.sports_soccer_rounded, size: 20, color: Colors.green.shade800),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Children Outdoor Play Guidance',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.green.shade900,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          family.outdoorPlaySafety,
                          style: TextStyle(fontSize: 11.5, color: Colors.green.shade800),
                        ),
                      ],
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

  Widget _buildCommuteTile({
    required SchoolCommuteWindow window,
    required IconData icon,
    required Color accentColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(icon, size: 16, color: accentColor),
                  const SizedBox(width: 6),
                  Text(
                    window.title,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: accentColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  window.timeRange,
                  style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold, color: accentColor),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Text(
                '${window.temp.round()}°C',
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 8),
              Text(
                '• ${window.condition}',
                style: TextStyle(fontSize: 12, color: Colors.grey.shade800),
              ),
              const Spacer(),
              Icon(Icons.water_drop, size: 13, color: Colors.blue.shade700),
              const SizedBox(width: 2),
              Text(
                '${window.rainProbability}% Rain',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.blue.shade800),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            window.advisory,
            style: TextStyle(fontSize: 11.5, color: Colors.grey.shade700),
          ),
        ],
      ),
    );
  }
}
