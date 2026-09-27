import 'package:flutter/material.dart';
import 'package:mausam_app/data/models/weather_data.dart';
import 'package:mausam_app/data/models/persona_type.dart';
import 'package:mausam_app/ui/core/widgets/weather_badge.dart';

/// HealthCard: Tailored for Health-Conscious Users
/// Features:
/// - National AQI scale gauge (Good, Satisfactory, Moderate, Poor, Very Poor, Severe)
/// - Alert banner if AQI > 200 (Unhealthy/Hazardous)
/// - Pollen count & breakdown (Tree, Grass, Weed)
/// - UV Index and Relative Humidity
///
/// Data Source Integration Point:
/// TODO: [CPCB API] Central Pollution Control Board - National Air Quality Index (NAQI)
/// Real endpoint: https://app.cpcbccr.com/AQI_Serv/aqi_data (Station-wise CAAQMS)
class HealthCard extends StatelessWidget {
  final WeatherData weatherData;

  const HealthCard({super.key, required this.weatherData});

  @override
  Widget build(BuildContext context) {
    final aqi = weatherData.aqi;
    final pollen = weatherData.pollen;
    final current = weatherData.current;
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with Persona Icon & Title
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: PersonaType.healthConscious.accentColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    PersonaType.healthConscious.icon,
                    color: PersonaType.healthConscious.accentColor,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Health & Air Quality',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${aqi.stationName} • ${aqi.stationDistanceKm} km away',
                        style: const TextStyle(fontSize: 11, color: Colors.grey),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                WeatherBadge(
                  label: aqi.category,
                  backgroundColor: aqi.categoryColor.withOpacity(0.15),
                  textColor: aqi.categoryColor,
                ),
              ],
            ),

            const SizedBox(height: 16),

            // High AQI Unhealthy Alert Banner (Triggered when AQI > 200)
            if (aqi.isUnhealthy) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFEBEE),
                  border: Border.all(color: const Color(0xFFEF5350), width: 1.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.warning_amber_rounded, color: Color(0xFFC62828), size: 22),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'HEALTH ALERT: High Air Pollution',
                            style: TextStyle(
                              color: Color(0xFFC62828),
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            aqi.healthAdvisory,
                            style: const TextStyle(
                              color: Color(0xFFB71C1C),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Main AQI Value & Gauge Bar
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceVariant.withOpacity(0.35),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              Text(
                                '${aqi.aqi}',
                                style: TextStyle(
                                  fontSize: 36,
                                  fontWeight: FontWeight.w900,
                                  color: aqi.categoryColor,
                                ),
                              ),
                              const SizedBox(width: 6),
                              const Text(
                                'AQI (NAQI)',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            'PM2.5: ${aqi.pm25} µg/m³  •  PM10: ${aqi.pm10} µg/m³',
                            style: const TextStyle(fontSize: 12, color: Colors.black87),
                          ),
                        ],
                      ),
                      Icon(
                        Icons.air_rounded,
                        size: 40,
                        color: aqi.categoryColor.withOpacity(0.8),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Segmented Color Scale Bar for National AQI
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: SizedBox(
                      height: 8,
                      child: Row(
                        children: [
                          Expanded(child: Container(color: const Color(0xFF2E7D32))), // Good (0-50)
                          Expanded(child: Container(color: const Color(0xFF689F38))), // Satisfactory (51-100)
                          Expanded(child: Container(color: const Color(0xFFFBC02D))), // Moderate (101-200)
                          Expanded(child: Container(color: const Color(0xFFFB8C00))), // Poor (201-300)
                          Expanded(child: Container(color: const Color(0xFFD32F2F))), // Very Poor (301-400)
                          Expanded(child: Container(color: const Color(0xFF880E4F))), // Severe (401-500)
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('0 Good', style: TextStyle(fontSize: 9, color: Colors.grey)),
                      Text('100', style: TextStyle(fontSize: 9, color: Colors.grey)),
                      Text('200', style: TextStyle(fontSize: 9, color: Colors.grey)),
                      Text('300', style: TextStyle(fontSize: 9, color: Colors.grey)),
                      Text('400', style: TextStyle(fontSize: 9, color: Colors.grey)),
                      Text('500+ Severe', style: TextStyle(fontSize: 9, color: Colors.grey)),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            // Secondary Health Indicators: Pollen & UV & Humidity
            Row(
              children: [
                Expanded(
                  child: _buildMetricTile(
                    icon: Icons.grass_rounded,
                    label: 'Pollen Count',
                    value: '${pollen.count} (${pollen.level})',
                    subtext: 'Grass: ${pollen.grassPollen}',
                    color: Colors.green.shade700,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildMetricTile(
                    icon: Icons.wb_sunny_rounded,
                    label: 'UV Index',
                    value: '${current.uvIndex}',
                    subtext: current.uvIndex > 7 ? 'Very High (Burn risk)' : 'Moderate UV',
                    color: Colors.amber.shade800,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildMetricTile(
                    icon: Icons.water_drop_rounded,
                    label: 'Humidity',
                    value: '${current.humidity}%',
                    subtext: current.humidity > 70 ? 'Oppressive' : 'Normal',
                    color: Colors.blue.shade700,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricTile({
    required IconData icon,
    required String label,
    required String value,
    required String subtext,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: color),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: color),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 2),
          Text(
            subtext,
            style: TextStyle(fontSize: 9.5, color: Colors.grey.shade700),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
