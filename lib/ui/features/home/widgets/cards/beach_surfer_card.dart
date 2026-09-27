import 'package:flutter/material.dart';
import 'package:mausam_app/data/models/weather_data.dart';
import 'package:mausam_app/data/models/persona_type.dart';
import 'package:mausam_app/ui/core/widgets/weather_badge.dart';

/// BeachSurferCard: Tailored for Beachgoers, Fisherfolk & Surfers
/// Features:
/// - Coastal city check (lat/lng or city metadata): hides or alerts if inland
/// - High/Low tide schedules and next tide countdown
/// - Wave height in meters & sea state roughness (Calm / Moderate / Rough)
/// - Sea surface temperature
///
/// Data Source Integration Point:
/// TODO: [INCOIS API] Indian National Centre for Ocean Information Services - Ocean State Forecast (OSF)
/// Real endpoint: https://incois.gov.in/portal/osf/tide_api.jsp
class BeachSurferCard extends StatelessWidget {
  final WeatherData weatherData;
  final ValueChanged<String>? onSelectCoastalCity;

  const BeachSurferCard({
    super.key,
    required this.weatherData,
    this.onSelectCoastalCity,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isCoastal = weatherData.isCoastal;
    final tide = weatherData.tideSea;


    // Inland condition: if beyond 25km coastal threshold
    if (!isCoastal || tide == null) {
      final coastDist = weatherData.coastDistanceKm;
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: PersonaType.beachgoersSurfers.accentColor.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      PersonaType.beachgoersSurfers.icon,
                      color: PersonaType.beachgoersSurfers.accentColor,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Beach & Marine Conditions',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  WeatherBadge(
                    label: coastDist != null
                        ? 'Inland (${coastDist.round()} km)'
                        : 'Inland City',
                    backgroundColor: const Color(0xFFECEFF1),
                    textColor: const Color(0xFF546E7A),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                '${weatherData.cityName} is located inland${coastDist != null ? ' ($coastDist km from Indian coastline)' : ''}. Ocean state forecasts and INCOIS tide tables are available for coastal locations within 25 km.',
                style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
              ),
              const SizedBox(height: 10),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    const Text(
                      'View coastal data:',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 8),
                    ActionChip(
                      label: const Text('Mumbai (Konkan)', style: TextStyle(fontSize: 11)),
                      onPressed: () => onSelectCoastalCity?.call('Mumbai'),
                    ),
                    const SizedBox(width: 6),
                    ActionChip(
                      label: const Text('Goa (Surf)', style: TextStyle(fontSize: 11)),
                      onPressed: () => onSelectCoastalCity?.call('Goa (Panaji)'),
                    ),
                    const SizedBox(width: 6),
                    ActionChip(
                      label: const Text('Kochi (Malabar)', style: TextStyle(fontSize: 11)),
                      onPressed: () => onSelectCoastalCity?.call('Kochi'),
                    ),
                    const SizedBox(width: 6),
                    ActionChip(
                      label: const Text('Surat (Macro-tidal)', style: TextStyle(fontSize: 11)),
                      onPressed: () => onSelectCoastalCity?.call('Surat'),
                    ),
                    const SizedBox(width: 6),
                    ActionChip(
                      label: const Text('Chennai (Coromandel)', style: TextStyle(fontSize: 11)),
                      onPressed: () => onSelectCoastalCity?.call('Chennai'),
                    ),
                    const SizedBox(width: 6),
                    ActionChip(
                      label: const Text('Puri (Odisha)', style: TextStyle(fontSize: 11)),
                      onPressed: () => onSelectCoastalCity?.call('Puri'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
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
                    color: PersonaType.beachgoersSurfers.accentColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    PersonaType.beachgoersSurfers.icon,
                    color: PersonaType.beachgoersSurfers.accentColor,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Beach & Ocean State',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        weatherData.coastDistanceKm != null
                            ? 'INCOIS Telemetry • ${weatherData.coastDistanceKm} km from coast'
                            : 'INCOIS Swell & Tide Telemetry',
                        style: const TextStyle(fontSize: 11, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                WeatherBadge(
                  label: tide.seaCondition,
                  backgroundColor: const Color(0xFFE1F5FE),
                  textColor: const Color(0xFF0277BD),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Coastal Zone Quick Switcher
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  const Text('Coasts: ', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.blueGrey)),
                  _buildCoastalSwitchChip('Mumbai', 'Mumbai (Konkan)', weatherData.cityName),
                  const SizedBox(width: 6),
                  _buildCoastalSwitchChip('Goa', 'Goa (Surf)', weatherData.cityName),
                  const SizedBox(width: 6),
                  _buildCoastalSwitchChip('Kochi', 'Kochi (Malabar)', weatherData.cityName),
                  const SizedBox(width: 6),
                  _buildCoastalSwitchChip('Surat', 'Surat (Macro-tidal)', weatherData.cityName),
                  const SizedBox(width: 6),
                  _buildCoastalSwitchChip('Chennai', 'Chennai (Coromandel)', weatherData.cityName),
                  const SizedBox(width: 6),
                  _buildCoastalSwitchChip('Puri', 'Puri (Odisha)', weatherData.cityName),
                ],
              ),
            ),

            const SizedBox(height: 14),

            // Next Tide Highlight Banner
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF0277BD), Color(0xFF0097A7)],
                ),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  const Icon(Icons.waves_rounded, color: Colors.white, size: 28),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Next Tide Event',
                          style: TextStyle(fontSize: 11, color: Colors.white70),
                        ),
                        Text(
                          tide.nextTideType,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      tide.nextTideCountdown,
                      style: const TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            // Tide Timings Schedule Grid
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50.withOpacity(0.4),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue.shade100),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildTideItem(
                    title: 'High Tide',
                    time: tide.highTideTime,
                    icon: Icons.arrow_upward_rounded,
                    color: const Color(0xFF0277BD),
                  ),
                  Container(height: 32, width: 1, color: Colors.blue.shade200),
                  _buildTideItem(
                    title: 'Low Tide',
                    time: tide.lowTideTime,
                    icon: Icons.arrow_downward_rounded,
                    color: const Color(0xFF00838F),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            // Wave Height & Water Temperature Tiles
            Row(
              children: [
                Expanded(
                  child: _buildMarineMetric(
                    icon: Icons.water_rounded,
                    label: 'Significant Wave Height',
                    value: '${tide.waveHeightM} meters',
                    status: tide.waveHeightM > 2.0 ? 'Rough swell' : 'Moderate swell',
                    color: const Color(0xFF0277BD),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildMarineMetric(
                    icon: Icons.thermostat_rounded,
                    label: 'Sea Water Temp',
                    value: '${tide.waterTempC}°C',
                    status: 'Warm tropical surf',
                    color: const Color(0xFF00897B),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTideItem({
    required String title,
    required String time,
    required IconData icon,
    required Color color,
  }) {
    return Row(
      children: [
        Icon(icon, size: 18, color: color),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: color)),
            Text(time, style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold)),
          ],
        ),
      ],
    );
  }

  Widget _buildMarineMetric({
    required IconData icon,
    required String label,
    required String value,
    required String status,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(10),
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
          Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          const SizedBox(height: 2),
          Text(status, style: TextStyle(fontSize: 10, color: Colors.grey.shade700)),
        ],
      ),
    );
  }

  Widget _buildCoastalSwitchChip(String targetCity, String label, String currentCity) {
    final isSelected = currentCity.toLowerCase().contains(targetCity.toLowerCase().split(' ').first);
    return ActionChip(
      label: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected ? Colors.white : const Color(0xFF003366),
        ),
      ),
      backgroundColor: isSelected ? const Color(0xFF003366) : const Color(0xFFE0F2F1),
      onPressed: () => onSelectCoastalCity?.call(targetCity),
    );
  }
}
