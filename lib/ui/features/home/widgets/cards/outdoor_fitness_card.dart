import 'package:flutter/material.dart';
import 'package:mausam_app/data/models/weather_data.dart';
import 'package:mausam_app/data/models/persona_type.dart';
import 'package:mausam_app/ui/core/widgets/weather_badge.dart';

/// OutdoorFitnessCard: Tailored for Runners, Cyclists & Fitness Enthusiasts
/// Features:
/// - Sunrise / Sunset & Golden Hour indicators
/// - Calculated "Best Running Hours" window (based on temp, wind, AQI)
/// - Surface Wind conditions
/// - Heat Index / Cold weather thermal alerts
///
/// Data Source Integration Point:
/// TODO: [IMD API] India Meteorological Department - Surface AWS Observations & Solar Ephemeris
/// Real endpoint: https://mausam.imd.gov.in/api/surface/aws_data
class OutdoorFitnessCard extends StatelessWidget {
  final WeatherData weatherData;

  const OutdoorFitnessCard({super.key, required this.weatherData});

  @override
  Widget build(BuildContext context) {
    final fitness = weatherData.outdoorFitness;
    final current = weatherData.current;
    final theme = Theme.of(context);

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
                    color: PersonaType.outdoorFitness.accentColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    PersonaType.outdoorFitness.icon,
                    color: PersonaType.outdoorFitness.accentColor,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Outdoor Fitness & Running',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                        'IMD Thermal & Solar Ephemeris',
                        style: TextStyle(fontSize: 11, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                WeatherBadge(
                  label: '${current.temperature.round()}°C',
                  backgroundColor: PersonaType.outdoorFitness.accentColor.withOpacity(0.15),
                  textColor: PersonaType.outdoorFitness.accentColor,
                ),
              ],
            ),

            const SizedBox(height: 14),

            // Heat / Cold Advisory banner if present
            if (fitness.heatColdAlert != null) ...[
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF3E0),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFFFB74D)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline_rounded, color: Color(0xFFE65100), size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        fitness.heatColdAlert!,
                        style: const TextStyle(fontSize: 11.5, color: Color(0xFFBF360C)),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
            ],

            // Sunrise, Sunset & Golden Hours Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFFFFECB3).withOpacity(0.6),
                    const Color(0xFFFFCC80).withOpacity(0.4),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildSolarItem(
                    icon: Icons.wb_twilight_rounded,
                    title: 'Sunrise',
                    time: current.sunrise,
                    goldenHour: fitness.goldenHourMorning,
                    color: Colors.amber.shade900,
                  ),
                  Container(
                    height: 36,
                    width: 1,
                    color: Colors.black12,
                  ),
                  _buildSolarItem(
                    icon: Icons.nights_stay_rounded,
                    title: 'Sunset',
                    time: current.sunset,
                    goldenHour: fitness.goldenHourEvening,
                    color: Colors.deepOrange.shade800,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Calculated "Best Running Hours"
            Row(
              children: [
                const Icon(Icons.bolt_rounded, size: 18, color: Color(0xFFE65100)),
                const SizedBox(width: 6),
                Text(
                  'Calculated Best Running Hours',
                  style: theme.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            ...fitness.bestRunningHours.map((window) {
              final isOptimal = window.rating == 'Optimal';
              final badgeColor = isOptimal ? const Color(0xFF2E7D32) : const Color(0xFFEF6C00);

              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                      decoration: BoxDecoration(
                        color: badgeColor.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          Text(
                            '${window.score}',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                              color: badgeColor,
                            ),
                          ),
                          Text(
                            window.rating,
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              color: badgeColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            window.timeWindow,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            window.reason,
                            style: TextStyle(
                              fontSize: 11.5,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),

            // Wind & Airflow metric footer
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.blue.shade50.withOpacity(0.5),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  const Icon(Icons.air_rounded, size: 16, color: Color(0xFF0277BD)),
                  const SizedBox(width: 6),
                  Text(
                    'Surface Wind: ${current.windSpeedKmh} km/h (${current.windDirection})',
                    style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600, color: Color(0xFF01579B)),
                  ),
                  const Spacer(),
                  Text(
                    current.windSpeedKmh > 20 ? 'Breezy' : 'Gentle',
                    style: TextStyle(fontSize: 11, color: Colors.blue.shade800),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSolarItem({
    required IconData icon,
    required String title,
    required String time,
    required String goldenHour,
    required Color color,
  }) {
    return Column(
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 4),
            Text(
              title,
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: color),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          time,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
        Text(
          'Golden: $goldenHour',
          style: TextStyle(fontSize: 9.5, color: Colors.grey.shade800),
        ),
      ],
    );
  }
}
