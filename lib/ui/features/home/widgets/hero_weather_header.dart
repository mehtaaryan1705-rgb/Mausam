import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mausam_app/data/models/weather_data.dart';
import 'package:mausam_app/data/services/mock_weather_data.dart';
import '../../location/location_search_modal.dart';

class HeroWeatherHeader extends StatelessWidget {
  final WeatherData weatherData;
  final bool isOffline;
  final DateTime? lastUpdated;
  final ValueChanged<String> onCityChanged;

  const HeroWeatherHeader({
    super.key,
    required this.weatherData,
    required this.isOffline,
    required this.lastUpdated,
    required this.onCityChanged,
  });

  @override
  Widget build(BuildContext context) {
    final current = weatherData.current;
    final timeStr = lastUpdated != null
        ? DateFormat('hh:mm a').format(lastUpdated!)
        : 'Just now';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF003366), // IMD Deep Navy
            Color(0xFF0F5298), // Atmospheric Blue
          ],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // City Selector & Government Badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Interactive Location Selector triggering LocationSearchModal
              InkWell(
                onTap: () => LocationSearchModal.show(context),
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.location_on, color: Color(0xFFFFB74D), size: 22),
                      const SizedBox(width: 6),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                weatherData.cityName,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Icon(Icons.search_rounded, color: Colors.white70, size: 18),
                            ],
                          ),
                          if (weatherData.isCoastal)
                            Text(
                              weatherData.coastDistanceKm != null
                                  ? 'Coastal • ${weatherData.coastDistanceKm} km to sea'
                                  : 'Coastal Zone (INCOIS active)',
                              style: const TextStyle(fontSize: 10, color: Color(0xFF80DEEA), fontWeight: FontWeight.bold),
                            )
                          else if (weatherData.stateName.isNotEmpty)
                            Text(
                              '${weatherData.stateName}, India',
                              style: const TextStyle(fontSize: 10, color: Colors.white70),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Live Status or Offline indicator
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: isOffline
                      ? const Color(0xFFFFF3E0).withOpacity(0.9)
                      : Colors.white.withOpacity(0.18),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 7,
                      height: 7,
                      decoration: BoxDecoration(
                        color: isOffline ? const Color(0xFFE65100) : const Color(0xFF69F0AE),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      isOffline ? 'Offline' : 'IMD Live',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: isOffline ? const Color(0xFFBF360C) : Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Main Temperature & Weather Condition
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${current.temperature.round()}',
                        style: const TextStyle(
                          fontSize: 62,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          height: 1.0,
                        ),
                      ),
                      const Text(
                        '°C',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    current.condition,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFE0E0E0),
                    ),
                  ),
                  Text(
                    'Feels like ${current.feelsLike.round()}°C • H: ${current.tempMax.round()}° L: ${current.tempMin.round()}°',
                    style: TextStyle(
                      fontSize: 12.5,
                      color: Colors.white.withOpacity(0.85),
                    ),
                  ),
                ],
              ),
              // Weather Condition Visual Icon
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _getConditionIcon(current.condition),
                  size: 52,
                  color: const Color(0xFFFFD54F),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Quick Weather Stats Strip (Humidity, Wind, Air Quality, Last updated)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.18),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(Icons.water_drop_outlined, '${current.humidity}%', 'Humidity'),
                Container(height: 24, width: 1, color: Colors.white24),
                _buildStatItem(Icons.air_rounded, '${current.windSpeedKmh.round()} km/h', 'Wind'),
                Container(height: 24, width: 1, color: Colors.white24),
                _buildStatItem(Icons.masks_outlined, '${weatherData.aqi.aqi}', 'AQI'),
                Container(height: 24, width: 1, color: Colors.white24),
                _buildStatItem(Icons.access_time_rounded, timeStr, 'Updated'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 13, color: Colors.white70),
            const SizedBox(width: 4),
            Text(
              value,
              style: const TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
        const SizedBox(height: 1),
        Text(
          label,
          style: TextStyle(fontSize: 10, color: Colors.white.withOpacity(0.75)),
        ),
      ],
    );
  }

  IconData _getConditionIcon(String condition) {
    final lower = condition.toLowerCase();
    if (lower.contains('rain') || lower.contains('shower')) {
      return Icons.grain_rounded;
    } else if (lower.contains('thunder') || lower.contains('storm')) {
      return Icons.thunderstorm_rounded;
    } else if (lower.contains('cloud') || lower.contains('overcast')) {
      return Icons.cloud_rounded;
    } else if (lower.contains('haze') || lower.contains('fog')) {
      return Icons.blur_on_rounded;
    }
    return Icons.wb_sunny_rounded;
  }
}
