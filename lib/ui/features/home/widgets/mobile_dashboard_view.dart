import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../data/models/weather_data.dart';
import '../../../core/weather_translations.dart';
import '../../../core/widgets/weather_badge.dart';
import '../../location/location_search_modal.dart';

class MobileDashboardView extends StatelessWidget {
  final WeatherData weatherData;
  final bool isOffline;
  final DateTime? lastUpdated;
  final ValueChanged<String>? onCityChanged;

  const MobileDashboardView({
    super.key,
    required this.weatherData,
    required this.isOffline,
    required this.lastUpdated,
    this.onCityChanged,
  });

  @override
  Widget build(BuildContext context) {
    final current = weatherData.current;
    final aqi = weatherData.aqi;
    final fitness = weatherData.outdoorFitness;
    final tide = weatherData.tideSea;
    final traveler = weatherData.traveler;
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context).languageCode;

    final translatedCondition = WeatherTranslations.translateConditionForLanguage(
      current.condition,
      locale,
    );
    final translatedAqiCat = WeatherTranslations.translateAqiCategoryForLanguage(
      aqi.category,
      locale,
    );

    final timeStr = lastUpdated != null
        ? DateFormat('hh:mm a').format(lastUpdated!)
        : 'Just now';

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Mobile App Top Bar with Location Switcher
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () => LocationSearchModal.show(context),
                  borderRadius: BorderRadius.circular(10),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF003366).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.location_on_rounded, color: Color(0xFF003366), size: 20),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                weatherData.cityName,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF003366),
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Icon(Icons.keyboard_arrow_down_rounded, size: 18, color: Colors.blueGrey),
                            ],
                          ),
                          Text(
                            weatherData.isCoastal
                                ? 'Coastal • ${weatherData.coastDistanceKm ?? 0} km to sea'
                                : (weatherData.stateName.isNotEmpty
                                    ? '${weatherData.stateName}, India'
                                    : 'India'),
                            style: TextStyle(
                              fontSize: 11,
                              color: weatherData.isCoastal ? const Color(0xFF00838F) : Colors.grey.shade600,
                              fontWeight: weatherData.isCoastal ? FontWeight.w600 : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: isOffline ? const Color(0xFFFFF3E0) : const Color(0xFFE8F5E9),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: isOffline ? const Color(0xFFE65100) : const Color(0xFF2E7D32),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        isOffline ? 'Offline' : 'IMD Live',
                        style: TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.bold,
                          color: isOffline ? const Color(0xFFE65100) : const Color(0xFF2E7D32),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // 2. Hero Weather Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF003366), Color(0xFF0F5298)],
              ),
              borderRadius: BorderRadius.circular(22),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF003366).withOpacity(0.25),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${current.temperature.round()}°C',
                          style: const TextStyle(
                            fontSize: 54,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            height: 1.0,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          translatedCondition,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFFFFF9C4),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Feels like ${current.feelsLike.round()}°C • H: ${current.tempMax.round()}° L: ${current.tempMin.round()}°',
                          style: TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.85)),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.14),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _getConditionIcon(current.condition),
                        size: 46,
                        color: const Color(0xFFFFD54F),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.access_time_rounded, size: 12, color: Colors.white70),
                          const SizedBox(width: 4),
                          Text('Updated: $timeStr', style: const TextStyle(fontSize: 11, color: Colors.white70)),
                        ],
                      ),
                      const Text(
                        'Ministry of Earth Sciences',
                        style: TextStyle(fontSize: 10.5, color: Colors.white60),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // 3. Vitals & Environment 3x2 Grid
          Text(
            locale == 'hi' ? 'पर्यावरण एवं मौसम स्थिति' : 'VITALS & ENVIRONMENT',
            style: const TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.7,
              color: Color(0xFF003366),
            ),
          ),
          const SizedBox(height: 8),
          GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 1.15,
            children: [
              _buildVitalTile(Icons.water_drop_rounded, '${current.humidity}%', locale == 'hi' ? 'नमी' : 'Humidity', const Color(0xFF1976D2)),
              _buildVitalTile(Icons.air_rounded, '${current.windSpeedKmh.round()} km/h', '${current.windDirection}', const Color(0xFF00897B)),
              _buildVitalTile(Icons.wb_sunny_rounded, '${current.uvIndex}', locale == 'hi' ? 'यूवी इंडेक्स' : 'UV Index', const Color(0xFFE65100)),
              _buildVitalTile(Icons.visibility_rounded, '${current.visibilityKm} km', locale == 'hi' ? 'दृश्यता' : 'Visibility', const Color(0xFF5E35B1)),
              _buildVitalTile(Icons.speed_rounded, '${current.pressureHpa} hPa', locale == 'hi' ? 'दबाव' : 'Pressure', const Color(0xFF455A64)),
              _buildVitalTile(Icons.wb_twilight_rounded, current.sunrise.split(' ')[0], 'Sunrise', const Color(0xFFD84315)),
            ],
          ),

          const SizedBox(height: 16),

          // 4. Air Quality & CAAQMS Transparency
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: aqi.categoryColor.withOpacity(0.3)),
              boxShadow: [
                BoxShadow(
                  color: aqi.categoryColor.withOpacity(0.08),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.air_rounded, color: aqi.categoryColor, size: 22),
                        const SizedBox(width: 8),
                        Text(
                          locale == 'hi' ? 'राष्ट्रीय वायु गुणवत्ता सूचकांक' : 'National Air Quality',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                      ],
                    ),
                    WeatherBadge(
                      label: translatedAqiCat,
                      backgroundColor: aqi.categoryColor.withOpacity(0.15),
                      textColor: aqi.categoryColor,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Text(
                      '${aqi.aqi}',
                      style: TextStyle(
                        fontSize: 38,
                        fontWeight: FontWeight.w900,
                        color: aqi.categoryColor,
                        height: 1.0,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'PM2.5: ${aqi.pm25} µg/m³ • PM10: ${aqi.pm10} µg/m³',
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${aqi.stationName} • ${aqi.stationDistanceKm} km away',
                            style: TextStyle(fontSize: 10.5, color: Colors.grey.shade600),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                if (aqi.isUnhealthy) ...[
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFEBEE),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.warning_amber_rounded, size: 16, color: Color(0xFFC62828)),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            aqi.healthAdvisory,
                            style: const TextStyle(fontSize: 11, color: Color(0xFFB71C1C)),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(height: 16),

          // 5. Marine / Coastal Status (if coastal or inland)
          if (weatherData.isIndia) ...[
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: weatherData.isCoastal ? const Color(0xFFE0F7FA) : const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: weatherData.isCoastal ? const Color(0xFF80DEEA) : Colors.grey.shade300,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: weatherData.isCoastal ? const Color(0xFF00838F) : Colors.grey.shade400,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      weatherData.isCoastal ? Icons.waves_rounded : Icons.landscape_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          weatherData.isCoastal
                              ? 'Coastal Waters (INCOIS active)'
                              : 'Inland Location',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13.5,
                            color: weatherData.isCoastal ? const Color(0xFF006064) : Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          weatherData.isCoastal && tide != null
                              ? 'Next: ${tide.nextTideType} • Wave: ${tide.waveHeightM}m • ${weatherData.coastDistanceKm} km to coast'
                              : '${weatherData.cityName} is ${weatherData.coastDistanceKm?.round() ?? 865} km from Indian coastline',
                          style: TextStyle(fontSize: 11.5, color: Colors.grey.shade700),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],

          // 6. Saved Travel Cities Watchlist
          Text(
            locale == 'hi' ? 'सहेजे गए यात्रा शहर' : 'SAVED TRAVEL DESTINATIONS',
            style: const TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.7,
              color: Color(0xFF003366),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 95,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: traveler.savedDestinations.length,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (context, index) {
                final dest = traveler.savedDestinations[index];
                return InkWell(
                  onTap: () => onCityChanged?.call(dest.city),
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    width: 145,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.grey.shade200),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.03),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                dest.city,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Text(
                              '${dest.temp.round()}°',
                              style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13, color: Color(0xFF003366)),
                            ),
                          ],
                        ),
                        Text(
                          dest.condition,
                          style: TextStyle(fontSize: 10.5, color: Colors.grey.shade600),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Row(
                          children: [
                            const Icon(Icons.grain_rounded, size: 11, color: Colors.blue),
                            const SizedBox(width: 3),
                            Text('${dest.rainProbability}% rain', style: const TextStyle(fontSize: 10, color: Colors.blue)),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVitalTile(IconData icon, String value, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 17, color: color),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black87),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            label,
            style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
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
